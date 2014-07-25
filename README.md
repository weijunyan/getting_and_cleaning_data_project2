getting_and_cleaning_data_project2
==================================
For question 1:
  First I read the trainging set and the test set, then they are set to be matrix to be combined by function "rbind".  Last, change the matrix to be a data frame. Thus I merge the training and test set. See:
  
"dataset<-as.data.frame(rbind(as.matrix(train),as.matrix(test))) "

For question 2:
 First, Find the measures on the mean and sd and its index in feauture.txt
 
"Feature<-read.table("features.txt")
mean_measure<- Feature[grepl("mean", Feature[,2]),]
mean_index <-mean_measure[,1]
std_measure<- Feature[grepl("std", Feature[,2]),]
std_index <- std_measure[,1] "

Then combine the two indexes. As they are both integer, it is easy to do this.
 
"mean_and_std <- c(mean_index,std_index)"

Last, get the subset by merging the same columns

"subdataset <- dataset[,mean_and_std]"

For question 3:
  First read the descriptive activity names and change the names to be character

"activity_names  <- read.table("activity_labels.txt")
names <- as.character(activity_names[,2])"

  Then read the activity names of train and test data

"train_activity <- as.matrix(read.table(".\\train\\y_train.txt"))
test_activity <- as.matrix(read.table(".\\test\\y_test.txt"))"
  
 Now merge the above two sets

"activityset<- c(train_activity,test_activity)"
 
Then add activity names to the data. Here we use a for function to do so.

"for (i in 1:6){
 activityset[activityset==i]=names[i]
}"

Last, we add activity names to the data set

"dataset$activity <- activityset "


For question 4: 
When we read the feature.txt, there are 2 columns, and the second column is the name of the features but it is factors, so we have to change the type when add names to the data set.

"names(dataset)[1:561] <- as.character(Feature[,2])"

For question 5:
First merge the training and test subject files, and we do it as the same with merging the training and test sets.

" train_subject <- as.matrix(read.table(".\\train\\subject_train.txt"))
test_subject <- as.matrix(read.table(".\\test\\subject_test.txt"))
subjectset<- c(train_subject,test_subject) "

Then we add the subject to be one column of data set

" dataset$subject <- subjectset "

In order to  get the average of each variable for each activity and each subject. My first step is to spit the total data set I get before by subject.

  ## step 1: split by subject
Split <- split(dataset,dataset$subject)

Then I compute the average of each variable for each activvity. I will use the tapply function, and get the data manually. We set a matrix with 180 (6*30) rows and 563 colums. 
 
"r=length(Split);
 X<- matrix(0,180,563)"

The 562th and 563th column are the different combination of activity and subject

" X[,562]<- rep(levels(as.factor(dataset$activity)),30)"

Then we use the tapply to get the average for each subject and each activity.

"
for (i in 1:r){
X[(6*i-5):(6*i),563] <- rep(i,6)
  for (j in 1:561){
X[(6*i-5):(6*i),j]<-as.numeric(tapply(Split[[i]][,j],Split[[i]]$activity,mean))
}

} "

Then, we change the matrix X to a data frame
and and the names to the data frame.

"AverageDataSet <- as.data.frame(X)
names(AverageDataSet) <- c(as.character(Feature[,2]),"activity","subject")"

Finally,we write the tidy data we have got into a txt file with the write.table function.

"write.table(AverageDataSet, file="AverageDataSet.txt")"