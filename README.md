---
README.md
---


This is description about how the output tidy data set get generated. 
The output tidy data set is "Mean of HCI Measurement.txt"
The codebook for tidy data set is "codebook.txt"
The code generate the output is "run_analysis.R"
The original data source locates under "HCI HAR Dataset folder", more details, please refer to enclosed README.txt

##Merges the training and the test sets to create one data set.
The majority process of merging train data set and test dataset is reading each kinds of data sets, merge each data sets with associated subject and activity mapping, add a new variable indicates data set type, and finally merge the result train dataset and test data set

###Reading neccessary data set
1. Load train data set "./HCI HAR Dataset/train/X_train.txt" using read.table. 
2. Load train activity data "./HCI Har Dataset/train/y_train.txt" using read.table
3. Load train subject data "./HCI Har Dataset/train/subject_train.txt" using read.table
5. Load test data set "./HCI HAR Dataset/test/X_test.txt" using read.table. 
6. Load test activity data "./HCI Har Dataset/test/y_test.txt" using read.table
7. Load test subject data "./HCI Har Dataset/test/subject_test.txt" using read.table
8. Load activity id/desctiption mapping "./HCI Har Dataset/activity_labels.txt" using read.table

###Replace activity id with description
1. Add index column into train activity data
2. Left join train acitivity data with activity id/description mapping and re-sort by index column to maintain original order
3. Add index column into test activity data
4. Left join test acitivity data with activity id/description mapping and re-sort by index column to maintain original order

###Merge all the data
1. Merge train data set, train activity desctiption column of joined train activity result in previous steps use cbind
2. Merge test data set, test activity desctiption column of joined test activity result in previous steps use cbind
3. Add Type column in each merged data set to indicates the data from "train" or "test"
4. Use rbind to merge train data set and test data from previous 1-3 steps

##Extracts only the measurements on the mean and standard deviation for each measurement. 
From performance perspective, this step should take place before actually merge the train/test data set. To identify mean and standard deviation varialbes, simply check if column name contains "mean()" or "std()"

###Find column match the criteria
This step should take place before merge train/test data set with activity/subject data
1. Use grepl to get list of mean/standard deviation columns
2. Select above columns from the train/test data set
3. Once finished continue merging with activity/subject data

##Uses descriptive activity names to name the activities in the data set
This step has been taken place while merging data in **Replace activity id with description** 

##Appropriately labels the data set with descriptive variable names. 
To define descriptive activity names, firstly, it should follow camels case and it should contain full name of f/t/acc/gyro...
In the existing column names, find and replace following characters:
1. Acc to Accelerometer
2. Gyro to Gyroscope
3. Mag to Magnitude
4. - to .
5. () to ""
6. BodyBody to Body
7. t to Time
8. f to Frequency
9. mean to Mean
10. std to Standard Deviation

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
This has been accomplished by get mean of each variable for each activity and subject use aggregate
Since each subject performed all 6 activities, the result should be 180.