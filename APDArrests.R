## install required packages
install.packages("DMWR2")
install.packages("caret")
install.packages("themis")
install.packages("moments")
install.packages("gbm")

##step 1 - load libraries
##load libraries
library(DMwR2)
library(caret)
library(themis)
library(moments)
library(ModelMetrics)

##_______________________________________________________##
##STEP 2 - load file
##read sample of dataset into R as a csv file
apddata <- read.csv('APD_Arrests.csv')

##_______________________________________________________##
#STEP 3 - Perform pre-processing
## 1. transform variable data types
## using as.factor() function, create classify Race and Sex variables
apddata$Sex <- as.factor(apddata$Sex)
apddata$Race <- as.factor(apddata$Race)

##using factor() function, create classify Neighborhood variables
apddata$Neighborhood <- factor(apddata$Neighborhood.Association, 
                         levels = c("Melrose","Pine Hills","Helderberg","Upper Washington Avenue",
                                    "Buckingham Lake","White","Arbor Hill Concerned Citizens","Sheridan Hollow",
                                    "No. Albany / Shaker Park","South End","West End","Black"),
                         labels =c("White","White","White","White","White","White",
                                   "Black","Black","Black","Black","Black","Black"))


##categorize the arrest types, using the factor() function
apddata$Arrest.type <- factor(apddata$Arrest.type,
                        levels = c("Arrest Warrant","Complaint","Crime in Progress","Order of Protection",
                        "Other","Summons","Indictment Warrant","Parole Warrant"),
                        labels = c("Major","Major","Major","Major","Major","Minor","Minor","Minor"))

##Split the Age into ranges of: 
#18 - 27; 28 - 37; 38 - 47; 48 - 57; 58 - 67; 67-77;and 78
agebreaks <- c(0, 27, 37, 47, 57, 67, 77) 

#cut the age using the agebreaks
a <- cut(apddata$Age, agebreaks, include.lowest=FALSE) 

#rename the age ranges
levels(a) <- c("18 - 27years","28 - 37years","38 - 47years", 
               "48 - 57years","58 - 67years","68 - 77years", "78 and above")


##--------------------------------------------##
## 2. drop variables not used the data set
apddata$ArrestID <- NULL 
apddata$City <- NULL
apddata$State <- NULL
apddata$Last.30.Days <- NULL
apddata$Code.Description <- NULL
apddata$Crime.LongID <- NULL
apddata$Attempt <- NULL
apddata$Arrest.Time <- NULL
apddata$Arrest.Date <- NULL
apddata$Ethnicity <- NULL
apddata$Law <- NULL
apddata$Incident <- NULL
apddata$NeighborhoodXY <- NULL
apddata$Neighborhood.Association <- NULL

## view dataset
summary(apddata)
str(apddata)
##view the age ranges
table(a)

##______________________________________________________________##
#STEP 4 - Perform exploratory visual analysis of sample dataset

##Frequency and Percentage tables
prop.table(table(apddata$Neighborhood))*100 
## arrests occur more in predominantly black neighborhood at 76.4% than
#23.5% in white
##get proportion of race
prop.table(table(apddata$Race))*100
hist(apddata$Age)

#------------------#
## Measure of Central Tendency
## get the normal distribution of the dataset and plot graph
norm_data <- rnorm(apddata) ##generally normal distribution
plot(density(norm_data)) ## create a density plot of the data
abline(v=mean(norm_data),lwd=5) ## plot a black line for mean
abline(v=median(norm_data), col="red", lwd=2) ##plot a red line for median

##calculate the skewness
skewness(norm_data)

#------------------#
# Measure of Variability
##get standard deviations of age in the data set
sd(table(apddata))

##__________________________________________________________##
#STEP 5 - Balance the dataset
## Up sample the minority  of the dataset
## Up sample the white race
with(apddata,
     {
       print(table(Age));
       print(table(Race));
       print(table(Neighborhood));
     }
)
White <- which(apddata$Race == "W")
Black <- which(apddata$Race == "B")
table(apddata$Race)

whiterace.sample <- sample(White, length(Black),replace = TRUE)
apddata.whiteup <- apddata[c(whiterace.sample,Black),]
table(apddata.whiteup$Race)

##_________________________________________________________________##
## Get test and training data, LINK: https://www.youtube.com/watch?v=BQ1VAZ7jNYQ 
## STEP 6 - Data splitting
## randomly split data set into 2 portions
## use set.seed() function, so that result is the same every time
set.seed(123)

## Get 80% of the balanced data set as the training set, 
#and 20% for Test set
size <- floor(0.8 * nrow(apddata.whiteup))
train_data <- sample(seq_len(nrow(apddata.whiteup)),size = size)
trainhalf <- apddata.whiteup[train_data,]
testhalf <- apddata.whiteup[-train_data,]

## Verify the split
#show table proportion - before
prop.table(table(apddata$Race))*100
plot(apddata$Race, col="maroon")

##after
prop.table(table(apddata.whiteup$Race))*100
plot(apddata.whiteup$Race, col="green") 


##_____________________________________________##
##STEP 7- create the train control  function
## Create train control function for K-fold cross validation method  
ctrl <- trainControl(method="cv", number=36,
                     savePredictions ="all",
                     classProbs=TRUE)
##set seed for k-folds
set.seed(123)
##_____________________________________________##
##STEP 8 - Fit the model 
## Logistic regression model, using a generalized linear model (glm)
model <- train(Race~Age+Sex+Arrest.type+Neighborhood,
             data = trainhalf,
             method= "glm", family="binomial",
             trControl=ctrl)
model
summary(model)

##_____________________________________________##
##STEP 9 - Validation 
## validate the model by fitting the model on the test set 
#predict outcome using model from training and apply to test
predictions <- predict(model,newdata=testhalf)

#----------------------------------------------#
## Evaluate the model using confusion matrix 
#confusionMatrix(predictions, testhalf$Race,cutoff = 0.5)
confusionMatrix(data = factor(predictions),
                reference = factor(testhalf$Race),
                positive ="W")

##_________________#
##optimizing the model
## remove the insignificant variables to optimize the model and increase accuracy
#remove Arrest type
##boost model with gbm
ctrl1 <- trainControl(method = "cv", number = 36,
                          classProbs = TRUE)
set.seed(123)
fit <- train(Race ~ Age+Sex-Arrest.type+Neighborhood, data = trainhalf,
             method = "gbm",
             trControl = ctrl1,
             verbose = FALSE)

predicted <- predict(fit,testhalf,type= "prob")[,2]
gbmpred <- as.factor(ifelse(predicted > 0.5,"W","B"))
testhalf$Race <- as.factor(testhalf$Race)
confusionMatrix(gbmpred, testhalf$Race)
summary(fit)
