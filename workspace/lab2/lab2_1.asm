SECTION .data

SECTION .text

msg: db "hello world!",0x0a,00;

global _start

_start:
	mov RAX, $
	mov RBX, [$]
	lea RCX, [$]

	mov RAX, msg
	mov RBX, [msg]
	lea RCX, [msg]

	lea R9, [msg+6]
	mov R10, [msg+6]
