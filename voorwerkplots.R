
### Function for generating boxplots similar to those in Voorwerk et al. (2023)

voorwerkplots <- function(cluster, data1, data2){
  
  # List that contains correct cell types and genes (when the genes are present in our data) for the corresponding biomarkers in Voorwerk et al. (2023)
  immune <- list(stromal=list(c(7,9,10,12),"Stromal TILs"), cd8=list("T_cells_CD8","CD8+ T cells"), pdl1=list("CD274","PDL1 expression"), 
                 cd8sign=list(c("CD8A","CD8B"),"CD8+ T cell signature"), pd1=list("PDCD1","PD1 expression"), 
                 regtsign=list("FOXP3","Regulatory T cell signature"), 
                 apmsign=list(c("TAP1","TAP2","TAPBP","HLA-A","HLA-B","HLA-C"),"APM signature"), 
                 ifnsign=list(c("CXCL9","CXCL10"),"IFN-γ signature"), infchemsign=list(c("CCL2","CCL4","CCL7"),"Inflammatory chemokine signature"), 
                 tuminfsign=list(c("CCL5","CD27","CD274","CD276","CD8A","CXCL9","CXCR6","HLA-DQA1","HLA-DRB1","HLA-E","IDO1","LAG3","NKG7","PDCD1LG2",
                                   "PSMB10","STAT1","TIGIT"),"Tumor inflammatory signature"), 
                 mastsign=list(c("MS4A2","CPA3","HDC","TPSAB1"),"Mast cell signature"))
  
  for(i in names(immune)){
    
    plotlist <- lapply(cluster, FUN = function(x){ # List of plots
      
      colorgplot <- colplotclust(x, data1, type = "single", veccol = c("brown", "goldenrod1", "lightblue", "pink"))$col # Jitter point colors
      
      if(i == names(immune)[1]){ # Table with mean abundance scores for the Stromal TILs and category labels
        df <- data.frame(value=rowMeans(data1[,unlist(immune[[i]][1])]), group=data1[,x])
      }
      else if(i == names(immune)[2]){ # Table with CD8+ T cell abundance scores and category labels
        df <- data.frame(value=data1[,unlist(immune[[i]][1])], group=data1[,x])
      }
      else{ # Table with single gene expression or mean expression of a gene set (for molecular signatures) and category labels
        ifelse(length(unlist(immune[[i]][1]))<2,
               df <- data.frame(value=data2[unlist(immune[[i]][1]),rownames(data1)], group=data1[,x]),
               df <- data.frame(value=rowMeans(t(data2[unlist(immune[[i]][1]),]))[rownames(data1)], group=data1[,x]))
      }
      
      # Table that contains the statistics (q1, median, q3) for each category 
      medquant <- df %>% group_by(group) %>% summarise(q1 = quantile(value, 0.25), q2 = quantile(value, 0.5), q3 = quantile(value, 0.75))
      
      # Final plot
      ggplot(df, aes(x = group, y = value, colour = colorgplot)) + geom_jitter(shape = 16, size = 3, width = 0.2) + scale_colour_identity() +
        geom_errorbar(data = medquant,aes(x = group, y = q2, ymin = q1, ymax = q3), width = 0.3, color = "black", linewidth = 1) +
        geom_segment(data = medquant, aes(x = as.numeric(group) - 0.2, xend = as.numeric(group) + 0.2, y = q2, yend = q2), color = "black", linewidth = 1) +
        theme_classic() + theme(axis.line = element_line(color = "black"), axis.text=element_text(size=12)) +
        xlab(x) + ylab("")
      
    })
    
    # Grid with all plots
    grid <- plot_grid(plotlist=plotlist, nrow = 2)
    # Common title
    title <- ggdraw() + draw_label(immune[[i]][2], fontface='bold')
    # Final figure
    print(plot_grid(title, grid, ncol=1, nrow = 2, rel_heights=c(0.1, 1)))
    
  }
}
