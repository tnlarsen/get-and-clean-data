
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

activity.labels <- readLines(file.path(main.data.dir, "activity_labels.txt"))

# Step 1: merge training and test sets into one data set
# First the subjects and activites are combined with the measurements by adding
# them as the first two columns. This is done for both test and training data. Then the 
# test and training data are combined vertically as rows.

# Combine the subject data, labels and measurements
combined.test.data <- cbind(subject.test, y.test, x.test)
combined.train.data <- cbind(subject.train, y.train, x.train)

#combine test and training data
complete.data <- rbind(combined.test.data, combined.train.data)


# Step 2: extracts only measurements on the mean and std for each measurement
# First find the features that contain (ignoring case) "mean" or "std" assuming these are all
# the measurements that are needed
mean.and.std.features =  features[grepl("mean|std", features$feature.name, ignore.case = TRUE), ]
rownames( mean.and.std.features ) <- NULL

# Extract the mean and std columns from the complete data
reduced.data <- completeData[,c(1,2, mean.and.std.features$feature.id + 2)]


# Step 3: use descriptive activity names to name the activities
# Using the information from the "activity labels.txt" file
reduced.data[,2] <- factor(reduced.data[,2], levels = c(1,2,3,4,5,6), gsub("_", ".", tolower(activity_labels)))
                          

# Step 4: Appropriatly label the data
# First the labels are massaged a bit:

labels <- mean.and.std.features$feature.name

labels <- gsub("([a-z])([A-Z])", "\\1.\\L\\2", labels, perl = TRUE)  # Convert from calmelCase to . separated
labels <- gsub("acc", "acceleration", labels)  # Expand acc to acceleration
labels <- gsub("[()-]", "", labels)  # Remove special characters

colnames(reduced.data) <-c("subject", "activity", labels)





