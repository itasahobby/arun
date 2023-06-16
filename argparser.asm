%define SYSCALL_WRITE 1
%define STDOUT 1

section .text

extern strlen
extern strcmp

; print_help()
print_help:
global print_help:function

  push rbp
  mov rbp, rsp

  call strlen
  
  mov rdx, rax
  mov rsi, rdi
  mov rax, SYSCALL_WRITE
  mov rdi, STDOUT
  syscall

  pop rbp
  ret

.strcmp_loop:
  mov r9b, [rdi + r8]
  mov r10b, [rsi +r8]

  ; increase counter
  add r8, 1
  ; check if the characters are equal
  cmp r9b, r10b
  jne .strcmp_end

  ; check if the characters are null
  cmp r9b, 0
  je .strcmp_match

  ; otherwise, continue looping
  jmp .strcmp_loop  

.strcmp_match:
  ; at this point the strings are equal
  xor rax, rax

.strcmp_end:

  pop rbp
  ret

; argparse(argc, argv, commands, commands_help)
argparse:
global argparse:function

  push rbp
  mov rbp, rsp

  ; store the pointer of argv[1] in r10
  mov r10, [rsi + 8]
  
  ; check if argc is 1 (no arguments given)
  cmp dword byte [rdi], 1
  je .argparse_help

  ; comparing argv[1] to check that the number of arguments are correct
  
  ; getting first command from data section
  mov r11, [rdx]
  ; comparing the number of arguments expected with the number of arguments given

  ; Check if there is no more commands
  cmp r11, 0
  je .argparse_help

  lea rdi, [rdx + 4]
  mov rsi, r10
.argparse_loop:
  call strcmp

  cmp rax, 0
  je .argparse_execute_command

.argparse_execute_command:


  ; if no arguments are given, print help message and exit
.argparse_help:
  ; by default returning null
  xor rax, rax
  mov rdi, rcx
  call print_help
  
  pop rbp
  ret
