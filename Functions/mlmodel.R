
### Function for training ML models and computing CV and test performance metrics

mlmodel <- function(train, test=NULL, model=c("svmLinear", "svmRadial", "rf", "xgbTree"), tunegrid=NULL, res=F, outfile=NULL, roc=F){
  
  if(!is.null(outfile)){sink(outfile)} # Connects to a file in which printed results will be sent, only if such file is specified
  
  model <- match.arg(model) # Ensures that only "svmLinear", "svmRadial", "rf", or "xgbTree" can be passed
  var <- colnames(train)[ncol(train)] # Name of the classification of interest
  
  # Defining the evaluation metric for selecting the best hyperparameters, depending on whether the classification is binary or not
  if(length(levels(train[,var]))==2){
    metricparam <- "Balanced_Accuracy" # Balanced accuracy
    perclass <- "single"
  }
  else{
    metricparam <- "Mean_Balanced_Accuracy" # Mean balanced accuracy (if multi-class classification)
    perclass <- "mean"
  }
  
  ## If one wants to train a model for model evaluation (to find the best hyperparameters)
  if(is.null(test)){
    # Training the model, using a grid with 6 default hyperparameter values or a specific (user-defined) grid
    set.seed(42)
    modelml <- train(as.formula(paste0(var,"~.")), data = train, method = model, trControl = controltrain, tuneGrid = tunegrid, tuneLength=6, metric = metricparam, verbosity=0)
    cat(paste("CLASSIFICATION:", var), "\n", "\n")
    if(controltrain$method!="none"){cat("# CV training metrics: averages per fold", "\n")}
    print(modelml)
    
    # If CV is used and one wants per-class and macro metrics calculated from all held-out predictions (pooled resamples, regardless of the fold), based on the best hyperparameter(s)
    if(res==T & controltrain$method!="none"){
      # Obtaining the CV training per-class metrics and macro metrics
      cat("\n", "# CV training metrics: overall and per class", "\n")
      print(traincm <- confusionMatrix(modelml$pred[,"pred"], modelml$pred[,"obs"], mode="everything"))
      
      # ROC curves and AUC
      roc_curvestrain <- lapply(levels(train[,var]), function(class){
        binlab <- as.numeric(modelml$pred$obs == class)
        roc(binlab, modelml$pred[[class]])})
      names(roc_curvestrain) <- levels(train[,var])
      # Macro AUC
      auctrain <- sapply(roc_curvestrain, function(class){class$auc})
      macroauctrain <- round(mean(auctrain), 4)
      # ggplot with the ROC curves
      classcol <- colplotclust(var, train, type = "group")
      p <- ggroc(roc_curvestrain, size = 1) + scale_colour_manual(name = NULL, values = classcol$col, labels = levels(train[,var])) +
        geom_abline(intercept = 1, slope = 1, color='grey', linewidth = 0.75, linetype = "dashed") + 
        theme_classic() +
        theme(axis.line = element_line(color = "black"), axis.text=element_text(size=12), plot.title = element_text(face = "bold", hjust = 0.5), axis.title=element_text(size=12), legend.text=element_text(size=12), legend.position.inside = c(0.8, 0.2)) +
        labs(x = "\n 1-Specificity", y = "Sensitivity \n", title = paste("ROC curves for classification", var, "— Macro AUC =", macroauctrain))
      
      # Showing the main CV macro metrics (F1, [mean] Balanced accuracy and AUC)
      cat("\n", "# CV training macro-metrics", "\n")
      if(perclass=="single"){
        print(c(traincm$byClass[c("F1","Balanced Accuracy")], AUC=macroauctrain))
      }
      else{
        print(c(colMeans(traincm$byClass[,c("F1","Balanced Accuracy")], na.rm = T), AUC=macroauctrain))
      }
      
      # If one wants the ROC curves to be printed
      if(roc==T){
        print(p)
      }
    }
    
    # If CV is used and one wants the (macro) metrics internally calculated over the folds, based on the best hyperparameter(s)
    # The metrics obtained from tuning the model correspond to averages of per-fold values (the per-fold values themselves obtained as averages of per-class values when the classification is multi-class)
    # These results represent in fact the resampling performance
    if(controltrain$method!="none"){
      bestresultrow <- apply(as.data.frame(sapply(colnames(modelml$bestTune), function(x) modelml$results[,x]==modelml$bestTune[,x])),
                             1, all)
      # Showing the best hyperparameter(s) and the corresponding model metrics ([Mean] balanced Accuracy and AUC only) and their standard deviation
      cat("\n", "# Best hyperparameter results", "\n")
      print(modelml$results[bestresultrow,] %>% select(all_of(c(colnames(modelml$bestTune))), all_of(metricparam), all_of(paste0(metricparam,"SD")), "AUC", "AUCSD"))
    }
  }
  
  ## If one wants to test a model   
  else{
    # Training the model
    set.seed(42)
    modelml <- train(as.formula(paste0(var,"~.")), data = train, method = model, trControl = controltrain, tuneGrid = tunegrid, verbosity=0)
    
    # Obtaining the test metrics (per-class and macro)
    modelmlpred <- predict(modelml, test)
    cat(paste("CLASSIFICATION:", var), "\n", "\n", "# Test metrics: overall and per class", "\n")
    print(testcm <- confusionMatrix(modelmlpred, test[,var], mode="everything"))
    
    # ROC curves and AUC
    modelmlpredprob <- predict(modelml, test, type = "prob") # Computes the prediction probabilities for the test set
    roc_curvestest <- lapply(levels(test[,var]), function(class){
      binlab <- as.numeric(test[,var] == class)
      roc(binlab, modelmlpredprob[[class]])})
    names(roc_curvestest) <- levels(test[,var])
    # Macro AUC
    auctest <- sapply(roc_curvestest, function(class){class$auc})
    macroauctest <- round(mean(auctest), 4)
    # ggplot with the ROC curves
    classcol <- colplotclust(var, train, type = "group")
    p <- ggroc(roc_curvestest, size = 1) + scale_colour_manual(name = NULL, values = classcol$col, labels = levels(train[,var])) +
      geom_abline(intercept = 1, slope = 1, color='grey', linewidth = 0.75, linetype = "dashed") + 
      theme_classic() +
      theme(axis.line = element_line(color = "black"), axis.text=element_text(size=12), plot.title = element_text(face = "bold", hjust = 0.5), axis.title=element_text(size=12), legend.text=element_text(size=12), legend.position.inside = c(0.8, 0.2)) +
      labs(x = "\n 1-Specificity", y = "Sensitivity \n", title = paste("ROC curves for classification", var, "— Macro AUC =", macroauctest))
    
    # Showing the main test macro metrics (F1, [mean] Balanced Accuracy and AUC)
    cat("\n", "# Test macro-metrics", "\n")
    if(perclass=="single"){
      print(c(testcm$byClass[c("F1","Balanced Accuracy")], AUC=macroauctest))
    }
    else{
      print(c(colMeans(testcm$byClass[,c("F1","Balanced Accuracy")], na.rm = T), AUC=macroauctest))
    }
    
    # If one wants the ROC curves to be printed
    if(roc==T){
      print(p)
    }
  }
  
  if(!is.null(outfile)){sink()} # Stops sending results to the file (if a file was specified)
  
  ## Returning training and/or test results when applicable
  if(is.null(test)){ # If training model for evaluation 
    
    if(res==T & controltrain$method!="none"){ # If full results computed (per-class and macro metrics from pooled resamples) from CV, returns the trained model and associated ROC curves
      invisible(list(cvmodel=modelml, cvrocplot=p))
    }
    else{ # If full results are not computed or if no CV were used, returns the trained model only
      invisible(list(trainmodel=modelml))
    }
  }
  else{ # If testing a model (test is not NULL), returns the (re)trained model, test results and associated ROC curves
    invisible(list(testresults=testcm, testrocplot=p, trainmodel=modelml))
  }
}
