#QUESTION 1 
#Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products.
#Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify 
#the rows of the data frame where the logical vector is TRUE. 

which(agricultureLogical) 

What are the first 3 values that result?
#load packages
library(dplyr)
library(readr)

#download file and check
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dest_file <- "American Community Survey.csv"
download.file(fileURL, destfile = dest_file, method = "curl")
file.exists(dest_file) 
list.files("/Users/kbormann/Desktop/Git Hub/DataSceinceCoursera/Assignments/Getting and Cleaning Data")

#load csv and turn into tb
housing_data <- read_csv(dest_file) %>%
  as_tibble

#create a logical vector agricultureLogical that identifies the households 
#on greater than 10 acres (ACR = 3) who sold more than $10,000 worth of agriculture products (AGS = 6)
housing_data <- housing_data %>%
  mutate(agricultureLogical = ACR == 3 & AGS == 6) %>%
  #verify
  glimpse

#verify
colnames(housing_data) 

## Find row indices where condition is TRUE
find_rows <- which(housing_data$agricultureLogical) %>%
  print
#---------------------------------------------------------------------

#QUESTION 2
#Using the jpeg package read in the following picture of your instructor into R: https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
#Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data?

#Download file
library(jpeg)
image_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
destfile <- "Jeff Image.jpg" 
download.file(image_URL, destfile, mode = "wb")
file.exists(destfile)
img_data <- readJPEG(destfile, native = TRUE)

#Compute quantiles
QT <- quantile(img_data, probs = c(0.3, 0.8))
print(QT)
#---------------------------------------------------------------------

#QUESTION 3
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Load the educational data from this data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
#Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?
  
#Load required libraries
library(readr)
library(dplyr)
#recreatable download on file 1 and create R image
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
destfile1 <- "Gross Domestic Product.csv"
if (!file.exists(destfile1)) {
  download.file(url1, destfile1, method = "curl")
}
GDP <- read_csv(destfile1) %>%
  print

#There are many empty columns in GDP and this is messy. I'm going to clean up GDP before loadingthe next csv file
#fix column name issue in GDP 
GDP <- read_csv(destfile1, skip = 4, col_names = TRUE) %>%
  print
#Remove empty columns by index and rows with all NAs
GDP <- GDP %>%
  select(-c(3, 6:10))  %>%
  filter(!if_all(everything(), is.na)) %>% 
  print

#rename columns correctly
GDP <- GDP %>%
  rename(
    CountryCode = `...1`,
    Ranking = `...2`,
    Economy = `...4`,
    GDP_Value = `...5`, 
  )
#remove last 4 rows
GDP <- GDP %>%
  slice(-c(229:232)) %>%  # Remove rows 229 to 232
  print()

#now with a cleaner GDP dataframe I can load EDU dataframe
#recreatable download on file 1 and create R image
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
destfile2 <- "educational data.csv"
if (!file.exists(destfile2)) {
  download.file(url2, destfile2, method = "curl")
}
EDU <- read_csv(destfile2) %>%
  print


#Merge dataframes by CountryCode
#using R code
Rcode_data <- merge(GDP, EDU, by = "CountryCode", all = FALSE)
#using dplyr method 1
dplyrM1_data <- inner_join(GDP, EDU, by = "CountryCode")  # Keeps only matching rows
#using dplyr method 2
dplyrM2_data <- semi_join(GDP, EDU, by = "CountryCode")  # Keeps only GDP rows that match EDU

# Convert Ranking to numeric
Rcode_data <- Rcode_data %>%
  mutate(Ranking = as.numeric(Ranking))  # Convert column to numeric

#Sort in decending order by rank
sorted_data <- Rcode_data %>%
  arrange(desc(Ranking))
          
#---------------------------------------------------------------------

#QUESTION 4

# Compute the average GDP ranking for each income group
average_rankings <- sorted_data %>%
  filter(`Income Group` %in% c("High income: OECD", "High income: nonOECD")) %>%
  group_by(`Income Group`) %>%
  summarize(Average_Rank = mean(Ranking, na.rm = TRUE))

print(average_rankings)
#---------------------------------------------------------------------

#QUESTION 5
#Cut the GDP ranking into 5 separate quantile groups. 
#Make a table versus Income.Group. 
#How many countries are Lower middle income but among the 38 nations with highest GDP?

#Cut the GDP ranking into 5 separate quantile groups. 
library(dplyr)

# Add a new column for GDP quantile groups
sorted_data <- sorted_data %>%
  mutate(GDP_Quantile = ntile(Ranking, 5))  # Divides into 5 groups
#Make a table versus Income.Group. 
table(sorted_data$GDP_Quantile, sorted_data$`Income Group`)
#filter for countries in lower middle income and dighest GDP
top_38 <- sorted_data %>%
  filter(Ranking <= 38 & `Income Group` == "Lower middle income") %>%
  count()

print(top_38)



colcolUse the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? (some Linux systems may produce an answer 638 different for the 30th quantile)