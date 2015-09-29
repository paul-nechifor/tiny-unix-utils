section .data

msg: times 21 db 0

%include "_u64_to_str.asm"

section .text

global _start
_start:
  mov rax, {{ number }}
  mov rbp, msg
  call u64_to_str

  ; Write the number.
  mov rax, 4
  mov rbx, 1
  mov rcx, msg
  mov rdx, rbp
  int 0x80

  ; Exit 0.
  mov rax, 1
  mov rbx, 0
  int 0x80
