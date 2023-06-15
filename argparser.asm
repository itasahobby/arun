%define SYSCALL_WRITE 1
%define STDOUT 1

section .data
  help_message:
    ; help message
    db "create <id> <bundle_path>", 10
    db "start <id>", 10
    db "state <id>", 10
    db "kill <id> <signal>", 10
    db "delete <id>", 10
    db 0

  help_message_len equ $ - help_message - 1

  commands:
    ; create <id> <bundle_path>
    dd 2
    db "create", 0
    ; start <id>
    dd 1
    db "start", 0
    ; state <id>
    dd 1
    db "state", 0
    ; kill <id> <signal>
    dd 2
    db "kill", 0
    ; delete <id>
    dd 1
    db "delete", 0
  
  commands_len equ $ - commands

section .text

; print_help()
print_help:
global print_help:function

  push rbp
  mov rbp, rsp

  mov rax, SYSCALL_WRITE
  mov rdi, STDOUT
  mov rsi, help_message
  mov rdx, help_message_len
  syscall

  pop rbp
  ret

; strcmp(s1, s2)
; compares two strings and returns 0 if they are equal, -1 if they are not equal
; they must be null-terminated
strcmp:
global strcmp:function

  push rbp
  mov rbp, rsp

  mov rax, -1

  ; store the counter in r8
  xor r8, r8
  ; store in r9 the first string
  xor r9, r9
  ; store in r10 the second string
  xor r10, r10

  strcmp_loop:
  mov r9b, [rdi + r8]
  mov r10b, [rsi +r8]

  ; increase counter
  add r8, 1
  ; check if the characters are equal
  cmp r9b, r10b
  jne strcmp_end

  ; check if the characters are null
  cmp r9b, 0
  je strcmp_match

  ; otherwise, continue looping
  jmp strcmp_loop  

strcmp_match:
  ; at this point the strings are equal
  xor rax, rax

strcmp_end:

  pop rbp
  ret

; argparse(argc, argv)
argparse:
global argparse:function

  push rbp
  mov rbp, rsp

  sub rsp, 16

  ; store the pointer of argv[1] in r10
  mov r10, [rsi + 8]
  
  ; check if argc is 1 (no arguments given)
  cmp dword byte [rdi], 1
  je argparse_help

  ; comparing argv[1] to check that the number of arguments are correct
  
  ; getting first command from data section
  mov r11, [commands]
  ; comparing the number of arguments expected with the number of arguments given

  ; Check if there is no more commands
  cmp r11, 0
  je argparse_help

argparse_loop:
  lea rdi, [commands + 4]
  mov rsi, r10
  call strcmp
  cmp rax, 0
  jne argparse_loop


; if no arguments are given, print help message and exit
argparse_help:
  ; by default returning null
  xor rax, rax
  call print_help
  
  add rsp, 16

  pop rbp
  ret
