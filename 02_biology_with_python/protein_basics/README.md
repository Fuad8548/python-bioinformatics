# Protein Basics with Python

Translation converts mRNA codon triplets into amino acids according to the Standard Genetic Code. Proteins exhibit specific physicochemical attributes, including molecular weight, net charge, and grand average of hydropathicity (**GRAVY** score) (GRAVY score of a protein measures its overall water-attracting or water-repelling nature by adding the hydropathy values of all its amino acids and dividing by the total length of the sequence).

## 2. Codon Tables

```python
CODON_TABLE = {
    'AUG': 'M', 'UUU': 'F', 'UUC': 'F', 'UUA': 'L', 'UUG': 'L',
    'UCU': 'S', 'UCC': 'S', 'UCA': 'S', 'UCG': 'S', 'UAU': 'Y',
    'UAC': 'Y', 'UGU': 'C', 'UGC': 'C', 'UGG': 'W', 'CUU': 'L',
    'CUC': 'L', 'CUA': 'L', 'CUG': 'L', 'CCU': 'P', 'CCC': 'P',
    'CCA': 'P', 'CCG': 'P', 'CAU': 'H', 'CAC': 'H', 'CAA': 'Q',
    'CAG': 'Q', 'CGU': 'R', 'CGC': 'R', 'CGA': 'R', 'CGG': 'R',
    'AUU': 'I', 'AUC': 'I', 'AUA': 'I', 'ACU': 'T', 'ACC': 'T',
    'ACA': 'T', 'ACG': 'T', 'AAU': 'N', 'AAC': 'N', 'AAA': 'K',
    'AAG': 'K', 'AGU': 'S', 'AGC': 'S', 'AGA': 'R', 'AGG': 'R',
    'GUU': 'V', 'GUC': 'V', 'GUA': 'V', 'GUG': 'V', 'GCU': 'A',
    'GCC': 'A', 'GCA': 'A', 'GCG': 'A', 'GAU': 'D', 'GAC': 'D',
    'GAA': 'E', 'GAG': 'E', 'GGU': 'G', 'GGC': 'G', 'GGA': 'G',
    'GGG': 'G', 'UAA': '*', 'UAG': '*', 'UGA': '*'
}
```
**Amino acids:**
1. C: Cysteine
2. H: Histidine
3. I: Isoleucine
4. M: Methionine
5. S: Serine
6. V: Valine
7. A: Alanine
8. G: Glycine
9. L: Leucine
10. P: Proline
11. T: Threonine
12. F: Phenylalanine (**F**enylalanine)
13. R: Arginine (a**R**ginine)
14. Y: Tyrosine (t**Y**rosine)
15. D: Aspartic Acid (aspar**D**ic)
16. W: Tryptophan (chosen for its double-ring shape)
17. K: Lysine (assigned K because it is closest to 'L' in the alphabet)
18. N: Asparagi**N**e 
19. Q: Glutamine (sounds slightly like "**Q**u-tamine")

## Kyte-Doolittle Hydropathy Scale for GRAVY score calculation
KYTE_DOOLITTLE = {
    'A': 1.8, 'R': -4.5, 'N': -3.5, 'D': -3.5, 'C': 2.5,
    'Q': -3.5, 'E': -3.5, 'G': -0.4, 'H': -3.2, 'I': 4.5,
    'L': 3.8, 'K': -3.9, 'M': 1.9, 'F': 2.8, 'P': -1.6,
    'S': -0.8, 'T': -0.7, 'W': -0.9, 'Y': -1.3, 'V': 4.2
}

## 3. Translation

```python
def translate_mrna(mrna_seq: str) -> str:
    
    mrna = mrna_seq.upper()
    protein = []
    
    for i in range(0, len(mrna) - 2, 3):
        codon = mrna[i:i+3]
        aa = CODON_TABLE.get(codon, "X")
        if aa == "*":
            break
        protein.append(aa)
        
    return "".join(protein)

print(translate_mrna("AUGUUCUAA"))   ## MF
```

## GRAVY Score
```python
def calculate_gravy_score(protein_seq: str) -> float:
    """ Calculate Grand Average of Hydropathicity """
    prot = protein_seq.upper()
    if len(prot) == 0:
        return 0.0
    total_hydropathy = sum(KYTE_DOOLITTLE.get(aa, 0.0) for aa in prot)
    return round(total_hydropathy/ len(prot), 3)

gravy = calculate_gravy_score("MFALK")
print(f"GRAVY Score: {gravy} (Positive = Hydrophobic, Negative = Hydrophilic)")
```

