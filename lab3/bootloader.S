.syntax unified
.cpu cortex-m4
.thumb

.global bootload

#ifndef BOOT_VARIANT
#define BOOT_VARIANT 1
#endif

.section .rodata
image:
    .incbin "kernel.bin"
end_of_image:
str_boot_start: .asciz "bootloader started"
str_boot_end: .asciz "bootloader end"

.section .text
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line

    ldr r0, =end_of_image
    ldr r1, =image
    ldr r2, =_ram_start

#if BOOT_VARIANT == 0
copy_loop:
    ldr r3, [r1], #4
    str r3, [r2], #4
    cmp r1, r0
    blo copy_loop

#elif BOOT_VARIANT == 1
    mov r5, #0
    mov r7, #4
copy_loop:
    ldr r3, [r1, r5]
    str r3, [r2, r5]
    add r5, r5, r7
    add r6, r1, r5
    cmp r6, r0
    blo copy_loop

#elif BOOT_VARIANT == 2
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
copy_loop:
    sub r1, r1, #4
    sub r2, r2, #4
    ldr r3, [r1]
    str r3, [r2]
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 3
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
    mov r5, #4
copy_loop:
    sub r1, r1, r5
    sub r2, r2, r5
    ldr r3, [r1]
    str r3, [r2]
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 4
copy_loop:
    ldrb r3, [r1], #1
    strb r3, [r2], #1
    cmp r1, r0
    blo copy_loop

#elif BOOT_VARIANT == 5
    mov r5, #0
    mov r7, #1
copy_loop:
    ldrb r3, [r1, r5]
    strb r3, [r2, r5]
    add r5, r5, r7
    add r6, r1, r5
    cmp r6, r0
    blo copy_loop

#elif BOOT_VARIANT == 6
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
copy_loop:
    sub r1, r1, #1
    sub r2, r2, #1
    ldrb r3, [r1]
    strb r3, [r2]
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 7
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
    mov r5, #1
copy_loop:
    sub r1, r1, r5
    sub r2, r2, r5
    ldrb r3, [r1]
    strb r3, [r2]
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 8
copy_loop:
    ldrh r3, [r1], #2
    strh r3, [r2], #2
    cmp r1, r0
    blo copy_loop

#elif BOOT_VARIANT == 9
    mov r5, #0
    mov r7, #2
copy_loop:
    ldrh r3, [r1, r5]
    strh r3, [r2, r5]
    add r5, r5, r7
    add r6, r1, r5
    cmp r6, r0
    blo copy_loop

#elif BOOT_VARIANT == 10
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
copy_loop:
    sub r1, r1, #2
    sub r2, r2, #2
    ldrh r3, [r1]
    strh r3, [r2]
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 11
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
    mov r5, #2
copy_loop:
    sub r1, r1, r5
    sub r2, r2, r5
    ldrh r3, [r1]
    strh r3, [r2]
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 12
copy_loop:
    ldmia r1!, {r3, r4}
    stmia r2!, {r3, r4}
    cmp r1, r0
    blo copy_loop

#elif BOOT_VARIANT == 13
copy_loop:
    ldmia r1!, {r3, r4, r5}
    stmia r2!, {r3, r4, r5}
    cmp r1, r0
    blo copy_loop

#elif BOOT_VARIANT == 14
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
copy_loop:
    ldmdb r1!, {r3, r4}
    stmdb r2!, {r3, r4}
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop

#elif BOOT_VARIANT == 15
    sub r4, r0, r1
    add r1, r1, r4
    ldr r2, =_ram_start
    add r2, r2, r4
copy_loop:
    ldmdb r1!, {r3, r4, r5}
    stmdb r2!, {r3, r4, r5}
    ldr r6, =image
    cmp r1, r6
    bhi copy_loop
#endif

    ldr r0, =str_boot_end
    bl dbgput_line

    ldr lr, =bootload_end
    add lr, lr, #1
    ldr r2, =_ram_start
    add r2, r2, #4
    ldr r0, [r2]
    bx r0

bootload_end:
    b bootload_end
