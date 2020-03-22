;; A Tiny UEFI Hello World

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
    enter 0x20, 0
    ; sub rsp, byte 0x28
    mov rcx, [rdx + 0x40] ; EFI_SYSTEM_TABLE->ConOut
    lea rdx, [rel hello_string]
    call [rcx + 0x08] ; EFI_SIMPLE_OUTPUT_PROTOCOL->OutputString
    xor eax, eax
    leave
    ; add rsp, byte 0x28
    ret

hello_string:
    dw u("Hello, world!"), 13, 10, 0

_END:
