##d rankhospital that takes three arguments: the 2-character abbreviated name of a
#state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
#The function reads the outcome-of-care-measures.csv file and returns a character vector with the name
#of the hospital that has the ranking specified by the num argument.

##The function should check the validity of its arguments. If an invalid state value is passed to rankhospital,
#the function should throw an error via the stop function with the exact message “invalid state”. If an invalid
#outcome value is passed to rankhospital, the function should throw an error via the stop function with
#the exact message “invalid outcome”.


rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  #create map for columns to be read
  outcome_map <- list(
    'heart attack' = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
    'heart failure' = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
    'pneumonia' = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  )
  ## check for valid outcome
  if(!(outcome %in% names(outcome_map))) {
    stop("invalid outcome. Choose: 'heart attack', 'heart failure', 'pneumonia'")
  }
  ## Check that state is valid
  if(!(state %in% outcome_data$State)) {
    stop("invalid state.")
  }
  
  #read the correct outcome column
  outcome_col <- outcome_map[[outcome]]
  #filter for state
  state_data <- outcome_data[outcome_data$State == state, ]
  #remove unavailable data
  state_data <- state_data[state_data[[outcome_col]] !="Not Available" & !is.na(state_data[[outcome_col]]), ]

  #if no state date
  if(nrow(state_data) == 0){
    stop("No data available for this state.")
  }
  ## Return hospital name in that state with the given rank
  #convert to numeric
  state_data[[outcome_col]] <- as.numeric(state_data[[outcome_col]])
  #order the data first by rank(ascending) then alphabetically
  ordered_data <- state_data[order(state_data[[outcome_col]], state_data$Hospital.Name), ]
  #define action based on num
  if(num == "best"){
    result <- ordered_data$Hospital.Name[1]
  }
  else if(num == "worst"){
    result <- ordered_data$Hospital.Name[nrow(ordered_data)]
  }
  else if (as.numeric(num) && num>0 && num <= nrow(ordered_data)) {
    result <- ordered_data$Hospital.Name[num]
    }
  else {
    result <-NA
  }
  ## 30-day death rate
  return(result)
}


