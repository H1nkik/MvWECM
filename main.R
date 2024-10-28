###loading
setwd("/Users/h1nkik/Desktop/MvWECM")
library(MASS) 
library(R.utils)
library(aricode)
library(R.matlab)
source("max_pignistic.R")
source("mymakeF.R")
source("compare_indices.R")
source("scale_01.R")
source("normalize.R")
source("newMVECM.R")

### If data type is excel:
#file_path <- c("reu1.csv", "reu2.csv","reu3.csv","reu4.csv","reu5.csv")
#X_reu<-list()
#for (i in 1:length(file_path)) {
  #X_reu[[i]] <- as.matrix(scale_01(read.csv(file_path[i],header = FALSE)))
#}
#realLabel =  as.numeric(as.factor(as.matrix(read.csv("reulabel.csv",header = FALSE))[,1]))


###reu2
mat_data <- readMat("reu2.mat")
X <- mat_data$X 
Y <- mat_data$gnd 
X_reu <- list()

for (i in 1:length(X)) {
  X_reu[[i]] <- as.matrix(normalize(X[[i]][[1]]))  
}

realLabel <- as.numeric(as.factor(as.matrix(Y)))
c<-6
t=length(X_reu)

#model
reMvecm<- mvwecm(c=c, x=X_reu, w = NULL, K = NULL, g0 = NULL, type = "pairs", pairs = NULL, Omega = TRUE, ntrials=1, alpha =1.25,delta =2, beta =58 ,eta = 1, epsi = 0.05, disp = TRUE)
myF <- mymakeF(c, type = "pairs", pairs = NULL, Omega = TRUE)
ComMass <- ComMassMv(reMvecm$m, reMvecm$w)
Gbest <- ComGbestMv(reMvecm$g)
Jbest <- reMvecm$Jbest
reComMvecm <- extractMass(ComMass, myF, g = Gbest, method = "mvwecm", crit = Jbest)
#eval
clusteridComMvecm = apply(reComMvecm$betp, 1,which.max)
clusteridComMvecm2 = apply(reComMvecm$mass, 1,which.max)-1
ariMvecm = ARI(clusteridComMvecm, realLabel)
nmiMvecm = NMI(clusteridComMvecm, realLabel)
epMvecm = compare_indices(clusteridComMvecm2, realLabel,method =1,if_credal_id = TRUE)

