#Step0: Load data
#Load label data
features <- read.table(file = "./features.txt")
activity_labels <- read.table(file = "./activity_labels.txt")

#Load train data
x_train <- read.table(file = "./train/X_train.txt")
y_train <- read.table(file = "./train/y_train.txt")
subject_train <- read.table(file = "./train/subject_train.txt")

#Load test data
x_test <- read.table(file = "./test/X_test.txt")
y_test <- read.table(file = "./test/y_test.txt")
subject_test <- read.table(file = "./test/subject_test.txt")


#Step1: Merge train and test data
merged_x <- rbind(x_train, x_test)
merged_y <- rbind(y_train, y_test)
merged_sub <- rbind(subject_train, subject_test)


#Step2: Extract only mean and std columns
selected_col <- grep("mean|std", features[,2])
merged_x_selected <- merged_x[,selected_col]


#Step3: Add name to activities
y_wid <- merge(merged_y, activity_labels)


#Step4: Add names to x and y data columns
colnames(y_wid) <- c("activity_id", "activity_name")
colnames(merged_x_selected) <- features[selected_col,][,2]
colnames(merged_sub) <- c("subject_id")

#Create one data frame with x, y and subject
dt <- cbind(merged_x_selected, y_wid, merged_sub)


#Step5: Creates tidy data set with the average of each variable for each activity and each subject.
#td <- aggregate(dt, by=list(dt$activity_id,dt$subject_id), FUN = mean)
#td1 <- aggregate(dt, by=list(dt$activity_id), FUN = mean)
#td2 <- aggregate(dt, by=list(dt$subject_id), FUN = mean)
td <- dt %>% group_by(subject_id,activity_id) %>% summarise_all(mean)
write.table(td, file = "./actsub_mean.txt")
