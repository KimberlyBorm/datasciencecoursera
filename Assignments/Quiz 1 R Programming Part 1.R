Quiz 1  - Mod 1


x <- 4L
class(x)

x <- c(4, TRUE)
class(x)

x <- c(1,3, 5) 
y <- c(3, 2, 10)
cbind(x,y)

x <- list(2, "a", "b", TRUE)
x[[2]]

x <- 1:4  
y <- 2:3
x + y 
class(x + y)

x <- c(17, 14, 4, 5, 13, 12, 10)
x[x > 10] == 4 #incorrect
x
x[x >= 10] <- 4 #incorrect
x
x[x > 10] <- 4 #correct
x
x[x == 10] <- 4 #incorrect
x
x[x == 4] > 10 #incorrect
x
x[x > 4] <- 10 #incorrect
x
x[x >= 11] <- 4 #correct
x
x[x < 10] <- 4 #incorrect
x


x <- c(3, 5, 1, 10, 12, 6)

x[x >= 6] <- 0 #incorrect
x
x[x == 0] < 6) #incorrect
x
x[x <= 5] <- 0 #correct
x
x[x > 6] <- 0 #incorrect
x
x[x < 6] == 0 #incorrect
x
x[x != 6] <- 0 #incorrect
x
x[x == 0] <- 6 #incorrect
x
x[x > 0] <- 6 #incorrect
x
x[x == 6] <- 0 #incorrect
x
x[x < 6] <- 0 #correct
x
x[x %in% 1:5] <- 0 #correct
x

