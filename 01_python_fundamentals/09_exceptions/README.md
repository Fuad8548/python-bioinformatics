# 9. Exceptions

Bioinformatics pipelines frequently handle thousands of files and unpredictable biological data, including corrupted FASTQ reads, missing files, empty sequences, or invalid character encodings. Exception handling (`try`, `except`, `else`, `finally`, `raise`) ensures your pipeline handles runtime errors gracefully—logging issue details or skipping invalid records—without abruptly crashing long-running workflows.

## Common exceptions

|  Exception Type   |        Trigger Condition         |                             Biological Context                              |
| :---------------: | :------------------------------: | :-------------------------------------------------------------------------: |
| FileNotFoundError |    Target file path not exit     |                Missing reference genome or input FASTA file                 |
| ZeroDivisionError |     Division by numeric zero     |   Calculating GC content or mean coverage on an empty sequence (len = 0)    |
|     KeyError      |  Dictionary key lookup failure   | Non-canonical or degenerate codon missing from a standard translation table |
|    ValueError     | Correct data type, invalid value |  Type-casting sequence length or handling unexpected non-IUPAC characters   |
| Custom Exceptions | User-defined domain logic errors |     Raising InvalidSequenceError when non-nucleotide characters appear      |

## 1. Handling file access and division by zero
Using `try-except` blocks to handle missing inputs and empty sequence data safely.

```python
def calculate_file_gc_content(file_path: str) -> float:
    """
    Reads a single-sequence file and calculates its GC percentage safely.
    """
    try:
        with open(file_path, "r", encoding="utf-8") as handle:
        sequence = "".join(line.strip() for line in handle if not line.startswith(">"))

        # May raise ZeroDivisionError if sequence is empty
        gc_content = sequence.upper().count("G") + sequence.upper().count("C")
        gc_percentage = (gc_count / len(sequence)) * 100
        return round(gc_percentage, 2)

        except FileNotFoundError:
        print(f"[ERROR] Specified file not found at path: '{file_path}'")
        return 0.0
        except ZeroDivisionError:
        print(f"[ERROR] Sequence file '{file_path}' is empty. Cannot divide by length 0.")
        return 0.0

# Safe execution
gc_res = calculate_file_gc_content("non_existent_file.fasta")
```

## 2. Custom Exceptions for Sequence Validation
Defining domain-specific exception classes to enforce biological constraints across your codebase.

```python
class InvalidSequenceError(Exception):
    """Raised when a biological sequence contains illegal characters."""
    pass

def validate_dna_sequence(sequence: str) -> str:
    """
    Validates that input contains only standard DNA bases (A, C, G, T, N).
    """ 
    allowed_bases = set("ACGTN")
    seq_upper = sequence.upper()
    invalid_chars = set(seq_upper) - allowed_bases

    if invalid_chars:
        raise InvalidSequenceError(
            f"Sequence contains invalid nucleotide base(s): {invalid_chars}"
        )
    return seq_upper

    # Testing custom exception handling
    test_seq = "ATGCZATCG"  # Contains illegal character 'Z'

    try:
        clean_seq = validate_dna_sequence(test_seq)
        print("Sequence Validated Successfully: ", clean_seq)
    except InvalidSequenceError as error:
        print(f"[VALIDATION FAILED] {error}")
```

## 3. Full Error Control Flow (`try-except-else-finally`)

```python
def parse_expression_value(raw_val: str) -> float:
    """
    Parses string input into a floating-point gene expression measurement.
    """
    print(f"Processing raw entry: '{raw_val}'...")

    try:
        # Attempt conversion
        numeric_val = float(raw_val)
    except ValueError:
        print(f"[WARNING] Could not parse '{raw_val}' as float. Defaulting to 0.0.")
        numeric_val = 0.0
    else:
        # Runs ONLY if try block succeeded without errors
        print(f"[SUCCESS] Successfully parsed value: {numeric_val}")
    finally:
        # Always executes (useful for cleanup operations)
        print("Completed processing line entry.\n")
        
    return numeric_val


parse_expression_value("14.52")
parse_expression_value("N/A")  # Triggers exception fallback
```

## Exercises

1. Write a function `translate_codon(codon: str) -> str` that performs a dictionary lookup on a codon table. Wrap the lookup in a `try-except KeyError` block so that any non-standard or degenerate codon returns "`X`" (unknown amino acid) instead of crashing.

Create a script that takes a list of file paths `["sample1.fasta", "corrupted.fasta", "sample2.fasta"]`, loops through them, parses sequence records, and logs errors to an `error.log` file while allowing processing to continue for valid files.
