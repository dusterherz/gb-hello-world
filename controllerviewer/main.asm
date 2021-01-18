INCLUDE "hardware.inc"

SECTION "Header", rom0[$100]

EntryPoint:
    di
    jp Start 

REPT $150 - $104
    db 0
ENDR

SECTION "Game Code", rom0

Start:
.waitVBlank
    ld a, [rLY]
    cp a, 144
    jr c, .waitVBlank

    xor a; ld a, 0
    ld [rLCDC], a

    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles

.copyFont
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, .copyFont

    ld hl, $9900; print sentence on top screen
    ld de, HelloWorldStr

.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString

    ld a, %11100100
    ld [rBGP], a

    xor a; ld a, 0
    ld [rSCY], a
    ld [rSCX], a
    ld [rNR52], a
    ld a, %10000001
    ld [rLCDC], a

xor d
xor e

.controlScroll
    ld a, [rLY]
    cp a, 144
    jr nz, .controlScroll
    nop
    nop
    nop
    ; read the input
    ld a, $20 ; set bit 5 for cross, 
    ld [$FF00], a
    ld a, [$FF00]
    ld a, [$FF00]
    ld b, a
    ld a, $10 ; set bit 4 for a b select start, 
    ld [$FF00], a
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld a, [$FF00]
    ld c, a
    ld a, $30; re-enable input if 5 and 4 are set
    ld [$FF00], a
    ld a, b
    bit 7, a
    jr z, .scrollDown
    jr .controlScroll

.scrollDown
    inc e
    ld a, e
    ld [rSCY], a ; scroll vertically
    jr .controlScroll

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello World string", ROM0

HelloWorldStr:
    db "Hello Github !", 0
