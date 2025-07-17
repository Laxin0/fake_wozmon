read_addr = $10
    ldx #0
    lda #$10
    sta read_addr
    lda #$00
    sta read_addr+1

readnextchar:
    lda (read_addr,x)
    sta stdout
    inc read_addr
    bne readnextchar
    inc read_addr+1
    cmp #0
    bne readnextchar
    jmp $FF00
