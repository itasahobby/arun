%define SYSCALL_WRITE 1
%define STDOUT 1

section .text

extern strlen
extern strcmp

;;
; Parse arguments, if it does not match exits.
; @param RDI - argc
; @param RDI - argv
; @param RDX - commands
; @param RCX - commands_help
; @return RAX - pointer to the command struct
;;
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

  mov rdi, rcx
  call strlen

  mov rdx, rax
  mov rsi, rcx
  mov rax, SYSCALL_WRITE
  mov rdi, STDOUT
  syscall

  
  xor rax, rax

  pop rbp
  ret
