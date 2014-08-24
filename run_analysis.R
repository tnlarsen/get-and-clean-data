
# Various constansts
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

data.dir <- file.path(".", "data")
zip.file <- file.path(data.dir, "UCI HAR Dataset.zip")
main.data.dir <- file.path(data.dir, "UCI HAR Dataset")
test.data.dir <- file.path(data.dir, "UCI HAR Dataset", "test")
train.data.dir <- file.path(data.dir, "UCI HAR Dataset", "train")


# Step 0: Download and unzip the file if needed and load the relevant data
if(!file.exists(data.dir)) {
    dir.create(data.dir)
    
    print('Downloading')
    download.file(url = fileUrl, destfile = zipFileName, method = "curl")
    
    print('Unzipping')
    unzip(zipFileName, exdir = data.dir)
}

x.test <- read.table(file.path(test.data.dir, "X_test.txt"))
y.test <- read.table(file.path(test.data.dir, "y_test.txt"))
subject.test <- read.table(file.path(test.data.dir, "subject_test.txt"))

x.train <- read.table(file.path(train.data.dir, "X_train.txt"))
y.train <- read.table(file.path(train.data.dir, "y_train.txt"))
subject.train <- read.table(file.path(train.data.dir, "subject_train.txt"))

features <- read.table(file.path(main.data.dir, "features.txt"), 
                       col.names = c("feature.id", "feature.name"),
                       colClasses=c("feature.name"="character"))

activity.labels <- read.table(file.path(main.data.dir, "activity_labels.txt"),
                              col.names = c("activity.id", "activity.name"), 
                              colClasses=c("activity.name"="character"))$activity.name

# Step 1: merge training and test sets into one data set
# First the subjects and activites are combined with the measurements by adding
# them as the first two columns. This is done for both test and training data. Then the 
# test and training data are combined vertically as rows.
#
# The resulting data.frame has this structure:
#
# subject.test    y.test    x.test
# subject.train   y.train   x.train
#


# Combine the subject data, labels and measurements
combined.test.data <- cbind(subject.test, y.test, x.test)
combined.train.data <- cbind(subject.train, y.train, x.train)

#combine test and training data
complete.data <- rbind(combined.test.data, combined.train.data)


# Step 2: extracts only measurements on the mean and std for each measurement
# First find the features that contain (ignoring case) "mean" or "std" assuming these include all the 
# measurements that are needed but excluding the ones starting with "angel" since they measure an angel between two 
# observations. 
mean.and.std.features =  features[grepl("mean|std", features$feature.name, ignore.case = TRUE), ]
mean.and.std.features =  mean.and.std.features[!grepl("^angle", mean.and.std.features$feature.name, ignore.case = TRUE), ]
rownames( mean.and.std.features ) <- NULL

# Extract the mean and std columns from the complete data
# retaining the two first column which is the subject and activity labels
reduced.data <- complete.data[,c(1,2, mean.and.std.features$feature.id + 2)]


# Step 3: use descriptive activity names to name the activities
# Using the information from the "activity labels.txt" file
reduced.data[,2] <- factor(reduced.data[,2], 
                           levels = 1:length(activity.labels), 
                           labels = gsub("_", ".", tolower(activity.labels)))
                          

# Step 4: Appropriatly label the data
# Doing the following manipulations:
# Expanding to complete words: so Acceleration instead of Acc, Magnitude instead of Mag, time instead of t etc.
# Removing dashes and parenthesis
# Remove the duplicatiion in BodyBody
labels <- mean.and.std.features$feature.name

labels <- gsub('Acc', 'Acceleration', labels)  # Expand Acc to Acceleration
labels <- gsub('Mag', 'Magnitude', labels)  # Expand Mag to Magnitude
labels <- gsub('Gyro', 'Gyroscope', labels)  # Expand Gyro to Gyroscope

labels <- gsub('BodyBody','Body', labels) # Replace BodyBody with Body assuming it is an error in the names
labels <- gsub('-mean()','Mean', labels, fixed = TRUE)  # Replace -mean() with Mean
labels <- gsub('-std()','StandardDeviation', labels, fixed = TRUE)  # Replace -std() with StandardDeviation
labels <- gsub('-meanFreq()','MeanFrequency', labels, fixed = TRUE)  # Replace -meanFreq() with MeanFrequency
labels <- gsub('^t','time', labels)  # Replace starting t with time
labels <- gsub('^f','frequency', labels)  # Replace starting f with frequency
labels <- gsub('(-)(X|Y|Z)', '\\2axis', labels)  # Replace -X with Xaxis and similarly for Y and Z

# Finally set the column names
colnames(reduced.data) <- c("subject", "activity", labels)


# Step 5: Create a new tidy data set
library(reshape2)
molten <- melt(reduced.data, id=c("subject", "activity"), measure.vars=labels)
tidy.means <- dcast(molten, subject + activity ~ variable, mean)

write.table(tidy.means, file=file.path(".", "tidy.data.set.txt"), row.name=FALSE)