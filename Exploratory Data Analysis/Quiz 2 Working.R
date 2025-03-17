Quiz 2 - Exploratory Data Analysis 

#2
library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)

#7
library(ggplot2)
library(datasets)
data(airquality)

qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

#10
qplot(votes, rating, data = movies)
