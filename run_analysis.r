# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

# Reading testing tables:
 subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
 x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
 y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
 subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
  features <- read.table('./data/UCI HAR Dataset/features.txt')
  
# Reading activity labels:
  activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
  
#Assigning Column Names  
  colnames(x_train) <- features[,2] 
  colnames(y_train) <-"activityId"
  colnames(subject_train) <- "subjectId"
  colnames(x_test) <- features[,2] 
  colnames(y_test) <- "activityId"
  colnames(subject_test) <- "subjectId"
  colnames(activityLabels) <- c('activityId','activityType')
 
#Merging all datasets into one  
   mrg_train <- cbind(y_train, subject_train, x_train)
   mrg_test <- cbind(y_test, subject_test, x_test)
   setAllInOne <- rbind(mrg_train, mrg_test)
   
#Reading Column Names   
   colNames <- colnames(setAllInOne)
   
#Vector for defining Id, mean and Stdev
   mean_and_std <- (grepl("activityId" , colNames) | 
                      grepl("subjectId" , colNames) | 
                      grepl("mean.." , colNames) | 
                      grepl("std.." , colNames) 
   )
   
#Making necessary subset from allinone 
   
   setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Name the activities in dataset
   setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                          +                               by='activityId',
                                        +                               all.x=TRUE)
#Creating a second, independent tidy set with the average of each variable for each activity and each subject.
   
    secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
    secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#Writing second tidy data set in txt file   
     write.table(secTidySet, "TidySet.txt", row.name=FALSE)
    
