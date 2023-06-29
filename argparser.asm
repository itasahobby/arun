%include "argparser.inc"
%include "linux.inc"
%include "string.inc"

section .text

;;
; Parse arguments, if it does not match exits.
; @param RDI - argc
; @param RSI - argv
; @param RDX - commands
; @param RCX - commands_help
; @return RAX - pointer to the command struct
;;
argparse:
global argparse:function

  push rbp
  mov rbp, rsp

  ; check if no were arguments given
  cmp rdi, 1
  je .argparse_help

  ; store only parameters in argc
  sub rdi, 2

  ; store subcomand
  mov r10, [rsi + 8]
  
.argparse_loop:

  mov r11, [rdx]

  ; commands should be null byte terminated, therefore this checks if the end of 
  ; the list was reached
  cmp r11, 0
  je .argparse_help
 
  push rdi
  push rsi
  
  mov rdi, [rdx + command.name]
  mov rsi, r10
  call strcmp
  
  pop rsi
  pop rdi

  add rdx, command_size

  cmp rax, 0
  jne .argparse_loop

  cmp rdi, [rdx + command.arg_count - command_size]
  jne .argparse_help

.argparse_fn_callback:

  jmp .argparse_end

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
