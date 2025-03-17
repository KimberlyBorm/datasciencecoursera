#NOTES FROM COURSERA VIDEO ON FUNCTIONS

#CREATING A SIMPLE FUNCTION
add2 <- function(x, y) {
  x + y
}
add2(3,5)

#next one!
above 10 <- function(x) {
  use <- x > 10
  x[use]
}

#and another... 
above <- function(x, n) {
  use <- x > n
  x[use]
}
x <- 1:20
above(x, 12)

#now the last one set a default n if hte user does not specify
above <- function(x, n= 10) {
  use <- x > n
  x[use]
}
above(x)
above(x, 12)

#MORE DIFFICULT FUNCTION WITH for() loop
#calcute the means of each column
columnmean <- function(y) {
  nc <- ncol(y)
  means <- numeric(nc)
  for(i in 1:nc) {
    means[i] <- mean(y[1, i])
  }
  means
}
columnmean(airquality)

#same function with NA removed
columnmean <- function(y, removeNA = TRUE) {
  nc <- ncol(y)
  means <- numeric(nc)
  for(i in 1:nc) {
    means[i] <- mean(y[1, i], na.rm = removeNA)
  }
  means
}
columnmean(airquality)
---------------------------------

#LESSON 9 -FUNCTIONS
  
#Step 1: write function 
boring_function <- function(x) {
     x
}
#Step 2: Save function 

#you can see hte source code by typing the in function name
boring_function
#function to calculate mean 
my_mean <- function(x){
  sum(x) / length(x)
}
#create a default arguement for the functionnremained(%%) where an unnamed divisor yield 2
remainder <- function(num, divisor = 2) {
  num%%divisor
}
#check a function for its agruements using hte function args(). *Yes, you can pass a function through another function
args(remainder)
#Write a function that preforms an input function on an vector input
evaluate <- function(func, dat){
  func(dat)
}

#write a function that adds one to an input using an 'anonymous function"
evaluate(function(x){x+1}, 6)
#write a function that returns the first variable of a vector to an input using an 'anonymous function"
evaluate(function(x){x[1]}, c(8, 4, 0))
#write a function that returns the last variable of a vector to an input using an 'anonymous function"
evaluate(function(x){x[length(x)]}, c(8, 4, 0))

#WORKING WITH ...
#use paste() but modify it to begin the START and end with STOP
telegram <- function(...){
     paste("START", ..., "STOP")
}
#create a MadLib using paste() and ...
mad_libs <- function(place, adjective, noun){
  paste("News from", place, "today where", adjective, "students took to the streets in protest of the new", noun, "being installed on campus.")
}
#use Mad_libs function 
mad_libs("woods", "anrgy", "bear")
#create a binary operator to create 'Good Job!' when "Good" %p% "job!" is typed
"%p%" <- function(left, right){ # Remember to add arguments!
  paste(left, right, sep = " ")
}
---------------------------------
  
#LESSON 10 - DATES AND TIMES 
  
Sys.Date() #show current date
Sys.time() #show current time
class() #confirm as date object
unclass() #see object internally
str(unclass("")) #have a more conpact view of unclass information
"time"$"min,sec. ect." # view ONLY min or sec, or ect. 

as.Date() #corerce date
as.POSIXlt(Sys.time()) #turn time from POSIXct to POSIXlt 

weekdays(d1) #show day of the week for a date or time 
months() #shows month
quarters() #show quarter

#convert a date/time in hte wrong format to POSIXlt class
t3 <- "October 17, 1986 08:24" 
strptime(t3, "%B %d, %Y %H:%M")

#you can complete operation on time data. Examples below
Sys.time() > t1
Sys.time() - t1
#request specific units of a time difference (Example days)
difftime(Sys.time(), t1, units = 'days')

#the lubridate package by Hadley Wickham is good if you need to work with a lot of dates and times