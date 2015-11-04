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

  ; Write the first character.
  mov rax, syscall_write
  mov rdi, stdout_fileno
  mov rsi, [rsp + 8 * rbx + 8]
  mov rdx, 1
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
