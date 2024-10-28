max_pignistic <- function(m=m,w=w,c=2){
  ######pignistic convert########
  #weighted sum m1__mT
  n <- nrow(m[[1]])
  W_m <- matrix(0,n,2^c)
  
  for (i in 1:length(m)) {
    W_m <- W_m + w[i] * m[[i]]
  }
  
  ###m in Bayes framework(Pignistic)
  myF <- mymakeF(c)
  f <- nrow(myF)
  card <- rowSums(myF)
  B_m <- matrix(0,n,c)
  for(i in 1:n){
    for(j in 1:c){
      B_m[i,j] <- 0
      for(jj in 2:f){
        B_m[i,j]<- B_m[i,j]+(W_m[i,jj]*myF[jj,j])/card[jj]
      }
    }
  }
  
  ##max_pignistic rule
  Label_Pre <- matrix(0,n,c)
  for (i in 1:n) {
    Label_Pre[i,which(B_m[i,] == max(B_m[i,]))] <- 1
  }
  Label_Pre = apply(Label_Pre, 1, which.max) 
  
  
  return(Label_Pre)
  
}
