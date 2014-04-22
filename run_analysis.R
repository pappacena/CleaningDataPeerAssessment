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
    features <- read.table(paste(directory, "/features.txt", sep=""), sep=" ")
    features[grep("(-mean|-std)\\(\\)", features[, 2]), ]
}


# This function concatenates the test and train datasets,
# both X (features) and Y (activity), plus the subject variables.
#
# get_dataset also translates activity codes to it's labels,
# and use human-readable names to describe each feature column
get_dataset <- function(directory="UCI HAR Dataset") {
    activities_labels <- get_activities(directory)
    get_activity_label <- function(activity_code) {
        activities_labels[activity_code, ]
    }
    
    features <- get_features(directory)
    feature_indexes <- features[, 1]
    feature_names <- as.character(features[, 2])
    
    # read subject test and train
    subject <- read.table(paste(directory, "/test/subject_test.txt", sep=""))
    subject <- rbind(subject, read.table(paste(directory, "/train/subject_train.txt", sep="")))
    
    # read features test and train
    x <- read.table(paste(directory, "/test/X_test.txt", sep=""))
    x <- rbind(x, read.table(paste(directory, "/train/X_train.txt", sep="")))
    
    # read activities test and train
    y <- read.table(paste(directory, "/test/Y_test.txt", sep=""))
    y <- rbind(y, read.table(paste(directory, "/train/Y_train.txt", sep="")))
    
    #activities <- apply(y, 1, get_activity_label)
    activities <- get_activity_label(y$V1)
    
    full_dataset <- cbind(x[, feature_indexes], subject=subject,
                          activity_code=y, activity=activities)

    names(full_dataset) <- c(feature_names, "subject", "activity_code", "activity")
    full_dataset
}


# Using data.table package, this functions returns the mean of each feature,
# groupping by subject/activity_code/activity
#
#   This function uses the ".SD", a placeholder for the "sub-datasets" returned by data.table
# when you use the "by" argument. You can learn a little more about the .SD by replacing
# the returned value of this function by the comment above it, which prints first lines of
# all subdatasets, instead of calculating it's means :)
get_tidy_dataset <- function(directory="UCI HAR Dataset", outputfile=NULL) {
    require(data.table)

    dataset <- get_dataset(directory)
    dt <- data.table(dataset)
    
    # uncomment the line below to see what .SD means
    # dt[, head(.SD), by=c("subject", "activity_code", "activity")]
    
    means <- dt[, lapply(.SD, mean), by=c("subject", "activity_code", "activity")]
    
    if(!is.null(outputfile)) {
        write.table(means, outputfile)
    }
    means
}


directory <- "UCI HAR Dataset"
tidy_filename <- "test.csv"

print("Build dataset")
dataset <- get_dataset(directory)

print("Done! Displaying some information about the full dataset")
summary(dataset)
str(dataset)
print("Dataset is available at 'dataset' variable.")
print("Generating the second tidy dataset")
tidy <- get_tidy_dataset(directory, tidy_filename)
print("New dataset generated. It's available as 'tidy' variable.")
print(paste0("A copy of the file is available at ", tidy_filename))