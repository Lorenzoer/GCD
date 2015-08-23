al <- read.table("./activity_labels.txt")[,2]           # Activity labels
f <- read.table("./features.txt")[,2]                   # Features

xtest <- read.table("./test/X_test.txt")                # X_test data
ytest <- read.table("./test/y_test.txt")                # Y_test data
stest <- read.table("./test/subject_test.txt")          # Subject_test data

xtrain <- read.table("./train/X_train.txt")             # X_train data
ytrain <- read.table("./train/y_train.txt")             # Y_train data
strain <- read.table("./train/subject_train.txt")       # subject train data

names(xtest) <- f                                       # names columns X_test
names(xtrain) <- f                                      # names columns X_train

f2 <- grepl("mean|std", f)                              # only mean and std features
xtest = xtest[,f2]                                      # only X_test data for mean and std
xtrain = xtrain[,f2]                                    # only X_train data for mean and std

ytest[,2] = al[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(stest) = "subject"
ytrain[,2] = al[ytrain[,1]]
names(ytrain) = c("Activity_ID", "Activity_Label")
names(strain) = "subject"

testd <- cbind(as.data.table(stest), ytest, xtest)      # test data
traind <- cbind(as.data.table(strain), ytrain, xtrain)  # train data
data <- rbind(testd, traind)                            # Merge test and train data

idl <- c("subject", "Activity_ID", "Activity_Label")
datal <- setdiff(colnames(data), idl)
newdata <- melt(data, id = idl, measure.vars = datal)

td <- dcast(newdata, subject + Activity_Label ~ variable, mean)  # Tidy data 
write.table(td, file = "./tidy_data.txt", row.name=FALSE)        # write tidy data in file
