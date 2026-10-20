import numpy as np
import matplotlib.pyplot as plt

# 1. Raw RNA-Seq read counts from a sequencing machine
# Rows = 3 Genes | Columns = 4 Samples (2 Healthy vs 2 Tumor)
gene_names = ["TP53 (Tumor Suppressor)", "BRCA1 (DNA Repair)", "MYC (Oncogene)"]
samples = ["Healthy_1", "Healthy_2", "Tumor_1", "Tumor_2"]

raw_counts = np.array([
    [120, 115,  12,  15],  # TP53: High in healthy, dropped in tumors
    [ 45,  50,  48,  52],  # BRCA1: Steady across all samples
    [  8,  14, 512, 640]   # MYC: Low in healthy, exploded in tumors
])

# 2. Add a pseudo-count (+1) to avoid log(0) errors if a gene count is zero
processed_counts = raw_counts + 1

# 3. Apply Log2 transformation to scale the biological data
log2_counts = np.log2(processed_counts)

print("--- Raw Machine Counts ---")
print(raw_counts)

print("\n--- Log2 Transformed Expression Matrix ---")
print(np.round(log2_counts, 2))


# visualizing the log2 transformed counts
# 2. Setup the plot canvas
plt.figure(figsize=(10, 6))

# 2. Plot lines and add text labels dynamically
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']
markers = ['o', 's', '^']

for i in range(len(gene_names)):
    # Plot the line
    plt.plot(samples, log2_counts[i, :], marker=markers[i], color=colors[i], linewidth=2.5, label=gene_names[i])
    
    # Add numeric labels to every point on this line
    for x_idx, y_val in enumerate(log2_counts[i, :]):
        plt.text(
            x=x_idx, 
            y=y_val + 0.2,       # Shifts the text slightly above the marker so it doesn't overlap
            s=f"{y_val:.2f}",    # Formats the number to 2 decimal places
            color=colors[i], 
            fontweight='bold', 
            fontsize=9,
            ha='center'          # Centers the text perfectly over the marker
        )

# 3. Styling
plt.title("Gene Expression Dynamics Across Tissue States", fontsize=14, fontweight='bold', pad=15)
plt.xlabel("Patient Tissue Samples", fontsize=12, labelpad=10)
plt.ylabel("Log2 Transformed Expression Level", fontsize=12, labelpad=10)
plt.ylim(0, 11)  # Raised limit slightly to make room for top text labels
plt.grid(axis='y', linestyle='--', alpha=0.5)
plt.legend(fontsize=10, loc='upper left')

plt.tight_layout()
plt.savefig("gene_expression_with_labels.png", dpi=300, bbox_inches='tight')
plt.show()
