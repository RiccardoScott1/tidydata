library("plyr")
library("dplyr")

# set working dir to location of "run_analysis.R"
path <- getSrcDirectory(function(x) {x})
setwd(path )
#download the .zip file if it exists
destfile = "data.zip"
method = "curl"
if (!file.exists(destfile)) {
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile,method)
}
# unzip to wk dir
unzip("data.zip")

# read features 
features <- read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
feat <- as.character(features[,2])

# read activity label 
act <- read.csv("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")

#make a factor variable of activities
fact <- factor(act[,1],labels = act[,2])

#get the labels and subjects....
#....of test set
test_label <- read.csv("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
#....of train set
train_label <- read.csv("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#replace the test and train labes with characters from activities 
test_label_char <- sapply(test_label, function(x){fact[x]})
train_label_char <- sapply(train_label, function(x){fact[x]})

#read the data sets ----------------------------
#for test
test_data <- read.table("UCI HAR Dataset/test/X_test.txt", 
                        header = FALSE, 
                        #give header names from features.txt 
                        col.names=feat, 
                        #defining nrows speeds it up
                        nrows = length(test_label[,1]))


#for train
train_data <- read.table("UCI HAR Dataset/train/X_train.txt", 
                        header = FALSE, 
                        #give header names from features.txt 
                        col.names=feat, 
                        #leave colnames as they are
                        #check.names = ,
                        #defining nrows speeds it up
                        nrows = length(train_label[,1]))

#choose only columns containing "mean" and "std" 
test_data_select <- test_data %>% dplyr::select(grep("mean", names(test_data)), grep("std", names(test_data)))
train_data_select <- train_data %>% select(grep("mean", names(train_data)), grep("std", names(train_data)))

# colbind subjects and activities
tests <-  cbind(subject_test, test_data_select)
colnames(tests)[1] <- "subject"
tests <-  cbind(test_label_char, tests)
colnames(tests)[1] <- "activity"

trains <-  cbind(subject_train, train_data_select)
colnames(trains)[1] <- "subject"
trains <-  cbind(train_label_char, trains)
colnames(trains)[1] <- "activity" 

#merge the sets 
all_together <- rbind(tests,trains)

# create a second, independent tidy data set with the average of each variable for each activity and each subject
summary <- all_together%>% group_by(activity,subject)%>%summarise_all(mean)
#Export the tidy data do tidy.txt
write.table(summary, file = "tidy.txt",row.name=FALSE)


