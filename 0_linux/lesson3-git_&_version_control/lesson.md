cat > /home/claude/phase-0-lesson-3-tutorial.md << 'LESSONEOF'
# Lesson 3: Git & Version Control

**Objective:** Learn to track code changes, collaborate with others, and share your work on GitHub.

**Time:** 3 hours

## What You'll Learn

By the end of this lesson, you'll be able to:
- Initialize a Git repository
- Commit changes to track your work
- Create and switch between branches
- Push to GitHub and pull updates
- Understand Git's conceptual model
- Collaborate with others on code
- View history and revert changes

## Why This Matters in Bioinformatics

**The Problem:**
- You write a bash script that works perfectly
- Tomorrow you modify it to add a feature
- Now it's broken and you don't remember what changed
- You have 10 different versions in your folder (script_v1.sh, script_v2.sh, ...)

**The Solution: Git**
- Track every change you make
- Know exactly what changed and when
- Go back to any previous version instantly
- Collaborate safely with teammates
- Have a backup on GitHub

Scientists use Git to:
- Share code reproducibly
- Track changes to bioinformatics pipelines
- Collaborate on analyses
- Document what changed and why

---

## Part 1: Git Concepts

### What is Git?

Git is a **version control system** that:
- Tracks changes to files over time
- Lets you revert to previous versions
- Enables collaboration
- Creates a history of your work

### The Core Idea

Imagine a game where you can:
1. **Save** your progress (commit)
2. **Load** a previous save (checkout)
3. **Branch off** to try something risky (branch)
4. **Merge** your branch back (merge)
5. **Share** your saves with friends (push/pull)

That's Git.

### Key Terms

**Repository (repo):** A folder containing your project and its entire history

**Commit:** A snapshot of your code at a point in time (like a save game)

**Branch:** An independent line of development (try ideas without breaking main code)

**Main/Master:** The primary branch (production-ready code)

**Stage:** Prepare changes for commit (add files to staging area)

**Push:** Send your commits to GitHub

**Pull:** Get commits from GitHub

---

## Part 2: Git Setup

### Install Git

**macOS:**
```bash
brew install git
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install git
```

**Windows:**
Download from https://git-scm.com/

### Configure Git

Tell Git who you are:
```bash
git config --global user.name "Fuad"
git config --global user.email "fuad@example.com"

# Verify
git config --list
```

---

## Part 3: Basic Git Workflow

### Step 1: Initialize a Repository

Create a new folder and initialize Git:
```bash
mkdir my_project
cd my_project
git init
```

This creates a `.git` folder (hidden) that stores the entire history.

### Step 2: Check Status

```bash
git status
```

Output:
```
On branch main
No commits yet
nothing to commit
```

### Step 3: Create and Stage Files

Create a file:
```bash
echo "#!/bin/bash" > script.sh
echo "echo 'Hello, Bioinformatics!'" >> script.sh
```

Check status:
```bash
git status
```

Output:
```
On branch main
Untracked files:
  script.sh
```

**Stage** the file (prepare for commit):
```bash
git add script.sh
```

Or stage everything:
```bash
git add .
```

Check status again:
```bash
git status
```

Output:
```
On branch main
Changes to be committed:
  new file: script.sh
```

### Step 4: Commit Changes

**Commit** = save a snapshot with a message:
```bash
git commit -m "Add initial script"
```

Output:
```
[main (root-commit) a1b2c3d] Add initial script
 1 file changed, 2 insertions(+)
```

The message should be **descriptive**: "Add initial script" is good. "stuff" is bad.

### Step 5: View History

```bash
git log
```

Output:
```
commit a1b2c3d4e5f6g7h8 (HEAD -> main)
Author: Fuad <fuad@example.com>
Date:   Mon Aug 31 10:00:00 2026 +0000

    Add initial script
```

View a shorter log:
```bash
git log --oneline
```

Output:
```
a1b2c3d Add initial script
```

---

## Part 4: Making Changes

### Scenario: You modify your script

Edit the script:
```bash
echo "echo 'Processing data...'" >> script.sh
```

Check status:
```bash
git status
```

Output:
```
On branch main
Changes not staged for commit:
  modified: script.sh
```

**View the differences:**
```bash
git diff script.sh
```

Output:
```
@@ -1,2 +1,3 @@
 #!/bin/bash
 echo 'Hello, Bioinformatics!'
+echo 'Processing data...'
```

**Stage and commit:**
```bash
git add script.sh
git commit -m "Add data processing message"
```

**View history:**
```bash
git log --oneline
```

Output:
```
b2c3d4e Add data processing message
a1b2c3d Add initial script
```

---

## Part 5: Branches

### Why Branches?

Imagine you want to:
- Try a new feature (might break things)
- But keep main code safe

**Solution: Create a branch**

```bash
# Create a new branch
git branch feature/improve-output

# List branches
git branch
# Output:
#   feature/improve-output
# * main

# Switch to the branch
git checkout feature/improve-output
```

Or do both in one command:
```bash
git checkout -b feature/improve-output
```

### Make Changes on the Branch

Edit your script:
```bash
echo "echo 'Done!'" >> script.sh
```

Commit:
```bash
git add script.sh
git commit -m "Add completion message"
```

View history:
```bash
git log --oneline
```

Output:
```
c3d4e5f Add completion message
b2c3d4e Add data processing message
a1b2c3d Add initial script
```

### Switch Back to Main

```bash
git checkout main
```

Note: The "Done!" line is NOT here (it's only on the feature branch).

### Merge the Branch

When feature is ready, merge it into main:
```bash
git checkout main
git merge feature/improve-output
```

Output:
```
Fast-forward
 script.sh | 1 +
 1 file changed, 1 insertion(+)
```

Now main has all changes from the branch.

### Delete the Branch

```bash
git branch -d feature/improve-output
```

---

## Part 6: GitHub

### Create a GitHub Account

Visit https://github.com and sign up.

### Create a Remote Repository

1. Log in to GitHub
2. Click "+" → "New repository"
3. Name it: `python-bioinformatics`
4. Add description: "9-phase bioinformatics curriculum"
5. Choose "Public" (so others can see it)
6. Click "Create repository"

GitHub shows you commands to run:

```bash
git remote add origin https://github.com/YOUR_USERNAME/python-bioinformatics.git
git branch -M main
git push -u origin main
```

### Push Your Code

First, add the remote:
```bash
git remote add origin https://github.com/YOUR_USERNAME/python-bioinformatics.git
```

Then push:
```bash
git push -u origin main
```

Output:
```
Counting objects: 3, done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), done.
To https://github.com/YOUR_USERNAME/python-bioinformatics.git
 * [new branch]      main -> main
Branch 'main' is set to tracking remote origin/main.
```

Your code is now on GitHub! 🎉

### View on GitHub

Visit: `https://github.com/YOUR_USERNAME/python-bioinformatics`

You'll see your files and commit history.

### Clone a Repository

To work on someone else's project:
```bash
git clone https://github.com/THEIR_USERNAME/their-project.git
cd their-project
```

This downloads the entire repository with full history.

---

## Part 7: Collaborative Workflow

### Scenario: Working with a Team

**Your colleague** makes a change on GitHub.

**You** want to get their changes:
```bash
git pull origin main
```

This fetches changes from GitHub and merges them.

### Scenario: You Push, They Pull

**You** make a commit and push:
```bash
git add .
git commit -m "Fix GC content calculation"
git push origin main
```

**Your colleague** pulls your changes:
```bash
git pull origin main
```

They now have your fix.

### Scenario: Conflict Resolution

Both of you edit the same line:

**You** push first:
```bash
git push origin main
```

**Your colleague** tries to pull:
```bash
git pull origin main
```

Git says there's a **conflict**. You need to resolve it manually:
1. Edit the conflicted file
2. Remove the conflict markers (<<<<, ====, >>>>)
3. Stage and commit:
```bash
git add file.py
git commit -m "Resolve merge conflict"
```

---

## Part 8: Real Bioinformatics Workflow

### Your Daily Workflow

**Morning: Start work**
```bash
# Pull latest changes
git pull origin main

# Create a feature branch
git checkout -b feature/filter-fastq
```

**During the day: Make changes**
```bash
# Edit filter_fastq.sh
git add filter_fastq.sh
git commit -m "Improve FASTQ filtering logic"

# Edit readme
git add README.md
git commit -m "Update documentation"
```

**End of day: Push to GitHub**
```bash
git push origin feature/filter-fastq
```

**Next day: Merge when ready**
```bash
git checkout main
git pull origin main
git merge feature/filter-fastq
git push origin main
```

---

## Part 9: Useful Commands

### View Differences Between Branches

```bash
git diff main feature/new-feature
```

### Undo Last Commit (keep changes)

```bash
git reset --soft HEAD~1
```

### Undo Last Commit (discard changes)

```bash
git reset --hard HEAD~1
```

### View Specific Commit

```bash
git show a1b2c3d
```

### See Who Changed a Line

```bash
git blame script.sh
```

Output:
```
a1b2c3d (Fuad 2026-08-31 10:00:00) #!/bin/bash
b2c3d4e (Fuad 2026-08-31 10:15:00) echo 'Hello, Bioinformatics!'
```

### Create a Tag (Release)

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## Part 10: Best Practices

### 1. Commit Often

Good:
```bash
git commit -m "Add sequence validator function"
git commit -m "Fix off-by-one error"
git commit -m "Add error handling"
```

Bad:
```bash
git commit -m "Lots of changes"
```

### 2. Write Descriptive Messages

Good: "Fix GC calculation in calc_gc.sh"
Bad: "fix"

Good: "Add FASTA parsing to main pipeline"
Bad: "update"

### 3. Branch for Features

Always create a branch for new features:
```bash
git checkout -b feature/batch-processing
```

Keep main clean and working.

### 4. Pull Before Push

Always pull latest changes before pushing:
```bash
git pull origin main
git push origin main
```

### 5. Don't Commit Sensitive Data

Create `.gitignore`:
```bash
# Ignore files
*.log
*.tmp
data/
secrets.txt
```

---

## Summary: Git Workflow

```
1. Initialize:     git init
2. Create file:    echo "code" > file.sh
3. Stage:          git add file.sh
4. Commit:         git commit -m "message"
5. Create branch:  git checkout -b feature/name
6. Make changes:   edit files
7. Stage & commit: git add . && git commit -m "message"
8. Merge:          git checkout main && git merge feature/name
9. Push to GitHub: git push origin main
10. Pull updates:  git pull origin main
```

---

## Common Mistakes to Avoid

❌ **Don't:** Commit binary files (large files, images)
✅ **Do:** Use `.gitignore` to exclude them

❌ **Don't:** Commit passwords or API keys
✅ **Do:** Use environment variables

❌ **Don't:** Push directly to main without testing
✅ **Do:** Use branches and merge after review

❌ **Don't:** Make huge commits with 100 changes
✅ **Do:** Make small, focused commits

---

**Ready?** Open `exercises.sh` and start using Git for real!
