##download and save CSV file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "United States Communities Data.csv", method = "curl")
file.exists() 
list.files("/Users/kbormann/Desktop/Git Hub/DataSceinceCoursera/Assignments/Getting and Cleaning Data")
##Read  csv file
us_com_data <- read.csv("United States Communities Data.csv", stringsAsFactors = FALSE)
#get a sense of the data
class(us_com_data)
str(us_com_data)
head(us_com_data)       #too many calumns which i could have realized earlier
summary(us_com_data)    #way too much for this file
##use codebook to count VAL over $1,000,000 (VAl = 24)
sum(us_com_data$VAL == 24, na.rm = TRUE)
##use hte codebook to idenify what 'tidy data' principle this violates
us_com_data$FES
us_com_data[["FES"]]



##download and save Excel file and verify
excelURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
destfile <- "Natural Gas Aquisition Program.xlsx" 
download.file(excelURL, destfile = destfile , method = "curl")
file.exists(destfile) 
##Read and view an Excel File
library(readxl)
ng_data <- read_excel(destfile, sheet = 1)
head(ng_data)
##read select rows adn columns
dat <- read_xlsx(destfile, sheet = 1, range = "G18:O23")
sum(dat$Zip*dat$Ext,na.rm=T)


##Download XML file
install.packages("XML")  # Run once if not installed
library(XML)
# Define the XML file URL
xmlURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
# Define the destination filename
destfile <- "restaurants.xml"
#download file NOTE:wb, not curl
download.file(xmlURL, destfile = destfile, mode = "wb")
#verify
file.exists(destfile)
list.files("/Users/kbormann/Desktop/Git Hub/DataSceinceCoursera/Assignments/Getting and Cleaning Data")

##read and parse the file
xml_data <- xmlTreeParse(destfile, useInternalNodes = TRUE)
str(xml_data)
# Get the root node
rootNode <- xmlRoot(xml_data)
# Print the name of the root node
xmlName(rootNode)
#Extract zip coses
zip_codes <- xpathSApply(rootNode, "//zipcode", xmlValue)
head(zip_codes)
sum(zip_codes == "21231")


##Use data.table to create R object
install.packages("data.table")  # Run once if not installed
library(data.table)
DT <- fread("United States Communities Data.csv")
#we can also create the r object directly from hte link (much easier/fewersteps)
DT <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
DT <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
#verify
head(DT)        # View first few rows
dim(DT)         # Check number of rows & columns
str(DT)         # View structure of dataset
colnames(DT)    # View column names

#check run time for functions 
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(rowMeans(DT)[DT$SEX == 1]; rowMeans(DT)[DT$SEX == 2])
system.time(sapply(split(DT$pwgtp15, DT$SEX), mean))
system.time(DT[, mean(pwgtp15), by = SEX])
