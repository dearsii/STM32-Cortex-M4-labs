.syntax unified
.cpu cortex-m4
.thumb

.global vtable_kernel
.global __kernel_reset__

#ifndef LAB2_VARIANT
#define LAB2_VARIANT 1
#endif

#define A_VALUE #14
#define B_VALUE #6
#define C_VALUE #4

.section .interrupt_vector
.type vtable_kernel, %object
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__ + 1
    .size vtable_kernel, . - vtable_kernel

.section .rodata
kernel_started: .asciz "kernel started"
result_label: .asciz "Result in r3 = "

.section .text
.type __kernel_reset__, %function
__kernel_reset__:
    ldr r0, =kernel_started
    bl dbgput_line

    mov r0, A_VALUE
    mov r1, B_VALUE
    mov r2, C_VALUE

#if LAB2_VARIANT == 0
    add r3, r0, r1
    asr r3, r3, #1
    mov r0, r2
    bl factorial
    add r3, r3, r0
#elif LAB2_VARIANT == 1
    sub r3, r0, r1
    mov r4, #3
    mul r3, r3, r4
    add r3, r3, #2
#elif LAB2_VARIANT == 2
    and r3, r0, r1
    lsr r3, r3, #1
    mov r0, r2
    bl factorial
    add r3, r3, r0
#elif LAB2_VARIANT == 3
    sub r4, r0, r1
    cmp r4, #0
    blt k_v3_negative
    add r3, r0, r1
    sdiv r3, r3, r2
    b k_done
k_v3_negative:
    sdiv r3, r4, r2
    b k_done
#elif LAB2_VARIANT == 4
    mul r4, r0, r1
    cmp r4, #10
    blt k_v4_less
    orr r3, r0, r1
    mul r3, r3, r2
    b k_done
k_v4_less:
    mul r3, r4, r2
    b k_done
#else
    add r3, r0, r2
    lsl r3, r3, #1
    sub r3, r3, r1
#endif

k_done:
    ldr r0, =result_label
    bl dbgput
    mov r0, r3
    bl dbgput_num
    bl newline
k_loop:
    b k_loop

factorial:
    push {r1, r2, lr}
    mov r1, r0
    mov r0, #1
factorial_loop:
    cmp r1, #1
    ble factorial_end
    mul r0, r0, r1
    sub r1, r1, #1
    b factorial_loop
factorial_end:
    pop {r1, r2, pc}
