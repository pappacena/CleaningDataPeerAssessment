CleaningDataPeerAssessment
==========================

Coursera's Getting and Cleaning Data course, "Peer Assessment"

This module has two main functions you should be looking:

# Usage
------------------------

### get_dataset()  or get_dataset(directory)

Gets the full dataset, with proper column names and labels, excluding feature columns withouth *"mean()"* or *"std()"* in it's name

### get_tidy_dataset(), get_tidy_dataset(directory) or get_tidy_dataset(directory, outputfile)

Gets the tidy dataset with the means of feature columns, groupped by subject and activity



# Main functions
------------------------

## get_dataset(directory="UCI HAR Dataset")


This function concatenates the test and train datasets, both X (features) and Y (activity), plus the subject variables.

This functions also translates the activity codes to it's description, and label the feature columns with human readable names.

It's important to note that only the columns with "std()" or "mean()" in it's names are returned by this function.


## get_tidy_dataset(directory="UCI HAR Dataset", outputfile=NULL)

This function uses the _get_dataset_ function to fetch all data and, using the *data.table* package, group all observations by it's subject + activity_code + activity and calculates the means of each feature.

It's done in a quite straight forward and fast way using data.table and the ".SD" special variable: 

`dt[, lapply(.SD, mean), by=c("subject", "activity_code", "activity")]`

In this case, we make data.table to group by these 3 columns, and will `lapply` the `mean` function to each column of the sub-datasets returned by the groupping operation.

If `outputfile` parameter is given, this function will write the result of calculations to this file before returning it.




# Helper functions
------------------------

For the `get_dataset` and `get_tidy_dataset` to work, we need these other helper functions:

## get_activities

Gets the activities labels from the activity_labels.txt file


## get_features

Gets the list of features from features.txt, excluding those that don't have "mean()" or "std()" in it's name.