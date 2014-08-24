#Readme

Description of the manipulations done in 'run_analysis.R'. Analysis done on data from [1].

##Manipulations

### Step 1: Merge training and test sets into one data set
First the subjects and activites are combined with the measurements by adding them as the first two columns. This is done for both test and training data. Then the test and training data are combined vertically as rows.

 The resulting data.frame has this structure:

    subject.test    y.test    x.test
    subject.train   y.train   x.train

### Step 2: Extract only measurements on the mean and std for each measurement
First find the features that contain (ignoring case) "mean" or "std" assuming these include all the 
measurements that are needed. After that I exclude the measurements starting with "angel" since they measure an angel between two 
observations. 

### Step 3: Use descriptive activity names to name the activities
Here I just use a lowercase version of the named loaded from "activity_labels.txt" file. In the names '_' is replaced with '.'

### Step 4: Appropriatly label the data
The following manipulations for the names are done:

  * Expanding to complete words: so Acceleration instead of Acc, Magnitude instead of Mag, Gyroscpoe instead of Gyro
  * Convert 't' and 'f' prefixes to "time" and "frequency" 
  * Removing dashes and parenthesis
  * Remove the duplication in BodyBody
  * replace "-mean()" with "Mean", "-std()" with "StandardDeviation" and "-meanFreq()" with "MeanFrequency"

### Step 5: Creates a second, independent tidy data set
This is done by first melting the data using "melt" and afterwards "dcast"'ing the data into the wide form using the "mean" function as the aggregation function.

##References:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

