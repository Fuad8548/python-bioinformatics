# 8. File Handling

Bioinformatics datasets are stored in standardized file formats such as FASTA, FASTQ, BED, GFF, and CSV/TSV matrices. Mastering raw file read/write operations using Python's context managers (`with open(...)`) is essential for processing files safely without running into memory overflow issues or file corruption.

## Common Bioinformatics File Formats
|  Format  | File Extension |                        Structure                         |              Key Content               |
| :------: | :------------: | :------------------------------------------------------: | :------------------------------------: |
|  FASTA   |  .fasta, .fa   | Header lines starting with >, followed by sequence lines |    Nucleotide or protein sequences     |
|  FASTQ   |  .fastq, .fq   |  4-line records (@header, sequence, +, quality_scores)   | Raw sequencing reads with Phred scores |
| TSV/ CSV |   .tsv, .csv   |         Tab/comma-delimited tables with headers          | Gene expression tables, variant lists  |

## 1. Memory-Efficient FASTA Parser (Context Manager)
Using with open() ensures the file closes automatically after reading. Iterating line-by-line prevents loading giant genomic files into memory all at once.

```python
def parse_fasta(file_path: str) -> dict[str, str]:
    """
    Parses a multi-record FASTA file into a dictionary of {header: sequence}.
    """
    fasta_records = {}
    current_header = None
    current_seq_parts = []

    with open(file_path, mode = "r", encoding = "utf-8") as file:
        for line in file:
            line = line.strip()
            if not line:
                continue

            if line.startswith(">"):
                # Save previous record if it exists
                if current_header:
                    fasta_records[current_header] = "".join(current_seq_parts)
                current_header = line[1:]   # Strip leading ">"
                current_seq_parts = []
            else: 
                current_seq_parts.append(line)

        # save the final record
        if current_header:
            fasta_records[current_header] = "".join(current_seq_parts)

    return fasta_records

print(parse_fasta("./brca1.fasta"))
```

## 2. FASTQ Record Parser & Quality Score Calculation
Parsing 4-line FASTQ blocks to convert ASCII Phred quality characters into average numeric scores (Q = ord(char) - 33).

```python
def parse_fastq_quality(fastq_file_path: str) -> list[dict]:
    """
    Reads a FASTQ file and computes average Phred quality per read.
    """
    read_summaries = []

    with open(fastq_file_path, "r", encoding="utf-8") as handle:
        while True:
            header = handle.readline().strip()
            seq = handle.readline().strip()
            plus = handle.readline().strip()
            qual = handle.readline().strip()

            if not header:
                break   # End of file reached
                
            # Convert ASCII character to phred33 score
            phred_scores = [ord(char) - 33 for char in qual]     # gets the ASCII integer value of the character & subtracting 33 aligns the value to the phred-33 standard
            avg_quality = sum(phred_scores) / len(phred_scores) if phred_scores else 0

            read_summaries.append({
                "id": header.split()[0],
                "seq_len": len(seq),
                "avg_phred": round(avg_quality, 2)
            })

        return read_summaries

print("./brca1.fastq")
```
- `strip()` removes surrounding whitespace, including the newline character in typical text files.

**Output**:
```bash
[{'id': '@SRR39943396.1', 'seq_len': 120, 'avg_phred': 37.23}, {'id': '@SRR39943396.2', 'seq_len': 120, 'avg_phred': 38.7}]
```
- avg_phred: 37.23 and 38.7 mean the machine was 99.98% accurate when reading these fragments, exceptionally high quality and ready for genetic analysis. (A Phred score of 40 means a 1 in 10,000 chance of an incorrect base call (99.99% accuracy).)

## 3. Writing Sequence Metrics to a Tab-Separated (TSV) File
Creating a custom report file by calculating sequence length and GC content for multiple entries and writing the output to disk.

```python
sequences = {
    "Gene_01": "ATGCGATCGATCGATCG",
    "Gene_02": "CCGCGATCGCGCGC",
    "Gene_03": "ATATATAATTATATAA"
}

output_tsv_path = "sequence_summary.tsv"

with open(output_tsv_path, mode="w", encoding="utf-8") as out_file:
    # Write TSV Header
    out_file.write("Gene_ID\tLength_bp\tGC_Percentage\n")
    
    for gene_id, seq in sequences.items():
        seq_len = len(seq)
        gc_pct = round(((seq.count("G") + seq.count("C")) / seq_len) * 100, 2)
        
        # Write tab-delimited record line
        out_file.write(f"{gene_id}\t{seq_len}\t{gc_pct}\n")

print(f"Summary report written to {output_tsv_path}")
```

**Output**:
```bash
Gene_ID Length_bp   GC_Percentage
Gene_01 17  52.94
Gene_02	14	85.71
Gene_03	16	0.0
```

## 4. Appending

```python
with open("results.txt", "a") as file:
    file.write("GC content: 0.52\n")
```

Be aware of the difference between `w` and `a`: `w` overwrites existing content, while `a` adds to the end.

## 5. Cleaning Sequence Files

Simple sequence files may contain blank lines or spaces.

```python
with open("sequence.txt") as file:
    sequence = "".join(line.strip() for line in file)
```

This pattern is useful, but it should not be applied blindly to formats where headers or record boundaries matter.

## Exercises

1. Write a script that opens a FASTA file, filters out any sequences shorter than 100 base pairs, and saves the remaining filtered records to a new output file named `filtered_output.fasta`.

2. Write a Python function ``extract_bed_regions(bed_file: str, chrom: str) -> list` that reads a tab-separated BED file (`chrom`, `start`, `end`, `feature_name`) and returns all feature records belonging only to the specified chromosome (e.g., "chr1").
