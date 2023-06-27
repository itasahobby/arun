%include "argparser.inc"
%include "linux.inc"
%include "runtime.inc"

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

  command_names:
    .create: db "create", 0
    .start:  db "start", 0
    .state:  db "state", 0
    .kill:   db "kill", 0
    .delete: db "delete", 0

  commands_struct:
    istruc command
      at command.arg_count, dd  2
      at command.name,      dq  command_names.create
      at command.fn,        dq  create
    iend

    istruc command
      at command.arg_count, dd  1
      at command.name,      dq  command_names.start
    iend
    
    istruc command
      at command.arg_count, dd  1
      at command.name,      dq  command_names.state
    iend
    
    istruc command
      at command.arg_count, dd  2
      at command.name,      dq  command_names.kill
    iend
    
    istruc command
      at command.arg_count, dd  1
      at command.name,      dq  command_names.delete
    iend

section .text

_start:
global _start:function

  ; store argc in rdi
  mov rdi, rsp
  ; store argv in rsi (8 bytes aligned)
  lea rsi, [rsp + 8]
  ; send commands struct to rdx
  lea rdx, [commands_struct]
  ; send help message to r8
  lea rcx, [help_message]
  call argparse

  mov rax, SYSCALL_EXIT
  mov rdi, 69
  syscall
