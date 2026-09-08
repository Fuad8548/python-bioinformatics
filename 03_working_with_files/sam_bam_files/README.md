# Next-Generation Sequencing (NGS) and Alignment Data Processing

Next-Generation Sequencing (NGS) platforms generate millions to billions of short DNA or RNA reads per run. Analyzing high-throughput sequencing data requires specialized, binary-compressed file formats and optimized libraries to process, filter, and inspect genomic alignments and sequence variations efficiently.

## The SAM and BAM Specifications
### Sequence Alignment/Map (SAM) 
In bioinformatics, it is a standardized text format used to store the results of aligning millions of short DNA or RNA sequences (reads) against a long reference genome (like the human genome).

   - **Removing Duplicates** (Quality Control): During PCR amplification in the lab, the exact same DNA fragment can get copied over and over. This skews your data. You can use the flag checker to look for 0x400 ("PCR or optical duplicate") and throw those reads away so they don't mess up your statistics.
   - **Finding Structural Variations**: If you check a read and find it is mapped (0x2 is false) but its mate is unmapped (0x8 is true), it tells you that something strange happened in that region of the genome—potentially pointing to a mutation or structural variant.
   - **Separating Forward and Reverse Strands**: DNA has two strands running in opposite directions. If you are doing RNA sequencing to see which genes are turned on, you need to know exactly which strand the read came from (0x10 vs 0x20) to map it to the correct gene.


## Binary Alignment/Map (BAM)
The format is the compressed, indexed binary equivalent of SAM, designed for rapid spatial querying over large genomic coordinates. While a SAM file is written in plain text (which humans can read, but takes up massive amounts of storage space), a BAM file is converted into raw computer data (1s and 0s). This makes the file significantly smaller and allows computers to read and search through it much faster. Because genomic datasets are so large, almost all real-world bioinformatics work is done using BAM files rather than SAM files.


## Structure of SAM/BAM Alignments
A SAM file consists of an optional header section (lines beginning with `@`) followed by alignment records containing 11 mandatory fields:

| Column | Field Name | Type    | Description                                          |
| :----: | ---------- | ------- | ---------------------------------------------------- |
|   1    | QNAME      | String  | Query template name (read identifier)                |
|   2    | FLAG       | Integer | Bitwise combination of alignment flags               |
|   3    | RNAME      | String  | Reference sequence identifier (e.g., chromosome)     |
|   4    | POS        | Integer | 1-based leftmost mapping position                    |
|   5    | MAPQ       | Integer | Mapping Quality (Phred score)                        |
|   6    | CIGAR      | String  | Compact idiosyncratic gapped alignment report string |
|   7    | RNEXT      | String  | Reference name of the mate read (= if identical)     |
|   8    | TLEN       | Integer | Observed template length (insert size)               |
|   9    | SEQ        | String  | Query sequence on the forward reference strand       |
|   10   | QUAL       | String  | ASCII phred quality scores for SEQ                   |


## Understanding Mapping Quality (MAPQ)

Mapping quality quantifies the probability $P_{\text{err}}$ that a read is incorrectly aligned to a specific location in the reference genome:
        $$\text{MAPQ} = -10 \cdot \log_{10}(P_{\text{err}})$$

A $\text{MAPQ} = 30$ indicates a $1\text{ in }1000$ chance ($0.1\%$) of mapping error, whereas $\text{MAPQ} = 0$ indicates ambiguous mapping where the read aligns equally well to multiple genomic regions.


## CIGAR String Operations
CIGAR strings describe precise structural alignments, indicating insertions, deletions, matches, and clipping relative to the reference.

|    Operation    | CIGAR Code |                      Description                      |
| :-------------: | :--------: | :---------------------------------------------------: |
| Match/ Mismatch |     M      |              Alignment match or mismatch              |
|    Insertion    |     I      |          Insertion relative to the reference          |
|    Deletion     |     D      |              Deletion from the reference              |
| Skipped Region  |     N      |      Intron or skipped region (e.g., in RNA-seq)      |
|    Soft Clip    |     S      | Sequence trimmed from alignment ends (present in SEQ) |
|    Hard Clip    |     H      |     Sequence removed completely (absent from SEQ)     |

## Bitwise FLAG Decoding
SAM flags store alignment properties as bitwise integer sums.

```python
def decode_sam_flag(flag_value):
    """
    Decodes a SAM bitwise flag into individual boolean properties.
    """
    flags = {
        0x1: "Read paired",
        0x2: "Read mapped in proper pair",
        0x4: "Read unmapped",
        0x8: "Mate unmapped",
        0x10: "Read reverse strand",
        0x20: "Mate reverse strand",
        0x40: "First in pair",
        0x80: "Second in pair",
        0x100: "Not primary alignment",
        0x200: "Read fails platform/vendor quality checks",
        0x400: "PCR or optical duplicate",
        0x800: "Supplementary alignment"
    }
    
    active_flags = []
    for bit, description in flags.items():
        if flag_value & bit:
            active_flags.append(description)
            
    return active_flags

# Example usage
sample_flag = 99  # 1 + 2 + 32 + 64
print(f"FLAG {sample_flag} attributes:")
for attr in decode_sam_flag(sample_flag):
    print(f" - {attr}")
```

**Example:**
1. **The Binary Secret (The Dictionary)**
Computers see numbers in binary (1s and 0s). Each property in the flags dictionary corresponds to a specific bit position (a single column in binary).
- `0x1` (1 in decimal) looks like `000000000001`
- `0x2` (2 in decimal) looks like `000000000010`
- `0x4` (4 in decimal) looks like `000000000100`
- `0x20` (32 in decimal) looks like `000000100000`
- `0x40` (64 in decimal) looks like `000001000000`

2. **The Example Flag: 99**
When you give the code the number 99, the computer converts it into binary:`000001100011`
If you look closely, the 1s are turned "on" at the exact positions for 1, 2, 32, and 64 (1 + 2 + 32 + 64 = 99).


## High-Performance BAM Manipulation with `pysam`
The `pysam` library wraps native C library `HTSlib` primitives, allowing Python scripts to read, filter, and iterate through SAM/BAM files.

Reading and Filtering BAM Records:

```python
import pysam

def summarize_bam_alignments(bam_path, min_mapq=30):
    """
    Parses a BAM file, counting total, unmapped, low-quality, and duplicate reads.
    """
    bam = pysam.AlignmentFile(bam_path, "rb")
    
    total_reads = 0
    unmapped_reads = 0
    low_mapq_reads = 0
    duplicate_reads = 0
    passed_reads = 0
    
    for read in bam.fetch():
        total_reads += 1
        
        if read.is_unmapped:
            unmapped_reads += 1
            continue
            
        if read.is_duplicate:
            duplicate_reads += 1
            continue
            
        if read.mapping_quality < min_mapq:
            low_mapq_reads += 1
            continue
            
        passed_reads += 1
        
    bam.close()
    
    return {
        "Total": total_reads,
        "Unmapped": unmapped_reads,
        "Duplicates": duplicate_reads,
        "Low MAPQ": low_mapq_reads,
        "Passed Filter": passed_reads
    }

# Example invocation
# stats = summarize_bam_alignments("aligned_reads.bam")
# print(stats)
```

Explanation:
1. `read.is_unmapped` (**Unmapped Reads**): These are DNA sequences that the computer couldn't match to the reference genome. They might be genetic "junk," contamination from bacteria, or sequencing errors. The code counts and skips them.
2. `read.is_duplicate` (**Duplicate Reads**): As mentioned before, these are identical copies created by lab chemistry tricks (PCR) rather than actual biology. Keeping them would distort your results, so the code filters them out.
3. `read.mapping_quality < min_mapq` (**Low Quality**): MAPQ (Mapping Quality) is a score telling you how confident the alignment software is about where it placed the read. A score of 30 means there is only a 1 in 1,000 chance the placement is wrong. Anything below 30 is considered ambiguous (the read could match multiple places in the genome), so the code filters it out.
4. `passed_reads` (**Passed Filter**): These are the "golden" reads. They are successfully matched to the genome, unique, and highly accurate.


## How the two codebases connect
When we write if `read.is_unmapped`, `pysam` goes into the BAM file's binary data, extracts the bitwise flag, performs the `& 0x4` operation, and returns `True` or `False`. This code makes our life much easier by hiding the complex binary logic behind clean, readable Python words.

## Genomic Region Fetching and Depth of Coverage
Indexed BAM files (`.bam.bai`) enable random access to specific chromosomal coordinates without scanning the entire alignment file.

**Theoretical vs. Realized Depth of Coverage**
Sequencing depth measures how many times a given base in the genome is independently sequenced. The theoretical depth $C$ is calculated as:
            $$C = \frac{N \cdot L}{G}$$

Where $N$ is total read count, $L$ is average read length, and $G$ is target genome size.






