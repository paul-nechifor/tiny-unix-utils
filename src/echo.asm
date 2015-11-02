%include '_macros.mac'

section .text

global _start
_start:

exit:
  mov rax, syscall_exit
  mov rbx, exit_success_code
  syscall
