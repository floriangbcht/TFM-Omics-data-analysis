
### Quick function for comparing existing alternative ternary and binary classifications with the Kmeans ones

classifvskmeans <- function(dataclassif, classif, datay, type = c("boxplot", "biplot")){
  
  type <- match.arg(type) # Ensure only "boxplot" or "biplot" can be passed
  
  if(classif == "wardD2_3"){ # Set the correct comparison depending on the cluster number
    k = 3
  }
  else{
    k = 2
  }
  
  ## Boxplot
  if(type == "boxplot"){
    
    # Box colors
    clustcol <- colplotclust(classif, dataclassif, type = "group")
    
    # Boxplot for hierarchical clustering
    p1 <- plotclust(data = dataclassif, xvar = classif, datay = datay, yvar = "counts", type = "boxplot", col = clustcol$col, title = F)
    
    # Boxplot for K-means
    p2 <- plotclust(data = dataclassif, xvar = paste0("k_means", k), datay = datay, yvar = "counts", type = "boxplot", col = clustcol$col, title = F)
  }
  else{ ## Biplot
    
    # Point colors for hierarchical clustering
    clustcol <- colplotclust(classif, dataclassif, type = "single")
    # Bivariate plot of read counts vs. indices for hierarchical clustering
    p1 <- plotclust(data = dataclassif, xvar = classif, datay = datay, yvar = "counts", type = "biplotESR1", col = clustcol$col, title = F)
    
    # Point colors for Kmeans
    clustcol <- colplotclust(paste0("k_means", k), dataclassif, type = "single")
    # Bivariate plot of read counts vs. indices for K-means
    p2 <- plotclust(data = dataclassif, xvar = classif, datay = datay, yvar = "counts", type = "biplotESR1", col = clustcol$col, title = F)
  }
  
  # Grid with the two plots
  grid <- plot_grid(plotlist=list(p1, p2), nrow = 1)
  # Common title
  title <- ggdraw() + draw_label(paste("Classification:",classif,"vs.",paste0("k_means", k), "\n"), fontface='bold')
  # Final figure
  print(plot_grid(title, grid, ncol=1, nrow = 2, rel_heights=c(0.1, 1)))
  
}
