library(swirl)
install_from_swirl("R Programming")
swirl()

------------------------
#display info below 
info() 
#Press Esc Key to exit swirl and return to the R prompt (>) 
#to exit and save your progress
bye() 
#skip question
skip()
# experiment with R on your own; swirl will ignore 
play()
#regain swirl attention 
nxt()
#main menu
main()
#help and more info 
help.start() 
----------------------------
#NOTE ON THE LESSON

LESSSON 1 - Basic Building Blocks

#create and store a vector
z <- c(1.1, 9, 3.14)

#up arrow scrolls through previous code
# tab key bring up auto-completion
-----------------------------------
LESSON 2 - Workspace and Files
#Mac and Linux work on Unix  - Learn more about Unix
#List all the objects in your local workspace 
ls()
#List all the files in your working directory 
list.files()
dir()
#examine a function with Help Page
?function

#create arcive of past directory 
old.dir <- getwd() 
#create a working directory
dir.create("testdir")
# delete directory after reseting working directory
unlink("testdir",recursive=TRUE) 
#create a file
file.create() 
#see if a file exists
file.exists("mytest.R")
#list file info 
file.info("mytest.R")
#remane file
file.rename("mytest.R", "mytest2.R")
#remove file
file.remove('mytest.R')
#copy file
file.copy("mytest2.R", "mytest3.R")

???????????????????????????
#use file.path to construct file and directory paths that are independent of the operating system your R code is running on
file.path("folder1", "folder2")
#create a drectory in working directory 
dir.create("testdir6")
#Create a directory called "testdir2" and a subdirectory for it called "testdir3"
dir.create(file.path("testdir2", "testdir3"), recursive = TRUE)pl

#reset past saved directory
setwd(old.dir)
# delete directory after reseting working directory
unlink("testdir",recursive=TRUE) 
----------------------------------------
  
LESSON 3 - Sequences of Numbers

#create a vector of ordered numbers
1:20
pi:10
seq(1, 20)
seq(0, 10, by=0.5)
#create. vetor of randon ordered numbers 5-10, name my_seq
my_seq <-seq(5, 10, length=30)
#create sequence of equal length to my_seq
1:length(my_seq)
seq(along.with = my_seq)
seq_along(my_seq)

#create vector with 40 zeros
rep(0, times = 40)
#vector to contain 10 repetitions of the vector (0, 1, 2)
rep(c(0, 1, 2), times = 10)
#vector to contain 10 zeros, then 10 ones, then 10 twos.
rep(c(0, 1, 2), each = 10)
----------------------------------------------
  
LESSON 4 - VECTORS

#atomic vector -  exactly one data type (i.e numerical)
#list - may contain multiple data types

# also have logical and character vectors

#create a numeric vector(num_vect) and set results (tf) < 1
num_vect <- c(0.5, 55, -10,  6)
tf <- num_vect < 1

#logical operators: < , > , <=, >=, == (exactly), != (inequality)
#`|` states AT LEAST ONE of the pieces is TRUE
#charater vectors are inclosed in double quotes ""
#LETTERS - a predefined variable containing a character  vector of all 26 letters

#join two vectors together
paste()
#join together the elements of the my_char character vector and separate them with single spaces
#`collapse` argument says seperate with space
paste(my_char, collapse = " " )
#'concatenate' your name to the end of my_char and title it my_name
my_name <- c(my_char, "Kimberly Bormann")

#the `sep` argument joins elements with a single space
paste("Hello", "world!", sep = " ")
-------------------------------------------
  
LESSON 5 - Missing Values
#NA is no/missing value, Nan is value does not exist (i.e = 0/0)
#a vector containing 1000 draws from a standard normal distribution
y <- rnorm(1000)
#a vector containing 1000 NAs
z <- rep(NA, 1000)
# select 100 elements at random from these 2000 values (combining y and z) 
my_data <- sample(c(y, z), 100)
#create logic function for NAs and count
my_na <- is.na(my_data)
sum(my_na)

#where the NAs are located in the data
is.na()
#vector of length "my_data with all NAs (nat desired or useful)
my_data == NA
-----------------------------------------------
  
LESSON 6  - Subsetting Vectors 

#index vector [ ] relates to position 
# first 10 imputs of x
x[1:10]
#sebset the 3rd, 5th, and 7th elements in x
x[c(3, 5, 7)]
#all elements of x except the 2nd and 10th element 
x[c(-2, -10)]
x[-c(2, 10)]

#create a vector that contains all of the non-NA values from x
y <- x[!is.na(x)]
#a vector of logical values, with TRUEs corresponding to values of y that are greater than zero 
y > 0 
#A vector of all the positive elements of y
y[y > 0]

#same results as above in one condensed line of code
x[!is.na(x) & x >0]

#create a names vector with 3 elements 
vect <- c(foo = 11, bar = 2, norf = NA)
#ask the names of the elements in vector vect
names(vect)
#create an unnameed vector and then name it
vect2 <- c(11, 2, NA)
names(vect2) <- c("foo", "bar", "norf")
#subset by vector names 
vect["bar"]
vect[c("foo", "bar")]
#check that two vectors are identical 
identical(vect, vect2)
----------------------------------------
  
LESSON 7 - Matrices and Data Frames

#give a vector dimentions to transform to a matrix
my_vector <- 1:20
dim(my_vector) <- c(4, 5)

#check dimentions of a matrix
dim(my_vector)
attributes(my_vector)
#confirm it is a matrix
class(my_vector)

#create the same matrix as above using matrix function
matrix(1:20, 4, 5)

#name the rows of the matrix(1 class) maing it a dataframe(multi-class)
patients <- c("Bill", "Gina", "Kelly", "Sean")
my_data <- data.frame(patients, my_matrix)
#(Note: cbind(patients, my_matrix) will 'implicut coercion' all charaters = BAD)
#another option that does the same thing
rownames(my_data) <- patients

#name the columns of my_data
cnames <- c("patient", "age", "weight", "bp", "rating", "test")
> colnames(my_data) <- cnames
