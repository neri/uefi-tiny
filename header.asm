
    org IMAGE_BASE
_BEGIN:
    db 'MZ' ; e_magic - Mark Zbikowski
    dw 0

_PE:
    db 'PE', 0, 0
    dw 0x8664 ; Machine
    dw 0 ; NumberOfSections
    dd 0, 0, 0 ; OBSOLETED
    dw (_OPTIONAL_HEADER_END - _OPTIONAL_HEADER) ; SizeOfOptionalHeader
    dw 0x0022 ; Characteristics - IMAGE_FILE_LARGE_ADDRESS_AWARE | IMAGE_FILE_EXECUTABLE_IMAGE

_OPTIONAL_HEADER:
    dw 0x020B ; PE32+
    db 0, 0 ; linker version
    dd 0, 0, 0 ; SizeOfCode, SizeOfInitializedData, SizeOfUninitializedData - DEPRECATED?
    dd EfiMain - RVA0 ; AddressOfEntryPoint
    dd 0 ; BaseOfCode - DEPRECATED?
    dq IMAGE_BASE ; ImageBase
    dd 4, 4 ; SectionAlignment | e_lfa_new, FileAlignment
    dw 0, 0, 0, 0, 0, 0 ; versions
    dd 0 ; Win32VersionValue - RESERVED
    dd (_END - _BEGIN) + 0x10000 ; SizeOfImage
    dd (_END - _BEGIN) ; SizeOfHeaders
    dd 0 ; CheckSum
    dw 0x0A ; Subsystem - IMAGE_SUBSYSTEM_EFI_APPLICATION
    dw 0 ; DllCharacteristics
    dq 0x10000, 0x10000, 0x10000, 0 ; SizeOfStackReserve, SizeOfStackCommit, SizeOfHeapReserve, SizeOfHeapCommit
    dd 0 ; LoaderFlags - RESERVED MBZ

    dd 0
_OPTIONAL_HEADER_END:

_END_HEADER:
