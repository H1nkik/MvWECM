normalize <- function(x){
  n <- ncol(x)
  m <- nrow(x)
  for(j in 1:n)
  {
    if(sd(x[,j])!=0){
      x[,j] <- (x[,j]-mean(x[,j]))/sd(x[,j])}else{
        x[,j]=rep(1)
      }
  }
  return(x)
}
# 
# normalize <- function(x){
#   n <- ncol(x)
#   m <- nrow(x)
#   for(j in 1:n)
#   {
#       x[,j] <- (x[,j]-mean(x[,j]))/sd(x[,j])
#   }
#   return(x)
# }