#Load data
features<-read.table("./UCI HAR Dataset/features.txt", header = FALSE)
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Load train data
train_X_data<-read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_Y_data<-read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE)
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Load test data
test_X_data<-read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_Y_data<-read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE)
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)


#Extracts only the measurements on the mean and standard deviation for each measurement. 
filteredfeatures<-features[grepl("mean()",features$V2,fixed = TRUE)|grepl("std()",features$V2,fixed = TRUE),]

#get description of activities. adding index column to maintain ordering
getActivityDescription<-function(activity_list, activity_labels){
        activity_list<-cbind(activity_list, c(1:nrow(activity_list)))
        activity_desc_list<-merge(activity_list, activity_labels, by = "V1", All.x=TRUE, sort=FALSE)
        names(activity_desc_list)<-c("ActivityId","index","Activity")
        activity_desc_list<- activity_desc_list[order(activity_desc_list$index),]
        return(activity_desc_list)
}
train_Y_desc_data<-getActivityDescription(train_Y_data,activity_labels)
test_Y_desc_data<-getActivityDescription(test_Y_data,activity_labels)

#merge train/test data set
mergeDataSet<-function(dataset, filtertedFeatures, subject, activity, type){
        output<-matrix()
        #only retrieve mean and std columns
        dataset<-dataset[,filtertedFeatures[,2]]
        output<-cbind(dataset,activity[,"Activity"])
        output<-cbind(output, subject)
        output<-cbind(output, type)
        names(output)<-c(as.character(filtertedFeatures[,2]),"Activity","Subject","Type")
        return(output)
}
train_set<-mergeDataSet(train_X_data,filteredfeatures,train_subject,train_Y_desc_data,"train")
test_set<-mergeDataSet(test_X_data,filteredfeatures,test_subject,test_Y_desc_data,"test")

#merge train and test data set
combined_set<-rbind(train_set,test_set)

#Appropriately labels the data set with descriptive variable names. 
headers<-names(combined_set)
headers<-gsub("Acc","Accelerometer",headers)
headers<-gsub("Gyro","Gyroscope",headers)
headers<-gsub("Mag","Magnitude",headers)
headers<-gsub("-",".",headers)
headers<-gsub("\\(|\\)","",headers)
headers<-gsub("BodyBody","Body",headers)
headers<-gsub("tBody","TimeBody",headers)
headers<-gsub("fBody","FrequencyBody",headers)
headers<-gsub("tGravity","TimeGravity",headers)
headers<-gsub("fGravity","FrequencyGravity",headers)
headers<-gsub("mean","Mean",headers)
headers<-gsub("std","Standard Deviation",headers)
names(combined_set)<-headers

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
combined_set_mean <- aggregate(.~Subject+Activity,data = combined_set, FUN=mean)

#Output file
write.table(combined_set_mean,"Mean of HCI Measurement.txt", row.names= FALSE)