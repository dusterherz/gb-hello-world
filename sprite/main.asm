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

.setSprites:
    ld a, 16
    ld [rOBJ0_X], a
    ld a, 150
    ld [rOBJ1_X], a
    ld a, 8
    ld [rOBJ0_Y], a
    ld a, 160
    ld [rOBJ1_Y], a
    ld a, MOV_RIGHT
    ld [rOBJ0_DIR], a
    ld a, MOV_LEFT
    ld [rOBJ1_DIR], a
    ld a, 3
    ld [rOBJ0_CHR], a
    ld [rOBJ1_CHR], a
    ld a, OAMF_PAL1 | OAMF_PRI
    ld [rOBJ0_ATTR], a
    ld a, OAMF_PAL1 | OAMF_PRI | OAMF_XFLIP
    ld [rOBJ1_ATTR], a

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
    call MoveSprites
    jr Main
MainEnd:

MoveSprites:
    ld d, OBJS_SIZE
    ld hl, rOBJ0_X
.moveSpritesLoop
    ld a, d
    or a
    ret z ; if d = 0, moveSprites is finished
    .moveSprite:
        push hl
        ld bc, $180 ; difference between rOBJ0_X and rOBJ0_DIR
        add hl, bc
        ld a, [hl]
        and a, MOV_LEFT
        jp nz, .moveLeft
        ld a, [hl]
        and a, MOV_RIGHT
        jp nz, .moveRight
    .moveLeft
        pop hl
        inc hl
        dec [hl]
        jr .checkDirection
    .moveRight
        pop hl
        inc hl
        inc [hl]
        jr .checkDirection
    .checkDirection
        ld a, [hl]
        dec hl
        push hl
        cp a, 160
        jp nc, .directionLeft
        cp a, 8
        jp c, .directionRight
        jr .moveSpritesLoopEnd
    .directionLeft
        ld bc, $180 ; difference between rOBJ0_Y and rOBJ0_DIR
        add hl, bc 
        ld a, MOV_LEFT
        ld [hl], a
        pop hl
        push hl
        ld bc, 3
        add hl, bc
        ld a,  OAMF_PAL1 | OAMF_PRI | OAMF_XFLIP
        ld [hl], a
        jr .moveSpritesLoopEnd
    .directionRight
        ld bc, $180 ; difference between rOBJ0_Y and rOBJ0_DIR
        add hl, bc 
        ld a, MOV_RIGHT
        ld [hl], a
        pop hl
        push hl
        ld bc, 3
        add hl, bc
        ld a,  OAMF_PAL1 | OAMF_PRI
        ld [hl], a
        jr .moveSpritesLoopEnd
    .moveSpritesLoopEnd
        pop hl
        ld bc, 4
        add hl, bc
        dec d
        jr .moveSpritesLoop

SECTION "Tiles", ROM0

InputTiles:
INCBIN "input.chr"
InputTilesEnd:
