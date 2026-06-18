.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global __hard_reset__

.type vtable, %object
.type __hard_reset__, %function

vtable:
    .word __stack_start
    .word __hard_reset__ + 1
    .size vtable, . - vtable

__hard_reset__:
    ldr r0, =__stack_start
    mov sp, r0
loop:
    b loop
    .size __hard_reset__, . - __hard_reset__
