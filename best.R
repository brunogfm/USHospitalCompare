## This function take two arguments: abbreviated name of a state and an outcome name. 
## The function reads the outcome-of-care-measures.csv file and returns a character vector 
## with the name of the hospital that has the best (i.e. lowest) 30-day mortality for the 
## specified outcome in that state. 

## outcome-of-care-measures.csv datset come from the Hospital Compare web site 
## (http://hospitalcompare.hhs.gov) run by the U.S. Department of Health and Human Services. 
## The purpose of the web site is to provide data and information about the quality of care 
## at over 4,000 Medicare-certified hospitals in the U.S. This dataset es- sentially covers 
## all major U.S. hospitals

best <- function(state = NULL, outcome = NULL) {

    ## Read outcome data
    data <-loadData("outcome-of-care-measures.csv")
    
    ## Load and create state and outcome data
    data_state <- buildStateData(data)
    
    ## Create outcome data with the fields from the lowest 30-day mortality 
    data_outcome <- buildOutcomeData(c(13, 19, 25))
    
    ## Check if state are not Null and if is valid
    validateState(state, data_state)
    
    ## Check if outcome are not Null and if is valid
    validateOutcome(outcome, data_outcome)
    
    ## Return hospital name in that state with lowest 30-day death
    data_outcome_state <- getSubSetOfDataByState(data, data_outcome, outcome, state)
    
    ## rate    
    data_outcome_state <- data_outcome_state[order(data_outcome_state[,2]),]

    ## Print
    data_outcome_state_names <- data_outcome_state[1]
    names(data_outcome_state_names) <- NULL
    print(head(data_outcome_state_names,1))
        
} 


## Load and create a data frame from a CVS file
loadData <- function(datafile) {
    
    data <- read.csv(datafile, colClasses = "character")
    data <- data[complete.cases(data), ]

}
    
## Load and create state data frame from outcome data frame
buildStateData <- function(data) {

    data_state <- data["State"]
    data_state <- data_state[!duplicated(data_state), ]    
    
}

## Create Outcome data frame 
buildOutcomeData <- function(fields) {

    data_outcome <- matrix(fields, nrow =  1, dimnames = list(c("value"), c("heart attack", "heart failure", "pneumonia")))
    
}

## Check if state are not Null and if is valid
validateState <- function(state, data_state) {
    
    ## Check that state are not Null
    if (is.null(state)) {
        stop("invalid state")
    }
    
    ## Check that state are valid
    flag_state <- FALSE
    for (ch in as.character(data_state)) { 
        if (ch == state) {
            flag_state <- TRUE    
        }
    }
    
    if (!flag_state) {
        stop("invalid state")
    }
}

## Check if Outcome are not Null and if is valid
validateOutcome <- function(outcome, data_outcome) {
    
    ## Check if outcome are not Null
    if (is.null(outcome)) {
        stop("invalid outcome")
    }
    
    ## Check if outcome are valid
    flag_outcome <- FALSE
    for (ch in as.character(colnames(data_outcome))) { 
        if (ch == outcome) {
            flag_outcome <- TRUE    
        }
    }
    
    if (!flag_outcome) {
        stop("invalid outcome")
    }
    
    
}

## Return hospital name in that state base on outcome fields
getSubSetOfDataByState <- function(data, data_outcome, outcome, state) {
    
    data[, data_outcome[,outcome]] <- as.numeric(data[, data_outcome[,outcome]])
    data_outcome_state <- subset(data, State == state)
    data_outcome_state <- data.frame(data_outcome_state[, 2], data_outcome_state[, data_outcome[,outcome]])
    data_outcome_state <- data_outcome_state[complete.cases(data_outcome_state), ]

}
