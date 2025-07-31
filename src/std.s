    .include "reg.s"
    .include "ports.s" 
   
    ;brk

    ;.org($200)

start:
    
    lda #$00
    sta r1l
    lda #$FF
    sta r1h

    lda #$FF
    sta r2l
    lda #$00
    sta r2h

    lda #$00
    ldy #$EE

    jsr memcpy
    jmp $FF00

    lda #<str
    ldy #>str
    jsr puts

    lda #<str2
    ldy #>str2
    jsr puts

    lda #<str
    sta r1l
    lda #>str
    sta r1h
    lda #<str2
    ldy #>str2

    jsr strcmp
    jsr printword

    lda #1
    sta sys

memcpy:
    sta t1l
    sta t1h
    ldx #0
.loop:
    lda r2l
    ora r2h
    beq .out

    lda (r1l,x)
    sta (t1l,x)

    inc t1l
    bne .skipIncT1h
    inc t1h
.skipIncT1h:
    inc r1l
    bne .skipIncR1h
    inc r1h
.skipIncR1h:
    
    lda r2l
    bne .skipDec
    dec r2h
.skipDec
    dec r2l
    jmp .loop
.out:
    rts

strcmp:
    sta t1l
    sty t1h
    ldx #0
    ldy #0
.nextchar:
    lda (t1l,x)
    cmp (r1l,x)
    beq .chareq
    lda #0        ; false
    rts
.chareq:
    ora (r1l,x)
    beq .out
    inc t1l
    bne .skip
    inc t1h
.skip:
    inc r1l
    bne .nextchar
    inc r1h
    jmp .nextchar
.out:
    lda #1        ; true 
    rts

printword:
    pha
    tya
    jsr printbyte ; high byte
    pla
    jsr printbyte
    rts

; printbyte(u8 byte)
printbyte:
    sta t1l
    lsr
    lsr
    lsr
    lsr
    cmp #10
    bpl .letter
    adc #'0'
    bne .print ; always
.letter
    adc #'A'
    sbc #10
.print
    sta stdout
    ; TODO: remove repetative code
    lda t1l
    and #%1111
    cmp #10
    bpl .letter2
    adc #'0'
    bne .print2 ; always
.letter2
    adc #'A'
    sbc #10
.print2
    sta stdout
    rts

; strlen(u16 *str) -> u16
strlen:
    ldx #0
    sta t1l
    sta t1h
    sta t2l
    sty t2h
.again:
    lda (t1l,x)
    beq .out 
    inc t1l
    bne .again
    inc t1h
    jmp .again
.out

    lda t1l ; TODO: Can I rewrite using less instructions and directly using Y?
    sbc t2l
    sta t1l
    lda t1h
    sbc t2h
    sta t1h
    inc t1l
    bne .skip
    inc t1h
.skip:
    lda t1l
    ldy t1h
    rts

; puts(u16 *string) arg not saved 
puts:
    ldx #0
    sta t1l
    sty t1h
.again:
    lda (t1l,x)
    sta stdout
    beq .out
    inc t1l
    bne .again
    inc t1h
    jmp .again
.out
    rts

    ; .org($1000)
str:  .string "Hello world\n"
str1: .string "Hello world\n"
str2: .string "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99\n"
    
    ;.org($FFFC)
    ;.word start

