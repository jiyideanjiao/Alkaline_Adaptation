## Comparative genomic analysis of fish alkaline adaptation

1. Project description:

    Comparative genomics study to understand how Tibetan highland fish adapt to extremely alkaline environment

2. Code availability for submission:

    Genomic signature of shifts in selection and alkaline adaptation in Tibetan highland fish. biorxiv, 2020 [link](https://www.biorxiv.org/content/10.1101/813501v1.full)

### Transcriptome de novo Assembly
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
- output files:
- e.g *Gymnocypris przewalskii*
- GPRZ.fa
- GPRZ_0.9.fa
- GPRZ.cds (nucleotide sequence)
- GPRZ.pep (protein sequence)

### Protein-Coding Gene Prediction

```
cd-hit -i transcripts.fa -o transcripts_0.9.fa -c 0.9 -n 5 -M 16000 –d 0 -T 8
TransDecoder.LongOrfs -t transcripts_0.9.fa
TransDecoder.Predict -t transcripts_0.9.fa
```
### BUSCO analysis

```
BUSCO
```
