section .text

global _start
_start:
  ; Set ebx to the number of arguments without program name.
  pop rdx
  pop rbx

loop_back:
  mov rax, rdx

  cmp rax, 0
  jle exit

  pop rbx ; Get an argument

  ; Calling creat() syscall with filename in ebx and permissions in ecx.
  mov rax, 8
  mov rcx, 0o644
  int 0x80

  dec rdx
  ;jmp loop_back

exit:
  mov rax, 1; The syscall for exit
  mov rbx, 0
  int 0x80
