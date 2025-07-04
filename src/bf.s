SRC    = $1000
TAPE   = $1100
NESTL  = $10
;KBD    = $D010         ;  PIA.A keyboard input
;KBDCR  = $D011         ;  PIA.A keyboard control register
;DSP    = $D012         ;  PIA.B display output register
;DSPCR  = $D013         ;  PIA.B display control register
;ECHO   = $FFEF

    lda #$8A
    jsr ECHO

    ldy #0
nextchar:
    lda KBDCR
    bpl nextchar

    lda KBD
    sta SRC,Y
    iny
    jsr ECHO
    
    cmp #$8A        ; \n ?
    bne nextchar

    ldx 0
    ldy 0
nextbf:
    lda SRC,Y
    iny
    ;jsr ECHO

    cmp #'+'+$80
    beq plus
    cmp #'-'+$80
    beq minus
    cmp #'<'+$80
    beq left
    cmp #'>'+$80
    beq right
    cmp #'.'+$80
    beq dot
    cmp #','+$80
    beq comma
    cmp #'['+$80
    beq opbrack
    cmp #']'+$80
    beq clbrack
    cmp #$8A
    bne nextbf
    jmp RESET
plus:
    inc TAPE,X
    jmp nextbf
minus:
    dec TAPE,X
    jmp nextbf
left:
    dex
    jmp nextbf
right:
    inx
    jmp nextbf
dot:
    lda TAPE,X
    jsr ECHO
    jmp nextbf
comma:
    lda KBDCR
    bpl comma
    lda KBD
    sta TAPE,X
    jmp nextbf
opbrack:
    cmp #']'+$80
clbrack:
    
    
    

    
