; ##LINK_LIBC##
; ##COMPILE_C## use_c_code_c_code.c

extern exit
extern c_code

section .text

global main
main:

  call c_code

  mov edi, 0
  call exit
