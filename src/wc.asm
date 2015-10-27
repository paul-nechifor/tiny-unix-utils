%include '_macros.mac'

section .data

byte_count: dq 0
word_count: dq 0
line_count: dq 0

section .bss

buffer: resb small_buf_size
output_str: resb 100

section .text

global _start
_start:

  ; Read from stdin into the buffer.
  mov rax, syscall_read
  mov rbx, stdin_fileno
  mov rcx, buffer
  mov rdx, small_buf_size
  syscall

  cmp rax, 0
  jle read_finished

  add [byte_count], rax

  ; Loop over everything that was read and count the line feeds.
  mov rcx, rax
count_line_feeds:
  cmp byte [buffer + rcx], chr_line_feed
  jne skip_increase_line_feeds
  inc qword [line_count]
skip_increase_line_feeds:
  loop count_line_feeds

  jmp _start

read_finished:
  ; From here:
  ;
  ; * `rsi` points to the next character to be written.
  ; * `rdi` is the lenght of the string (its actual asignment is lower though).
  mov rsi, output_str

  ; Add the first number to `output_str` and increase length and the write
  ; pointer.
  mov rax, [byte_count]
  mov rbp, rsi
  call u64_to_str
  mov rdi, rbp
  add rsi, rbp

  ; Add a space.
  mov byte [rsi], chr_space
  inc rdi
  inc rsi

  ; Write the second number.
  mov rax, [word_count]
  mov rbp, rsi
  call u64_to_str
  add rdi, rbp
  add rsi, rbp

  ; Add a space.
  mov byte [rsi], chr_space
  inc rdi
  inc rsi

  ; Write the third number.
  mov rax, [line_count]
  mov rbp, rsi
  call u64_to_str
  add rdi, rbp
  add rsi, rbp

  ; Add a line feed at the end of it all.
  mov byte [rsi], chr_line_feed
  inc rdi

  ; Write the line to stdout.
  mov rax, syscall_write
  mov rbx, stdout_fileno
  mov rcx, output_str
  mov rdx, rdi
  syscall

exit:
  mov rax, syscall_exit
  mov rbx, exit_success_code
  syscall

%include '_u64_to_str.asm'
