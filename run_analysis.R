
#Various constansts
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

zipFileName <- "./data/UCI HAR Dataset.zip" 
dataDirName <- "data"

#Download and unzip the file if needed and load the relevant data
get.data <- function() {
  
  if(!file.exists(dataDirName)) {
    dir.create(dataDirName)
    
    print('Downloading')
    download.file(url = fileUrl, destfile = zipFileName, method = "curl")
    
    print('Unzipping')
    unzip(zipFileName, exdir=dataDirName)
  }

}

#Load the relevant files
get.data()

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt", col.names = c("FeatureId", "FeatureName"))

#Find the features that contain (ignoring case) "mean" or "std"
mean_and_std_features =  features[grepl("mean|std", features$FeatureName, ignore.case = TRUE), ]
rownames( mean_and_std_features ) <- NULL

#Extract the mean and std columns from test and train data
X_test_mean_std <- X_test[,mean_and_std_features$FeatureId]
X_train_mean_std <- X_train[,mean_and_std_features$FeatureId]

#Set the column names
colnames(X_test_mean_std) <- mean_and_std_features$FeatureName
colnames(X_train_mean_std) <- mean_and_std_features$FeatureName

#Combine the subject data, labels and measurements
combinedTestData <- cbind(subject_test, y_test, X_test_mean_std)
combinedTrainData <- cbind(subject_train, y_train, X_train_mean_std)

#combine test and training data
completeData <- rbind(combinedTestData, combinedTrainData)
colnames(completeData) <-cbind(c("Subject", "Activity"), mean_and_std_features$FeatureName)

