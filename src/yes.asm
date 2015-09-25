%include "_elf_start.asm"

msg: db "y", 10
len: equ $-msg

_start:
  mov eax, 4
  mov ebx, 1
  mov ecx, msg
  mov edx, 2
  int 0x80
  jmp _start

%include "_elf_end.asm"
