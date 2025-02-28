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
#Function to read data baseed on filestructure and READMe for test and train files since it needs to be completed more than once
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
#read feature file and create 2 columns for later use
features <-readr::read_table(file.path("Final Assignment Data", "UCI HAR Dataset", "features.txt"),
                             col_names = c("feature_num", "feature_name"))
#filter for mean and std in feature names to create T/F (// b/c () are special charter and we want a literal charters))
features_mean_std <- features %>%
    dplyr::filter(grepl("mean\\(\\)|std\\(\\)", feature_name))
#select indices of these features corresponding to X_ data
selected_indices <- features_mean_std$feature_num
#adjust for first 3 columns
measurement_indices <- selected_indices + 3
#subset full_data
subset_data <- full_data %>% 
    dplyr::select(subject, activity, activity_name, dplyr::all_of(measurement_indices))
#print to check results
head(subset_data)


# Task 3) Uses descriptive activity names to name the activities in the data set
#completed in Step 1 functions (see above)


# Task 4) Appropriately labels the data set with descriptive variable names. 
colnames(subset_data) [4:ncol(subset_data)] <- features_mean_std$feature_name
#print to check results
head(subset_data)


# Task 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
avg_data <- subset_data %>%
    dplyr::group_by(subject, activity, activity_name) %>%
    dplyr::summarise(across(4:66, mean), .groups = "drop")
#View new dataset
head(avg_data)
#Write average data as csv files (not required but I wanted to)
write_csv(avg_data, "averagemeanandstd_dataset.csv")
