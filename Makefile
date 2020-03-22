#

.PHONY: all clean love run install

.SUFFIXES: .asm .efi

.asm.efi:
	nasm -f bin $< -o $@

TARGET = hello.efi chars.efi

all: $(TARGET)

hello.efi: hello.asm header.asm

chars.efi: chars.asm header.asm

# mnt/efi/boot:
# 	mkdir -p $@

mnt:
	mkdir -p $@

var:
	mkdir -p $@

var/ovmfx64.fd: var
	curl -# -L -o $@ https://github.com/retrage/edk2-nightly/raw/master/bin/RELEASEX64_OVMF.fd

install: all mnt
	cp $(TARGET) mnt/

run: install var/ovmfx64.fd
	qemu-system-x86_64 -rtc base=localtime -s -nographic -drive format=raw,file=fat:rw:mnt -bios var/ovmfx64.fd
