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

repeat_loop:
  cmp rax, 0
  je flip_numbers

  mov rdx, 0
  mov rcx, 10
  div rcx
  add dl, 48
  mov byte [rbp + rbx], dl
  inc rbx
  jmp repeat_loop

flip_numbers:
  cmp rbx, 1
  je return_now

  mov r8, rbx
  dec r8
  shr r8, 1
  mov r9, r8
  inc r9

flip_next_digits:
  cmp r8, 0
  jl return_now

  mov dl, byte [rbp + r8]
  mov al, byte [rbp + r9]
  mov byte [rbp + r8], al
  mov byte [rbp + r9], dl

  dec r8
  inc r9
  jmp flip_next_digits

return_now:
  mov rbp, rbx

  ret
