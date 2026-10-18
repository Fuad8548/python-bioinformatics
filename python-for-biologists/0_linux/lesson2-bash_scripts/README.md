# Lesson 2: Bash Scripting

**Objective:** Master bash scripting to automate repetitive bioinformatics tasks.

**Time:** 4 hours

## What You'll Learn

After this lesson, you'll be able to:
- Write variables to store data
- Use loops (for, while) to repeat commands
- Create functions for reusable code
- Make decisions with conditionals (if/else)
- Capture and use command output
- Write complete automation scripts
- Handle command-line arguments

## Why This Matters

**Without scripts:** Process 100 FASTQ files = type 100 commands = errors

**With scripts:** Write script once, run on 1000s of files overnight automatically

Real bioinformatics work is 80% script writing, 20% analysis.

## Lesson Structure

### Part 1: Variables
Store data in variables, use them throughout your script. Foundation for everything else.

### Part 2: Conditionals (if/else)
Make decisions: "If file exists, process it. Otherwise, error out."

### Part 3: Loops
Repeat commands: "For each FASTA file, count sequences" (instead of doing it manually 100 times).

### Part 4: Functions
Group related commands into reusable blocks. Define once, call many times.

### Part 5: Advanced Concepts
- Capturing output of commands
- String manipulation
- Error handling
- Command-line arguments

### Part 10: Practical Bioinformatics
Real-world examples: counting sequences, filtering FASTQ files, processing batches.

## How to Work Through This Lesson

### Step 1: Read the Tutorial
```bash
cat phase-0-lesson-2-tutorial.md
```

**Duration:** 1.5 hours

**Focus on:**
- Understanding each concept (Part 1-4)
- Seeing how it applies to bioinformatics (Part 10)
- Don't memorize syntax—understand logic

### Step 2: Run the Examples
```bash
bash phase-0-lesson-2-examples.sh
```

**Duration:** 45 minutes

**What happens:**
- Script creates test FASTA and FASTQ files
- Shows 33 working examples with output
- Each example demonstrates a concept
- You see what the code does

**Key tip:** After seeing output, try running individual commands from the examples yourself.

### Step 3: Solve the Exercises
```bash
bash phase-0-lesson-2-exercises.sh
```

**Duration:** 2-3 hours

**What to do:**
- 10 practice problems
- Write your own scripts (not just read them)
- Save as `exercise_1.sh`, `exercise_2.sh`, etc.
- Test your scripts

**Important:** Type commands yourself. Copy-pasting teaches nothing.

### Step 4: Check Solutions
```bash
bash phase-0-lesson-2-solutions.sh
```

**Duration:** 30 minutes

**What to do:**
- Compare your solutions to references
- Note different approaches
- Try improving your code
- Don't worry if your solution differs—many correct approaches exist

## Exercises Summary

| #   | Task                   | Concepts                       | Difficulty |
| --- | ---------------------- | ------------------------------ | ---------- |
| 1   | Variables and echo     | Variables                      | ⭐ Easy     |
| 2   | File checking          | Conditionals                   | ⭐ Easy     |
| 3   | Loop through files     | For loop, command substitution | ⭐ Easy     |
| 4   | Counter loop           | While loop, arithmetic         | ⭐ Easy     |
| 5   | Function validation    | Functions, return values       | ⭐⭐ Medium  |
| 6   | Process multiple files | Loops, conditionals            | ⭐⭐ Medium  |
| 7   | Sequence statistics    | Loops, calculations            | ⭐⭐ Medium  |
| 8   | Batch rename           | Functions, loops               | ⭐⭐ Medium  |
| 9   | Generate CSV report    | Loops, file I/O                | ⭐⭐ Medium  |
| 10  | Complete pipeline      | All concepts combined          | ⭐⭐⭐ Hard   |

## Learning Tips

### 1. **Type, Don't Copy-Paste**
- Copy-pasting teaches nothing
- Typing builds muscle memory
- Your fingers learn syntax patterns

### 2. **Understand Before Memorizing**
Don't memorize bash syntax. Understand:
- Why variables exist (store data)
- Why loops exist (repeat commands)
- Why functions exist (reuse code)

### 3. **Test Incrementally**
```bash
# Instead of writing a huge script, build it step by step:

# Step 1: Get file list
for file in *.fasta; do echo $file; done

# Step 2: Count sequences
for file in *.fasta; do 
    count=$(grep -c "^>" $file)
    echo $file: $count
done

# Step 3: Store in variable
for file in *.fasta; do
    count=$(grep -c "^>" $file)
    total=$((total + count))
done
echo $total
```

### 4. **Debug with Echo**
When something doesn't work, print debug info:
```bash
#!/bin/bash
file=$1
echo "DEBUG: file is $file"
count=$(grep -c "^>" $file)
echo "DEBUG: count is $count"
echo "Result: $count sequences"
```

### 5. **Check Syntax**
Before running a script:
```bash
bash -n my_script.sh
# If output is silent, no errors
# If errors printed, fix them
```

### 6. **Start Simple**
Don't write the perfect script. Write one that works, then improve:
```bash
# v1: Works but ugly
for f in *.fasta; do grep -c "^>" $f >> output.txt; done

# v2: Cleaner
for file in *.fasta; do
    count=$(grep -c "^>" $file)
    echo "$file: $count sequences"
done

# v3: More professional
count_sequences() {
    grep -c "^>" $1
}
for file in *.fasta; do
    count=$(count_sequences $file)
    echo "$file: $count sequences"
done
```

## Common Mistakes & How to Fix Them

### Mistake 1: No Quotes Around Variables
```bash
# WRONG:
file=$1
if [ -f $file ]; then  # Fails if filename has spaces

# RIGHT:
file="$1"
if [ -f "$file" ]; then  # Works even with spaces
```

### Mistake 2: Spaces Around `=` When Assigning Variables
```bash
# WRONG:
name = "Alice"  # Error: "=" treated as a command

# RIGHT:
name="Alice"
```

### Mistake 3: Forgetting `$` When Using Variables
```bash
# WRONG:
name="Alice"
echo name  # Prints: name

# RIGHT:
name="Alice"
echo $name  # Prints: Alice
```

### Mistake 4: Not Quoting in Loops
```bash
# WRONG:
for file in *.fasta; do
    count=$(wc -l < $file)  # Fails if filenames have spaces

# RIGHT:
for file in *.fasta; do
    count=$(wc -l < "$file")
done
```

## Real-World Examples

### Example 1: Process All Samples
```bash
#!/bin/bash
# Process all FASTQ files: count reads, extract high-quality

for fastq in *.fastq; do
    echo "Processing $fastq..."
    total=$(grep -c "^@" $fastq)
    echo "  Total reads: $total"
done
```

### Example 2: Quality Control Report
```bash
#!/bin/bash
# Generate QC report for sequencing run

for sample in sample_*.fastq; do
    reads=$(grep -c "^@" $sample)
    
    if [ $reads -gt 1000000 ]; then
        status="PASS"
    else
        status="FAIL"
    fi
    
    echo "$sample: $reads reads - $status"
done
```

### Example 3: Backup with Timestamp
```bash
#!/bin/bash
# Backup important files with timestamp

timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="backup_$timestamp"
mkdir -p "$backup_dir"

for file in *.fasta *.fastq; do
    cp "$file" "$backup_dir/"
done

echo "Backup created in $backup_dir"
```

## What You'll Be Able to Do

After this lesson + practice:
- Write loops that process 1000s of files
- Create functions for common tasks
- Handle errors gracefully
- Generate reports automatically
- Automate overnight batch processing
- Share reproducible pipelines with collaborators

## Next Lesson: Git & Version Control

After mastering bash scripting, you'll learn:
- Track changes to your scripts (git)
- Collaborate with others (GitHub)
- Keep history of what changed and why
- Recover old versions if something breaks

Bash scripts + Git = professional bioinformatics workflow

## Resources

**Inside this lesson:**
- `tutorial.md` — Comprehensive reference (bookmark this)
- `examples.sh` — 33 working examples
- `exercises.sh` — 10 practice problems

**External:**
- `man bash` — Official bash manual (in terminal)
- `shellcheck.net` — Check your script for errors

## FAQs

**Q: How long until I'm good at bash?**
A: After ~20 hours of practice, you'll write scripts confidently. Mastery takes 100+ hours.

**Q: Do I need to memorize syntax?**
A: No. Bookmark the tutorial and reference it. Your brain learns through repetition.

**Q: What if I make a mistake?**
A: Good! Mistakes teach you more than successes. Bash is forgiving—scripts won't delete things unexpectedly.

**Q: Can I just copy-paste examples?**
A: You *can*, but you won't learn. Type everything yourself.

**Q: What's the most important concept?**
A: Loops. Once you understand loops, you can automate 80% of bioinformatics work.

---

## Getting Started

```bash
# 1. Read the tutorial
cat phase-0-lesson-2-tutorial.md

# 2. See examples in action
bash phase-0-lesson-2-examples.sh

# 3. Write solutions
# (Edit and save exercise_1.sh, exercise_2.sh, etc.)

# 4. Check your work
bash phase-0-lesson-2-solutions.sh

# 5. Compare approaches
# (Note what's different, what's better, what's worse)
```

## Expected Timeline

| Activity        | Time        | What to Do                             |
| --------------- | ----------- | -------------------------------------- |
| Read tutorial   | 1.5 hrs     | Study Part 1-10, take notes            |
| Run examples    | 45 min      | Execute examples.sh, understand output |
| Write exercises | 2-3 hrs     | Code solutions 1-10, test each one     |
| Check solutions | 30 min      | Compare your code to references        |
| **TOTAL**       | **4-5 hrs** | You're now a bash scripter!            |

---

**Questions?** Check the tutorial first—most answers are there.

**Ready?** Open the tutorial and start reading!

```bash
cat phase-0-lesson-2-tutorial.md | head -100
```