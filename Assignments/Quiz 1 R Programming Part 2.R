#load and name dataset
library(readr)
hw1 <- read_csv("hw1_data copy.csv")

#view dataset
View(hw1)

#number of rows and columns
nrow(hw1)
ncol(hw1)

#names of objects
names(hw1)

#view first 2 lines of dataset
head(hw1, 2)

#view last two row of dataset
tail(hw1, 2)

#view structure of dataset
str(hw1)

#view a specific row
hw1[45:47, ] # rows 45-47
hw1[47, ]    # row 47

#view row 47, column Ozone
hw1[47,1]

#find the location of the missing values in Ozone 
which(is.na(hw1$Ozone))

#count the missing values in Ozone
sum(is.na(hw1$Ozone))

#explore variables in our dataset (NA for all)
min(hw1$Ozone)
max(hw1$Ozone)
range(hw1$Ozone)

#take mean of Ozone with  NA removed
meanOzone <- mean(hw1$Ozone, na.rm = TRUE) 
print(meanOzone)

#extract the subset of rows of the data frame where Ozone values are above 31 and Temp values are above 90
subset_hw1 <- hw1[hw1[, 1] > 31 & hw1[, 4] > 90, ] 
print(subset_hw1)

#find mean of Solar.R in this subset
meanSolarsubset <- mean(subset_hw1$Solar.R, na.rm = TRUE) 
print(meanSolarsubset)

#split month variable 
smonth <- split(hw1, hw1$Month)
str(smonth)

#find the mean of "Temp" when "Month" is equal to 6
month6 <- hw1[hw1$Month == 6, ]
print(month6)
meanTemp <- mean(month6$Temp, na.rm = TRUE) 
print(meanTemp)

#find maximum ozone value in the month of May(month=5)

month5 <- hw1[hw1$Month ==5, ]
print(month5)
maxOzone <- max(month5$Ozone, na.rm = TRUE)
print(maxOzone)
