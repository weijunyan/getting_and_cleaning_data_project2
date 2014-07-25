train<-read.table(".\\train\\X_train.txt")
test<-read.table(".\\test\\X_test.txt")

## 1.Merges the training and the test sets to create one data set.

dataset<-as.data.frame(rbind(as.matrix(train),as.matrix(test)))

##2.Extracts only the measurements on the mean and standard deviation
## for each measurement. 
Feature<-read.table("features.txt")
  # Find the measures on the mean and sd
mean_measure<- Feature[grepl("mean", Feature[,2]),]
mean_index <-mean_measure[,1]
std_measure<- Feature[grepl("std", Feature[,2]),]
std_index <- std_measure[,1]
mean_and_std <- c(mean_index,std_index)
  # get the subset
subdataset <- dataset[,mean_and_std]

## 3.Uses descriptive activity names to name the activities in the data set
  ## First read the descriptive activity names
activity_names  <- read.table("activity_labels.txt")
names <- as.character(activity_names[,2])
  ## Then read the activity names of train and test data
train_activity <- as.matrix(read.table(".\\train\\y_train.txt"))
test_activity <- as.matrix(read.table(".\\test\\y_test.txt"))
  ## Now merge the above two sets
activityset<- c(train_activity,test_activity) 
  ## add activity names to the data
for (i in 1:6){
 activityset[activityset==i]=names[i]
}
dataset$activity <- activityset

mean_std <- c(mean_and_std,562)
subsetdataset_activity <- dataset[,mean_std]

## 4.Appropriately labels the data set with descriptive variable names. 
names(dataset)[1:561] <- as.character(Feature[,2])
subsetdataset_activity <- dataset[,mean_std]

## 5.Creates a second, independent tidy data set with 
##the average of each variable for each activity and each subject. 
  
train_subject <- as.matrix(read.table(".\\train\\subject_train.txt"))
test_subject <- as.matrix(read.table(".\\test\\subject_test.txt"))
  ## Now merge the above two sets
subjectset<- c(train_subject,test_subject)
dataset$subject <- subjectset 
  ## step 1: split by subject
Split <- split(dataset,dataset$subject)
r=length(Split);
 X<- matrix(0,180,563)
 X[,562]<- rep(levels(as.factor(dataset$activity)),30)
for (i in 1:r){
X[(6*i-5):(6*i),563] <- rep(i,6)
  for (j in 1:561){
X[(6*i-5):(6*i),j]<-as.numeric(tapply(Split[[i]][,j],Split[[i]]$activity,mean))
}

}
AverageDataSet <- as.data.frame(X)
names(AverageDataSet) <- c(as.character(Feature[,2]),"activity","subject")
write.table(AverageDataSet, file="AverageDataSet.txt")
