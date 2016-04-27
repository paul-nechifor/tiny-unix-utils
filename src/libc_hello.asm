; ##LINK_LIBC##

extern puts
extern exit

section .data

message: db "hello", 0

section .text

global main
main:
  mov edi, message
  call puts
  mov rax, 2

  mov edi, 0
  call exit
