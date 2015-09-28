section .data

msg: db "y", 10
len: equ $ - msg

section .text

global _start
_start:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg
  mov edx, 2
  int 0x80
  jmp _start
