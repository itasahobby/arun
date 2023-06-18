
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

  mov rax, -1

  ; initialize the counter
  xor r8, r8

.strcmp_loop:
  mov r9b, [rdi + r8]
  mov r10b, [rsi +r8]

  inc r8

  cmp r9b, r10b
  jne .strcmp_end

  ; if they are null and last character was equal, then they are equal
  cmp r9b, 0
  je .strcmp_match

  jmp .strcmp_loop  

.strcmp_match:
  xor rax, rax

.strcmp_end:
  ret
