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
- **Deconvolution.Rmd** contains the code necessary to prepare the data for deconvolution analysis, perform such analysis using the ConsensusTME framework, compute the correlations of abundance scores vs. ESR1, compare the classifications using statistical tests based on abundance scores and a PCA, make generalized comparisons of the classifications based on relevant immunological features, and finally compute a supplementary analysis consisting in the application of CART on selected classifications.
- **Summary_tables_classification_comparisons.xlsx** provides summary tables of the generalized comparisons of the classifications based on ten relevant immunological features.
- **Supervised_ML.Rmd** contains the code for training supervised ML models with CV using SVM, RF, and XGBoost (for each selected classification), selecting the best-tuned models, testing them, and comparing performances. In a second part it also contains the code for computing SHAP values at distinct levels and producing various plots for visualizing feature importance (magnitude) and direction of the effect. These models are trained using 20 features, i.e., ESR1 expression as well as the 19 abundance scores (19 immunological features).
- **svmmodels.rda**, **rfmodels.rda**, and **xgboostmodels.rda** are lists that contain the results of all trained SVM, RF, and XGBoost models, respectively. These results includes resample performances (averaged across folds), performances computed from pooled resamples, and ROC curves.
- **modelsML.rda** is a list that only contains the results of the best-tuned/best-performing (selected) models, for each model-type (algorithm), for each selected classification.
- **evaluationML.rda** is a list that contains the test results of the selected models, for each model-type (algorithm), for each selected classification. This includes the re-trained models (no CV), the performances computed from test predictions, and ROC curves.
- **ML_models_results_CV&test.xlsx** provides confusion matrices and macro-metrics computed from pooled held-out resamples (training with CV) and test data
- **fullplotshap.rda** is a list that contains the mean raw and absolute SHAP values (per-class values) and feature importance plots of the selected models, for each model-type (algorithm), for each selected classification.
- **modelsESR1.rda** is a list that contains the results of ML models trained based on ESR1 expression only, using the model settings of the previously selected models.

**Importantly, The "GDC data/TCGA-BRCA" folder contains two sub-folders, "Transcriptome_Profiling/Gene_Expression_Quantification" and "Clinical/Clinical_Supplement", including all files of the initial data download, therefore corresponding to the base TCGA-BRCA transcriptomic data and clinical information used in the present project.** 

The **"Function"** folder includes the following files:
- **colplotclust.R** is a custom function for attributing colors to individual points or whole category depending on the classification.
- **plotclust.R** is a custom function for for generating a boxplot for a specific variable (ESR1 expression or other) or a bivariate plot that can be of any variable Y vs. variable X (or specifically ESR1 expression vs. index), depending on the classification.
- **classifvskmeans.R** is a custom function for comparing the HCLUST-derived alternative classifications with those derived from K-means (for these specific data). Requires *plotclust()* and *colplotclust()*.
- **grouptest.R** is a custom function for computing between group differences according to the number of categories, data normality, and homoscedasticity. It includes arguments for computing other comparative results.
- **mlmodel.R** is a custom function for training ML models and computing CV and test performance metrics. Requires*colplotclust()*.
- **compMLmodels.R** is a custom function for comparing different ML models (from a list of trained ML model with the function *mlmodel()*), using the balanced accuracy as evaluation metric.
- **plotshap.R** is a custom function for generating mean SHAP magnitudes and directions (averages across all predictions) and computing a per-class feature importance plot for a specific model.

The **"Results"** folder contains three sub-folders, **"HTML reports"**, **"Deconvolution files"**, and **"Supervised ML files"**. **"HTML reports"** includes the reports generated from the *.Rmd* documents in *.html* format. **"Deconvolution files"** includes the results of among-group comparison tests based on the abundance scores (independently for each immunological feature) for all investigated classifications. **"Supervised ML files"** includes the cross-validation results from training the models using the selected classifications.


**WARNING: SOME FILES ARE NOT PROVIDED BECAUSE OF EXCEEDING MAXIMUM FILE SIZE ALLOWED ON GITHUB BUT ARE HERE DESCRIBED ANYWAY**
- **data.rda** corresponds to the prepared *SummarizedExperiment* object obtained just after the initial data download. These are the unprocessed expression data and sample information.
- **dataclean.rda** corresponds to the *SummarizedExperiment* object resulting from the preprocessing step.

**Both object can be easily generated following the code provided at the beginning of Exploration_Data.Rmd**
