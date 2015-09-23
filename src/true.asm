%include "_elf_start.asm"

_start:
  mov bl, 0
  xor eax, eax
  inc eax
  int 0x80

%include "_elf_end.asm"
