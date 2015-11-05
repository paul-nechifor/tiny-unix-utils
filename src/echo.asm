%include '_macros.mac'

section .data

space_array: db chr_space

section .text

global _start
_start:

  ; `rsp` is argc
  ; `rsp + 8` is argv[0]
  mov rbp, [rsp]
  xor rbx, rbx
  inc rbx

print_next_one:
  cmp rbx, rbp
  jae exit

  ; Find the address of the end byte. In the syscall below, the length is
  ; computed by subtracting the start address.
  mov rdx, [rsp + 8 * rbx + 8]
test_next_byte_for_zero:
  cmp byte [rdx], 0
  je done_computing_the_length
  inc rdx
  jmp test_next_byte_for_zero
done_computing_the_length:

  ; Write the first character.
  mov rax, syscall_write
  mov rdi, stdout_fileno
  mov rsi, [rsp + 8 * rbx + 8]
  sub rdx, rsi
  syscall

  inc rbx
  cmp rbx, rbp
  jae exit

  ; Write a space.
  mov rax, syscall_write
  mov rdi, stdout_fileno
  mov rsi, space_array
  mov rdx, 1
  syscall

  jmp print_next_one

exit:
  mov rax, syscall_exit
  xor rdi, rdi
  syscall
