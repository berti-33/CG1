# Somatic Variant Calling and Clonality Analysis Pipeline

An automated secondary-analysis bioinformatics pipeline designed for paired tumor-normal genomic DNA sequencing data (Illumina platform, GRCh37/hg19 reference). The workflow covers alignment post-processing, germline baseline benchmarking, somatic SNV/indel identification, copy number profiling, and purity/ploidy deconvolution.

---

## 🛠 Required Tools & Dependencies

| Tool | Version / Source | Function in Pipeline |
| :--- | :--- | :--- |
| **Java** | OpenJDK 8 (`jdk8u492`) | Runtime environment for GATK 3.8, Picard, SnpEff, VarScan |
| **SAMtools** | `v1.21` | Coordinate sorting, indexing, and base-level mpileup generation |
| **BCFtools** | `v1.21` | Germline variant calling and heterozygous site filtration |
| **VCFtools** | `v0.1.17` | Quality metric filtering and concordance checking |
| **GATK** | `v3.8` (GenomeAnalysisTK) | Indel realignment, BQSR, UnifiedGenotyper, ASEReadCounter |
| **Picard** | Latest Release (`picard.jar`) | Identification and removal of PCR/optical duplicate reads |
| **VarScan 2** | `v2.3.9` | Somatic SNV/indel calling and copy number calculation |
| **SnpEff & SnpSift** | Latest Release (`snpEff.jar`) | Variant annotation (hg19kg) and clinical filtering (ClinVar/HapMap) |
| **R / DNAcopy** | R runtime (`CBS.R`) | Circular Binary Segmentation (CBS) for copy number data |
| **CLONET** | Custom package (`step.R`) | Subclonal deconvolution, tumor purity, and ploidy estimation |

---

## 📁 Reference Datasets & Genomic Resources

- **Reference Genome:** GRCh37/hg19 FASTA (`human_g1k_v37.fasta`)
- **Target Intervals:** Exome or panel capture regions (`Captured_Regions.bed`)
- **Known Polymorphic Sites:** HapMap 3.3 (`hapmap_3.3.b37.vcf`)
- **Clinical Pathogenicity Database:** ClinVar Pathogenic variants (`clinvar_Pathogenic.vcf`)
- **Annotation Database:** SnpEff database `hg19kg`

---

## 🔄 Pipeline Workflow
[Control.bam] [Tumor.bam]
│ │
▼ ▼
┌───────────────────────────────┐
│ 1. Preprocessing │
│ - samtools sort & index │
│ - GATK Indel Realignment │
│ - GATK BQSR (BaseRecal) │
│ - Picard MarkDuplicates │
└───────────────┬───────────────┘
│
├──────────────────────────────────────┐
▼ ▼
┌───────────────────────────────┐ ┌───────────────────────────────┐
│ 2. Germline & Heterozygotes │ │ 3. Somatic Variant Calling │
│ - BCFtools & GATK Calling │ │ - samtools mpileup (-q 1) │
│ - VCFtools Filter & Diff │ │ - VarScan somatic │
│ - BCFtools Het Extraction │ │ - SnpEff & SnpSift (ClinVar) │
└───────────────┬───────────────┘ └───────────────┬───────────────┘
│ │
▼ │
┌───────────────────────────────┐ │
│ 4. Copy Number & ASEReads │ │
│ - VarScan copynumber/Caller │ │
│ - CBS Segmentation (DNAcopy) │ │
│ - GATK ASEReadCounter │ │
└───────────────┬───────────────┘ │
│ │
▼ ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. Deconvolution & Integration │
│ - CLONET (Purity, Ploidy, Allele-Specific Copy Number) │
│ - SnpSift High-Impact Filtering │
└──────────────────────────────────────────────────────────────┘
code
Code
---

### Step 1: Read Alignment Post-Processing

1. **Sorting and Indexing:**
   - Both `Control.bam` and `Tumor.bam` are coordinate-sorted and indexed using `samtools sort` and `samtools index`.
2. **Local Indel Realignment:**
   - `GATK RealignerTargetCreator` identifies target regions requiring realignment within the capture boundary (`-L Captured_Regions.bed`).
   - `GATK IndelRealigner` aligns reads locally around indels to eliminate false mismatches caused by mapping artifacts.
3. **Base Quality Score Recalibration (BQSR):**
   - `GATK BaseRecalibrator` models systematic errors using known variation from `hapmap_3.3.b37.vcf`.
   - `GATK PrintReads` recalculates per-base quality scores and writes original qualities (`--emit_original_quals`).
   - `GATK AnalyzeCovariates` evaluates before-and-after recalibration metrics into CSV and PDF reports.
4. **Duplicate Removal:**
   - `Picard MarkDuplicates` scans coordinate-sorted BAM files, flags PCR and optical duplicates, and removes them (`REMOVE_DUPLICATES=true`).

---

### Step 2: Germline Calling & Tool Concordance

1. **Variant Discovery:**
   - Evaluates the normal sample with two distinct callers:
     - `bcftools mpileup -Ou -a DP | bcftools call -Ov -c -v`
     - `GATK UnifiedGenotyper -L Captured_Regions.bed`
2. **Metric Filtering:**
   - `vcftools` applies unified quality thresholds to both output call sets:
     - Minimum quality score: `--minQ 20`
     - Minimum average read depth: `--min-meanDP 5`
     - Maximum average read depth: `--max-meanDP 200`
     - Non-SNP exclusion: `--remove-indels`
3. **Concordance Analysis:**
   - `vcftools --diff --diff-site` performs site-by-site pairwise comparisons between BCFtools and GATK calls to evaluate call overlap.
4. **Annotation:**
   - Both germline VCFs are annotated using `snpEff` (`hg19kg`), followed by `SnpSift Annotate` passes querying `hapmap_3.3.b37.vcf` and `clinvar_Pathogenic.vcf`.

---

### Step 3: Somatic SNV and Indel Discovery

1. **Pileup Generation:**
   - Alignment files are parsed with `samtools mpileup -q 1` (minimum mapping quality threshold of 1) to create base-level pileups for control and tumor samples.
2. **Somatic Variant Calling:**
   - `VarScan somatic` evaluates both pileups concurrently and partitions variants into somatic, germline, and LOH classifications:
     - Point mutations: `--output-snp`
     - Insertions/Deletions: `--output-indel`
     - Format: VCF 4.1 (`--output-vcf 1`)
3. **Annotation and Pathogenicity Tagging:**
   - Somatic variants are queried against HapMap (`SnpSift Annotate`) to flag common polymorphisms.
   - Known clinically relevant sites are appended via `clinvar_Pathogenic.vcf`.

---

### Step 4: Somatic Copy Number Alteration (SCNA) Profiling

1. **Depth-Ratio Assessment:**
   - `samtools mpileup -q 1` runs simultaneously on tumor and control BAMs, feeding into `VarScan copynumber --mpileup 1`.
2. **Copy Calling:**
   - `VarScan copyCaller` normalizes read depths and adjusts the baseline $\log_2$ ratio across genomic segments.
3. **Circular Binary Segmentation (CBS):**
   - The R script `CBS.R` utilizes the Bioconductor package `DNAcopy` to smooth noise, identify breakpoints, and segment continuous $\log_2$ copy ratios (`SegPlot.pdf`).

---

### Step 5: Allele-Specific Reads, Purity, and Ploidy (CLONET)

1. **Heterozygous Anchor Selection:**
   - Diploid heterozygous SNPs are isolated from the normal control using:
     ```bash
     bcftools view -v snps -m2 -M2 -g het Control.vcf
     ```
2. **Allele-Specific Expression Counting:**
   - `GATK ASEReadCounter` quantifies reference and alternate allele read counts at identified heterozygous loci in both control and tumor BAMs.
   - Strict filter thresholds ensure data fidelity:
     - `-minDepth 20`
     - `--minMappingQuality 20`
     - `--minBaseQuality 20`
     - `-U ALLOW_N_CIGAR_READS`
3. **Subclonal Deconvolution via CLONET:**
   - The R script `step.R` (For Clonet) takes four inputs:
     1. CBS segmented copy number profiles (`.seg`)
     2. Control allele-specific counts (`ASEreadControl.csv`)
     3. Tumor allele-specific counts (`ASEreadTumor.csv`)
     4. Somatic SNV calls (`somatic.pm.vcf`)
   - It computes B-allele frequencies (BAF), models tumor cellularity (purity $p$), determines overall sample ploidy ($\psi$), and estimates absolute, allele-specific copy numbers.

---

### Step 6: Functional & Clinical Variant Prioritization

The annotated somatic VCF is filtered using `SnpSift filter` using the following expression:

```bash
((exists ID) & (ANN[ANY].IMPACT = 'HIGH') & (exists CLNSIG))
