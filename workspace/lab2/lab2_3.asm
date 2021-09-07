SECTION .data

SECTION .text

global _start

_start:
	mov RAX, RSP
	mov RBX, RBP
	push 1
	push 2
	push 3

	mov RCX, RSP
	mov RDX, RBP
	pop R8
	pop R9
	pop R10

	mov RSI, RSP
	mov RDI, RBP
	call .callTest
	NOP

_start.callTest:
	push RBP
	mov RBP, RSP

	mov RAX, RSP
        mov RBX, RBP
        push 1
        push 2
        push 3

        mov RCX, RSP
        mov RDX, RBB
        pop R8
        pop R9
        pop R10

        mov RSI, RSP
        mov RDI, RBP
