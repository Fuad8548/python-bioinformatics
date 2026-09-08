# 1. Variables and Data Types

Variables store data in memory. In bioinformatics, you frequently work with sequence names (strings), sequence lengths (integers), melting temperatures or GC percentages (floats), and sequence validity checks (booleans).

## Key data types
|  Type   | Python Name |             Bioinformatics Example              |
| :-----: | :---------: | :---------------------------------------------: |
| String  |     str     | Gene name ("BRCA1"), DNA sequence ("ATGCGATCG") |
| Integer |     int     | Sequence Length (1204), Chromosome number (17)  |
|  Float  |    float    |     GC percentage (48.5), p-value (0.0012)      |
| Boolean |    bool     |   Has start codon (True), is mutated (False)    |

## 1. Declaring Variables and Inspecting Types

A variable is a name that refers to a value.

```python
# Gene Metadata
gene_symbol = "TP53"          # str
chromosome_pos = 7571720      # int
gc_percentage = 52.4          # float
is_oncogene = False           # bool

# Check variable types
print(type(gene_symbol))      # Output: <class 'str'>
print(type(chromosome_pos))   # Output: <class 'int'>
print(type(gc_percentage))    # Output: <class 'float'>
print(type(is_oncogene))      # Output: <class 'bool'>
```

## 2. Dynamic Typing & Variable Reassignment
Python dynamically infers data types, but variable values can be converted (type casting):

```python
raw_read_count = "15420"      # Read from a file as string
read_count = int(raw_read_count)  # Convert to integer for analysis

coverage = 30
coverage_float = float(coverage)  # 30.0

print(f"Read count: {read_count}, Coverage: {coverage_float}")
```

## 3. Biological Calculations using Primitive Types

```python
seq_length = 150
g_count = 42
c_count = 38

# Calculate GC ratio
total_gc = g_count + c_count
gc_fraction = total_gc / seq_length
gc_percent = gc_fraction * 100

print("GC Percent:", round(gc_percent, 2), "%")
```

## 7. Common Mistakes

A string is not the same as a number:

```python
length = "100"
# length + 5  # TypeError
```

Convert it first:

```python
length = int(length)
print(length + 5)
```

## Exercises

1. Define variables for a gene with name "`EGFR`", length `3633`, molecular weight `134.2`, and boolean flag `is_target = True`. Print their types using `type()`.

2. Given sequence length `250`, `A=60`, `T=60`, `G=65`, `C=65`, compute the AT/GC ratio using floating-point division.
