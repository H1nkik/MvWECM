max_decision <- function(m=m,w=w,c=2){
  #weighted sum m1__mT
  n <- nrow(m[[1]])
  W_m <- matrix(0,n,2^c)
  
  for (i in 1:length(m)) {
    W_m <- W_m + w[i] * m[[i]]
  }
  
  
  Label_Pre <- matrix(0,n,2^c)
  for (i in 1:n) {
    Label_Pre[i,which(W_m[i,] == max(W_m[i,]))] <- 1
  }
  Label_Pre = apply(Label_Pre, 1, which.max) 
  
  return(Label_Pre)
}