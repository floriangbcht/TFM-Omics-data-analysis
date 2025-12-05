
### Function for generating mean SHAP magnitudes and directions (averages across all predictions) and computing a feature importance plot for each class of a specific model

plotshap <- function(model, shap=F){
  
  modname <- names(model) # Name of the model
  
  # Choosing the correct type of model
  modeltype <- case_when(
    grepl("_svmLinear", modname) ~ "SVM",
    grepl("_rf", modname) ~ "RF",
    grepl("_xgboost", modname) ~ "XGBOOST",
    TRUE ~ NA_character_)
  
  # Choosing the correct classification
  if(grepl("IHC", modname)){
    classif <- colnames(datatrain)[21]
  }
  else if(grepl("Ternary", modname)){
    classif <- colnames(datatrain)[22]
  }
  else if(grepl("Binary", modname)){
    classif <- colnames(datatrain)[23]
  }
  
  classes <- levels(datatrain[,classif]) # Names of the classes
  
  finalmodel <- model[[modname]]$trainmodel # Extract the re-trained model (retrained on the full training set)
  
  # Computing the (raw) SHAP values for each prediction for each class
  shaplist <- lapply(classes, function(class){
    predwrap <- function(object, newdata){ # Wrapper function for predicting the class of an observation
      predict(object, newdata = newdata, type = "prob")[ ,class]
    }
    set.seed(42) # Fixing a seed for reproducibility
    fastshap::explain(object = finalmodel, X = datatrain[c(1:20)], pred_wrapper = predwrap, nsim = 500, adjust = T) # Approximated and adjusted SHAP values
  })
  
  names(shaplist) <- classes
  
  magn_meanshapval <- sapply(shaplist, function(x){colMeans(abs(x))}) # Mean absolute values (MAGNITUDE)
  
  dir_meanshapval <- sapply(shaplist, function(x){colMeans(x)}) # Mean raw values (DIRECTION)
  
  # List of feature importance plots (one for each class)
  # Importance corresponds to the (mean) absolute SHAP value
  plotlist <- lapply(colnames(magn_meanshapval), function(class){
    
    df <- data.frame(immunvar=rownames(magn_meanshapval), shap=magn_meanshapval[,class], row.names = NULL)
    
    ggplot(df, aes(x = shap, y = reorder(immunvar, shap))) +
      geom_col(fill = "steelblue") + 
      labs(x = "Mean SHAP value \n", y = NULL, title = class) +
      theme_gray() +
      theme(panel.grid.major.x = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(color = "black"), plot.title = element_text(face = "bold", hjust = 0.5))
  })
  names(plotlist) <- colnames(magn_meanshapval)
  
  # Displaying only one plot if the classification is binary (the plot is the same for the two classes)
  if(grepl("Binary", modname)){
    fig <- plotlist[[1]] + labs(title=paste("Feature importance for classification", classif, "with", modeltype), subtitle=names(plotlist)[1]) +
      theme(plot.subtitle = element_text(face = "bold", hjust = 0.5))
  }
  
  # Grid of plots if the classification is multi-class
  else{
    # Grid with all the plots
    grid <- plot_grid(plotlist=plotlist, ncol = 2)
    # Common title
    title <- ggdraw() + draw_label(paste("Feature importance for classification", classif, "with", modeltype), fontface='bold', size=15)
    # Final figure
    fig <- plot_grid(title, grid, ncol=1, nrow = 2, rel_heights=c(0.1, 1))
  }
  
  # Printing the plot (if one wants to)
  if(shap==T){
    print(fig)
  }
  
  # Returning the matrix of mean absolute SHAP values, the matrix of mean raw SHAP vlaues, each individual plots (per-class) and the final plot
  invisible(list(magn_shap_values=magn_meanshapval, dir_shap_values=dir_meanshapval, plot_per_class=plotlist, final_plot=fig))
}

