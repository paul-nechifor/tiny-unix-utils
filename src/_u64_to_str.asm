section .text

; MAX_U64 has 20 digits.
u64_to_str:
  mov rbx, 1

  cmp rax, 0
  jne start_algorithm
  mov byte [rbp], 48
  jmp return_now

start_algorithm:
  mov rcx, 10
  div rcx
  add dl, 48
  mov byte [rbp], dl

return_now:
  mov rbp, rbx

  ret
