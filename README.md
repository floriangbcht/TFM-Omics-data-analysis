# TFM-Omics-data-analysis
Hello World! My name is Florian and this repository contains all pieces of R code and important files that I used for my TFM project (Master's in Bioinformatics and Biostatistics of the Universitat Oberta de Catalunya–Universitat de Barcelona).

This project aims at refining the classification of ER-low and intermediate-positive breast tumors by integrating ESR1 expression and immune-related features, starting from clustering analyses on the entire cohort and evaluating how alternative thresholds impact these specific subgroups. More specifically, the main goal can be divided into three specific objectives:
1.	To identify natural subgroups from ESR1 gene expression using clustering models.
2.	To characterize the immunological profiles based on deconvolution analysis and further compare the investigated classifications.
3.	To validate the hypothesized best classification scheme using supervised ML models.

Here is a breakdown of the included files:
- **Template.docx** is simply the template used when generating Word documents from the R markdown files.
- **Exploration_Data.Rmd** contains the code necessary to download the TCGA-BRCA data (RNA-seq; read counts) and associated clinical information, as well as the steps of data preprocessing, normalization, and exploration, including the exploration of ESR1 expression for the traditional IHC classification.
- **clindata.rda** corresponds to the clinical table obtained just after the initial data download. This is the unprocessed supplementary clinical information for the samples.
- **clindataclean.rda** corresponds to the clinical table resulting from the preprocessing step.
- **listdge.rda** is the *DGEList* object that contains the expression matrix (raw read counts) and the sample library sizes and normalization factors (TMM method).
- **countsER.rda** is a two-columned table that contains, for each patient, the TMM-normalized log CPM read count of the ESR1 gene as well as the IHC category ("<1%", "1-9%", "10-50%", or ">50%") to which the patient belongs.
- **Clustering.Rmd** contains the code for identifying natural subgroups (based on ESR1 expression) using different clustering approaches, comparing the resulting alternative classifications and selecting the most interesting ones, and finally comparing them with the traditional IHC classification.
- **countsERmod.rda** is a seven-columned table that contains, for each patient, the TMM-normalized log CPM read count of the ESR1 gene as well as the category to which the patient belongs for the traditional IHC classification as well as the five alternative classifications kept at the end of the clustering step.
- **Deconvolution.Rmd** contains the code necessary to prepare the data for deconvolution analysis, perform such analysis using the ConsensusTME framework, compute the correlations of abundance scores vs. ESR1, compare the classifications using statistical tests based on abundance scores and a PCA, make generalized comparisons of the classifications based on relevant immunological features, and finally compute supplementary analysis including boxplots comparable to those of Voorwerk et al. (2023) and the application of CART on selected classifications.
- **Summary_tables_classification_comparisons.xlsx** provides summary tables of the generalized comparisons of the classifications based on ten relevant immunological features.

**Importantly, The "GDC data/TCGA-BRCA" folder contains two sub-folders, "Transcriptome_Profiling/Gene_Expression_Quantification" and "Clinical/Clinical_Supplement", including all files of the initial data download, therefore corresponding to the base TCGA-BRCA transcriptomic data and clinical information used in the present project.** 

The "Function" folder includes the following files:
- **colplotclust.R** is a custom function for attributing colors to individual points or whole category depending on the classification.
- **plotclust.R** is a custom function for for generating a boxplot for a specific variable (ESR1 expression or other) or a bivariate plot that can be of any variable Y vs. variable X (or specifically ESR1 expression vs. index), depending on the classification.
- **classifvskmeans.R** is a custom function for comparing the HCLUST-derived alternative classifications with those derived from K-means (for these specific data). Requires *plotclust()* and *colplotclust()*.
- **grouptest.R** is a custom function for computing between group differences according to the number of categories, data normality, and homoscedasticity. It includes arguments for computing other comparative results.
- **voorwerkplots.R** is a custom function for generating comparable boxplots to those in Voorwerk et al. (2023), based on both gene expression data and cell-type abundance scores.

The "Results" folder contains two sub-folders, "HTML reports" and XXXXXXXXXXXXXXXXXX. "HTML reports" includes the reports generated from the *.Rmd* documents in *.html* format.


**WARNING: SOME FILES ARE NOT PROVIDED BECAUSE OF EXCEEDING MAXIMUM FILE SIZE ALLOWED ON GITHUB BUT ARE HERE DESCRIBED ANYWAY**
- **data.rda** corresponds to the prepared *SummarizedExperiment* object obtained just after the initial data download. These are the unprocessed expression data and sample information.
- **dataclean.rda** corresponds to the *SummarizedExperiment* object resulting from the preprocessing step.
