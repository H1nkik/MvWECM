compare_indices <- function(vec1, vec2, method = 1, mybeta = 1, if_credal_id = FALSE, if_noisy_id = FALSE) {
    ## modified time 2015-03-05 
    ## can be used for the precision of credal partition
    ## if vec1 is credal_id, 0,1,..2^f-1,use if_credal_id=TRUE,or it default FALSE
    ## the input of the real cluster id can be some noisy id
    ## the noisy id flag is 1000
    ## vec1: the cluster result by experiment
    ## vec2: the real cluster, stand cluster
    ## method=0 purity
    ## method=1 precision (evidential precision)
    ## method=2 recall
    ## method=3 F-score with para mybeta
    ## method=4 RI
    ## method=5 Return three values, P, R, RI    

    if (class(vec1) == "communities") {
        vec1 = membership(vec1)
    }
    
    if (class(vec2) == "communities") {
        vec2 = membership(vec2)
    }
    n = length(vec1)
    nodes = 1:n
    com1 = c()
    com2 = c()
    
    name1 = unique(vec1)
    name2 = unique(vec2)
    K1 = length(name1)
    K2 = length(name2)
    for (i in 1:K1) {
        com1[i] = list(nodes[vec1 == name1[i]])
        names(com1)[i] = name1[i]
    }
    for (i in 1:K2) {
        com2[i] = list(nodes[vec2 == name2[i]])
        names(com2)[i] = name2[i]
    }
    
    if (method == 0) {
        ## purity
        cor_num = 0
        may_id = 1:K2
        for (i in 1:K1) {
            
            temp = sapply(may_id, function(x) {
                return(length(intersect(com1[[i]], com2[[x]])))
            })
            cor_num = cor_num + max(temp)
            # id_del = which.max(temp) cor_num = cor_num + max(temp) may_id = may_id[-id_del]
        }
        
        accuracy = cor_num/n
    }
    
    if (method != 0) {
        ## precision
        expe_cluster_mat = matrix(0, n, n)
        real_cluster_mat = matrix(0, n, n)
        for (i in 1:K1) {
            # if there is one node in the cluster, next
            if (length(com1[[i]]) == 1) {
                next
            }
            
            # for credal id input
            if (if_credal_id) {
                cluster_dec_id = as.numeric(names(com1)[i])
                temp = log(cluster_dec_id)/log(2)
                temp1 = round(temp)
                # if this is an imprecise cluster for credal id or empty set, go next
                if (temp1 != temp || cluster_dec_id == 0) {
                  next
                }
            }
            nodepair_id = combn(com1[[i]], 2)
            # print(dim(nodepair_id)[2])
            node_id = apply(nodepair_id, 2, function(x) {
                x = sort(x)
                x[1] + (x[2] - 1) * n
            })
            expe_cluster_mat[node_id] = 1
            
            # length(which(expe_cluster_mat==1))
        }
        expe_cluster_mat[lower.tri(expe_cluster_mat)] = 2
        # expe_cluster_mat[lower.tri(expe_cluster_mat)] = t(expe_cluster_mat)[lower.tri(t(expe_cluster_mat))]
        for (i in 1:K2) {
            # if there is one node in the cluster, next for stand cluster, there should not happen
            if (length(com2[[i]]) == 1) {
                next
            }
            # for there are noisy id input
            if (if_noisy_id) {
                temp = as.numeric(names(com2)[i])
                # temp1=round(temp) if this is an noisy cluster for credal id, go next
                if (temp == 1000) {
                  next
                }
            }
            nodepair_id = combn(com2[[i]], 2)
            node_id = apply(nodepair_id, 2, function(x) {
                x = sort(x)
                x[1] + (x[2] - 1) * n
            })
            real_cluster_mat[node_id] = 1
            
            
        }
        # real_cluster_mat[lower.tri(real_cluster_mat)] = t(real_cluster_mat)[lower.tri(t(real_cluster_mat))]
        real_cluster_mat[lower.tri(real_cluster_mat)] = 2
        
        diag(expe_cluster_mat) = 2
        diag(real_cluster_mat) = 2
        
        exp_p = which(expe_cluster_mat == 1)
        rel_p = which(real_cluster_mat == 1)
        exp_n = which(expe_cluster_mat == 0)
        rel_n = which(real_cluster_mat == 0)
        
        # choose(8,2)+choose(5,2)+choose(4,2)
        TP = length(intersect(rel_p, exp_p))
        # FP=length(exp_p)-TP;
        FP = length(intersect(rel_n, exp_p))
        
        ## -n, delete the effect by the diag element, which both be 0
        TN = length(intersect(rel_n, exp_n))
        FN = length(intersect(rel_p, exp_n))
      
        # FN=length(rel_n)-TN;
        P = TP/(TP + FP)
        
        R = TP/(TP + FN)
		cat(TP, TN, FP, FN, "\n")
    }
    ## end if method !=0
    
    if (method == 1) {
        accuracy = P
    } else if (method == 2) {
        accuracy = R
    } else if (method == 3) {
        accuracy = (mybeta + 1) * P * R/(mybeta * P + R)
    } else if (method == 4) {
        accuracy = (TP + TN)/(TP + TN + FP + FN)
    } else if (method == 5){
	    accuracy =  c(P, R, (TP + TN)/(TP + TN + FP + FN)) 
	}
    return(accuracy)
    
}


 
