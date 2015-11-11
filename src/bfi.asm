; Brainfuck Interpreter

%include '_macros.mac'

section .data

section .bss
tape:  resb 65535

section .text

global _start
_start:
  ; rax = pointer to the current instruction.
  mov rax, [rsp + 16]
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

  cmp cl, '['
  je process_next_instruction

  cmp cl, ']'
  je instr_loop_back
  jmp process_next_instruction

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

instr_loop_back:
  ; If the byte at the data head is 0, go to the next instruction.
  cmp byte [rbx], 0
  je process_next_instruction

  ; In this case we need to loop back until we find the matching '[' for this
  ; ']'. Since they can be nested we keep track of matching brackets by
  ; incremeting on ']' and decrementing on '['. When we hit 0, we're there.
  mov rdx, 1

load_previous_instruction_until_the_match_is_found:
  dec rax
  mov cl, [rax]

  cmp cl, '['
  je dec_matching_brackets

  cmp cl, ']'
  je inc_matching_brackets

  jmp load_previous_instruction_until_the_match_is_found

dec_matching_brackets:
  dec rdx
  jmp check_if_we_have_the_correct_one
inc_matching_brackets:
  inc rdx
  jmp check_if_we_have_the_correct_one

check_if_we_have_the_correct_one:
  cmp rdx, 0
  je process_next_instruction
  jmp load_previous_instruction_until_the_match_is_found

exit:
  mov rax, syscall_exit
  mov rdi, exit_success_code
  syscall
