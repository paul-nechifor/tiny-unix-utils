%include '_macros.mac'

section .data

section .text

global _start
_start:

  ; `rsp` is argc
  ; `rsp + 8` is argv[0]
  mov rax, 1
  mov rdi, 1
  mov rsi, [rsp + 16]
  mov rdx, 1
  syscall

exit:
  mov rax, 60
  xor rdi, rdi
  syscall
