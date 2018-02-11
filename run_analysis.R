#Load Needed Packages 

library(plyr)

#Read all test data

trainData <- read.table("./uci_har_dataset/train/X_train.txt")
testData <- read.table("./uci_har_dataset/test/X_test.txt")
trainLabel <- read.table("./uci_har_dataset/train/y_train.txt")
testLabel <- read.table("./uci_har_dataset/test/y_test.txt")
trainSubject <- read.table("./uci_har_dataset/train/subject_train.txt")
testSubject <- read.table("./uci_har_dataset/test/subject_test.txt")

#Join Train Data and Test Data

joinData <- rbind(trainData, testData)
joinLabel <- rbind(trainLabel, testLabel)
joinSubject <- rbind(trainSubject, testSubject)

# Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./uci_har_dataset/features.txt")


# use grep to get the coumn number of the features which contains 'std' or 'mean()'
featuresMeanStd <- grep("std|mean\\(\\)", features$V2)


# create a table with the features we want
extract <- joinData[,featuresMeanStd]

# set  column names
names(extract) <- features[featuresMeanStd, 2]

# Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table("./uci_har_dataset/activity_labels.txt")

joinLabel[,1] <- activityLabels[joinLabel[,1], 2]

names(joinLabel) <- "activity"

# Appropriately labels the data set with descriptive variable names

names(joinSubject) <- "subject"

# bind data into a single data table
allData <- cbind(extract, joinLabel, joinSubject)


# creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyData <- ddply(.data = allData, .variables = c("subject", "activity"), .fun = numcolwise(mean))

write.table(tidyData, "tidy.txt", row.names = FALSE)