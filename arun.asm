%define SYSCALL_EXIT 60

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

extern argparse
extern print_hello

_start:
global _start:function

  ; store argc in rdi
  mov rdi, rsp
  ; store argv in rsi (8 bytes aligned)
  lea rsi, [rsp + 8]
  ; send commands struct to rdx
  lea rdx, [commands]
  ; send help message to r8
  lea rcx, [help_message]
  call argparse

  mov rax, SYSCALL_EXIT
  mov rdi, 69
  syscall
