## This function takes three arguments: the 2-character abbreviated name of a state (state), 
## an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
## The function reads the outcome-of-care-measures.csv file and returns a character vector 
## with the name of the hospital that has the ranking specified by the num argument.

## outcome-of-care-measures.csv datset come from the Hospital Compare web site 
## (http://hospitalcompare.hhs.gov) run by the U.S. Department of Health and Human Services. 
## The purpose of the web site is to provide data and information about the quality of care 
## at over 4,000 Medicare-certified hospitals in the U.S. This dataset es- sentially covers 
## all major U.S. hospitals

rankhospital <- function(state, outcome, num = "best") {  
    
    ## Read outcome data
    data <-loadData("outcome-of-care-measures.csv")
    
    ## Load and create state and outcome data
    data_state <- buildStateData(data)
    
    ## Create outcome data with the fields from the 30-day death rate  
    data_outcome <- buildOutcomeData(c(11, 17, 23))    
    
    ## Check if state are not Null and if is valid
    validateState(state, data_state)
    
    ## Check if outcome are not Null and if is valid
    validateOutcome(outcome, data_outcome)
    
    ## Return hospital name in that state with the given rank
    data_outcome_state <- getSubSetOfDataByState(data, data_outcome, outcome, state)
    
    ## rate    
    data_outcome_state <- data_outcome_state[order(data_outcome_state[,2],data_outcome_state[,1]),]
    
    ## Print
    data_outcome_state_names <- data_outcome_state[1]
    names(data_outcome_state_names) <- NULL
    
    if (num == "best") {
        num <- 1 
        return(data_outcome_state_names[num,1])
        
    }
    if (num == "worst") {
        worst <- nrow(data_outcome_state_names)
        return(data_outcome_state_names[worst,1])
        
    }else{
        return(data_outcome_state_names[num,1])
        
    }
    
    
}
