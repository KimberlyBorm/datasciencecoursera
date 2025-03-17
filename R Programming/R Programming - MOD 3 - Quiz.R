library(datasets)
data(iris)
?iris
str(iris)
#There will be an object called 'iris' in your workspace. In this dataset, what is the
#mean of 'Sepal.Length' for the species virginica? 
tapply(iris$Sepal.Length, iris$Species, summary)
#Continuing with the 'iris' dataset from the previous Question, what R code returns a vector of the 
#means of the variables 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'?
apply(iris[1:4], 2, mean)


library(datasets)
data(mtcars)
?mtcars
#How can one calculate the average miles per gallon (mpg) by number of cylinders in the car (cyl)? Select all that apply.
mean(mtcars$mpg, mtcars$cyl)
lapply(mtcars, mean)
apply(mtcars, 2, mean)
split(mtcars, mtcars$cyl)
with(mtcars, tapply(mpg, cyl, mean))                    #CORRECT
sapply(split(mtcars$mpg, mtcars$cyl), mean)             #CORRECT
sapply(mtcars, cyl, mean)
tapply(mtcars$mpg, mtcars$cyl, mean)                    #CORRECT
tapply(mtcars$cyl, mtcars$mpg, mean)
#Continuing with the 'mtcars' dataset from the previous Question, what is the absolute difference between the 
#average horsepower of 4-cylinder cars and the average horsepower of 8-cylinder cars?
mean_hp_by_cly <- tapply(mtcars$hp, mtcars$cyl, mean)
abs_diff <- abs(mean_hp_by_cly[4] - mean_hp_by_cly[8])
abs_diff

debug(ls)
ls()
