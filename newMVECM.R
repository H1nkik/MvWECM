#'\code{mvecm} computes a credal partition from a matrix of attribute data using the Evidential c-means (MVECM) algorithm.
#' @param c Number of  clusters.
#' @param t Number of views
#' @param x input list of length t. It contains t-views data.  Element is a matrix of n*d[t]  correspondly.
#' @param g0 Initial prototypes, a list of length t. Element is a matrix of size c *d[t] correspondly. if not supplied, 
#' the prototypes are initialized randomly.
#' @param type Type of focal sets ("simple": empty set, singletons and Omega;
#' "full": all \eqn{2^c} subsets of \eqn{\Omega}; "pairs": \eqn{\emptyset}, singletons,
#' \eqn{\Omega}, and all or selected pairs).
#' @param Omega Logical. If TRUE (default), the whole frame is included (for types 'simple' and pairs')
#' @param pairs Set of pairs to be included in the focal sets; if NULL, all pairs are
#' included. Used only if type="pairs".
#' @param ntrials Number of runs of the optimization algorithm (set to 1 if g0 is  supplied).
#' @param alpha Exponent of the cardinality in the cost function.
#' @param w input matrix of size 1 x t, where t is the number of views. it quantifies the view weight.
#' @param K input matrix of size t x t, which quantifies the collaboration strength between each view of data sites. K[i,i]=0(i = 1,···,t)
#' @param delta  Distance to the empty set.
#' @param beta Control the view_weight
#' @param eta Exponent of cost function
#' @param epsi Minimum amount of improvement.
#' @param disp If TRUE (default), intermediate results are displayed.
#' @return The credal partition (an object of class \code{"credpart"}).

mvwecm <- function(c, x, w = NULL, K = NULL, g0 = NULL, type = "full", pairs = NULL, Omega = TRUE, ntrials=1, alpha = 1,delta = 10,beta = 1, eta = 1, epsi = 0.001, disp = TRUE,timemax=500 ){
  
  #---------------------- initializations --------------------------------------
  #the number of object (data samples)
  n <- nrow(x[[1]])
  
  #the number of view
  t <- length(x)
  
  #initialize view weight matrix 
  w <- matrix(1/t,nrow = 1,ncol = t)
  
  # collaboration strength between each pair of data sites
  K <- matrix(1,nrow = t,ncol = t)
  for (i in 1:t){
    K[i,i]=0
  }
  
  #feature dimensions of each view. 
  d <- matrix(0, 1, t)
  for (i in 1:t){
    d[i] <- ncol(x[[i]])    #column
  }
  
  delta2 <-delta^2 
  
  myF <- mymakeF(c, type, pairs, Omega) #focal matrix
  f <- nrow(myF)
  card <- rowSums(myF[2:f,])
 
  
  JT_list <- c()
  J1_list <- c()
  J2_list <- c()
  J3_list <- c()
  
  Jbest <- Inf
  Jold <- 1*10^10 #old objective
  
  #initialize the clustering center
  g <- list()
  for (itrial in 1:ntrials) {
    if (is.null(g0)){ 
      for (i in 1:t){
        #set.seed(seed)
        g[[i]] <- x[[i]][sample(1:n, c), ] 
      }#(random prototypes)
    }else {
      for (i in 1:t){
        g[[i]] <- g0[[i]] 
      }
    }
    
    #initialize the mass value
    m <- list()
    for (i in 1:t){
      m[[i]] <- matrix(1/(f-1), n, f-1)
    }
  
    
    #the center vector of views. construct as a list
    gplus <- list() #composite prototypes
    for (i in 1:t){
      gplus[[i]] <- matrix(0, f-1, d[i])
    }
    
    iter <- 0
    pasfini <- TRUE
    #------------------------ iterations-----------------------------------------
    while(pasfini){
      iter <- iter + 1
      for (i in 2:f)  {
        fi <- myF[i,]
        for (j in 1:t){
          truc <- matrix(fi, c, d[j]) 
          gplus[[j]][i-1, ] <- colSums(g[[j]] * truc)/sum(myF[i,])
        }
      }
      
      Ds <- list()#distance matirx
      for (i in 1:t){
        Ds[[i]] <- matrix(0, n, f-1)
      }
      for (i in 1:t){
        for (j in 1:(f-1)){
          Ds[[i]][, j] <- (rowSums((x[[i]] - matrix(gplus[[i]][j,], n, d[i], byrow = TRUE))^2))
          }
      }
      #browser()
      #caculation of masses
      psi <- list()
      phi <- list()
      for (i in 1:t){
        psi <- matrix(0, 1, t)
        phi[[i]] <- matrix(0, n, f-1)
      }
      #Calculation of psi and phi
      psi <- rowSums(K)
      
      for (i in 1:n){
        for (j in 1:(f-1)){
          for (k in 1:t){
            for(s in 1:t){
              phi[[k]][i, j] <- phi[[k]][i, j] + K[k, s] * m[[s]][i, j]
            }
          }
        }
      }
      
      ######caculation of the mass m, it consist of t matrix, which is a matrix of size n*f-1
      for (k in 1:t){
        for(i in 1:n){
          for (j in 1:(f-1)){
            vect1 <- (eta * phi[[k]][i,j]) / (w[k] * card[j] ^ alpha + eta * psi[k])
            vect2 <- 1-sum((eta * phi[[k]][i,])/(w[k] * card ^ alpha + eta * psi[k]))
            vect3 <- 1/((w[k] * card[j] ^ alpha + eta * psi[k]) * Ds[[k]][i,j])
            vect4 <- sum(1/((w[k] * card ^ alpha + eta * psi[k]) * Ds[[k]][i,])) 
            vect5 <- 1/(w[k] * delta2)#delta may take different values in different views, but here I take the same value.
            m[[k]][i, j] <- vect1 + (vect2 * vect3)/ (vect4 + vect5)
            if(is.nan(m[[k]][i,j])){
              m[[k]][i,j]<-0
            }
          }
        }
      }
      
      #######update the center
      #caculation of centers , the matrix H in the paper
      H <- list()
      for (i in 1:t){
        H[[i]] <- matrix(0, c, c)
      }
      for (i in 1:t){
        for (k in 1:c){
          for (l in 1:c){
            # truc <- rep(0,c)
            # truc[c(k , l)] <- 1
            # myt <- matrix(truc, f, c, byrow = TRUE)
            #indices <- which(rowSums((myF - myt) - abs(myF - myt)) == 0)  # indices of all Aj including wk and wl
            indices = which(myF[, l] == 1 & myF[, k] == 1) # indices of all Aj including wk and wl
            indices <- indices - 1
            if(length(indices) == 0)
              H[[i]][l, k] <- 0 else{
                for (jj in 1:length(indices)){
                  j <- indices[jj]
                  mj <- m[[i]][, j] ^ 2
                  H[[i]][l, k] <- H[[i]][l, k]+sum(w[i] * mj * card[j]^(alpha - 2))
                }
              }
          }
        }
      }
      
      #Caculation of the H[t, s] in paper
      Hs <- list()
      for (p in 1:t){
        for(q in 1:t){
          index <- (p - 1) * t + q
          Hs[[index]] <- matrix(0, c, c)
          if(p != q){
            
            for (k in 1:c){
              for (l in 1:c){
                indices = which(myF[, l] == 1 & myF[, k] == 1) # indices of all Aj including wk and wl
                indices <- indices - 1
                if(length(indices) == 0)
                  Hs[[index]][l,k] <- 0
                else{
                  for (jj in 1:length(indices)){
                    j <- indices[jj]
                    mj <- (m[[p]][, j] - m[[q]][, j]) ^ 2
                    Hs[[index]][l, k] <- Hs[[index]][l, k] + sum(mj * (card[j] ^ (-2)))
                  }
                }
              }
            }
          }
        }
      }
      
      # the construction of the B[t] matrix
      B <- list()
      for(k in 1:t){
        B[[k]] <- matrix(0, c, d[k])
      }
      for(k in 1:t){
        for (l in 1:c) {
          indices = which(myF[, l] == 1) # indices of all Aj inclduing wl
          indices <- indices - 1
          mi <- matrix(card[indices]^(alpha - 1), n, length(indices), byrow = TRUE) * m[[k]][, indices] ^ 2 * w[k]
          s <- rowSums(mi)
          mats <- matrix(s, n, d[k])
          xim <- x[[k]] * mats
          B[[k]][l, ] <- colSums(xim)
        }
      }
      
      #construction of the B[t,s]
      Bs <- list()
      for (p in 1:t){
        for(q in 1:t){
          index <- (p-1) * t + q
          # print(index)
          Bs[[index]] <- matrix(0, c, d[p])
          if(p!=q){
            for (l in 1:c) {
              indices = which(myF[, l] == 1) # indices of all Aj inclduing wl
              indices <- indices - 1
              mi <- matrix(1/card[indices], n, length(indices), byrow = TRUE) * ((m[[p]][, indices]-m[[q]][, indices])^2)
              s <- rowSums(mi)
              mats <- matrix(s, n, d[p])
              xim <- x[[p]] * mats
              Bs[[index]][l, ] <- colSums(xim)
            }
          }
        }
      }
      #set H[t]+sum(eta*K[t,s]*H[t,s]) as matrix KH, set B[t]+sum(eta*K[t,s]B[t,s]) as matrix KB.
      KH <- H
      KB <- B
      for(k in 1:t){
        for(s in 1:t){
          index <- (k - 1) * t + s
          KH[[k]] <- KH[[k]] + eta * K[k, s] * Hs[[index]]
        }
      }
      for(k in 1:t){
        for(s in 1:t){
          index <- (k - 1) * t + s
          KB[[k]] <- KB[[k]] + eta * K[k, s] * Bs[[index]]
        }
      }
    
      #centers are solved
      for(k in 1:t){
        g[[k]] <- solve(KH[[k]], KB[[k]])
      }
      ##Update the view weight
      #Caculation of view's wight
      tri <- matrix(0,t,1)
      temp = matrix(0,t,1)
    
      for (k in 1:t){
        for (i in 1:n) {
          for (j in 1:(f-1)) {
            temp[k] <- temp[k] + card[j] ^ alpha * m[[k]][i,j] ^2 * Ds[[k]][i,j] 
          }
        }
        tri [k] <- temp[k] + sum(delta2 * ((1 - rowSums(m[[k]])) ^ 2))
        }
      for (k in 1:t){
        w[k] <- exp((-tri[k]-beta)/beta)/sum(exp((-tri-beta)/beta))
      }
    
      mvide <- list()
      for(k in 1:t){
        mvide[[k]] <- 1 - rowSums(m[[k]])#(m_iphi)
      }
      
      JT=0
      J1 <- 0
      J2 <- 0
      J3 <- 0
      for(k in 1:t){
        J1 <- J1 + w[k]*(sum(m[[k]]^2 * Ds[[k]] * matrix(card^alpha, n, f-1, byrow = TRUE)) + delta2 * sum(mvide[[k]]^2))
        for(s in 1:t){
          J2 <-J2+ eta * K[k, s] * sum((m[[k]]-m[[s]])^2 * Ds[[k]])
        }
        J3 <- J3 + beta * w[k] * log(w[k]+epsi)
      }
      
      JT <- J1 + J2 +J3
      JT_list <- append(JT_list,JT)
      J1_list <- append(J1_list,J1)
      J2_list <- append(J2_list,J2)
      J3_list <- append(J3_list,J3)
      if(disp){
        print(paste("Iteration:", iter, ", Objective function:", JT))
        #print(paste("J1:",J1, ", J2:", J2,",J3:",J3,"####w:",w))
        #print("----------------------------------------------------")
      }
      pasfini <- (abs(JT - Jold) >= epsi)&&(iter < timemax)
      Jold <- JT #(update J)
    }#end while loop
    
    if (JT < Jbest){
      Jbest <- JT
      mbest <- m
      gbest <- g
      wbest <- w
    }
    res <- c(itrial, JT, Jbest)
    names(res) <- NULL
  }
  for (k in 1:t){
    m[[k]] <- cbind(1 - rowSums(mbest[[k]]), mbest[[k]])
  }
  re <- list(m, gbest, wbest, Jbest, JT_list)
  names(re) <- c('m', 'g', 'w', 'J','JT_list')
  return(re)
  
  
}


#############################################################
ComMassMv <- function(mass,weight){
  n <- length(mass)
  Mass <- mass[[1]] * weight[1]
  for (i in 2:n) {Mass <- Mass + weight[i] * mass[[i]]}
  
  return(Mass)}



ComGbestMv <- function(gbest){
  n <- length(gbest)
  Gbest <- gbest[[1]]
  for (i in 2:n) {
    Gbest <- cbind(Gbest,gbest[[i]])
  }
  return(Gbest)
}
