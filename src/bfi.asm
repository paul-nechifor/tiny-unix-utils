; Brainfuck Interpreter

%include '_macros.mac'

section .data

program: db "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.", 0

section .bss
tape:  resb 65535

section .text

global _start
_start:
  ; rax = pointer to the current instruction.
  mov rax, program
  ; rbx = pointer to the tape (data).
  mov rbx, tape
  jmp load_instruction

process_next_instruction:
  inc rax

load_instruction:
  ; cl = the current instruction to be executed.
  mov cl, [rax]

  cmp cl, 0
  je exit

  cmp cl, '>'
  je instr_move_data_right

  cmp cl, '<'
  je instr_move_data_left

  cmp cl, '+'
  je instr_inc_data

  cmp cl, '-'
  je instr_dec_data

  cmp cl, '.'
  je instr_put_char

instr_move_data_right:
  inc rbx
  jmp process_next_instruction

instr_move_data_left:
  dec rbx
  jmp process_next_instruction

instr_inc_data:
  inc byte [rbx]
  jmp process_next_instruction

instr_dec_data:
  dec byte [rbx]
  jmp process_next_instruction

instr_put_char:
  push rax
  mov rax, syscall_write
  mov rdi, stdout_fileno
  mov rsi, rbx
  mov rdx, 1
  syscall
  pop rax
  jmp process_next_instruction

exit:
  mov rax, syscall_exit
  mov rdi, exit_success_code
  syscall
