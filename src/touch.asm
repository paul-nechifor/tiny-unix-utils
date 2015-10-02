section .text

global _start
_start:
  mov rdx, [rsp]

loop_back:
  cmp rdx, 1
  je exit

  mov rax, 8
  mov rbx, [rsp + 8 * rdx]
  mov rcx, 0o644
  int 0x80
  dec rdx
  jmp loop_back

exit:
  mov rax, 1
  mov rbx, 0
  int 0x80
