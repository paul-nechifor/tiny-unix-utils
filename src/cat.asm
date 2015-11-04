%include '_macros.mac'

section .bss

buffer: resb small_buf_size

section .text

global _start
_start:

  ; Read from stdin into the buffer.
  mov rax, syscall_read
  mov rdi, stdin_fileno
  mov rsi, buffer
  mov rdx, small_buf_size
  syscall

  ; Exit if an error occured or there isn't anything left to read.
  cmp rax, 0
  jle exit

  ; Store the number of bytes read into `rdx`.
  mov rdx, rax

  ; Write the same number of bytes to stdout.
  mov rax, syscall_write
  mov rdi, stdout_fileno
  mov rsi, buffer
  syscall

  jmp _start

exit:
  mov rax, syscall_exit
  mov rdi, exit_success_code
  syscall
