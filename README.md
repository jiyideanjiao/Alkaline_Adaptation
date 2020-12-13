## Comparative genomic analysis of fish alkaline adaptation
 
Chao Tong
(Dec-13, 2020)
 
  
1. Project description:

    Comparative genomics study to understand how Tibetan highland fish adapt to extremely alkaline environment

2. Code availability for submission:

    Genomic signature of shifts in selection and alkaline adaptation in Tibetan highland fish. biorxiv, 2020 [link](https://www.biorxiv.org/content/10.1101/813501v1.full)

### Transcriptome *de novo* Assembly

- introduction to **Trinity** [link](https://github.com/trinityrnaseq/trinityrnaseq/wiki)
- install **Trinity** via **conda**
```
conda install -c bioconda trinity
```
start *de novo* assembly
```
Trinity \
--trimmomatic \
--seqType fq \
--max_memory 20G \
--left left.fq \
--right right.fq \
--CPU 20 \
--output trinity_output \
--no_bowtie \
--quality_trimming_params "SLIDINGWINDOW:4:20 LEADING:10 TRAILING:10 MINLEN:70"  \
--normalize_reads \
--normalize_max_read_cov 100
```

- output files: GPRZ.fa (fasta format)

### Protein-Coding Gene Prediction

- introduction to **TransDecoder** [link](https://github.com/TransDecoder/TransDecoder/wiki)
- install **TransDecoder** via **conda**
```
conda install -c bioconda transdecoder
```


```
cd-hit -i transcripts.fa -o transcripts_0.9.fa -c 0.9 -n 5 -M 16000 –d 0 -T 8
TransDecoder.LongOrfs -t transcripts_0.9.fa
TransDecoder.Predict -t transcripts_0.9.fa
```

- output files:
1. GPRZ_0.9.fa
2. GPRZ.cds (nucleotide sequence)
3. GPRZ.pep (protein sequence)

### BUSCO analysis

```
BUSCO
```


### Species phylogeny

introduction to **R** package, **phangorn** [link](https://cran.r-project.org/web/packages/phangorn/phangorn.pdf)

define the function 

input files:
codon/AA alignment file (fasta/phylip format)
phylogenetic tree file (nwk format, add label)

```
Rscript pruned_tree.R
```


### Ortholog identification
introduction to **OMA** [link](https://omabrowser.org/oma/home/)
- install **OMA** via **conda**
```
conda install -c hcc oma
```
update the <parameters.drw> file

```
OMA -n 40
```


### Molecular Evolution Analysis
estimate the rate of molecular evolution (dN/dS) for alkaline tolerant and alkaline intolerant fish species
- introduction to **HyPHY** [link](http://www.hyphy.org/)
- install **HyPHY** via **conda**
```
conda install -c bioconda hyphy
```

define foreground branches: species {test}
- input files:
- codon alignment file (phylip format)
- phylogenetic tree file (nwk format, add label)

run script with **snakemake** [link](https://snakemake.readthedocs.io/en/stable/)
```
snakemake --cores=1 -s snakefile_relax
```

### Positive Selection Analysis

detect the signal of positive selection at at least one site on at least one branch of *a propri* defined branches (e.g. alkaline tolerant fish)
- input files:
- codon alignment file (phylip format)
- phylogenetic tree file (nwk format, add label)

```
snakemake --cores=1 -s snakefile_busted
```

