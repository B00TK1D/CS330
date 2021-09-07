SECTION .data

SECTION .text

msg: db "hello world!",0x0a,00;

global _start

_start:
	mov RAX, $
	mov RBX, [rel $]
	lea RCX, [rel $]

	mov RAX, msg
	mov RBX, [rel msg]
	lea RCX, [rel msg]

	lea R9, [rel msg+6]
	mov R10, [rel msg+6]
