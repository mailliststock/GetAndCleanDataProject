library(reshape2)
setwd("/Users/rcc/Desktop/dataset")

# Loading...
X_test<-read.csv("./test/X_test.txt", 
                 header=FALSE, sep="", comment.char="", colClasses="numeric")
y_test<-read.csv("./test/y_test.txt", 
                 header=FALSE, sep="")
subject_test<-read.csv("./test/subject_test.txt", 
                       header=FALSE, sep="")
X_train<-read.csv("./train/X_train.txt",
                  header=FALSE, sep="", comment.char="", colClasses="numeric")
y_train<-read.csv("./train/y_train.txt",
                  header=FALSE, sep="")
subject_train<-read.csv("./train/subject_train.txt",
                        header=FALSE,sep="")

## Part 1: 
# a. Start by merge train and test sets to make one big dataframe
# then changes variable names for y_test and subject_test...
names(y_test)<-"activity.labels"
names(subject_test)<-"subjectID"

# b. Merge the X_test, y_test and subject_test on one single dataframe
testD<-cbind(X_test, y_test, subject_test)

# c. Change variable names 
names(y_train)<-"activity.labels"
names(subject_train)<-"subjectID"

# d. Merge 3 dataframe with column bind
TrainD<-cbind(X_train, y_train, subject_train)

# e. Merge 2 dataframe with row bind
bigD<-rbind(testD, TrainD)

## Part 2 
# a. Get variables that have std() or mean() and read in "features.txt" and
# use as column names for X_test. 
# b. Get relevant variables(from bigD) by logical vector
vN<-read.csv("./features.txt",
             header=FALSE, sep="")
names(bigD)<- c(as.character(vN$V2),
                "activity.labels", "subjectID")
cN<-grepl("mean\\(\\)|std\\(\\)|activity|subject", names(bigD))
bigD<-bigD[,cN]

## Part 3 
# Change number codes to words (at "activity_labels") using activity_labels.txt file.
bigD$activity.labels<-as.factor(bigD$activity.labels)
levels(bigD$activity.labels)<-list(WALKING="1", 
                                   WALKING_UPSTAIRS="2", WALKING_DOWNSTAIRS="3", SITTING="4", STANDING="5", LAYING="6")

## Part 4
# Put a label on vars based on those names that are inside the "features.txt" file.
names(bigD)<-c("tBodyAcc_mean_X", "tBodyAcc_mean_Y", "tBodyAcc_mean_Z", "tBodyAcc_std_X", 
               "tBodyAcc_std_Y", "tBodyAcc_std_Z", "tGravityAcc_mean_X", "tGravityAcc_mean_Y", 
               "tGravityAcc_mean_Z","tGravityAcc_std_X", "tGravityAcc_std_Y", "tGravityAcc_std_Z",
               "tBodyAccJerk_mean_X", "tBodyAccJerk_mean_Y", "tBodyAccJerk_mean_Z", "tBodyAccJerk_std_X",
               "tBodyAccJerk_std_Y", "tBodyAccJerk_std_Z", "tBodyGyro_mean_X", "tBodyGyro_mean_Y", 
               "tBodyGyro_mean_Z", "tBodyGyro_std_X", "tBodyGyro_std_Y", "tBodyGyro_std_Z",
               "tBodyGyroJerk_mean_X", "tBodyGyroJerk_mean_Y", "tBodyGyroJerk_mean_Z", "tBodyGyroJerk_std_X",
               "tBodyGyroJerk_std_Y", "tBodyGyroJerk_std_Z" ,"tBodyAccMag_mean", "tBodyAccMag_std",
               "tGravityAccMag_mean", "tGravityAccMag_std", "tBodyAccJerkMag_mean", "tBodyAccJerkMag_std",
               "tBodyGyroMag_mean", "tBodyGyroMag_std", "tBodyGyroJerkMag_mean", "tBodyGyroJerkMag_std",
               "fBodyAcc_mean_X", "fBodyAcc_mean_Y", "fBodyAcc_mean_Z", "fBodyAcc_std_X",
               "fBodyAcc_std_Y", "fBodyAcc_std_Z", "fBodyAccJerk_mean_X", "fBodyAccJerk_mean_Y",
               "fBodyAccJerk_mean_Z", "fBodyAccJerk_std_X", "fBodyAccJerk_std_Y", "fBodyAccJerk_std_Z",
               "fBodyGyro_mean_X", "fBodyGyro_mean_Y", "fBodyGyro_mean_Z", "fBodyGyro_std_X",
               "fBodyGyro_std_Y", "fBodyGyro_std_Z", "fBodyAccMag_mean", "fBodyAccMag_std",
               "fBodyAccJerkMag_mean", "fBodyAccJerkMag_std", "fBodyGyroMag_mean","fBodyGyroMag_std",
               "fBodyGyroJerkMag_mean", "fBodyGyroJerkMag_std", "activity", "subjectID" )

## Part 5
# Now we create another independent tidy data set with the average 
# of each variable (using casting and melting) for each activity/subject. 
meltD<-melt(bigD, id=c("subjectID", "activity")) 
castD<-dcast(meltD, subjectID+activity ~ variable, fun.aggregate=mean)
write.table(castD, "tidydataset.txt",sep="|")