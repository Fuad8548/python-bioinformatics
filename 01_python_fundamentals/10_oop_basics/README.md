# 10. Object-Oriented Programming Basics

Object-Oriented Programming (OOP) is a design paradigm that bundles data (attributes) and logic (methods) into cohesive structures called Classes. In bioinformatics, OOP provides clean, modular abstractions for complex biological entities—such as representing DNA sequences, genes, proteins, alignment outputs, or structural models (PDB files) as interactive Python objects.

## Key OOP Concepts

|       Term        |                    Definition                    |                  Bioinformatics Analogy                   |
| :---------------: | :----------------------------------------------: | :-------------------------------------------------------: |
|       Class       |          Blueprint for creating objects          |            A template for a DNASequence object            |
| Instance / Object |        A specific realization of a class         | tp53_seq = DNASequence(header="TP53", sequence="ATGC...") |
|     Attribute     |          Variable attached to an object          |          self.header, self.length, self.organism          |
|      Method       |         Function defined inside a class          |           self.gc_content(), self.transcribe()            |
|    Inheritance    | Deriving specialized classes from a parent class |     Gene inheriting core properties from DNASequence      |

## 1. Building a Fundamental DNASequence Class

Encapsulating sequence data along with computational methods for GC content and transcription.

```python
class DNASequence:
    """Represents a biological DNA sequence with validation and sequence manipulation tools."""

    def __init__(self, sequence_id: str, sequence: str, organism: str = "Unknown"):
        self.sequence_id = sequence_id
        self.sequence = sequence.upper()
        self.organism = organism
        self.length = len(self.sequence)
    
    def calculate_gc_content(self) -> float:
        """Calculates the GC percentage of the sequence."""
        if self.length == 0:
            return 0.0
        g_count = self.sequence.count("G")
        c_count = self.sequence.count("C")
        return round(((g_count + c_count) / self.length) * 100, 2)

    def transcribe(self) -> str:
        """Transcribes DNA sequence into RNA."""
        return self.sequence.replace("T", "U")

# Instantiating and utilizing sequence objects
gene_obj = DNASequence(sequence_id="BRCA1_01", sequence="atgcgatcgatcg", organism="Homo sapiens")

print(f"Gene ID: {gene_obj.sequence_id}")
print(f"Organism: {gene_obj.organism}")
print(f"Length: {gene_obj.length} bp")
print(f"GC Content: {gene_obj.calculate_gc_content()}%")
print(f"RNA Transcript: {gene_obj.transcribe()}")
```

## 2. Overloading Python Magic (Dunder) Methods
Implementing `__len__`, `__repr__`, and `__eq__` allows custom sequence objects to integrate naturally with standard Python functions.

```python
class FastRecord:
    """FASTA record object with native Python operator support."""

    def __init__(self, header: str, sequence: str):
        self.header = header
        self.sequence = sequence.upper()

    def __len__(self) -> int:
        """Enables len(record_object)."""
        return len(self.sequence)

    def __str__(self) -> str:
        """Defines user-friendly string representation when using print()."""
        return f">{self.header}\n{self.sequence}"

    def __repr__(self) -> str:
        """Defines official developer string representation."""
        return f"FastRecord(header='{self.header}', length={len(self)})"

    def __eq__(self, other) -> bool:
        """Enables equality checking between two FastRecord objects (rec1 == rec2)."""
        if isinstance(other, FastRecord):
            return self.sequence == other.sequence
        return False


# Usage example
rec1 = FastRecord("Seq1", "ATGCGATC")
rec2 = FastRecord("Seq2", "ATGCGATC")

print(f"Length via len(): {len(rec1)} bp")
print(f"Formatted Output:\n{rec1}")
print(f"Developer Repr: {repr(rec1)}")
print(f"Are records equal? {rec1 == rec2}")  # True
```

## 3. Class Inheritance: Extending `DNASequence` to a `Gene` Class
Using inheritance to create specialized domain models with additional genomic metadata (e.g., coordinates, strand orientation, and expression levels).

```python
class Gene(DNASequence):
    """Subclass inheriting from DNASequence with added genomic context."""

    def __init__(
        self,
        sequence_id: str,
        sequence: str,
        chromosome: str,
        start: int,
        end: int,
        strand: str = "+"
    ):
        # Call parent class constructor (__init__)
        super().__init__(sequence_id=sequence_id, sequence=sequence)
        self.chromosome = chromosome
        self.start = start
        self.end = end
        self.strand = strand

    def get_genomic_coordinates(self) -> str:
        """Returns formatted genomic location string."""
        return f"{self.chromosome}:{self.start}-{self.end} ({self.strand})"


# Instantiate specialized subclass object
tp53_gene = Gene(
    sequence_id="TP53",
    sequence="ATGGGCTCCGAACGG",
    chromosome="chr17",
    start=7571720,
    end=7590868,
    strand="-"
)

# Inherited methods + specialized subclass methods
print(f"Gene: {tp53_gene.sequence_id}")
print(f"Location: {tp53_gene.get_genomic_coordinates()}")
print(f"Inherited GC Content: {tp53_gene.calculate_gc_content()}%")
```

## 5. Keep It Simple

At this stage, focus on:

- class
- object
- attribute
- method
- constructor
- `self`

Do not worry yet about advanced inheritance patterns or complex architecture.

## 6. Mini Example

```python
class SequenceRecord:
    def __init__(self, name, sequence):
        self.name = name
        self.sequence = sequence

    def length(self):
        return len(self.sequence)

record = SequenceRecord("gene_1", "ATGCGTAA")
print(record.name)
print(record.length())
```

## Exercises

1. Create a ProteinSequence class with an attribute amino_acids. Implement a method molecular_weight() that calculates total weight using an internal dictionary of average amino acid molecular weights (e.g., 'A': 89.09, 'C': 121.16).

2. Extend the Gene class by adding an attribute exons (a list of coordinate tuples [(start1, end1), (start2, end2)]) and a method calculate_coding_length() that sums the lengths of all exons.
