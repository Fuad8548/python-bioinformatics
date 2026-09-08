Genomic annotation formats map genomic features (genes, exons, peaks) to coordinate spaces. Coordinate system conventions differ across formats:
- **0-based, half-open** `[start, end)`: Start position is 0-indexed; end position is non-inclusive. Used by BED files.
- **1-based, fully inclusive** `[start, end]`: Start position is 1-indexed; end position is inclusive. Used by GFF3 and GTF files.


## BED (Browser Extensible Data) Format
BED files require 3 mandatory fields and can extend up to 12 columns.

| Field Name |            Description            |
| :--------: | :-------------------------------: |
|   chrom    | Name of the chromosome/ scaffold  |
| chromStart |    Starting position (0-based)    |
|  chromEnd  |    Ending position (exclusive)    |
|    name    |           feature label           |
|   score    |     Score between 0 and 1000      |
|   strand   | defines strand orientation (+/ -) |

Feature length in a 0-based half-open format simplifies to:
        $$\text{Length} = \text{chromEnd} - \text{chromStart}$$

```python
def parse_bed3(bed_path):
    """ Parse BED file and compute feature lengths. """
    features = []
    with open(bed_path, "I") as f:
        for line in f:
            if line_startswith("#") or line.startswith("track") or not line.strip():
                continue
            parts = line.strip().split("\t")
            chrom = parts[0]
            start = int(parts[1])
            end = int(parts[2])
            length = end - start
            features.append((chrom, start, end, length))
    return features
```

## GFF3 and GTF Formats
GFF3 (Generic Feature Format) and GTF (Gene Transfer Format) represent gene structures across 9 tab-delimited columns.

1. seqid: Chromosome or scaffold identifier
2. source: Program or database origin
3. type: Feature type (e.g., gene, mRNA, exon, CDS)
4. start: Start coordinate (1-based, inclusive)
5. end: End coordinate (1-based, inclusive)
6. score: Numerical score or . if missing
7. strand: +, -, or .
8. phase: Reading frame offset (0, 1, 2, or .)
9. attributes: Semicolon-separated key-value metadata pairs

**Key Attribute Format Differences**
- **GTF**: Uses space-separated key-value pairs with double quotes: gene_id "ENSG00000139618"; transcript_id "ENST00000380152";

- **GFF3**: Uses equals signs for key-value pairs: ID=gene01;Name=BRCA2;biotype=protein_coding


```python
def parse_gtf_attributes(attr_string):
    """Parse GTF 9th column attribute string into a dictionary."""
    attributes = {}
    items = attr_string.strip().split(";")
    for item in items:
        item = item.strip()
        if not item:
            continue
        parts = item.split(" ", 1)
        key = parts[0]
        value = parts[1].replace('"', '') if len(parts) > 1 else ""
        attributes[key] = value
    return attributes
```

**Explanation**:
1. In a GTF file, attributes are formatted using spaces and quotation marks, like this: 
    `key "value"; key "value";`
2. Sample GTF Attribute String:
    `gene_id "ENSG000001"; gene_name "TP53";`
3. `items = attr_string.strip().split(";")` => Splits the text at every semicolon. It creates a list: `['gene_id "ENSG000001"', ' gene_name "TP53"', '']`
4. `item = item.strip()` => Removes accidental spaces arount the text: 
    `' gene_name "TP53"'` becomes `'gene_name "TP53"'`
5. `parts = item.split(" ", 1)`  => Splits the item into exactly two parts at the first space it finds. For the first item, `parts[0]` is `"gene_id"` and `parts[1]` is `'"ENSG000001"'`.
6. `value = parts[1].replace('"', '')` => Cleans up the value by removing the annoying quotation marks ("). 
    `'"ENSG000001"'` becomes `"ENSG000001"`
7. `attributes[key] = value` => Saves it to the dictionary.

Final Output:
```bash
{
    "gene_id": "ENSG000001", 
    "gene_name": "TP53"
}
```

```python
def parse_gff3_attributes(attr_string):
    """Parse GFF3 9th column attribute string into a dictionary."""
    attributes = {}
    items = attr_string.strip().split(";")
    for item in items:
        item = item.strip()
        if not item:
            continue
        if "=" in item:
            key, value = item.split("=", 1)
            attributes[key] = value
    return attributes
```

**Explantion**:
In a GFF3 file, attributes are much cleaner. They use equals signs (=) and no quotation marks, like this: `key=value;key=value`
Sample GFF3 Attribute String: 
    `ID=gene:ENSG000001;Name=TP53;biotype=protein_coding
    `

1. `items = attr_string.strip().split(";")` => splits the text at the semicolon. It creates a list:
    `['ID=gene:ENSG000001', 'Name=TP53', 'biotype=protein_coding']`
2. `if "=" in item:` => Checks to make sure the line actually contains an equals sign before trying to split it (to prevent crashes).
3. `key, value = item.split("=", 1)` => Splits the text into two variables right at the equals sign. For the first item, `key` becomes `"ID"` and `value` becomes `"gene:ENSG000001"`
4. `attributes[key] = value` => Saves it directly to the dictionary.

Final Output:
```bash
{
    "ID": "gene:ENSG000001",
    "Name": "TP53",
    "biotype": "protein_coding"
}
```

Summary Differences:
- **GTF**: Uses a space `( )` to separate key/value, and values have quotes (`""`).
- **GFF3**: Uses an equals sign (`=`) to separate key/value, and values have no quotes.









































