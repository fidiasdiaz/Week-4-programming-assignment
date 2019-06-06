# Setting work directory and loading data
setwd("C:/Users/fjdia/OneDrive/Documentos/Academics/Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
test_setX <- read.table("./test/X_test.txt")
train_setX <- read.table("./train/X_train.txt")
test_setY <- read.table("./test/Y_test.txt")
train_setY <- read.table("./train/Y_train.txt")
features <- read.table("features.txt")
activity_lab <- read.table("activity_labels.txt")
test_subject <- read.table("./test/subject_test.txt")
train_subject <- read.table("./train/subject_train.txt")

# Assinging descriptive column names to each table
colnames(test_setX) <- features$V2
colnames(train_setX) <- features$V2
colnames(test_setY) <- "activityID"
colnames(train_setY) <- "activityID"
colnames(test_subject) <- "subjectID"
colnames(train_subject) <- "subjectID"
colnames(activity_lab) <- c("activityID", "activityType")

# Merging all the tables in one
allmerged <- rbind(cbind(test_setX, test_setY, test_subject), cbind(train_setX, train_setY, train_subject))

# Making table that retrieves columns related to the mean and standard deviation
mean_std <- (grepl("mean", colnames(allmerged)) | grepl("std", colnames(allmerged)) | grepl("subjectID", colnames(allmerged)) | grepl("activityID", colnames(allmerged)))
allmerged_desc <- allmerged[mean_std == TRUE]
allmerged_desc_act <- merge(allmerged_desc, activity_lab, by.x = "activityID", all.x = TRUE)

# Aggregating the previous table by activity and subject
Tidyallmerged_desc_act <- aggregate(. ~activityID + subjectID, allmerged_desc_act, mean)
Tidyallmerged_desc_act <- Tidyallmerged_desc_act[order(Tidyallmerged_desc_act$subjectID, Tidyallmerged_desc_act$activityID),]

# Saving the final tidy table
write.table(Tidyallmerged_desc_act, "Tidyallmerged_desc_act.txt", row.name=FALSE)
