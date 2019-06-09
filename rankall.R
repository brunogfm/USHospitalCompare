## This function takes two arguments: an outcome name (outcome) and a hospital rank- ing (num). 
## The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame 
## containing the hospital in each state that has the ranking specified in num. 

## outcome-of-care-measures.csv datset come from the Hospital Compare web site 
## (http://hospitalcompare.hhs.gov) run by the U.S. Department of Health and Human Services. 
## The purpose of the web site is to provide data and information about the quality of care 
## at over 4,000 Medicare-certified hospitals in the U.S. This dataset es- sentially covers 
## all major U.S. hospitals

rankall <- function(outcome, num = "best") {
    
    ## Read outcome data
    data <-loadData("outcome-of-care-measures.csv")
    
    ## Load and create state and outcome data
    data_state <- buildStateData(data)
    
    ## Create outcome data with the fields from the 30-day death rate  
    data_outcome <- buildOutcomeData(c(11, 17, 23))    
    
    ## Check if outcome are not Null and if is valid
    validateOutcome(outcome, data_outcome)
    
    ## Return hospital name in that state with the given rank
    data_outcome_state <- getSubSetOfDataByOutcome(data, data_outcome, outcome)

    
    ## For each state, find the hospital of the given rank
    data_outcome_state <- getSubSetOfDataByState(data_outcome_state, data_state, num)

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

## Return hospital name in that state with the given rank
getSubSetOfDataByOutcome <- function(data, data_outcome, outcome) {
    
    data[, data_outcome[,outcome]] <- as.numeric(data[, data_outcome[,outcome]])
    data_outcome_hospital <- data.frame(data[, 2], data[, 7], data[, data_outcome[,outcome]])
    names(data_outcome_hospital) <- c("Hospital","State", "Rate")
    return(data_outcome_hospital)
       
}

## For each state, find the hospital of the given rank
## Return a data frame with the hospital names and the
## (abbreviated) state name
getSubSetOfDataByState <- function(data_outcome_state, data_state, num) {
    
    data_allState_Rank <- data.frame()
    data_rank_state <- data.frame("Hospital" = NA, "State" = NA,  "Rate" = NA,  "Rank" = NA)
    
    for (ch in as.character(data_state)) { 
        
        data_rank_state <- subset(data_outcome_state, State == ch)
        
        #Sort date for rank creation
        data_rank_subset <- data_rank_state[order(data_rank_state$Rate, data_rank_state$Hospital),]

        data_rank <- cbind(data_rank_subset,Rank=c(1:nrow(data_rank_subset)))
    
        # Check eligibility options of ranking num
        if(num == "best") {
            num <- 1
            data_allState_Rank <- rbind(data_allState_Rank,data_rank[num,])
        }
        if(num == "worst"){ 
            last_data_rank <- data_rank[complete.cases(data_rank), ]
            rownum <- nrow(last_data_rank)
            data_allState_Rank <- rbind(data_allState_Rank,data_rank[rownum,])
            next()
            
        }
            
        if (is.na(data_rank[num,])) { 
            data_allState_Rank <- rbind(data_allState_Rank,c(NA,ch,NA,num))
        }
        else{
            data_allState_Rank <- rbind(data_allState_Rank,data_rank[num,])
        }
        
    }
    
    data_allState_Rank <- data_allState_Rank[order(data_allState_Rank$State),]
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    data_allState_Rank_print <- data_allState_Rank[c("Hospital", "State")]
    
}



