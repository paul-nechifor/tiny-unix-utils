section .bss

buffer: resb 4096

section .text

global _start
_start:

  mov rax, 3
  mov rbx, 0
  mov rcx, buffer
  mov rdx, 4096
  int 0x80

  cmp rax, 0
  jle exit

  mov rdx, rax

  mov rax, 4
  mov rbx, 1
  mov rcx, buffer
  int 0x80

  jmp _start

exit:
  mov rax, 1
  mov rbx, 0
  int 0x80
