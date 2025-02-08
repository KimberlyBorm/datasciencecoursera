
list.files()                                                      #List all the files in your working directory 
getwd()                                                           #get file path to working
                                                                  #set working directory
File_Path <- "/Users/kbormann/Desktop/Git Hub/DataSceinceCoursera
/Assignment 1 - R/Programming Assignment 1 - Air Pollution/specdata"
setwd(File_Path)

#Create one dataframe from multiple CVS files (*not neccessary for this assignment but good to know)
library("dplyr")                                                  # Load dplyr package
library("plyr")                                                   # Load plyr package
library("readr")                                                  # Load readr package

temp = list.files(pattern="\\.csv$")                              #lists all files in the wd that end with .csv and store as temp
myfiles = lapply(temp, read.delim)                                ##load multiple tab-delimited(reads columns) files into R as a list of data frames
combined_data <- do.call(rbind, myfiles)                          #binds all rows of 'myfile' to create one dataset called 'combined_data'

colnames(combined_data)                                           #ask column names

# function to find the mean of pollutants from specific monitors, ignoring NAs
pollutantmean <- function(directory, pollutant, id = 1:332) {
                                                                        # Ensure the directory path is correct
        if (!file.exists(directory)) {
          stop("Directory does not exist.")
        }
                                                                         # Create a list of file paths based on the specified IDs
        file_paths <- list.files(directory, full.names = TRUE)[id]
                                                                        # Initialize an empty vector to store the pollutant values
      pollutant_values <- numeric()
                                                                        # Loop through the specified files and read data
      for (file in file_paths) {
        data <- read.csv(file)
                                                                        # Extract the pollutant column and ignore NAs
        if (pollutant %in% colnames(data)) {
          pollutant_values <- c(pollutant_values, data[[pollutant]])
        } else {
          stop("Pollutant not found in the data.")
        }
      }
                                                                            # Calculate and return the mean, ignoring NAs
      mean(pollutant_values, na.rm = TRUE)
}

#function reports numberof completely observed cases in each data file
complete <- function(directory, id = 1:332) {
      if (!file.exists(directory)) {
      stop("Directory does not exist.")
   }
    file_path <- list.files(directory, full.names = TRUE)[id]
    results <- data.frame(id = integer(), nobs = integer())
    for (i in seq_along(file_path)) {
      data <- read.csv(file_path[i])
      n_complete <- sum(complete.cases(data))
      results <- rbind(results, data.frame(id = id[i], nobs = n_complete))
    }
    return(results)
}

#function that calculates the correlation between sulfate and nitrate for a set value of complete cases
corr <- function(directory, threshold = 0) {
  if (!file.exists(directory)) {
     stop("Directory does not exist.")
  }
  file_path <- list.files(directory, full.names = TRUE)
  correlations <- numeric()
  for (file in file_path) {
     data <- read.csv(file)
     n_complete <- sum(complete.cases(data))
   
     if (n_complete > threshold) {
      complete_data <- data[complete.cases(data), ]
      
      if ("sulfate" %in% colnames(complete_data) && "nitrate" %in% colnames(complete_data)) {
        corr_value <- cor(complete_data$sulfate, complete_data$nitrate)
        correlations <- c(correlations, corr_value)
      }
    }
  }
  return(correlations)
}


#for quiz 
RNGversion("3.5.1")  
set.seed(42)
cc <- complete("specdata", 332:1)
use <- sample(332, 10)
print(cc[use, "nobs"])

cr <- corr("specdata")                
cr <- sort(cr)   
RNGversion("3.5.1")
set.seed(868)                
out <- round(cr[sample(length(cr), 5)], 4)
print(out)

cr <- corr("specdata", 129)                
cr <- sort(cr)                
n <- length(cr)    
RNGversion("3.5.1")
set.seed(197)                
out <- c(n, round(cr[sample(n, 5)], 4))
print(out)

cr <- corr("specdata", 2000)                
n <- length(cr)                
cr <- corr("specdata", 1000)                
cr <- sort(cr)
print(c(n, round(cr, 4)))
get
