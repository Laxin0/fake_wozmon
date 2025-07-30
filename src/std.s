    .include "reg.s"
    
    stdin  = $D000
    stdout = $D001
    hexout = $D002
    sys    = $D003
    
    brk

    .org($F000)

start:

    lda #<str
    sta r1l
    lda #>str
    sta r1h
    lda #<str1
    sta r2l
    lda #>str1
    sta r2h

    jsr strcmp
    jsr printword

    lda #1
    sta sys 

strcmp:
    ldx #0
.nextchar:
    lda (r1l,x)
    cmp (r2l,x)
    beq .checkend
    stx r1l
    stx r1h ; TODO: you know. new call convention
    rts
.checkend:
    ora (r2l,x)
    beq .out
    inc r1l
    bne .skip
    inc r1h
.skip:
    inc r2l
    bne .nextchar
    inc r2h
    jmp .nextchar
.out:
    stx r1h
    inx
    stx r1l ; TODO: same thing
    rts

printword:
    lda r1l
    pha
    lda r1h
    sta r1l
    jsr printbyte
    pla
    sta r1l
    jsr printbyte
    rts

; printbyte(u8 byte)
printbyte:
    lda r1l
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
    lda r1l
    sta t1l
    lda r1h
    sta t1h
.again:
    lda (r1l,x)
    beq .out 
    inc r1l
    bne .again
    inc r1h
    jmp .again
.out

    lda r1l
    sbc t1l
    sta r1l
    lda r1h
    sbc t1h
    sta r1h
    inc r1l
    bne .skip
    inc r1h
.skip:
    rts

; puts(u16 *string) arg not saved 
puts:
    ldx #0
.again:
    lda (r1l,x)
    sta stdout
    beq .out
    inc r1l
    bne .again
    inc r1h
    jmp .again
.out
    rts

    .org($FFFC)
    .word start

    .org($1000)
str:  .string "Hello world\n"
str1: .string "Hello world\n"
str2: .string "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99\n"
