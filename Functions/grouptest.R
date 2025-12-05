
### Function for computing among group differences according to the number of categories (2 or more), data normality, and homoscedasticity
### It includes the possibility of computing median comparison results, adjusted p-value (within a comparative context), and effect size (magnitude of the differences)

grouptest <- function(yvar, cluster, data, resulttest = T, mediancomp = F, pvaladj = F, ncomps = NULL, magnitude = F, printtable = F, writetable = F){
  cat("\n", "\n", "TEST WITH CLASSIFICATION", cluster, "\n")
  cat("VARIABLE:", yvar, "\n","\n")
  
  ngroups <- length(levels(data[,cluster]))
  
  restable <- data.frame(matrix(nrow = 1, ncol = 3), row.names = cluster) # Result table that would contain the elements mentionned above, except the effect size that can only be printed
  colnames(restable) <- c("Adj_P", "Abs_median_diff", "Gradient")
  
  ### If two groups only
  if(ngroups==2){
    # Normality test for each group
    normalres <- tapply(data[,yvar], data[,cluster], function(x){
      shapiro.test(x)$p.value})
    ## If normality in both groups
    if(all(normalres>0.05)){
      # Homocedasticity test
      vareq <- car::leveneTest(data[,yvar]~data[,cluster])$"Pr(>F)"[1]>0.05
      # Student's (t) test
      testfinal <- t.test(data[,yvar]~data[,cluster], var.equal = vareq)
      pvalue <- testfinal$p.value
      if(pvalue<0.05 & resulttest == T){
        cat("Student test", "\n", pvalue)
      }
    }
    ## If non-normality in a least one group
    else{
      # Mann-Whitney test
      testfinal <- wilcox.test(data[,yvar]~data[,cluster], correct = F)
      pvalue <- testfinal$p.value
      if(pvalue<0.05 & resulttest == T){
        cat("Mann-Whitney test", "\n", pvalue)
      }
    }
    ## If one wants median comparison results
    if(mediancomp == T){
      medians <- sort(by(data[,yvar], data[,cluster], median))
      restable[cluster, "Abs_median_diff"] <- max(medians)-min(medians) # Compute the absolute value of median range
      if(all(names(medians)==levels(data[,cluster])) | all(names(medians)==rev.default(levels(data[,cluster])))){ # Show the gradient of medians
        restable[cluster, "Gradient"] <- paste(names(medians), collapse = " ")
      }else{
        restable[cluster, "Gradient"] <- "Unordered"}
    }
    ## If one wants the adjusted p-value
    if(pvaladj == T){ # Adjusted p-value that depends on the number of comparisons
      restable[cluster, "Adj_P"] <- p.adjust(pvalue, method = "fdr", n = ncomps)
    }
    ## If one wants the effect size
    if(magnitude == T){
      # Cohen's D or Cliff's delta
      cat("\n")
      if(grepl("t-test", testfinal$method)){
        print(effectsize::cohens_d(data[,yvar]~data[,cluster])) # Cohen's D
      }
      else{
        print(effectsize::cliffs_delta(data[,yvar]~data[,cluster])) # Cliff's delta
      }
    }
  }
  
  #### If more than two groups
  else{
    # ANOVA model
    anovmod <- lm(data[,yvar]~data[,cluster])
    # Normality test on the residuals
    normalres <- shapiro.test(anovmod$residuals)
    ## If normality of the residuals
    if(normalres$p.value>0.05){
      # Homocedasticity test (on original data)
      vareq <- car::leveneTest(data[,yvar]~data[,cluster])$"Pr(>F)"[1]>0.05
      # If homocedasticity
      if(vareq){
        # One-way ANOVA
        testgroup <- aov(data[,yvar]~data[,cluster])
        pvalue <- summary(testgroup)[[1]]$"Pr(>F)"[1]
        # Paired t test
        if(pvalue<0.05 & resulttest == T){
          print(pairwise.t.test(data[,yvar], data[,cluster], p.adjust.method = "bonferroni")$p.value)
        }
      }
      # If heterocedasticity
      else{
        # Welch ANOVA
        testgroup <- oneway.test(data[,yvar]~data[,cluster])# var.equal = FALSE by default
        pvalue <- testgroup$p.value
        # Paired Games-Howell test
        if(pvalue<0.05 & resulttest == T){
          print(rstatix::games_howell_test(data, as.formula(paste0(yvar, "~", cluster))))# Bonferroni Correction by default
        }
      }
    }
    ## If non-normality of the residuals
    else{
      # Kruskal-Wallis test
      testgroup <- kruskal.test(as.formula(paste0(deparse(substitute(data)), "$", yvar, "~", deparse(substitute(data)), "$", cluster)))
      pvalue <- testgroup$p.value
      if(pvalue<0.05 & resulttest == T){
        # Paired Dunn's test
        dunn.test::dunn.test(data[,yvar], data[,cluster], method = "Bonferroni")
      }
    }
    ## If one wants median comparison results
    if(mediancomp == T){
      medians <- sort(by(data[,yvar], data[,cluster], median))
      restable[cluster, "Abs_median_diff"] <- max(medians)-min(medians)
      if(all(names(medians)==levels(data[,cluster])) | all(names(medians)==rev.default(levels(data[,cluster])))){
        restable[cluster, "Gradient"] <- paste(names(medians), collapse = " ")
      }else{
        restable[cluster, "Gradient"] <- "Unordered"}
    }
    ## If one wants the adjusted p-value
    if(pvaladj == T){
      restable[cluster, "Adj_P"] <- p.adjust(pvalue, method = "fdr", n = ncomps)
    }
    ## If one wants the effect size
    if(magnitude == T){
      # Epsilon squared or Eta squared
      cat("\n")
      print(effectsize::effectsize(testgroup))
    }
  }
  ## If one wants the table to be saved as a .csv document (one per grouping variable in a comparative context)
  if(writetable == T){
    write.csv(restable, file = paste0("results_", cluster, ".csv"))}
  if(printtable == T){
    cat("\n")
    print(restable)}
}
