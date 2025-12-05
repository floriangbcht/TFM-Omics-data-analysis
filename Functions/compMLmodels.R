
### Function for comparing different ML models from a list of trained ML model with the function *mlmodel()*, using the balanced accuracy as evaluation metric 

compMLmodels <- function(model1, model2=NULL){
  
  # Extract the CV results
  modelsML <- lapply(model1, function(x){x$cvmodel})
  
  # If the compared model is not in the same list, extracts the CV results the same way and adds it to the first model results
  if(!is.null(model2)){
    modelsML2 <- lapply(model2, function(x){x$cvmodel})
    modelsML <- append(modelsML, modelsML2)
  }
  
  # Defining the evaluation metric depending on whether the classification is binary or not
  for(classif in c("IHC", "Ternary", "Binary")){
    
    if(classif=="Binary"){
      metriccomp <- "Balanced_Accuracy"
    }
    else{
      metriccomp <- "Mean_Balanced_Accuracy"
    }
    
    cat("CLASSIFICATION:", classif, "\n")
    
    modelsclassif <- modelsML[grep(classif, names(modelsML))] # Only selects the models trained for a same classification
    
    besttune <- lapply(modelsclassif, function(x){x$bestTune}) # Extracts the best hyperparameter(s) of each model
    
    # Showing the best hyperparameter(s) of all models compared
    cat("\n", "Best hyperparameters:", "\n \n")
    print(besttune)
    
    # Applying the function *resamples()* for comparing models
    modelresults <- resamples(modelsclassif)
    
    # Showing the evaluation metric summary statistics of all models compared
    cat("\n", metriccomp, "\n")
    print(summary(modelresults, metric = metriccomp))
    
    bw <- bwplot(modelresults, metric = metriccomp) # Boxplots
    dt <- dotplot(modelresults, metric = metriccomp) # Plots showing the confidence intervals
    gridExtra::grid.arrange(bw,dt, ncol=2)
    
    # Extracting and printing the confidence intervals
    cat("\n Confidence intervals: \n")
    print(as.data.frame(dt$panel.args[[1]]) %>% mutate(val=x, model=y) %>% group_by(model) %>% summarize(lower = min(val), upper = max(val)) %>% as.data.frame())
    
    # Results of the pairwise comparisons (onferroni-corrected paired Student's t tests)
    cat("\n Pairwise comparisons: \n")
    print(summary(diff(modelresults, metric = metriccomp)))
    cat("\n \n")
  }
}
