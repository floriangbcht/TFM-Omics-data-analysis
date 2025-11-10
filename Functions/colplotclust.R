
### Function for attributing colors depending on the classification

colplotclust <- function(classif, data, type = c("group", "single"), veccol = c("grey", "steelblue", "forestgreen", "tomato")){
  
  type <- match.arg(type) # Ensure only "group" or "single" can be passed
  
  ngroups <- length(levels(data[,classif]))
  
  if(ngroups==4){ # Vector of colors that depends on the group size
    colorg <- veccol
  }
  else if(ngroups==3){
    colorg <- veccol[-1]
  }
  else{
    colorg <- veccol[-c(1,3)]
  }
  
  if(type == "group"){colorgplot <- list(col=colorg[factor(levels(data[,classif]), levels=levels(data[,classif]))])} # One color per group
  else{colorgplot <- list(col=colorg[data[,classif]])} # One color per observation, matching with group
  
  return(colorgplot)
}
