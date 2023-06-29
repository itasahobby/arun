
section .text

;;
; Calculate the length of a null terminated string in bytes.
; @param RDI - address of string
; @return RAX - number of bytes in string
;;
strlen:
global strlen:function

    mov rax, -1
.strlen_loop:
    inc rax
    cmp byte [rdi+rax], 0
    jne .strlen_loop
    ret


;;
; Compare two null terminated strings.
; @param RDI - address of first string
; @param RDI - address of first string
; @return RAX - if both strings are the same return 0, otherwise returns -1
;;
strcmp:
global strcmp:function

  push r12
  push r13
  push r14

  mov rax, -1

  ; initialize the counter
  xor r12, r12

.strcmp_loop:
  mov r13b, [rdi + r12]
  mov r14b, [rsi +r12]

  inc r12

  cmp r13b, r14b
  jne .strcmp_end

  ; if they are null and last character was equal, then they are equal
  cmp r13b, 0
  je .strcmp_match

  jmp .strcmp_loop  

.strcmp_match:
  xor rax, rax

.strcmp_end:
  
  pop r14
  pop r13
  pop r12

  ret
