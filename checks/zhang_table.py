"""Audit the deviation column of Table 2 in arXiv:2504.00987v2 using Eqs. 5–9."""
from collections import Counter
import json

# (length, hexadecimal sequence with right padding, reported deviation)
ROWS = [
    (92, "EE01C0E77667DD34DAE94B5", 12), (92, "BB5495B2233288618FBC1E0", 9),
    (98, "993A76393CDB4BCF78FF00AA8", 13), (104, "0F80F3C20AAB1844295B6ED666", 12),
    (106, "696D27CA748C66071EAFDD1177C", 14), (108, "F2401F3D9FF1CF46D58D96AA959", 14),
    (110, "33F83762F128DF55064B5B7BE79C", 16), (112, "A0496A493FAECCC8AFC3D50E738F", 13),
    (114, "B6C3648DB19C8C387A9EAA8578000", 15), (116, "52DF72096B92DCC87407044C8E1D5", 14),
    (118, "E003FB9F87C674E5CD6D34CCB2AD54", 15), (120, "84AD68060864EE7989E1A6C0BA7551", 18),
    (99, "0CF30C003783CBCC8DA92AAD4", 15), (107, "E3C5CA9D21C2792DED3FC88AEEE", 17),
    (109, "DA62534CFBB114B94A3EBE3BE1F8", 17), (113, "5C3E8E2CC45A6DD1B794047295800", 19),
    (119, "81F0200DDD2B8C4E654E18ACA9A69A", 20),
]


def edits(s):
    if len(s) % 2:
        yield s, dict(operation="none")
        return
    for rotation in range(len(s)):
        row = s[rotation:] + s[:rotation]
        for i in range(len(row)+1):
            for bit in "01":
                yield row[:i]+bit+row[i:], dict(rotate_left=rotation, insert_after=i, bit=bit)
            if i < len(row):
                yield row[:i]+row[i+1:], dict(rotate_left=rotation, delete_position=i+1)


def integer_histogram(n, word):
    """Enumerate from the right using integer rotations and bit insertion/deletion."""
    def distance(x, length):
        half = length//2
        lo = x & ((1<<half)-1)
        hi = x >> (half+1)
        reflected = int(format(hi, f"0{half}b")[::-1], 2)
        parity = sum(1 << (half-j) for j in range(1,half+1,2))
        return bin(lo ^ reflected ^ parity).count("1")
    if n%2:
        return Counter([distance(word,n)])
    counts = Counter()
    for _ in range(n):
        for right in range(n+1):
            hi, lo = word>>right, word&((1<<right)-1)
            for bit in (0,1):
                counts[distance((((hi<<1)|bit)<<right)|lo,n+1)] += 1
            if right<n:
                counts[distance(((hi>>1)<<right)|lo,n-1)] += 1
        word = (word>>1) | ((word&1)<<(n-1))
    return counts


def audit(n, hex_word, reported):
    bits = format(int(hex_word,16), f"0{4*len(hex_word)}b")[:n]
    if len(bits)!=n or int(hex_word,16) != int(bits,2)<<((-n)%4):
        raise ValueError("Encoding mismatch")
    histogram = Counter()
    best = n
    move_minima = {}
    for row, edit in edits(bits):
        mid = len(row)//2
        failed = [j for j in range(1,mid+1) if (row[mid-j] != row[mid+j]) != bool(j%2)]
        histogram[len(failed)] += 1
        move = "insertion" if "insert_after" in edit else "deletion" if "delete_position" in edit else "as_printed"
        move_minima[move] = min(move_minima.get(move,n),len(failed))
        if len(failed)<best:
            best = len(failed)
            witness = dict(edit=edit,failed_offsets=failed)
    expected = 1 if n%2 else n*(2*(n+1)+n)
    if sum(histogram.values())!=expected or histogram!=integer_histogram(n,int(bits,2)):
        raise ArithmeticError("Exhaustive checkers disagree")
    if n%2:
        mid = n//2
        move_minima["best_rotation"] = min(sum((bits[(r+mid-i)%n]!=bits[(r+mid+i)%n])!=bool(i%2)
                                             for i in range(1,mid+1)) for r in range(n))
    return dict(n=n, hex=hex_word, reported=reported, exact=best, operations=expected,
                witness=witness, move_minima=move_minima, histogram=dict(sorted(histogram.items())))


if __name__ == "__main__":
    print(json.dumps([audit(*r) for r in ROWS], indent=2))
