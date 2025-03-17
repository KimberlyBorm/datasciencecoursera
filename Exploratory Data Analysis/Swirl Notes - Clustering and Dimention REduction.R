##Swirl Notes - Clustering and Dimention Reduction

##11: Hirarcical Clustering 
#one can decide to stop clustering either when the clusters are too far apart to be merged 
#(distance criterion) or when there is a sufficiently small number of clusters (number criterion)."
#Distance or similarity are usually the metrics used.

#Euclidean distance and correlation similarity are continuous measures
#Manhattan distance is a binary measure
# use a measure of distance that fits your problem
#agglomerative (bottom-up) hierarchical clustering
#Use Euclidean distance (default) to find all distances
distxy <- dist(dataFrame)
#dendrogram (uses complete linkage to measure distance between clusters)
hc <- hclust(distxy)
plot(hc)
#same plot without labels or leaves 
plot(as.dendrogram(hc))
#It is a good idea to experiment with different methods of linkage to see the varying ways
# your data groups - average and complete linkages

#Heat maps originated in 2D displays of the values in a data matrix. Larger values
#were represented by small dark gray or black squares (pixels) and smaller values by
#lighter squares.
> heatmap(dataMatrix, col = cm.colors(25))


##12: K Means Clustering  
#a method of clustering that usees the least sum of squares 
#Requires: 
    #1: A number of clusters
    #2: A defined distance metric
    #3: An initial guess as to cluster centroids
#When complete the algorithm produces 1)  a final position of each cluster's centroid 
#2)the assignment of each data point or observation to a cluster.

kmeans(datamatrix, centers, iter.max, nstart)
#centers - either a number of clusters or a set of initial centroids. 
#iter.max - maximum number of iterations to go through
#nstart - number of random starts if centers is a number
#Examples: 
    kmObj <- kmeans(dataFrame, centers = 3)
    #plot clustered data colorcoaded
    plot(x, y, col = kmObj$cluster, pch = 19, cex = 2)
    #add centroids 
    points(kmObj$centers, col = c("black","red","green"), pch = 3, cex = 3, lwd = 3)
    
    #6 centers with same data (can run inside a plot to view the results quickly)
    plot(x, y, col = kmeans(dataFrame,6)$cluster,  pch = 19, cex = 2)


##13: Dimension Reduction
#principal component analysis (PCA) and singular value decomposition (SVD)
    heatmap() # runs a hierarchical cluster analysis on the matrix
#Data Compression (a lower rank matrix that explains the original data)
    #find a smaller set of multivariate variables that are uncorrelated AND
    #explain as much variance (or variability)    
#solutions are PCA and SVD
#The principal components of X are the columns of V
#The singular values of X are found in the diagonal elements of D, 
#D gives the singular values of a matrix in decreasing order of weight.
    #SVD - express 1 matrix (X) as product of 3 matrices (X = UDV^t)
        #Here U and V each have orthogonal (uncorrelated) columns.
        #U's (row means) columns are the left singular vectors of X and V's(column means) columns are the right singular 
        #vectors of X.  D is a diagonal matrix, by which we mean that all of its entries not on 
        #the diagonal are 0. The diagonal entries of D are the singular values of X, weights for the U and V columns 
        #accounting for the variation in the data
            #first dimention of hte data
            a1 <- svd1$u[,1] %*% t(svd1$v[,1])* svd1$d[1]
            # first two dimentions of the data
            a2 <- svd1$u[,1:2] %*% diag(svd1$d[1:2]) %*% t(svd1$v[,1:2]) 
    #PCA
        #first we scale the matrix (subtract the column mean from every element and 
        #divide the result by the column standard deviation)
        svd(scale(mat))
        prcomp(scale(mat))
        #this shows that the principal components of the scaled matrix, shown in the Rotation component
        #of the prcomp output, ARE the columns of V, the right singular values. 
        #Thus, PCA of a scaled matrix yields the V matrix (right singular vectors) 
        #of the same scaled matrix.
    #Misssing Data
        #The bioconductor package (http://bioconductor.org) has an impute package which you
        #can use to fill in missing data. One specific function in it is impute.knn.
    #when reducing dimensions  pay attention to the scales on which different variables are measured 
    #and make sure that all your data is in consistent units
 
#14: Clustering Example
Example of SVD
sub1 <- subset(ssd, subject == 1)
dim(sub1)
names(sub1[,1:12])        
#plots
par(mfrow=c(1, 2), mar = c(5, 4, 1, 1))
plot(sub1[, 1], col = sub1$activity, ylab = names(sub1)[1])
plot(sub1[, 2], col = sub1$activity, ylab = names(sub1)[2])
legend("bottomright",legend=unique(sub1$activity),col=unique(sub1$activity), pch = 1)
par(mfrow=c(1,1))
#focus on the 3 dimensions of mean acceleration
mdist <- dist(sub1[,1:3])
hclustering <- hclust(mdist)
myplclust(hclustering, lab.col = unclass(sub1$activity))
# again with maximiun accelleration
mdist <- dist(sub1[,10:12])
hclustering <- hclust(mdist)
myplclust(hclustering, lab.col = unclass(sub1$activity))
#SVD
svd1 <- svd(scale(sub1[,-c(562,563)]))
maxCon <- which.max(svd1$v[,2])
mdist <- dist(sub1[,c(10:12,maxCon)])
hclustering <- hclust(mdist)
myplclust(hclustering, lab.col = unclass(sub1$activity))
kClust <- kmeans(sub1[, -c(562, 563)], centers = 6)
table(kClust$cluster, sub1$activity)
#test consistence of results with 100 random starts
kClust <- kmeans(sub1[, -c(562, 563)], centers = 6, nstart = 100)
#investage Laying (29)
laying <- which(kClust$size==29)
plot(kClust$centers[laying, 1:12],pch=19,ylab="Laying Cluster")
names(sub1[,1:3]) 
#investigate walkdown
walkdown <- which(kClust$size == 49)
plot(kClust$centers[walkdown, 1:12],pch=19,ylab="Walkdown Cluster")

