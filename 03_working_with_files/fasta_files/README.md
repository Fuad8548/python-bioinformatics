# FASTA File Processing

The FASTA format represents nucleotide or amino acid sequences. Each record consists of a **header** line starting with `>` followed by sequence identifier details, and one or more subsequent lines containing the raw sequence.

```bash
>seq1 Human hemoglobin subunit beta
ATGGTGCACCTGACTCCTGAGGAGAAGTCTGCCGTTACTGCCCTGTGGGGCAAGGTGAACGTGGATGAAGTTGGTGGTGAGGCCCTGGGCAG
```

## Custom Python Generator Parser
Large genomic files (e.g., full genome assemblies) should be streamed line-by-line using generators to maintain low memory overhead.

```python
def parse_fasta(file_path):
    """
    Stream FASTA records as (header, sequence) tuples.
    Handles multi-line sequences without loading entire file into memory.
    """
    header = None
    sequence_chunks = []

    with open(file_path, "r") as file:
        for line in file:
            line = line.strip()
            if not line:
                continue
            if line.startswith(">"):
                if header is not None:
                    yield header, "".join(sequence_chunks)
                header = line[1:]   # Reset: It then grabs the new header name (skipping the > symbol) 
                sequence_chunks = []   # clears out sequence_chunks to prepare for the new sequence.
            else:
                sequence_chunks.append(line.upper())    # If the line does not start with >, it must be raw DNA/protein text.

        if header is not None:
            yield header, "".join(sequence_chunks)  #  This final block ensures the last record is safely delivered.

# Example usage
for header, sequence in parse_fasta("samples.fasta"):
    print(f"Header: {header}")
    print(f"Length: {len(sequence)} bp")
```

Output:
```bash
Header: NC_000019.10:44905796-44909393 APOE [organism=Homo sapiens] [GeneID=348] [chromosome=19]
Length: 3598 bp
```

## Biopython Integration
For pipeline workflows, `Bio.SeqIO` simplifies sequence manipulation, including calculating GC content and generating reverse complements.

```python
from Bio import SeqIO
from Bio.SeqUtils import gc_fraction

for record in SeqIO.parse("./samples.fasta", "fasta"):  # The for loop: Instead of loading a massive file all into memory at once, this works like a Python generator (bringing back our yield concept!). It streams through the file, serving you one sequence at a time as a SeqRecord object stored in the variable record
    identifier = record.id
    sequence = record.seq
    gc_content = gc_fraction(sequence) * 100
    rev_comp = sequence.reverse_complement()   # .reverse_complement(): This is a powerful built-in method. It flips the sequence backward (reverse) and replaces every nucleotide with its matching base pairs (complement: A↔T, C↔G). This simulates what the opposite DNA strand looks like reading in the standard 5' to 3' direction.

    print(f"ID: {identifier} | GC: {gc_content:.2f}% | RevComp Start: {rev_comp[:10]}")
```

Output:
```bash
ID: NC_060943.1:47730492-47734089 | GC: 61.03% | RevComp Start: TGCGTGAAAC    
```
Explanation: 10 bases of the very last line of samples.fasta => GTTTCACGCA (reverse complement: TGCGTGAAAC)

## FASTQ Format and Quality Metrics
FASTQ extends FASTA by appending base quality scores for High-Throughput Sequencing (HTS) data. Every FASTQ record spans exactly four lines:

- Line 1: `@` identifier and optional run metadata.
- Line 2: Raw nucleotide sequence.
- Line 3: `+` separator (optionally repeating the header).
- Line 4: ASCII-encoded Phred quality scores corresponding to Line 2 bases.

**SRA toolkit command-line:**
```bash
fastq-dump --stdout -X 2 ERR15935052
```
Output:
```bash
@ERR15935052.1 LH00935:13:22V73FLT4:1:1101:48998:1070 length=300
CNTCTTCTCAGTGCCTGAGATTGTGAGGGAGACCCAGGACCTAATTGAACAAGGGGCACTCCTGCAAGCCCACCGGAAGCTGATGGACCTGGAGTGCTCCCGGGACGGGCTGATGTACGAGCAGTACCGCATGGACAGTGGGAACACGCGGTCCTGACAACTGAGACCAGCAAGGTGGGGTCACGGCGGACAGTGACCAGTGACCTCTGCAGCACCATCCACAGCTGCTTAGCCAGCTCATCAGAGAGCCCCTGCGTGCTGCCAAAGTAGCCATGGATGAGGGTCATGTCACGCGTGTTC
+ERR15935052.1 LH00935:13:22V73FLT4:1:1101:48998:1070 length=300
I#IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
```

```python
def ascii_to_phred(qual_string, offset=33):
    """Convert an ASCII quality string to a list of integer Phred scores."""
    return [ord(char) - offset for char in qual_string]

def phred_to_error_prob(q_score):
    """Convert a Phred score to error probability."""
    return 10 ** (-q_score / 10.0)

# Example
qual_str = "I#III"
scores = ascii_to_phred(qual_str)
probs = [phred_to_error_prob(q) for q in scores]

print("Phred Scores:", scores)   
print("Error Probabilities:", probs) 
```

**Explanation**:
- why `ascii_to_phred`? Computers don't want to store quality scores as multi-digit numbers (like `40, 2, 40`) because it takes up too much text space. Instead, they store every score as a single keyboard character.
- `ord(char)` looks up the computer's internal number code (ASCII code) for that keyboard symbol.
- `- offset` (minus 33) shifts that number down to give you the real Phred Score.
- why `phred_to_error_prob`? A Phred score is logarithmic. A high score means high accuracy; a low score means low accuracy. This function converts that score into a raw decimal probability (\(P\)) that the base call is wrong. The formula: $$Q = -10 \cdot \log_{10}(P)$$


Output:
```bash
Phred Scores: [40, 2, 40, 40, 40]
Error Probabilities: [0.0001, 0.6309573444801932, 0.0001, 0.0001, 0.0001]
```

**Explanation:**
The Raw Sequence Line: 
- This is the actual genetic sequence (`A`, `C`, `T`, `G`) that the machine read.
- `C` is the very first base, followed by an `N`. An `N` means the machine knew a base was there, but its laser signal was too blurry to determine if it was an `A`, `C`, `T`, or `G`.

The Quality Score Line (Phred Scores):
Instead of writing multi-digit percentages, the system maps numbers to single keyboard symbols using Phred+33 ASCII encoding.
  - `I`: This represents a Phred score of 40 (an extremely high accuracy rate of 99.99%). Almost your entire read consists of `I` symbols, which means the run quality is exceptionally high.
    - Calculations:
    **Phred Score:** 
    `"I" -> ord('I') is 73 -> 73 - 33 = 40` 
    **Error Probability:**
    `\(10^{-(40/10)} = 10^{-4}\) = 0.0001 (99.99% accurate)`

  - `#`: This represents a Phred score of **2** (a high probability of error). Notice that the `#` character is the second letter in this row, which perfectly maps back to the blurry `N` base in line 2!
    - Calculation:
    **Phred Score**:
    `"#" -> ord('#') is 35 -> 35 - 33 = 2`  
    **Error Probability**: 
    `\(10^{-(2/10)} = 10^{-0.2}\) = 0.6309 (63.09% Chance of Error (Garbage/Blurry))`










