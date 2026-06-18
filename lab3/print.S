.syntax unified
.cpu cortex-m4
.thumb

.global dbgput
.global dbgput_line
.global newline
.global dbgput_num

#define SEMIHOSTING_SYS_WRITE0 #0x04

.section .rodata
nl: .asciz "\n"

.section .bss
.align 2
num_buffer: .space 16

.section .text
dbgput:
    push {r1, lr}
    mov r1, r0
    mov r0, SEMIHOSTING_SYS_WRITE0
    bkpt #0xAB
    pop {r1, pc}

dbgput_line:
    push {lr}
    bl dbgput
    bl newline
    pop {pc}

newline:
    push {r0, lr}
    ldr r0, =nl
    bl dbgput
    pop {r0, pc}

dbgput_num:
    push {r1-r7, lr}
    ldr r1, =num_buffer
    add r1, r1, #15
    mov r2, #0
    strb r2, [r1]
    mov r4, #10

    cmp r0, #0
    bne convert_loop
    sub r1, r1, #1
    mov r2, #'0'
    strb r2, [r1]
    b print_number

convert_loop:
    cmp r0, #0
    beq print_number
    udiv r5, r0, r4
    mls r6, r5, r4, r0
    add r6, r6, #'0'
    sub r1, r1, #1
    strb r6, [r1]
    mov r0, r5
    b convert_loop

print_number:
    mov r0, r1
    bl dbgput
    pop {r1-r7, pc}
