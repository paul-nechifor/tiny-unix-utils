BITS 32
org 0x08048000

ehdr: ; Elf32_Ehdr
  db 0x7F, "ELF" ; e_ident
  db 1, 1, 1, 0, 0
