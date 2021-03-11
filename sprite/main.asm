INCLUDE "hardware.inc"
INCLUDE "sprite.inc"

SECTION "Header", rom0[$100]

EntryPoint:
    di
    jp Start 

REPT $150 - $104
    db 0
ENDR

SECTION "Game Code", rom0

Start:
.init
    ld a, [rLY]
    cp a, 144
    jr c, .init

.initTiles
    xor a ; ld a, 0
    ld [rLCDC], a ; disable screen
    ld hl, _VRAM
    ld de, InputTiles
    ld bc, InputTilesEnd - InputTiles

    .copyTiles
        ld a, [de]
        ld [hli], a
        inc de
        dec bc
        ld a, b
        or a, c
        jr nz, .copyTiles

.enableInterrupts
    ld a, IEF_VBLANK
    ld [rIE], a

.setPalette0
    ld a, %00011011
    ld [rOBP0], a
    ld a, %11100100
    ld [rOBP1], a

.setSprite:
    ld a, 15
    ld [OBJ0_X], a
    ld a, 8
    ld [OBJ0_Y], a
    ld a, MOV_RIGHT
    ld [OBJ0_DIR], a
    ld a, 2
    ld [OBJ0_CHR], a
    ld a, OAMF_PAL1 | OAMF_PRI
    ld [OBJ_ATTR], a

.enableScreen
    ld a, LCDCF_ON|LCDCF_BG9800|LCDCF_OBJON|LCDCF_OBJ8|LCDCF_BGON
    ld [rLCDC], a; enable screen with obj & bg

StartEnd:

Main:
    halt 
    nop 
    ld a, [rIF]
    and IEF_VBLANK
    jr z, Main
    xor a
    ld [rIF], a ; wait for Vblank in a clean way
    call MoveSprite
    jr Main
MainEnd:

MoveSprite:
    ld a, [OBJ0_DIR]
    and a, MOV_LEFT
    jp nz, .moveLeft
    ld a, [OBJ0_DIR]
    and a, MOV_RIGHT
    jp nz, .moveRight
.moveLeft
    ld hl, OBJ0_Y
    dec [hl]
    jr .checkDirection
.moveRight
    ld hl, OBJ0_Y
    inc [hl]
    jr .checkDirection
.checkDirection
    ld a, [OBJ0_Y]
    cp a, 50
    jp z, .directionLeft
    cp a, 0
    jp z, .directionRight
    ret
.directionLeft
    ld a, MOV_LEFT
    ld [OBJ0_DIR], a
    ret
.directionRight
    ld a, MOV_RIGHT
    ld [OBJ0_DIR], a
    ret

SECTION "Tiles", ROM0

InputTiles:
INCBIN "input.chr"
InputTilesEnd:
