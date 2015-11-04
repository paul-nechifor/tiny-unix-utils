%include '_macros.mac'

section .data

byte_count: dq 0
word_count: dq 0
line_count: dq 0
prev_char_is_letter: db 0

section .bss

buffer: resb small_buf_size
output_str: resb 100

section .text

global _start
_start:

  ; Read from stdin into the buffer.
  mov rax, syscall_read
  mov rdi, stdin_fileno
  mov rsi, buffer
  mov rdx, small_buf_size
  syscall

  cmp rax, 0
  jle read_finished

  add [byte_count], rax

  ; Loop over everything that was read and then count the line feeds. Here:
  ;
  ; * `al` holds the current caracter to be compared (it's set a little lower).
  ; * `rcx` is used for looping over the buffer (the buffer is traversed in
  ;   reverse).
  mov rcx, rax
  mov rbx, 0

count_line_feeds:
  xor rax, rax
  mov al, [buffer + rcx - 1]
  cmp al, chr_line_feed
  jne dont_increase_line_feeds
  inc qword [line_count]
dont_increase_line_feeds:

  ; The next stage is figuring out if a character is a letter (i.e. matches
  ; `[A-Za-z_]`).
  cmp al, chr_a_lower
  jb compare_to_uppers
  cmp al, chr_z_lower
  jbe this_character_is_a_letter

compare_to_uppers:
  cmp al, chr_a_upper
  jb compare_to_underscore
  cmp al, chr_z_upper
  jbe this_character_is_a_letter

compare_to_underscore:
  cmp al, chr_underscore
  jne this_character_isnt_a_letter

this_character_is_a_letter:
  mov dl, byte [prev_char_is_letter]
  mov byte [prev_char_is_letter], 1
  cmp dl, 0
  je increase_word_count
  jmp continue_this_loop

this_character_isnt_a_letter:
  mov byte [prev_char_is_letter], 0
  jmp continue_this_loop

increase_word_count:
  inc qword [word_count]

continue_this_loop:
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

  ; Write the line to stdout. The arguments for the call are out of order
  ; because I've used `rdi`.
  mov rax, syscall_write
  mov rdx, rdi
  mov rsi, output_str
  mov rdi, stdout_fileno
  syscall

exit:
  mov rax, syscall_exit
  mov rdi, exit_success_code
  syscall

%include '_u64_to_str.asm'
