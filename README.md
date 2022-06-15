### Comparative and Evolutionary Genomics of Alkaline Tolerant Fish
- Author: Chao Tong, Miao Li, Yongtao Tang, Kai Zhao
- Date: Apri-23, 2021
- Project description: Comparative genomics study to understand how Tibetan highland fish adapt to extremely alkaline environment
- Publication: Genomic signature of shifts in selection and alkaline adaptation in highland fish. **Genome Biology and Evolution**. 2021 [link](https://academic.oup.com/gbe/article/13/5/evab086/6248097)

#### Assembly :: Transcriptome

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

#### Removed Redundant Transcripts
- introduction to **CD-HIT** [link](http://weizhongli-lab.org/lab-wiki/doku.php?id=cd-hit-user-guide)
- install **CD-HIT** via **conda**

```
conda install -c bioconda cd-hit
```
run cd-hit
- input files: GPRZ.fa (nucleotide sequence)
- output file: GPRZ_0.9.fa

```
cd-hit -i transcripts.fa -o transcripts_0.9.fa -c 0.9 -n 5 -M 16000 –d 0 -T 8
```


#### Protein-Coding Gene Prediction

- introduction to **TransDecoder** [link](https://github.com/TransDecoder/TransDecoder/wiki)
- install **TransDecoder** via **conda**
```
conda install -c bioconda transdecoder
```


```
TransDecoder.LongOrfs -t transcripts_0.9.fa
TransDecoder.Predict -t transcripts_0.9.fa
```
- input files: GPRZ_0.9.fa
- output files:
1. GPRZ.cds (nucleotide sequence)
2. GPRZ.pep (protein sequence)

#### Species phylogeny

- introduction to **R** package, **phangorn** [link](https://cran.r-project.org/web/packages/phangorn/phangorn.pdf)

define the function *pruneTreeFromAln*

- input files:
- codon/AA alignment file (fasta/phylip format)
- phylogenetic tree file (nwk format, add label)

```
Rscript pruned_tree.R
```

#### Ortholog identification
- introduction to **OMA** [link](https://omabrowser.org/oma/home/)
- install **OMA** via **conda**
```
conda install -c hcc oma
```
update the <parameters.drw> file

- input files:
- genome data: protein sequences
- parameters.drw
- phylogenetic tree: define a outgroup

```
OMA -n 40
```
#### Sequence Alignment
1. prepare amino acid sequence alignment
- introduction to **MUSCLE** [link](https://www.ebi.ac.uk/Tools/msa/muscle/)
- install **MUSCLE** via **conda**
```
conda install -c bioconda muscle
```
- input file: {gene}.fas (fasta format)
- output file: {gene}.aln (fasta format)
```
snakemake --cores=1 -s snakefile_muscle
```
2. prepare codon alignment
- introduction to **pal2nal** [link](http://www.bork.embl.de/pal2nal/)
- install **pal2nal** via **conda**
```
conda install -c bioconda pal2nal
```
- input files: {gene}.fa (nucleotide sequence) and {gene}.aln (amino acid sequence)
- output files: {gene}.pml or {gene}.fas
```
perl pal2nal.pl $id.fa -output fasta -nogap > $id.fas
```

#### Molecular Evolution Analysis
1. estimate the rate of molecular evolution (dN/dS) for alkaline tolerant and alkaline intolerant fish species
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
2. Likelihood Ratio Test
- lnLH1: two discrete ratios of dN/dS
- lnLH0: one ratio of dN/dS
```
ΔlnL = 2(lnLH1-lnLH0)
```
discard the gene with reported LRT *P* value > 0.05 


3. extract rapidly evolving gene

compare the two ratios of dN/dS, LRT *P* value < 0.05
- ω(alkaline tolerant species) > ω(alkaline intolerant species): rapidly evolving genes in alkaline tolerant species


#### Positive Selection Analysis

1. detect the signal of positive selection at at least one site on at least one branch of *a prori* defined branches (e.g. alkaline tolerant fish)
- input files:
- codon alignment file (phylip format)
- phylogenetic tree file (nwk format, add label)

```
snakemake --cores=1 -s snakefile_busted
```
2. extract positively selected genes
BUSTED model automatically discard the gene with reported LRT *P* value > 0.5
further check the reported output files:
- gene with LRT *P* value < 0.05: positively selected gene

#### Gene Ontology (GO) Enrichment Analysis
1. prepare the background GO dataset for shared orthologs
- introduction to **Trinoate pipeline** [link](https://github.com/Trinotate/Trinotate.github.io/wiki) 

2. prepare input geneset (e.g. rapidly evolving genes)
- introduction to **R** package, **topGO** [link](https://bioconductor.org/packages/release/bioc/vignettes/topGO/inst/doc/topGO.pdf)

- algorithm = "classic"
- statistic = "fisher"

- input files: gene.csv and fish_go_annotation.csv
- output file: gene_classic_fisher_enriched_GO.csv

```
Rscript topGO_run.R
```
3. further execute similarity filter
- introduction to **REVIGO** [link](http://revigo.irb.hr/)
- input files: enriched_GO.txt (paste to blank on the web page)
- output files: download, or make a Rscript
