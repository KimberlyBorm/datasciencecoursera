#rankall that takes two arguments: an outcome name (outcome) and a hospital ranking (num). The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame
#containing the hospital in each state that has the ranking specified in num. For example the function call
#rankall("heart attack", "best") would return a data frame containing the names of the hospitals that
#are the best in their respective states for 30-day heart attack death rates. The function should return a value
#for every state (some may be NA). The first column in the data frame is named hospital, which contains
#the hospital name, and the second column is named state, which contains the 2-character abbreviation for
#the state name. Hospitals that do not have data on a particular outcome should be excluded from the set of
#hospitals when deciding the rankings.
#Handling ties. The rankall function should handle ties in the 30-day mortality rates in the same way
#that the rankhospital function handles ties.

#The function should check the validity of its arguments. If an invalid outcome value is passed to rankall,
#the function should throw an error via the stop function with the exact message “invalid outcome”. The num
#variable can take values “best”, “worst”, or an integer indicating the ranking (smaller numbers are better).
#If the number given by num is larger than the number of hospitals in that state, then the function should
#return NA.


rankall <- function(outcome, num = "best") {
      ## Read outcome data
      outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
      
      ## Check that state and outcome are valid
      # Define valid outcomes and corresponding column names
      outcome_map <- list(
          'heart attack' = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
          'heart failure' = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
          'pneumonia' = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
      )
      #check outcome if valid
        if (!(outcome %in% names(outcome_map))) {
          stop("invalid outcome")
        }
     
      ## For each state, find the hospital of the given rank
      #identify column that matches outcome
      outcome_col <- outcome_map[[outcome]]
      #separate correct column and remove NAs
      outcome_data <- outcome_data[outcome_data[[outcome_col]] != "Not Available", ]
      #rewrite data as numeric
      outcome_data[[outcome_col]] <- as.numeric(outcome_data[[outcome_col]])
      #extract state info and loop through each state only once
      states <- unique(outcome_data$State)
      #sort alphabetically
      states <- sort(states)
    
      ## Return a data frame with the hospital names and the (abbreviated) state name
      #initialize data frame to store data and set as characters
      result <- data.frame(hospital = character(), state = character(), stringsAsFactors = FALSE)
      #loop through each state
      for(state in states) {
        #filter for specific state
        state_data <- outcome_data[outcome_data$State == state, ]
        #order the data by outcome and alphabetically
         ordered_data <- state_data[order(state_data[[outcome_col]], state_data$Hospital.Name), ]
         
         ##Determine the hospital for the requested rank
         if(num == "best"){
           hospital_name <- ordered_data$Hospital.Name[1]
         }
           else if(num == "worst") {
            hospital_name <- ordered_data$Hospital.Name[nrow(ordered_data)]
           }
         else if(is.numeric(as.numeric(num)) && as.numeric(num) > 0 && as.numeric(num) <= nrow(ordered_data)) {
           hospital_name <- ordered_data$Hospital.Name[as.numeric(num)]
           }
         else {
             hospital_name <- NA
         }
         #add results to the data frame
         result <- rbind(result, data.frame(hospital = hospital_name, state = state, stringsAsFactors = FALSE))
      }
    return(result)
}
        