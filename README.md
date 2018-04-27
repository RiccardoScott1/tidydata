"run_analysis.R" takes data from the accelerometers from the Samsung Galaxy S smartphone <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> and exports a neat and tidy summary of them in "tidy.csv". 
In detail it:
- loads "plyr" and "dplyr" packages
- sets working directory to the location of "run_analysis.R"
- downloads the .zip file if it exists and unzips it 
- it reads the features "features.txt", activities "activity_labels.txt", labels "Y_test.txt" and subjects "subject_test.txt" for the test and train datasets
- reads the data setsc("X_train.txt" and "X_test.txt") giving header names from features.txt 
- selects only columns containing "mean" and "std" 
- adds subjects and activities as columns
- merges the train and test sets vertically (rbind): this big detailed dataframe is called "all_together"
- an independent tidy data set with the average of each variable for each activity and each subject is exported to "tidy.txt" and commented in "CodeBook"# tidydata
# tidydata
