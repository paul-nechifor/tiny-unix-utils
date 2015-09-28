; MAX_U64 has 20 digits.
section .data

msg: times 30 db 0

section .text

global _start
_start:
  mov rax, 4

  mov rbx, 1

  cmp rax, 0
  jne start_algorithm
  mov byte [msg], 48
  jmp return_now

start_algorithm:
  mov rcx, 10
  div rcx
  mov byte [msg], dl
  add byte[msg], 48

return_now:
  mov rbp, rbx

  ; Write number.
  mov rax, 4
  mov rbx, 1
  mov rcx, msg
  mov rdx, rbp
  int 0x80

  ; Exit 0.
  mov rax, 1
  mov rbx, 0
  int 0x80
