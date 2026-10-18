# Lesson 2: Bash Scripting

**Objective:** Write scripts that automate repetitive tasks. Instead of typing commands one-by-one, a script runs them all in sequence—saving time and preventing errors.

**Time:** 4 hours

## What You'll Learn

By the end of this lesson, you'll be able to:
- Use variables to store data
- Write loops to repeat commands
- Create functions for reusable code
- Use conditionals (if/else) for decision logic
- Write a complete bioinformatics pipeline script
- Handle command-line arguments
- Debug and optimize scripts

## Why This Matters in Bioinformatics

A typical task: *Process 100 FASTQ files, filter by quality, count reads*.

**Without a script:**
```bash
# Do this 100 times manually... 😱
head sample_1.fastq
grep "^+" sample_1.fastq | wc -l
# ... repeat 99 more times
```

**With a script:**
```bash
# Run this once, it processes all 100 files automatically ✓
bash process_all_fastq.sh
```

Bash scripts:
- Eliminate human error
- Run overnight on 1000s of files
- Are reproducible (same inputs = same outputs)
- Can be shared with collaborators

---

## Part 1: Variables

A variable is a container that holds a value. Use it to store data, then reference it later.

### Syntax

```bash
# Create a variable (no spaces around =)
name="value"

# Use the variable (with $)
echo $name
```

### Examples

```bash
# String variables
sample_name="sample_1"
echo $sample_name
# Output: sample_1

# Numeric variables
read_count=1000000
echo $read_count
# Output: 1000000

# Path variables
data_dir="/home/fuad/bioinformatics/data"
echo $data_dir
# Output: /home/fuad/bioinformatics/data

# Use variables in commands
file="$data_dir/sequences.fasta"
grep "^>" $file
# Equivalent to: grep "^>" /home/fuad/bioinformatics/data/sequences.fasta
```

### Important: Quotes vs No Quotes

```bash
# Without quotes: Treats special characters literally
variable=hello world
# ERROR: "world" is treated as a separate command

# With quotes: Keeps the value as one string
variable="hello world"
echo $variable
# Output: hello world

# Single quotes: Prevents variable expansion
name="Alice"
echo 'Hello $name'
# Output: Hello $name (the literal string, not "Hello Alice")

# Double quotes: Allows variable expansion
echo "Hello $name"
# Output: Hello Alice
```

### Special Variables

```bash
# Command-line arguments
$1          # First argument
$2          # Second argument
$*          # All arguments
$#          # Number of arguments

# Example script: greet.sh
#!/bin/bash
name=$1
echo "Hello $name!"

# Running: bash greet.sh Alice
# Output: Hello Alice!
```

---

## Part 2: Conditionals (if/else)

Make decisions in your script. Execute code *if* something is true.

### Syntax

```bash
if [ condition ]; then
    # Do something if condition is true
else
    # Do something if condition is false
fi  # marks the end of if statement block, literally the word "if" spelled backward 
```

### Common Conditions

```bash
# File tests
[ -f file.txt ]     # True if file exists
[ -d directory ]    # True if directory exists
[ -s file.txt ]     # True if file exists and has size > 0

# String comparisons
[ $var = "value" ]      # Strings are equal
[ $var != "value" ]     # Strings are not equal
[ -z $var ]             # String is empty
[ -n $var ]             # String is not empty

# Numeric comparisons
[ $num -eq 10 ]     # Equal
[ $num -ne 10 ]     # Not equal
[ $num -lt 10 ]     # Less than
[ $num -gt 10 ]     # Greater than
[ $num -le 10 ]     # Less than or equal
[ $num -ge 10 ]     # Greater than or equal

# Multiple conditions
[ condition1 ] && [ condition2 ]    # AND (both must be true)
[ condition1 ] || [ condition2 ]    # OR (either can be true)
```

### Examples

```bash
# Check if file exists before processing
file=$1
if [ -f $file ]; then
    echo "Processing $file..."
    grep "^>" $file | wc -l
else
    echo "Error: $file not found"
fi

# Check if variable is empty
quality=$1
if [ -z $quality ]; then
    echo "Error: Please provide quality threshold"
else
    echo "Using quality threshold: $quality"
fi

# Compare numbers
read_count=$(grep -c "^@" reads.fastq)
if [ $read_count -gt 1000000 ]; then
    echo "Large file: $read_count reads"
else
    echo "Small file: $read_count reads"
fi

# Multiple conditions
if [ -f reads.fastq ] && [ -s reads.fastq ]; then
    echo "FASTQ file exists and has content"
fi
```

---

## Part 3: Loops

Repeat a command for each item in a list, or while a condition is true.

### For Loops

```bash
# Loop through a list
for item in apple banana cherry; do
    echo "I like $item"
done

# Output:
# I like apple
# I like banana
# I like cherry
```

**In bioinformatics:**

```bash
# Process multiple FASTA files
for file in *.fasta; do
    echo "Processing $file..."
    grep -c "^>" $file
done

# Process files in a range
for i in 1 2 3 4 5; do
    file="sample_${i}.fastq"
    echo "Processing $file..."
    wc -l $file
done

# Process files with a C-style loop
for ((i=1; i<=5; i++)); do
    file="sample_${i}.fastq"
    echo "Read $(grep -c '^@' $file) reads from $file"
done
```

### While Loops

```bash
# Repeat while a condition is true
counter=1
while [ $counter -le 5 ]; do
    echo "Count: $counter"
    counter=$((counter + 1))  # Increment counter
done

# Output:
# Count: 1
# Count: 2
# Count: 3
# Count: 4
# Count: 5
```

**In bioinformatics:**

```bash
# Read a FASTQ file line by line
count=0
while read line; do
    if [[ $line == @* ]]; then
        count=$((count + 1))
    fi
done < reads.fastq
echo "Total reads: $count"
```

---

## Part 4: Functions

Group commands into reusable blocks. Define once, call many times.

### Syntax

```bash
# Define a function
function_name() {
    # Commands here
    echo "Doing something..."
}

# Call the function
function_name
```

### With Arguments

Functions receive arguments just like scripts:

```bash
# Define a function that takes arguments
count_sequences() {
    file=$1
    count=$(grep -c "^>" $file)
    echo "File $file has $count sequences"
}

# Call the function with an argument
count_sequences data/sequences.fasta
# Output: File data/sequences.fasta has 5 sequences
```

### Return Values

```bash
# Return a value (0 = success, 1 = error)
is_valid_fasta() {
    file=$1
    if grep -q "^>" $file; then
        return 0  # Success
    else
        return 1  # Error
    fi
}

# Check the return value
if is_valid_fasta data/sequences.fasta; then
    echo "Valid FASTA file"
else
    echo "Not a valid FASTA file"
fi
```

### Practical Examples

```bash
# Function: filter sequences by length
filter_sequences() {
    input=$1
    min_length=$2
    output=$3
    
    grep "^>" $input > $output.tmp
    grep -v "^>" $input >> $output.tmp
    # (In real code, use awk to filter)
    mv $output.tmp $output
}

# Call it
filter_sequences data/sequences.fasta 50 output/long_sequences.fasta
```

---

## Part 5: Advanced: Capturing Output

Store the output of a command in a variable.

### Syntax

```bash
# Using $()
result=$(command)

# Using backticks (older, less recommended)
result=`command`
```

### Examples

```bash
# Count lines in a file
line_count=$(wc -l < data/reads.fastq)
echo "Total lines: $line_count"

# Count sequences
seq_count=$(grep -c "^>" data/sequences.fasta)
echo "Sequences: $seq_count"

# Extract a value from a file
header=$(head -n 1 data/sequences.fasta)
echo "First sequence: $header"

# Use in calculations
total_reads=$(grep -c "^@" reads.fastq)
total_bases=$((total_reads * 100))  # Assuming 100-bp reads
echo "Total bases: $total_bases"
```

---

## Part 6: String Manipulation

Work with text inside variables.

### Basic Operations

```bash
# String length
seq="ATGCATGC"
length=${#seq}
echo $length  # Output: 8

# Substring
seq="ATGCATGC"
echo ${seq:0:3}      # First 3 characters: ATG
echo ${seq:4:4}      # 4 characters starting at position 4: ATGC

# Replace text
filename="sample.fastq"
name=${filename%.*}  # Remove extension: sample
echo $name

# All uppercase/lowercase
name="sample"
echo ${name^^}       # SAMPLE (bash 4+)
echo ${name,,}       # sample (bash 4+)
```

---

## Part 7: A Complete Example Script

Here's a realistic bioinformatics script combining everything:

```bash
#!/bin/bash

# Script: filter_fastq.sh
# Purpose: Filter FASTQ files by quality threshold
# Usage: bash filter_fastq.sh input.fastq min_quality output.fastq

# Check arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 input.fastq min_quality output.fastq"
    echo "Example: $0 reads.fastq 20 reads_filtered.fastq"
    exit 1
fi

# Store arguments
input_file=$1
min_quality=$2
output_file=$3

# Check if input file exists
if [ ! -f $input_file ]; then
    echo "Error: Input file $input_file not found"
    exit 1
fi

# Function: check if quality score passes threshold
passes_quality() {
    quality_line=$1
    threshold=$2
    
    # Count 'I' characters (high quality)
    good_bases=$(echo $quality_line | grep -o "I" | wc -l)
    total_bases=${#quality_line}
    
    if [ $good_bases -ge $threshold ]; then
        return 0  # Passes
    else
        return 1  # Fails
    fi
}

# Process the file
echo "Filtering $input_file..."
count=0
passed=0

while read -r line1 && read -r line2 && read -r line3 && read -r line4; do
    count=$((count + 1))
    
    # Check if read passes quality threshold
    if passes_quality "$line4" $min_quality; then
        # Write to output
        echo "$line1" >> $output_file
        echo "$line2" >> $output_file
        echo "$line3" >> $output_file
        echo "$line4" >> $output_file
        passed=$((passed + 1))
    fi
    
    # Progress indicator
    if [ $((count % 1000)) -eq 0 ]; then
        echo "Processed $count reads..."
    fi
done < $input_file

# Report results
echo "Done!"
echo "Total reads: $count"
echo "Passed quality filter: $passed"
echo "Filtered reads saved to: $output_file"
```

---

## Part 8: Best Practices

### 1. Always Start with a Shebang

```bash
#!/bin/bash
# This line tells the system to use bash to run the script
```

### 2. Add Comments

```bash
#!/bin/bash
# Script: analyze_sequences.sh
# Author: Fuad
# Date: 2026-08-31
# Purpose: Count sequences in FASTA files

# Variables
input_dir="./data"
output_dir="./results"

# Main logic
for file in $input_dir/*.fasta; do
    # Count sequences (lines starting with >)
    count=$(grep -c "^>" $file)
    echo "$file: $count sequences"
done
```

### 3. Use Meaningful Names

```bash
# Bad
for f in *.fasta; do
    c=$(grep -c "^>" $f)
done

# Good
for fasta_file in *.fasta; do
    sequence_count=$(grep -c "^>" $fasta_file)
    echo "$fasta_file: $sequence_count sequences"
done
```

### 4. Check for Errors

```bash
#!/bin/bash

# Set error handling
set -e  # Exit on any error

# Or check each command
if ! grep -q "^>" $file; then
    echo "Error: Not a valid FASTA file"
    exit 1
fi
```

### 5. Make Scripts Executable

```bash
chmod +x filter_fastq.sh
# Now you can run it directly:
./filter_fastq.sh input.fastq 20 output.fastq
# Instead of:
bash filter_fastq.sh input.fastq 20 output.fastq
```

---

## Part 9: Debugging Scripts

### Print Debug Information

```bash
#!/bin/bash

# Enable debug mode (prints each command)
set -x

# Your script here
file=$1
count=$(grep -c "^>" $file)
echo $count

# Disable debug mode
set +x
```

### Use Echo to Trace Variables

```bash
#!/bin/bash

file=$1
echo "DEBUG: Processing file: $file"

count=$(grep -c "^>" $file)
echo "DEBUG: Found $count sequences"

output="results_${file}"
echo "DEBUG: Writing to: $output"
```

### Check Script Syntax

```bash
bash -n script.sh
# If there are syntax errors, it will report them
# If not, no output (silence = success)
```

---

## Part 10: Common Bioinformatics Tasks

### Task 1: Count Sequences in Multiple Files

```bash
#!/bin/bash

echo "File,Sequences"
for file in *.fasta; do
    count=$(grep -c "^>" $file)
    echo "$file,$count"
done
```

### Task 2: Extract Sequences Longer Than N bp

```bash
#!/bin/bash

min_length=$1

grep "^>" input.fasta > output.fasta
grep -v "^>" input.fasta | awk -v min=$min_length 'length >= min' >> output.fasta
```

### Task 3: Process FASTQ Files in Batch

```bash
#!/bin/bash

for fastq in *.fastq; do
    echo "Processing $fastq..."
    
    # Count reads
    reads=$(grep -c "^@" $fastq)
    
    # Count bases
    bases=$(grep -v "^@" $fastq | grep -v "^+" | grep -v "^[IIII]" | wc -c)
    
    echo "Reads: $reads, Approx bases: $bases"
done
```

### Task 4: VCF Filtering

```bash
#!/bin/bash

# Filter variants by quality
min_qual=$1
input_vcf=$2

# Print headers
grep "^#" $input_vcf

# Print variants passing quality
grep -v "^#" $input_vcf | awk -v qual=$min_qual '$6 >= qual { print }'
```

---

## Summary

| Concept            | Syntax                             | Example                    |
| ------------------ | ---------------------------------- | -------------------------- |
| **Variables**      | `var="value"`                      | `file="data.fasta"`        |
| **Use variable**   | `$var`                             | `grep "^>" $file`          |
| **If condition**   | `if [ condition ]; then ... fi`    | `if [ -f $file ]; then`    |
| **For loop**       | `for item in list; do ... done`    | `for f in *.fasta; do`     |
| **While loop**     | `while [ condition ]; do ... done` | `while [ $i -le 5 ]; do`   |
| **Function**       | `func() { ... }`                   | `count_seqs() { ... }`     |
| **Capture output** | `result=$(command)`                | `count=$(grep -c "^>" $f)` |
| **Arguments**      | `$1, $2, $#`                       | `file=$1`                  |

---

## What's Next?

After mastering these concepts:

1. **Do the exercises** (in `exercises.sh`)
   - Practice writing loops and functions
   - Write scripts that process real data
   
2. **Lesson 3: Git & Version Control**
   - Track changes to your scripts
   - Collaborate with others
   
3. **Mini-Project: FASTA Analyzer**
   - Combine loops, functions, and conditionals
   - Build a complete bioinformatics tool

---

## Resources

- **Bash manual:** `man bash`
- **Bash guide:** https://mywiki.wooledge.org/BashGuide
- **Bash pitfalls:** https://mywiki.wooledge.org/BashPitfalls

---

**Ready?** Open `exercises.sh` and start writing scripts!