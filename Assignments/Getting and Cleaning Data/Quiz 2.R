
#QUESTION 1 (When was the data charing repo created?)

##Initializing an Application and Getting data from API
library(httr)
#Find OAuth settings for github (http://developer.github.com/v3/oauth/)
oauth_endpoints("github")
#Save your own authoization setting 
myapp <- oauth_app("github",
                   key = "Ov23lid7SLWkPWEcw1gp",
                   secret = "8764c24f1534b21cede06541722de78170e5f864")
#Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
# Use API
gtoken <- config(token = github_token)

##API request for the 'datasharing' repository
req <- GET("https://api.github.com/repos/jtleek/datasharing", gtoken)
# Check if the request was successful
stop_for_status(req)
# Extract and parse JSON content
repo_data <- content(req, as = "parsed", type = "application/json")
# View available fields
names(repo_data)

#Extract the Repository Creation Time
repo_data$created_at
#______________________________________

#QUESTION 2
##Use SQL to read and write dataframes

#Dowload the file normally
URL <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
destfile <- "American Community Survey.csv"
download.file(URL, destfile = destfile, method = "curl")
list.files()
local_file <- read.csv(destfile)
##*First you must install MySQL on your personal computer before you can proceed*
##install and launch SQL
install.packages("RMySQL")
library(RMySQL)
# Establish a connection
con <- dbConnect(MySQL(),
                 user = "root",
                 password = "",  # If Step 1 worked without a password, leave this empty
                 dbname = "my_database",  # Replace with your actual database name
                 host = "localhost")
#check connection is successful
dbListTables(con)
##send perviously downloaded file to MySQL
dbWriteTable(con, "acs", local_file, row.names = FALSE, overwrite = TRUE)
#run a simple query to check everything works
result <- dbGetQuery(con, "SELECT * FROM acs")
print(result)
#disconnect
dbDisconnect(con)

#QUESTION 2 (WHAT SQLDF CODE DOES THE SAME AS THE dbGet Query below?)
##use R image to answer questions 
query <- "SELECT AGEP, pwgtp1 FROM acs WHERE AGEP < 50"
result <- dbGetQuery(con, query)
head(result)
nrow(result)
summary(result)

##do this same thing with sqldf (sqldf not made for MYSQL so you have to force connection)
install.packages("sqldf")  # Install (only needed once)
library(sqldf)  # Load the package
#sqldf was built to work on SQLite not MYSQL so you need to provide hte MYSQL connection so sqldf kows where to look
#alternitively you can install SQLite and these commands will work without forcing the connection

#Select only the data for the probability weights pwgtp1 with ages less than 50?
sqldf("select pwgtp1 from acs", connection = con)
sqldf("select pwgtp1 from acs where AGEP 50", connection = con)
sqldf("select * from acs where AGEP 50 and pwgtp1", connection = con)
sqldf("select * from acs", connection = con)
#-------------------------------------------------

#QUESTION 3 (What is the equivalent function to unique(acs$AGEP))
sqldf("select distinct AGEP from acs", connection = con)

#-------------------------------------------------

#QUESTION 4 (HTTP - OPEN SOURCE)
# Read the HTML page
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
html_lines <- readLines(url, warn = FALSE)  # Read HTML content into a vector
# Extract the 10th, 20th, 30th, and 100th lines
selected_lines <- html_lines[c(10, 20, 30, 100)]
# Count the number of characters in each selected line
char_counts <- nchar(selected_lines)
# Print results
print(char_counts)
#-----------------------------------------------

#QUESTION 5 (FWF - FIXED WIDTH FILE)
# Define the file URL
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
#Download the file
download.file(file_url, destfile = "wksst8110.for", method = "curl")
# View first 20 lines of the file
readLines("wksst8110.for", n = 20)   #can see first 4 rows are headers

#DETERMINE COLUMN WIDTH
# Read first data row n=5, since 1:4 is header
raw_line <- readLines("wksst8110.for", n = 5)[5]
print(raw_line)

#count charaters
# Read first few lines of raw data (excluding headers)
raw_lines <- readLines("wksst8110.for", n = 10)
# Count number of characters in each row
char_counts <- nchar(raw_lines)
# Print results
print(char_counts) #[1] 49  0 61 62 62 62 62 62 62 62

#out the data in a more readablr format
raw_lines <- readLines("wksst8110.for", n = 10)
cat(paste(raw_lines, collapse = "\n"))    #this still didn;t help me with the spacing 

# Print each character in the row with its position and deliniate by hand
for (i in 1:nchar(raw_lines[5])) {
  cat(i, ":", substr(raw_lines[5], i, i), "\n")
}

# Read fixed-width file with adjusted column widths
data <- read.fwf("wksst8110.for", 
                 widths = c(12, 6, 6, 8, 5, 8, 5, 8, 4), 
                 skip = 4)  # Skip header rows
# View first few rows
head(data)
#view just row 4
print(data[, 4])

# Sum the numbers in the 4th column
sum_of_fourth_column <- sum(data[, 4], na.rm = TRUE)
# Step 5: Print result
print(sum_of_fourth_column)


