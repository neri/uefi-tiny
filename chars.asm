;; UEFI CHARS

%define u(x) __utf16__(x) 
%define IMAGE_BASE 0x140000000
%define RVA_TEXT (_TEXT - _BEGIN)
%define RVA0 IMAGE_BASE

[bits 64]
[section .text]

%include "header.asm"

_TEXT:

    global EfiMain
EfiMain:
    push rbx
    push rdi
    enter 0x20, 0
    mov rdi, rdx ; EFI_SYSTEM_TABLE

    mov ebx, 0x20
.loop:
    mov rcx, [rdi + 0x40] ; EFI_SYSTEM_TABLE->ConOut
    lea rdx, [rbp + 0x20]
    mov [rdx], ebx
    call [rcx + 0x08] ; EFI_SIMPLE_OUTPUT_PROTOCOL->OutputString
    inc ebx
    cmp bl, 0x7F
    jb .loop

    xor eax, eax
    leave
    pop rdi
    pop rbx
    ret


_END:
