def byte_to_str(a):
    t = a
    a >>= 4
    if a > 9:
        print(chr((ord('A') + a) - 10), end="")
    else:
        print(chr(ord('0') + a), end="")
    t &= 0b1111
    a = t
    if a > 9:
        print(chr((ord('A') + a) - 10), end="")
    else:
        print(chr(ord('0') + a), end="")


for i in range(0, 0x100, 7):
    byte_to_str(i)
    print()
