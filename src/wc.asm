%include '_macros.mac'

section .data

byte_count: dq 0

section .bss

buffer: resb small_buf_size
output_str: resb 21

section .text

global _start
_start:

  ; Read from stdin into the buffer.
  mov rax, syscall_read
  mov rbx, stdin_fileno
  mov rcx, buffer
  mov rdx, small_buf_size
  syscall

  cmp rax, 0
  jle read_finished

  add [byte_count], rax

  jmp _start

read_finished:
  mov rax, [byte_count]
  mov rbp, output_str
  call u64_to_str

  ; Write the number.
  mov rax, syscall_write
  mov rbx, stdout_fileno
  mov rcx, output_str
  mov rdx, rbp
  syscall

exit:
  mov rax, syscall_exit
  mov rbx, exit_success_code
  syscall

%include '_u64_to_str.asm'
