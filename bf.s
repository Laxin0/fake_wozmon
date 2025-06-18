SRC    = $1000
TAPE   = $1100
KBD    = $D010         ;  PIA.A keyboard input
KBDCR  = $D011         ;  PIA.A keyboard control register
DSP    = $D012         ;  PIA.B display output register
DSPCR  = $D013         ;  PIA.B display control register
ECHO   = $FFEF

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
    cmp #$8A
    bne nextchar
    ldx 0
    ldy 0
nextbf:
    lda SRC,Y
    iny
plus:
    cmp #'+'+$80
    bne minus
    lda #'P'+$80
    jsr ECHO
    inc TAPE,X
minus:
    cmp #'-'+$80
    bne right
    lda #'M'+$80
    jsr ECHO
    dec TAPE,X
right:
    cmp #'>'+$80
    bne left
    lda #'R'+$80
    jsr ECHO
    inx
left:
    cmp #'<'+$80
    bne nextbf
    lda #'L'+$80
    jsr ECHO
    dex
    
    cmp #$8A
    bne nextbf
return:
    jmp $FF00
    
    

    
