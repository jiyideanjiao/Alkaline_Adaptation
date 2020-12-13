## Comparative genomic analysis of alkaline tolerant and alkaline intolerant fishes

1. Project description:

    comparative genomics study to understand how Tibetan highland fish adapt to extremely alkaline environment

2. Code availability for submission:

    Genomic signature of shifts in selection and alkaline adaptation in Tibetan highland fish. biorxiv, 2020 [link](https://www.biorxiv.org/content/10.1101/813501v1.full)

### Transcriptome de novo assembly
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
