getwd()
#open and explore the data
library(readr)
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)
ncol(outcome) 
nrow(outcome)
names(outcome) 
str(outcome)
# make a simple histogram of the 30-day death rates from heart attack
outcome[, 11] <- as.numeric(outcome[, 11])
## You may get a warning about NAs being introduced; that is okay
hist(outcome[, 11])


##test 'Best' function for accuracy 
source("best.R")
best("TX", "heart attack")
#"CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure")
#"FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")
#"JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")
#"GREATER BALTIMORE MEDICAL CENTER"
best("BB", "heart attack")
#Error in best("BB", "heart attack") : invalid state
best("NY", "hert attack")
#Error in best("NY", "hert attack") : invalid outcome

#Quiz for Assinment 3
best("SC", "heart attack")
best("NY", "pneumonia")
best("AK", "pneumonia")

##Test 'rankhospital' for accuracy
source("rankhospital.R")
rankhospital("TX", "heart failure", 4)
#"DETAR HOSPITAL NAVARRO"
rankhospital("MD", "heart attack", "worst")
#"HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000)
#NA

#Quiz 3 Questions cont. 
rankhospital("WA", "heart attack", 7)
rankhospital("TX", "pneumonia", 10)
rankhospital("NY", "heart attack", 7)

##Test for rankall
source("rankall.R")
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)

#Quiz 3 Questions cont. 
r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)

r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)

r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)


