SECTION .data

SECTION .text

global _start


_start:
        xor r8, r8
        xor r10, r10
        shr r8, 1
        shr r10, 1
        mov rcx, 65
        LOOP _loop1

_loop1:
        shr r8, 1
        shl r9, 1
        sar r10, 1
        sal r11, 1
