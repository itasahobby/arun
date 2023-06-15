%define SYSCALL_EXIT 60

; arg_parser:
;   push rbp
;   mov rbp, rsp

;   sub rsp, N

;   [...]


;   add rsp, N
;   pop rbp
;   ret


section .text

extern argparse
extern print_hello

_start:
global _start:function

  ; store argc in rdi
  mov rdi, rsp
  ; store argv in rsi (8 bytes aligned)
  lea rsi, [rsp + 8]
  call argparse

  mov rax, SYSCALL_EXIT
  mov rdi, 0
  syscall
