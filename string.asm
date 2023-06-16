
section .text

strlen:
global strlen:function
    ; Get length of string in rax
    push rcx
    mov rcx, -1
.loop:
    inc rcx
    cmp byte [rdi+rcx], 0
    jne .loop
    mov rax, rcx
    pop rcx
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
