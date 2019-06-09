
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
