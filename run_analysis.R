install.packages("plyr")
library(plyr)
install.packages("dplyr")
library(dplyr)

#load each tab-delimited table into R
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
#merge subject_train, y_train, and X_train
labeled_train <- cbind(subject_train, y_train, X_train)
#merge subject_test, y_test, and X_test
labeled_test <- cbind(subject_test, y_test, X_test)
#merge labeled_train and labeled_test
train_test <- rbind(labeled_train, labeled_test)

#load features table into R
features <- read.table("./features.txt")
#create names for columns
column_names <- c("subject", "activity", as.character(features[,2]))
#add column_names to train_test data frame
colnames(train_test) <- column_names

#extract first 2 columns and columns containing mean or standard deviation data
mean_std <- train_test[, c(1,2, grep("mean\\(|std", names(train_test)))]

#load activity_labels table into R
activities <- read.table("./activity_labels.txt")

#convert values in 2nd column from integer to character
mean_std[,2] <- as.character(mean_std[,2])

#replace the activity codes with activity names in 2nd column
mean_std[,2] <- revalue(mean_std[,2], c("1" = "WALKING", "2" = "WALKING_UPSTAIRS", 
                        "3" = "WALKING_DOWNSTAIRS", "4" = "SITTING",
                        "5" = "STANDING", "6" = "LAYING"))

#arrange data set by subject, then activity
arranged_mean_std <- arrange(mean_std, subject, activity)

#group by subject and activity
grouped_mean_std <- group_by(arranged_mean_std, subject, activity)

#create new data set containing variable mean for each subject and activity
tidy_dataset <- summarise_each(grouped_mean_std, funs(mean))

#create txt file of tidy_dataset
write.table(tidy_dataset, "./tidy_dataset.txt", sep="\t", row.names = FALSE)
                                                                  