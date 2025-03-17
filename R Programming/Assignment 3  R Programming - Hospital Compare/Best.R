best <- function(state, outcome) {
      ## Read outcome data
      outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
     
       ## Check that state and outcome are valid
      
      ## Define valid outcomes and corresponding column names
      outcome_map <- list(
          'heart attack' = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
          'heart failure' = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
          'pneumonia' = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
      )
      ## Check validity of state
      if (!(state %in% outcome_data$State)) {
         stop("invalid state")
      }
      ##check validity of outcomes
      if (!(outcome %in% names(outcome_map))) {
         stop("invalid outcome. choose: 'heart attack', 'heart failure', 'pneumonia'.")
      }
      ## Return hospital name in that state with lowest 30-day death
      
      # identify the correct column 
      outcome_col <- outcome_map[[outcome]]
      
      #filter of state and remove rows with NA
      state_data <- outcome_data[outcome_data$State == state & outcome_data[[outcome_col]] != "Not Available", ]
      #error if no data avalible in the state
      if (nrow(state_data) == 0) {
        stop("No data available for this state.")
      }
      #convert data to numeric
      state_data[[outcome_col]] <- as.numeric(state_data[[outcome_col]])
      #hospital with lower rate
      min_value <- min(state_data[[outcome_col]], na.rm = TRUE)
      best_hospitals <- state_data[state_data[[outcome_col]] == min_value, "Hospital.Name"]
      # Sort hospital names alphabetically in case of ties
      best_hospital <- sort(best_hospitals)[1]
      
  return(best_hospital)
      }
