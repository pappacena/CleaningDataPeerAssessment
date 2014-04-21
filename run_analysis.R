## This module has functions to do the following steps:
##  1- Concatenate the train and test sets for X variables
##  2- Remove the features that does not has "mean" or "std" in it's name
##  3- Put the activity label at the end of the resulting dataset
## The resulting dataset for this processing is easyly available by calling
##      > data <- get_dataset(UCI_dataset_directory)
## All other functions are just helpers for get_dataset


# Get the activities and it's labels
get_activities <- function(directory) {
    activities <- read.table(paste(directory, "/activity_labels.txt", sep=""))
    data.frame(row.names = activities$V1, activity=activities$V2)
}

# Get the valid features indexes
# The list of features includes only the features ended by "std()" or "mean()"
get_features <- function(directory) {
    features <- read.table(paste(directory, "/features.txt", sep=""))
    features[grep("(-mean|-std)\\(\\)$", features[, 2]), ]
}


get_dataset <- function(directory="UCI HAR Dataset") {
    activities_labels <- get_activities(directory)
    get_activity_label <- function(activity_code) {
        activities_labels[activity_code, ]
    }
    
    features <- get_features(directory)
    feature_indexes <- features[, 1]
    feature_names <- as.character(features[, 2])
    
    test_subject <- read.table(paste(directory, "/test/subject_test.txt", sep=""))
    test_x <- read.table(paste(directory, "/test/X_test.txt", sep=""))
    test_y <- read.table(paste(directory, "/test/Y_test.txt", sep=""))
    
    test_activities <- apply(test_y, 1, get_activity_label)
    full_dataset <- cbind(test_x[, feature_indexes], subject=test_subject,
                          activity_code=test_y, activity=test_activities)

    names(full_dataset) <- c(feature_names, "subject", "activity_code", "activity")
    full_dataset
}


directory <- "UCI HAR Dataset"

#print(get_feature_indexes(directory))
datasets <- get_dataset(directory)