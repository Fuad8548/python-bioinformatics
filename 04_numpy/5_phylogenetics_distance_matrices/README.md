In phylogenetics, we trace evolution by comparing the genetic sequences of different species.
When studying evolution, we compare genetic sequences across different species. To build an evolutionary tree, we must first calculate a Genetic Distance Matrix, which counts how many mutational differences exist between every possible pair of species.
Instead of writing slow Python for loops to compare species one by one, we use a matrix dot product (`np.dot`) to calculate the whole grid in parallel.

## Code Breakdown & Design Choices

1. **The Data Representation (One-Hot DNA Matrix)**
Each row in the `species_dna` matrix represents a genome sequence where positions are encoded relative to a reference sequence:
- 1: Matches the reference nucleotide.
- 0: A mutation (does not match the reference).
```text
Position:    1  2  3  4  5  6
Species A: [ 1  0  1  0  1  0 ]
Species B: [ 1  1  0  1  0  1 ]
Species C: [ 0  0  0  1  1  1 ]
```

2. **Counting Shared Markers via Matrix Multiplication**
To find out how closely related two species are, we need to count how many times they both have a 1 at the exact same position.
Mathematically, this is the Dot Product (⋅) of the species vectors. Multiplying the matrix by its own transpose (`species_dna.T`) calculates this dot product for every single pair of species simultaneously:
$\(\text{Shared\ Markers}_{i,j}=\sum _{k=1}^{\text{sequence\_length}}(\text{Species}_{i}[k]\times \text{Species}_{j}[k])\)$

Because 1 × 1 = 1 and any other combination (1 × 0 or 0 × 0) equals 0.

- Species A vs. Itself (Row 0, Column 0):
	- Species A is [1, 0, 1, 0, 1, 0].
	- It has exactly three 1s.
	- Multiplying it by itself yields (1*1) + (0*0) + (1*1) + (0*0) + (1*1) + (0*0) = 3.
	- Our output has a 3 at position [0, 0]. **Correct**.
- Species B vs. Itself (Row 1, Column 1):
	- Species B is [1, 1, 0, 1, 0, 1].
	- It has exactly four 1s.
	- Multiplying it by itself yields (1*1) + (1*1) + (0*0) + (1*1) + (0*0) + (1*1) = 4.
	- Our output has a 4 at position [1, 1]. **Correct**.
- Species C vs. Itself (Row 2, Column 2):
	- Species C is [0, 0, 0, 1, 1, 1].
	- It has exactly three 1s.
	- Multiplying it by itself yields (0*0) + (0*0) + (0*0) + (1*1) + (1*1) + (1*1) = 3.
	- Our output has a 3 at position [2, 2]. **Correct**.
- Species A vs. Species B (Row 0, Column 1):
	- Species A: [1, 0, 1, 0, 1, 0]
	- Species B: [1, 1, 0, 1, 0, 1]
	- Let's check where they both have a 1: Only at the very first index (Index 0). Everywhere else, one has a 1 and the other has a 0.
	- Therefore, they share exactly 1 marker.
	- Your output has a 1 at position [0, 1]. **Correct**.
- Species B vs. Species C (Row 1, Column 2):
    - Species B: [1, 1, 0, 1, 0, 1]
	- Species C: [0, 0, 0, 1, 1, 1]
	- They both share a 1 at Index 3 and Index 5.
	- Therefore, they share exactly 2 markers.
	- Your output has a 2 at position [1, 2]. **Correct**.

Looking at the result:
```text
Shared Markers Matrix:
     A  B  C
A  [[3  1  1]
B   [1  4  2]
C   [1  2  3]]
```

1. **Converting to Evolutionary Distance**
In phylogenetics, distance measures how dissimilar two organisms are. A simple distance metric is the **Hamming Distance** (the number of positions where two sequences differ).
The code calculates a variation of this by subtracting the shared reference markers from the total sequence length (L = 6):
$\(\text{Distance}=\text{Total\ Sequence\ Length}-\text{Shared\ Reference\ Markers}\)$

Let's plug our real `shared_markers` grid numbers into this subtraction rule:
$\(\text{Distance\ Grid}=6-\left[\begin{matrix}3&1&1\\ 1&4&2\\ 1&2&3\end{matrix}\right]=\left[\begin{matrix}(6-3)&(6-1)&(6-1)\\ (6-1)&(6-4)&(6-2)\\ (6-1)&(6-2)&(6-3)\end{matrix}\right]\)$
This yields exactly your final printed grid:
```text
Evolutionary Distance Matrix:
     A  B  C
A  [[3  5  5]
B   [5  2  4]
C   [5  4  3]]
```

## Interpreting intra-space distance
- Species B has a self-distance of 2.
- Species C has a self-distance of 3.

## Interpreting Inter-Species Distance:
- Distance(B, C) = 4: Species B and C are the closest relatives in this pool (lowest off-diagonal distance).
- Distance(A, B) = 5 and Distance(A, C) = 5: Species A is equally and maximally distant from both B and C.


- `species_dna.T`: This transposes the array, flipping it vertically. It turns our (3, 6) matrix into a (6, 3) matrix.
- `np.dot(species_dna, species_dna.T)`: Multiplying a (3, 6) matrix by a (6, 3) matrix results in a clean (3, 3) matrix. NumPy automatically aligns every species row against every other species column, multiplying and summing them up instantly. This acts like a high-speed scanner counting how many times two species both share a 1 at the exact same location.

## Output:
```bash
           [Human] [Chimp] [Gorilla] [Mouse]
[Human]   [[   0,      1,       2,      4],
[Chimp]    [   1,      0,       1,      3],
[Gorilla]  [   2,      1,       0,      3],
[Mouse]    [   4,      3,       3,      0]]
```

**The Biological Insights:**
1. The Diagonal is Always 0: The distance between Human and Human is 0 because a sequence is identical to itself.
2. Clonality/Proximity: Human and Chimp have a distance of only 1, meaning they are highly related and split from a common ancestor very recently.
3. Evolutionary Distance: The Mouse has a distance of 4 from the Human. It is highly mutated compared to primates, placing it far away on the evolutionary tree.

































