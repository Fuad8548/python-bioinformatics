# 5. Conditionals

Conditionals allow a program to make decisions. In bioinformatics, they are commonly used for sequence validation, quality thresholds, classification, and rule-based filtering.

## Boolean Operators $ Comparisons
| Operator |           Description           |     Bioinformatics Example     |
| :------: | :-----------------------------: | :----------------------------: |
|    ==    |            Equal to             |         codon == "ATG"         |
|    !=    |          Not equal to           |         strand != "+"          |
|  > / <   |     Greater than/ less than     |       phred_score >= 30        |
|    in    |        Membership check         |        "N" in sequence         |
|    or    | True if either condition is met |   base == "A" or base == "T"   |
|   not    |   inverts boolean truth value   | not sequence.startswith("ATG") |

## 1. Validating DNA Sequences & Ambiguous Bases
Before processing sequencing reads, you must verify that the sequence contains only valid nucleotides (`A`, `C`, `G`, `T`) and evaluate ambiguous base flags like '`N`'

```python
sequence = "ATGCGATCNAATCG"

# check for ambiguous bases
if "N" in sequence or "n" in sequence:
    n_count = sequence.upper().count("N")
    print(f"Warning: Sequence contains {n_count} ambiguous base(s) ('N').")
else:
    print("Sequence validation passed: No 'N' bases detected.")
```

## 2. Identifying Open Reading Frame (ORF) Signals
Checking if a sequence starts with a valid canonical start codon (`ATG`) and ends with one of the standard stop codons (`TAA`, `TAG`, `TGA`).

```python
dna_seq = "ATGCGTACGTTAG"
stop_codons = ["TAA", "TAG", "TGA"]

has_start = dna_seq.startswith("ATG")
has_stop = dna_seq[-3:] in stop_codons
is_in_frame = len(dna_seq) % 3 == 0

if has_start and has_stop and is_in_frame:
    print("Valid ORF candidate: Contains start codon, valid stop codon, and is in-frame")
elif has_start and not has_stop:
    print("Incomplete ORF: Contains start codon but lacks a terminal stop codon")
elif not is_in_frame:
    print("Frameshift warning: Sequence length is not a multiple of 3.")
else:
    print("Non-coding sequence: Missing canonical translation signals.")
```

## 3. Gene Expression Categorization
Categorizing gene expression activity based on log2 fold change ($\log_2\text{FC}$) and adjusted p-value ($p_{\text{adj}}$) thresholds.

```python
gene_name = "BRCA1"
log2_fold_change = 2.45  # the gene is more active and it's activity increases over 5-fold
p_adj = 0.003   # higher statistical certainty

# Thresholds: |log2FC| >= 1.5 and p_adj < 0.01
if log2_fold_change >= 1.5 and p_adj < 0.01:
    status = "Significantly Up-regulated"
elif log2_fold_change <= -1.5 and p_adj < 0.01:
    status = "Significantly Down-regulated"
else:
    status = "Not Differentially Expressed (Neutral)"

print(f"Gene: {gene_name} | Status: {status}")
```

## Exercises

1. Write a script that checks a sequence's GC content. If `GC >= 60%`, print "`High GC Region`"; if `GC <= 40%`, print "`AT-Rich Region`"; otherwise, print "`Balanced GC Content`".

2. Given a list of Phred quality scores `[35, 28, 40, 15, 38]`, write a conditional that flags the read as "`PASS`" if all scores are >= 20 and the average score is >= 30, otherwise output "`FAIL`".
