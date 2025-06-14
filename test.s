  .org $8000

start:
  lda 'H'
  sta $6000

  .org $fffc
  .word $8000
