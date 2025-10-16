# TFM-Omics-data-analysis
Hello World! My name is Florian and this repository contains all pieces of R code and important files that I used for my TFM project (Master's in Bioinformatics and Biostatistics of the Universitat Oberta de Catalunya–Universitat de Barcelona).

This project aims at refining the classification of ER-low and intermediate-positive breast tumors by integrating ESR1 expression and immune-related features, starting from clustering analyses on the entire cohort and evaluating how alternative thresholds impact these specific subgroups. More specifically, the main goal can be divided into three specific objectives:
1.	To identify natural subgroups from ESR1 gene expression using clustering models.
2.	To characterize the immunological profiles based on deconvolution analysis and further compare the investigated classifications.
3.	To validate the hypothesized best classification scheme using supervised ML models.

Here is a breakdown of the included files:
- **Template.docx** is simply the word template used for generating the R markdown files.
- **Exploration_Data.Rmd** contains the code necessary to download the TCGA-BRCA data (RNA-seq; read counts) and associated clinical information, as well as the steps of data preprocessing, normalization, and exploration, including the exploration of ESR1 expression for the traditional IHC classification.
- **data.rda** and **clindata.rda** correspond to the prepared *SummarizedExperiment* object and clinical table respectively obtained just after the initial downloading of the data. These are the untouches, unprocessed data. With those, the reader can skip the downloading and preparing step.
- **dataclean.rda** and **clindataclean.rda** correspond to the *SummarizedExperiment* object and clinical table respectively obtained after the preprocessing step.
- **listdge.rda** is the *DGEList* object that contains the expression matrix (raw read counts) and the library size and normalization factor (TMM method) for each sample.
- **countsER.rda** is a two-columned table that contains, for each patient, the TMM-normalized log CPM read count of the ESR1 gene as well as the IHC category ("<1%", "1-9%", "10-50%", or ">50%") to which the patient belongs.
