    ldx #0
.loop:
    lda msg,x
    beq .out
    sta stdout
    inx
    jmp .loop
.out:
    lda #msg+1
    ldy #msg
    jsr strlen
    jsr PRBYTE
    jmp $FF00


strlen:
    sta $0
    sty $1
    ldx #0
.again
    lda ($0,x)
    beq .out
    inx
    jmp  .again
.out
    tya
    rts


msg: .string "This is string\n"
    msg_len = *-msg

