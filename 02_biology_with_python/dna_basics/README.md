# DNA Basics with Python

Deoxyribonucleic Acid (DNA) consists of two antiparallel polynucleotide chains composed of four nitrogenous bases: Adenine (A), Thymine (T), Guanine (G), and Cytosine (C). A pairs with T via two hydrogen bonds, and G pairs with C via three hydrogen bonds.

## Key Calculations & Concepts
1. **Melting Temp($T_m$)**:
    - Marmur-Doty Formula (for short oligos < 14 bp):
        $$T_m = (A + T) \times 2^\circ\text{C} + (G + C) \times 4^\circ\text{C}$$

    - Salt-Adjusted Formula (for sequences $> 13$ bp):
        $$T_m = 64.9 + 41 \times \frac{(G + C - 16.4)}{(A + T + G + C)}$$

2. **Molecular Weight of Monostranded DNA (Molar Mass):**
    - Average weight of a deoxynucleotide monophosphate $\approx 328.2 \text{ g/mol}$.
    - Formula:
        $$\text{MW} = (A \times 313.21) + (T \times 304.2) + (C \times 289.18) + (G \times 329.21) - 61.96 \text{ g/mol (water/phosphate correction)}$$

## Python Implementation: DNA Analysis Suite

```python
def calculate_dna_melting_temp(sequence: str) -> float:
    """
    Calculates DNA melting temperature (Tm) in Celsius.
    """
    seq = sequence.upper()
    a = seq.count("A")
    t = seq.count("T")
    g = seq.count("G")
    c = seq.count("C")
    length = len(seq)

    if length < 14:
        return float((a + t) * 2 + (g + c) * 4)
    else:
        return round(64.9 + 41 * (g + c - 16.4) / length, 2)

def calculate_dna_molecular_weight(sequence: str) -> float:
    """ Calculates approximate molecular weight (g/mol) of single-stranded DNA."""
    weights = {'A': 313.21, 'T': 304.20, 'C': 289.18, 'G': 329.21}
    seq = sequence.upper()
    mw = sum(weights.get(base, 0) for base in seq) - 61.96
    return round(mw, 2)

def find_restriction_sites(sequence: str, enzyme_site: str = "GAATTC") -> list[int]:
    """Finds 0-based start positions of a restriction enzyme recognition site (e.g., EcoRI: GAATTC)."""
    seq = sequence.upper()
    site = enzyme_site.upper()
    positions = []

    pos = seq.find(site)
    while pos != -1:
        positions.append(pos)
        pos = seq.find(site, pos + 1)

    return positions

# Example usage
dna = "ATGCGAATTCGATCGGAATTCG"
print(f"DNA: {dna}")
print(f"Melting Temp (Tm): {calculate_dna_melting_temp(dna)} °C")
print(f"Molecular Weight: {calculate_dna_molecular_weight(dna)} g/mol")
print(f"EcoRI Cut Sites (GAATTC): {find_restriction_sites(dna, 'GAATTC')}")
```


