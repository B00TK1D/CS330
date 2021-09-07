SECTION .data

SECTION .text

Msg:	db 'Hello',0x0a
	db '',0;

Out: db '/dev/stdout',0;

global _start

_start:
	; Open stdout
	mov rax, 2
	mov rdi, Out
	mov rsi, 1
	syscall

	; Save file descriptor
	mov rdi, rax

	; Write to stdout
	mov rax, 1
	mov rsi, Msg
	mov rdx, 6
	syscall

	; exit
	mov rax, 60
	mov rdi, 0
	syscall
