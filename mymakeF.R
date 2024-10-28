#' Creation of a matrix of focal sets
#'
#' \code{makeF} creates a matrix of focal sets
#'
#' @param c Number of  clusters.
#' @param type Type of focal sets ("simple": \eqn{\emptyset}, singletons and \eqn{\Omega};
#' "full": all \eqn{2^c} subsets of \eqn{\Omega}; "pairs": \eqn{\emptyset}, singletons,
#' \eqn{\Omega}, and all or selected pairs).
#' @param pairs Set of pairs to be included in the focal sets; if NULL, all pairs
#'  are included. Used only if type="pairs".
#' @param Omega Logical. If TRUE (default), \eqn{\Omega} is a focal set (for types 'simple' and
#' 'pairs').
#'
#' @return A matrix (f,c) of focal sets.
#' @export
#' @import R.utils
#'
#' @examples
#' c<-4
#' ## Generation of all 16 focal sets
#' F<-makeF(c,type='full')
#' 
#' ## Generation of focal sets of cardinality 0, 1 and c
#' F<-makeF(c,type='simple')
#' 
#' ## Generation of focal sets of cardinality 0, 1, and 2
#' F<-makeF(c,type='pairs',Omega=FALSE)
#' 
#' ## Generation of focal sets of cardinality 0, 1, and c, plus the pairs (1,2) and (1,3)
#' F<-makeF(c,type='pairs',pairs=matrix(c(1,2,1,3),nrow=2,byrow=TRUE))
#' (1nk:此处 不是NULL,选定一些集合对)

#for Function intToBin (1nk:该转换函数需要下面这个包,且被限制为最大2 ^ 32)
# library(R.utils)

mymakeF <- function(c, type = "full", pairs = NULL, Omega = TRUE) {
    ## typye: "simple", "full" or "pairs"
    if (type == "full") {
        # All the 2^c focal sets
        ii <- 1:2^c
        N <- length(ii)     #(1nk:幂集元素个数)
        myF <- matrix(0, N, c)
        CC <- intToBin(0:(N - 1))  #(1nk:把幂集元素全部表为十转二进制)
        for(i in 1:N) myF[i, ] <- as.numeric(substring(CC[i], 1:c, 1:c))
        #(1nk:把二进制的字符串型转为数值型)
        myF <- myF[, c:1] #(1nk:二进制数值矩阵的列对换)
    } else {
        # type= 'simple' or 'pairs'
        myF <- rbind(rep(0, c), diag(c))  # the empty set and the singletons
        #(1nk:rbind行合并,rep重复0 c次,diag(c)生成c*c的单位矩阵)
        
        if (type == "pairs") {
            # type = 'pairs' pairs not specified: we take them all
            if (is.null(pairs)) {
                for (i in 1:(c - 1)) {
                  for (j in (i + 1):c) {
                    f <- rep(0, c)
                    f[c(i, j)] <- 1
                    myF <- rbind(myF, f)
                  }
                }
            } else {
                # pairs specified
                n <- nrow(pairs)
                for (i in 1:n) {
                  f <- rep(0, c)
                  f[pairs[i, ]] <- 1
                  myF <- rbind(myF, f)
                }
            }
        }
        if (Omega) 
            myF <- rbind(myF, rep(1, c))  # the whole frame
    }
    
    row.names(myF) <- NULL
    return(myF)
}
