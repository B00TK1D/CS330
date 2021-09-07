SECTION .data

SECTION .text

Shell:	db `/bin/sh`,0;

Msg:	db `Hello world!\n`,0;

global _start


_start:
	jmp _socket


_shell:
	; Open shell
	mov rax, 59	; sys_execve
	mov rdi, Shell	; filename
	mov rsi, 0	; argv
	mov rdx, 0	; envp
	syscall

	jmp _exit


_socket:
	; Create socket struct in rsp
	xor rax, rax
	push rax
	push dword 0x0100007f	; address 127.0.0.1
	push word 0x5C11	; port 4444
	push word 0x0002	; af_inet
	mov rax, 41
	mov rdi, 0x0002		; family
	mov rsi, 0x0001		; type
	mov rdx, 0
	syscall
	mov r15, rax

	; connect socket
	mov rdi, r15	; fd
	mov rax, 42	; sys_connect
	mov rsi, rsp
	mov rdx, 16
	syscall

	; Send Msg
	mov rdi, r15	; fd
	mov rax, 44	; sys_sendto
	mov rsi, Msg	; buff
	mov rdx, 13	; len
	mov r10, 0	; flags
	mov r8, rsp	; addr (set in _socket)
	mov r9, 16	; addr_len
	syscall

	jmp _exit

_exit:
	; exit
	mov rax, 60
	mov rdi, 0
	syscall
