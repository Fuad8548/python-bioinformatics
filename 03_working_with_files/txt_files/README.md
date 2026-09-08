# Working with TXT Files

Plain text files are one of the simplest ways to store biological information.

Examples include:

- laboratory notes;
- DNA sequences;
- sample identifiers;
- experimental observations;
- lists of genes;
- lists of proteins.

---

# 1. Opening a File

A basic approach is:

```python
file = open("sequence.txt", "r")
content = file.read()
file.close()
```

# 2. Using with open(...)

The recommended approach is:

```python
with open("sequence.txt", "r") as file:
    content = file.read()
```
When the with block finishes, Python automatically closes the file.

# 3. Reading an Entire File
Suppose `sequence.txt` contains: `ATGCGTAC`
you can read it using:
```python
with open("sequence.txt", "r") as file:
    sequence = file.read()

print(sequence)
```

# 4. Reading Line by Line

Suppose a file contains:
Sample_01
Sample_02
Sample_03

You can process each line:

```python
with open("samples.txt", "r") as file:
    for line in file:
        print(line.strip())
```

The .strip() method removes:
- newline characters;
- surrounding spaces.

# Reading lines into a list

```python
with open("samples.txt", "r") as file:
    lines = file.readlines()

print(lines)
```

Example output:

```python
[
    "Sample_01\n",
    "Sample_02\n",
    "Sample_03\n"
]
```

You can clean them:

```python
samples = []

with open("samples.txt", "r") as file:
    for line in file:
        samples.append(line.strip())

print(samples)
```

# Writing a file

To create or overwrite a file:

```python
with open("results.txt", "w") as file:
    file.write("GC content: 52.4%")
```

The `w` mode means write.
Important:
If the file already exists, `w` will overwrite it.

# Writing Multiple Lines

```python
with open("results.txt", "w") as file:
    file.write("Sequence Analysis Report\n")
    file.write("Length: 120\n")
    file.write("GC Content: 52.4%\n")
```

# Appending to a file

```python
with open("results.txt", "a") as file:
    file.write("New analysis result\n")
```

`a` mode adds new content without deleting existing content.

# File paths

You may store files inside directories.
Example:
project/
│
├── data/
│   └── sequences.txt
│
└── analyze.py

then:

```python
with open("data/sequences.txt", "r") as file:
    content = file.read()
```

# 10. Cleaning Biological Sequence Files

Suppose your file contains:
`ATGC
GTAA
CCGT`

You may want one continuous sequence.

```python
with open("sequence.txt", "r") as file:
    sequence = "".join(
        line.strip()
        for line in file
    )

print(sequence)
```

Output: `ATGCGTAACCGT`

Then normalize:

```python
sequence = sequence.upper()
```

# Common Mistakes
### Forgetting to Close Files
Avoid:

```python
file = open("data.txt")
```

without eventually closing it.

Prefer:

```python
with open("data.txt") as file:
    content = file.read()
```

### Accidentally Overwriting Files
Remember: use `w` with caution

### Forgetting newline characters

```python
file.write("Result 1")
file.write("Result 2")
```

Produces: `Result 1Result 2`

Instead:

```python
file.write("Result 1\n")
file.write("Result 2\n")
```

### Hard-Coding Absolute Paths
Avoid machine-specific paths such as:
`C:/Users/YourName/Desktop/project/data.txt`
Prefer relative paths when possible.















