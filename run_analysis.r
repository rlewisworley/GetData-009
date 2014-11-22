##########################################GetData-009###################
###  RLW - 11/22/2014                                               ####
###                                                                 ####
###                                                                 ####
########################################################################

# clean up the workspace
rm(list = ls())

# get the packages

setwd("G:/Coursera/GetData-009")
#install.packages("data.table")
library(data.table)

#Read data from Files
Data_Motion <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/test/X_test.txt",header=FALSE)
Data_Motion_act <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/test/y_test.txt",header=FALSE)
Data_Motion_sub <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainData <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_act <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_sub <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/train/subject_train.txt",header=FALSE)
activities <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
features <- read.table("G:/Coursera/GetData-009/Files/UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")


#Name activities in the data set

Data_Motion_act$V1 <- factor(Data_Motion_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)

# Label the data

colnames(Data_Motion)<-features$V2
colnames(trainData)<-features$V2
colnames(Data_Motion_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(Data_Motion_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")

# Merge test and data sets
Data_Motion<-cbind(Data_Motion,Data_Motion_act)
Data_Motion<-cbind(Data_Motion,Data_Motion_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
bigData<-rbind(Data_Motion,trainData)

#Extract mean and SD
bigData_mean<-sapply(bigData,mean,na.rm=TRUE)
bigData_sd<-sapply(bigData,sd,na.rm=TRUE)

# Produce clean data set
DT <- data.table(bigData)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="G:/Coursera/GetData-009/TIdyMotionData.txt",sep=",",row.names = FALSE)