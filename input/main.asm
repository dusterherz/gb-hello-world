INCLUDE "hardware.inc"

SECTION "vblankint", ROM0[$40]
    reti

SECTION "entry", ROM0[$100]
    jp start

SECTION "Main", rom0[$150]
start:
    ; Enables interrupts & callbacks
    ld a, IEF_VBLANK ; set register a to the value to enable interrupts on Vblank
    ld [rIE], a ; set memory that handle interrupt with a value (aka IEF_VBLANK)
    ei ; Enable Interrupts
mainLoop:
    call updateJoypad
    halt
    jp   mainLoop

updateJoypad:
    ld hl, rP1; Set hl register to the cu
    ld [hl], P1F_GET_BTN ; pre
