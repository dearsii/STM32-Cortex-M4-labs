.syntax unified
.cpu cortex-m4
.thumb

.global lab2

#ifndef LAB2_VARIANT
#define LAB2_VARIANT 1
#endif

#define A_VALUE #14
#define B_VALUE #6
#define C_VALUE #4
#define SHIFT_VALUE #1

lab2:
    push {lr}
    mov r0, A_VALUE
    mov r1, B_VALUE
    mov r2, C_VALUE

#if LAB2_VARIANT == 0
    // r3 = (a + b) / 2 + c!
    add r3, r0, r1
    asr r3, r3, #1
    mov r0, r2
    bl factorial
    add r3, r3, r0

#elif LAB2_VARIANT == 1
    // r3 = (a - b) * 3 + 2
    sub r3, r0, r1
    mov r4, #3
    mul r3, r3, r4
    add r3, r3, #2

#elif LAB2_VARIANT == 2
    // r3 = ((a & b) >> 1) + c!
    and r3, r0, r1
    lsr r3, r3, SHIFT_VALUE
    mov r0, r2
    bl factorial
    add r3, r3, r0

#elif LAB2_VARIANT == 3
    // if (a - b) >= 0: r3 = (a + b) / c; else r3 = (a - b) / c
    sub r4, r0, r1
    cmp r4, #0
    blt variant3_negative
    add r3, r0, r1
    sdiv r3, r3, r2
    b variant_done
variant3_negative:
    sdiv r3, r4, r2
    b variant_done

#elif LAB2_VARIANT == 4
    // if (a * b) >= 10: r3 = (a | b) * c; else r3 = (a * b) * c
    mul r4, r0, r1
    cmp r4, #10
    blt variant4_less
    orr r3, r0, r1
    mul r3, r3, r2
    b variant_done
variant4_less:
    mul r3, r4, r2
    b variant_done

#else
    // Bonus/example variant: r3 = ((a + c) << 1) - b
    add r3, r0, r2
    lsl r3, r3, #1
    sub r3, r3, r1
#endif

variant_done:
    pop {pc}

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
