# this scripts perform following steps in a given order

# Step 1 : Merge the training and test data
# Step 2 : Use descriptive activity names to name the activity in dataset
# Step 3 : Assign names to activity number
# step 4 : Normalize column names in tidy data using grep

# First of all load libararies which we'll use in scripts 
library(reshape)
library(plyr)

# Stored data folder in cktest folder under the name of gettingData so set working
# direcotry to current directory
setwd("F:/cktest/gettingData/")
 
# Read test files from test directory
x_test <- read.table("./test/x_test.txt")
y_test <- read.table("./test/y_test.txt")
subjectTest <- read.table("./test/subject_test.txt")

# Read train file from train directory
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")
 
# Load variable names 
features <- read.table("./features.txt")
 
# Assign variable name to respective column in test and training datasets
colnames(x_train) <- features$V2
colnames(x_test) <- features$V2
 
# Assign Coulmn name "activity" to activity dataset column
y_test <-  rename(y_test, c(V1="activity"))
y_train <- rename(y_train, c(V1="activity"))

# Load activity file so that we could replce activity code to its value
activityfile <- read.table("./activity_labels.txt")
activity_label <- levels(activityfile$V2)

# Replacing activity code by respective labels
y_test$activity <- factor(y_test$activity, labels = activity_label)
y_train$activity <- factor(y_train$activity, labels = activity_label)

# Assigning column name to Subject data set
subjectTrain <- rename(subjectTrain, c(V1="subjectid"))
subjectTest <- rename(subjectTest, c(V1="subjectid"))

# Bind train and test dataset columnwise 
d_train <- cbind(x_train, subjectTrain, y_train)
d_test <- cbind(x_test, subjectTest, y_test)

# Now binding test and train data set rowwise to get final value
temp_data <- rbind(d_train, d_test)


# Fetching only specific columns which contains means Standard, Deviation, Subjectid, activity 
tidy_data  <- temp_data[,grep("mean|std|subjectid|activity",colnames(temp_data))]

# removing symbols like "-", "(", ")" from column headings
cleanNames = gsub("\\(|\\)|-|,", "", names(tidy_data))
colnames(tidy_data) <- cleanNames


# Summarize data
final_tidy = ddply(tidy_data, .(activity, subjectid), numcolwise(mean))

# Writing final data into csv file
write.csv(final_tidy, file="data.csv", sep = ",", append=F)
