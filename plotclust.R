
### Function for generating a boxplot for a variable (ESR1 expression or other) or a bivariate plot that can be of any variable Y vs. variable X or specifically ESR1 expression vs. index, depending on the classification

plotclust <- function(data, xvar, datay = NULL, yvar, col = NULL, type = c("boxplot", "biplotESR1", "biplot"), title = TRUE) {
  
  type <- match.arg(type) # Ensure only "boxplot", "biplotESR1", or "biplot" can be passed
  
  if(is.null(datay)){datay <- data}
  
  ## Generating the boxplot
  if(type == "boxplot"){
    
    if(is.null(col)){ # Determine the vector of box colors for the boxplot
      fillcol <- rep("lightgray",length(levels(data[,xvar])))
    }else{
      fillcol <- col}
    
    # Boxplot
    yname <- ifelse(yvar=="counts","Read count",yvar) # Set the y-axis title depending on the dependent variable
    p <- ggplot() + geom_boxplot(aes(x=data[,xvar], y=datay[,yvar]), fill=fillcol, linewidth = 0.7, outlier.shape = 21, outlier.size = 2, outlier.color = "black", outlier.fill = "white") +
      labs(x = "Cluster", y = yname) + 
      theme_classic() + 
      theme(axis.line = element_line(color = "black"), axis.text=element_text(size=12))
    
    if(yvar=="counts"){ # Change y-axis scale only if the dependant variable is ESR1
      p <- p + scale_y_continuous(breaks = seq(-2, 12, 2))
    } else {p}
    
    if(title == TRUE){ # Add a title only if title == TRUE
      p + labs(title = paste("Classification:",xvar,"\n")) + theme(plot.title = element_text(face = "bold", hjust = 0.5), axis.title=element_text(size=12))
    }else{
      p}
  }
  
  ## Generating the bivariate plot
  else{
    
    if(is.null(col)){ # Determine the vector of point colors for the bivariate plot
      colourcol <- rep("lightgray",nrow(data))
    }else{
      colourcol <- col}
    
    # Bivariate plot
    if(type=="biplotESR1"){ # Use indices as x variable if it is a biplot of ESR1 vs. indices; also set directly the axis titles
      xdatavar <- seq(nrow(data))
      xname <- "Index"
      yname <- "Read count"
      
    } else{ # Use directly the input variables and variable names if it is a biplot of variable Y vs. variable X
      xdatavar <- data[,xvar]
      xname <- xvar
      yname <- yvar
    }
    
    p <- ggplot() + geom_point(aes(x=xdatavar, y=datay[,yvar], colour=colourcol), shape = 16, size = 3) + scale_color_identity() +
      labs(x = xname, y = yname) + 
      theme_classic() + 
      theme(axis.line = element_line(color = "black"), axis.text=element_text(size=12))
    
    if(type=="biplotESR1"){ # Change y-axis scale only if the dependant variable is ESR1
      p <- p + scale_y_continuous(breaks = seq(-2, 12, 2))
    } else {p}
    
    if(title == TRUE & type=="biplotESR1"){ # Add a title only if title == TRUE and type=="biplotESR1"
      p + labs(title = paste("Classification:",xvar,"\n")) + theme(plot.title = element_text(face = "bold", hjust = 0.5), axis.title=element_text(size=12))
    }else{
      p}
  }
}
