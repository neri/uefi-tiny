;; UEFI CHARS

%define u(x) __utf16__(x) 
%define IMAGE_BASE 0x140000000
%define RVA_TEXT (_TEXT - _BEGIN)
%define RVA0 IMAGE_BASE

[bits 64]
[section .text]

%if 1
    org IMAGE_BASE
_BEGIN:
    db 'MZ' ; e_magic - Mark Zbikowski
    dw 0
    ; times 0x3C - ($ - $$) db 0
    ; dd (_PE - _BEGIN) ; e_lfanew

_PE:
    db 'PE', 0, 0
    dw 0x8664 ; Machine
    dw 1 ; NumberOfSections
    dd 0, 0, 0 ; OBSOLETED
    dw (_SECTION_HEADER - _OPTIONAL_HEADER) ; SizeOfOptionalHeader
    dw 0x0022 ; Characteristics - IMAGE_FILE_EXECUTABLE_IMAGE, IMAGE_FILE_LARGE_ADDRESS_AWARE

_OPTIONAL_HEADER:
    dw 0x020B ; PE32+
    db 14, 0 ; linker version
    dd 0, 0, 0 ; SizeOfCode, SizeOfInitializedData, SizeOfUninitializedData - DEPRECATED?
    dd EfiMain - RVA0 ; AddressOfEntryPoint
    dd 0 ; BaseOfCode - DEPRECATED?
    dq IMAGE_BASE ; ImageBase
    dd 4, 4 ; SectionAlignment | e_lfa_new, FileAlignment
    dw 6, 0, 0, 0, 6, 0 ; versions
    dd 0 ; Win32VersionValue - RESERVED
    dd (_END - _TEXT) + RVA_TEXT, (_END_HEADER - _BEGIN) ; SizeOfImage, SizeOfHeaders
    dd 0 ; CheckSum
    dw 0x0A ; Subsystem - IMAGE_SUBSYSTEM_EFI_APPLICATION
    dw 0x8160 ; DllCharacteristics - _HIGH_ENTROPY_VA, _DYNAMIC_BASE, _NX_COMPAT, _TERMINAL_SERVER_AWARE
    dq 0x100000, 0x10000, 0x100000, 0x10000 ; SizeOfStackReserve, SizeOfStackCommit, SizeOfHeapReserve, SizeOfHeapCommit
    dd 0 ; LoaderFlags - RESERVED MBZ
    dd 6 ; NumberOfRvaAndSizes - 16 formal, 6 OVMF's minimal
    times 6 dd 0, 0 ; dummy

_SECTION_HEADER:
    db ".text", 0, 0, 0 ; Name
    dd (_END - _TEXT), RVA_TEXT ; VirtualSize, VirtualAddress
    dd (_END - _TEXT), _TEXT - _BEGIN ; SizeOfRawData, PointerToRawData
    dd 0, 0, 0 ; OBSOLETED
    dd 0x60000020 ; Characteristics - IMAGE_SCN_CNT_CODE, IMAGE_SCN_MEM_EXECUTE, IMAGE_SCN_MEM_READ

_END_HEADER:

%endif

_TEXT:

    global EfiMain
EfiMain:
    push rbx
    push rdi
    enter 0x20, 0

    mov rdi, rdx
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
