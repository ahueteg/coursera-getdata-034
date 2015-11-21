## STEP 1: Merges the training and the test sets to create one data set

# read data into data frames
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

# add column name for subjects
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# add column names for measurements
features <- read.table("features.txt")
names(X_train) <- features[,2]
names(X_test) <- features[,2]

# add column name for activities
names(y_train) <- "activityID"
names(y_test) <- "activityID"

# merge datasets into one dataset "data"
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
data <- rbind(train, test)

## STEP 2: Extracts only the measurements on the mean and standard
## deviation for each measurement.

# determine which columns contain "mean()" or "std()"
extract_features <- grepl("mean|std", names(data))

# ensure that we also keep the subjectID and activity columns
extract_features[1:2] <- TRUE

# remove unnecessary columns
data <- data[, extract_features]

## STEP 3: Uses descriptive activity names to name the activities
## in the data set.
## STEP 4: Appropriately labels the data set with descriptive
## activity names. 

# convert the activityID column from integer to factor
activity_labels <- read.table("activity_labels.txt")
data$activityID <- factor(data$activityID, 
                          labels=activity_labels[,2])

## STEP 5: Creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

# create the tidy data set
library(reshape2)
meltdata <- melt(data, id=c("subjectID","activityID"))
tidydata <- dcast(meltdata, subjectID+activityID ~ variable, mean)

# write the tidy data set to a file
write.table(tidydata, "tidy.txt", row.names=FALSE)
