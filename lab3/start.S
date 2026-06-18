.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global __hard_reset__

.section .interrupt_vector
.type vtable, %object
vtable:
    .word __stack_start
    .word __hard_reset__ + 1
    .size vtable, . - vtable

.section .text
.type __hard_reset__, %function
__hard_reset__:
    ldr r0, =__stack_start
    mov sp, r0
    bl bootload
stop:
    b stop
