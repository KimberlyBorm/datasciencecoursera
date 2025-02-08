#QUESTION 1 
#Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
#What is the value of the 123 element of the resulting list?

# Define the directory path
directory_path <- "/Users/kbormann/Desktop/Git Hub/DataSceinceCoursera/Assignments/Getting and Cleaning Data"
# Check if the directory exists; if not, create it (using recursive = TRUE if needed)
if (!dir.exists(directory_path)) {
  dir.create(directory_path, recursive = TRUE)
}
#define url and file name
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
destfile <- "American Community Survey.csv"
#download file
if (!file.exists(destfile)) {
  download.file(url, destfile = destfile, method = "curl")
} else {
  message("File already exists.")
}

#covert to R dataframe
library(readr)
housing <- read_csv(destfile)

split_names <- strsplit(colnames(housing), "wgtp") 
print(split_names)

split_names[[123]]
#-----------------------------------------------------------

#QUESTION 2

#define url and file name
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
destfile <- "Gross Domestic Product.csv"
#download file
if (!file.exists(destfile)) {
  download.file(url, destfile = destfile, method = "curl")
} else {
  message("File already exists.")
}

#covert to R dataframe
library(readr)
GDP <- read_csv(destfile)
#check names of columns
names(GDP)
head(GDP)
#clean the data bu removing commas nad turning data to numeric
library(dplyr)
gdp_clean <- GDP %>% 
  filter(!is.na(`...5`)) %>% 
  mutate(GDP_Value = as.numeric(gsub(",", "", `...5`)))
#check the column was formated correctly
head(gdp_clean)

#Subset only 190 countries because their are extra values in the column
gdp_clean <- gdp_clean %>% 
  filter(!is.na(`Gross domestic product 2012`) & `Gross domestic product 2012` != "") %>% 
  mutate(`Gross domestic product 2012` = as.numeric(`Gross domestic product 2012`)) %>%
  filter(`Gross domestic product 2012` <= 190)
##calculate Average of GGP_Value
average_GDP <- mean(gdp_clean$GDP_Value, na.rm = TRUE)
print(average_GDP)
#-----------------------------------------------------------

#QUESTION 3
#In the data set from Question 2 what is a regular expression that would allow you to count 
#the number of countries whose name begins with "United"? 
grep("^United",gdp_clean$'...4')
#-----------------------------------------------------------

#QUESTION 4
#FRom GDP and EDU data, match the data based on the country shortcode. 
#Of the countries for which the end of the fiscal year is available, how many end in June?

#Match column names before combining the dataframes
colnames(EDU)

#changecolnames for clean_GDP
gdp_clean <- gdp_clean %>%
  rename(CountryCode = '...1',
         Rank = 'Gross domestic product 2012',
         CountryName = '...4',
         GDP = '...5')
#check results
colnames(gdp_clean)
#Merge dataframes by CountryCode
mergded_edu_gdp <- merge(gdp_clean, EDU, by = "CountryCode", all = FALSE)
#how many countries fiscial years end in June(in 'Special Notes, )
num_june <- length(grep("June", mergded_edu_gdp$'Special Notes', ignore.case = TRUE))
print(num_june)
#-----------------------------------------------------------

#QUESTION 5
#How many values were collected in 2012? How many values were collected on Mondays in 2012?
#get data
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
#count entries in 2012
library(lubridate)
num_2012 <- grep("^2012", sampleTimes)
print(num_2012)
length(num_2012)

# seperate only entries from 2012
only_2012 <- sampleTimes[1261:1510]
print(only_2012)     
#convert dates to weekdays
days <- wday(only_2012)

# count 2s for monday
num_mon <- length(grep("2", days))
print(num_mon)

