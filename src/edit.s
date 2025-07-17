stdin  = $D000 ; I don't know
stdout = $D001

left_l  = $10

    ldx #0
    lda #$10
    sta left_l
    lda #$00
    sta left_l+1

readchar:
    lda stdin
    bmi readchar
    
    sta stdout
    cmp #'$'
    beq exitprogram
    sta (left_l,x)
    inc left_l
    bne readchar
    inc left_l+1
    jmp readchar
exitprogram:
    lda #0
    sta (left_l,x)
    jmp $FF00
