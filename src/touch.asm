%include "_elf_start.asm"

_start:
  ; Set ebx to the number of arguments without program name.
  pop edx
  ;dec edx ; I don't understant why I don't need this.

loopBack:
  mov eax, edx
  jz exit

  pop ebx ; Get an argument

  ; Calling creat() syscall with filename in ebx and permissions in ecx.
  mov eax, 8
  mov ecx, 0644
  int 0x80

  dec edx
  jmp loopBack

exit:
  mov eax, 1 ; The syscall for exit
  mov ebx, 0
  int 0x80

%include "_elf_end.asm"
