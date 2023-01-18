;; A Tiny UEFI Hello World

%define IMAGE_BASE 0x140000000
%define RVA_TEXT (_TEXT - _BEGIN)
%define RVA0 IMAGE_BASE

[bits 64]
[section .text]

%include "header.asm"

_TEXT:

    global EfiMain
EfiMain:
    sub rsp, 0x28
    mov rcx, [rdx + 64]
    lea rdx, [rel hello_string]
    call [rcx + 8]

fin:
    jmp fin

hello_string:
    dw __utf16__("Hello, world!"), 13, 10, 0

_END:
