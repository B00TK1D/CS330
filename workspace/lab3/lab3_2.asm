SECTION .data

SECTION .text

shell:	db `/bin/sh`,0;

global _start

_start:
	; Open shell
	mov rax, 59	; sys_execve
	mov rdi, shell	; filename
	mov rsi, 0	; argv
	mov rdx, 0	; envp
	syscall

	jmp exit

exit:
	; exit
	mov rax, 60
	mov rdi, 0
	syscall
