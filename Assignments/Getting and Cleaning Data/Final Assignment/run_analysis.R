# Task 1) Merges the training and the test sets to create one data set.
## Also, Task 3)  because it seems like a natural addition to combining the data with the below function

#define url and file name for download
library(readr)
library(tidyverse)
library(dplyr)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "Final Assignment Data.zip"
#download if does not exist 
if (!file.exists(destfile)) {
    download.file(url, destfile = destfile, mode = "wb")
}else {
    message("file already exists")
}
#unzip folder and name
unzip(destfile, exdir = "Final Assignment Data")
#Function to read data baseed on filestructure and READMe for test and train files
read_data <- function(type){
    #folder path in base directory to merge multiple files
    folder_path <- file.path("Final Assignment Data", "UCI HAR Dataset", type)
    #build folder paths for three files we need to combine
    subject_file <- file.path(folder_path, paste0("subject_", type, ".txt"))
    activity_file <- file.path(folder_path, paste0("y_", type, ".txt"))
    data_file <- file.path(folder_path,paste0("X_", type, ".txt"))
    #Read files using read_table2 (b/c data separated by whitespace) 
    #(also, readr:: not necessary but useful for later readability/clarity and good practice for avoiding namespace conflict)
    subject <- readr::read_table2(subject_file, col_names = "subject")
    activity <- readr::read_table2(activity_file, col_names = "activity")
    data <- readr::read_table2(data_file, col_names = FALSE)
    # Coerce all data columns to numeric to prevent issues in future
    data <- data %>% 
        mutate(across(everything(), as.numeric))
    #combine data frames by columns
    combined_data <- dplyr::bind_cols(subject, activity, data)
    #Read activity labels file for easy of readability 
    activity_labels <- readr::read_table(file.path("Final Assignment Data", "UCI HAR Dataset", "activity_labels.txt"), 
                                         col_names = c("activity", "activity_name"))
    #merge and relocate activity names column so activity name follow activity
    combined_data <- combined_data %>% 
        dplyr::left_join(activity_labels, by = "activity") %>% 
        dplyr::relocate(activity_name, .after = activity)
    
    return(combined_data)
}
#run function on test and train to create two merged data frames
train_data <- read_data("train")
test_data <- read_data("test")
#Combine test and train data into one dataset
full_data <- dplyr::bind_rows(train_data,test_data)
readr::write_csv(full_data, "combined_dataset.csv")
#check data 
head(full_data)

# Task 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

# Task 3) Uses descriptive activity names to name the activities in the data set

# Task 4) Appropriately labels the data set with descriptive variable names. 

# Task 4) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.