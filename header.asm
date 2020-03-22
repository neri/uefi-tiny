
    org IMAGE_BASE
_BEGIN:
    db 'MZ' ; e_magic - Mark Zbikowski
    dw 0

_PE:
    db 'PE', 0, 0
    dw 0x8664 ; Machine
    dw 1 ; NumberOfSections
    dd 0, 0, 0 ; OBSOLETED
    dw (_SECTION_HEADER - _OPTIONAL_HEADER) ; SizeOfOptionalHeader
    dw 0x0002 ; Characteristics - IMAGE_FILE_EXECUTABLE_IMAGE

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
    dw 0 ; DllCharacteristics
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
