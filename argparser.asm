%include "argparser.inc"
%include "linux.inc"
%include "string.inc"

section .text

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

  ; store subcomand
  mov r10, [rsi + 8]
  
  ; check if no were arguments given
  cmp dword byte [rdi], 1
  je .argparse_help

  ; comparing argv[1] to check that the number of arguments are correct
  
  ; getting first command from data section
  mov r11, [rdx]
  ; comparing the number of arguments expected with the number of arguments given

  ; Check if there are no more commands
  cmp r11, 0
  je .argparse_help

  mov rdi, [rdx + command.name]
  mov rsi, r10
.argparse_loop:
  call strcmp

  cmp rax, 0
  mov rax, rdx
  je .argparse_end

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

.argparse_end:

  pop rbp
  ret
