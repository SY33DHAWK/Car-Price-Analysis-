options(max.print = 99999999)


mydata <- read.csv("D:/AIUB Docs/Introduction to Data Science/pr/car_price_prediction_ 2.csv",header = TRUE, sep =",")
mydata


install.packages(c("dplyr","tidyr"))
install.packages(c("tidyverse","Amelia"))
library(dplyr)
library(tidyr)
library(tidyverse)
library(Amelia)

str(mydata)

summary(mydata)

options(scipen = 999)

hist(mydata$Price,
     main = "Histogram of Price",
     xlab = "Price",
     col = "lightblue",
     border = "white")


hist(mydata$Mileage,
     main = "Histogram of Mileage",
     xlab = "Mileage",
     col = "lightgreen",
     border = "white")


mydata$Brand <- factor(mydata$Brand)
mydata$Model <- factor(mydata$Model)
mydata$Fuel.Type <- factor(mydata$Fuel.Type)
mydata$Transmission <- factor(mydata$Transmission)
mydata$Condition <- factor(mydata$Condition)

mydata$Year <- as.integer(mydata$Year)

str(mydata)

colSums(is.na(mydata))

missmap(mydata, main = "Missing Values Map")


Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

num_cols <- c("Engine.Size", "Mileage", "Price")

for (col in num_cols) {
  mydata[[col]][is.na(mydata[[col]])] <- median(mydata[[col]], na.rm = TRUE)
}

cat_cols <- c("Brand", "Model", "Fuel.Type", "Transmission", "Condition")

for (col in cat_cols) {
  mydata[[col]][is.na(mydata[[col]])] <- Mode(mydata[[col]])
}

mydata <- mydata %>% filter(
  Mileage > 0,
  Price > 0,
  Year >= 1990 & Year <= 2025
)
str(mydata)



sum(duplicated(mydata))

mydata <- mydata[!duplicated(mydata), ] 

Q1 <- quantile(mydata$Price, 0.25)
Q3 <- quantile(mydata$Price, 0.75)
IQR_price <- Q3 - Q1

lower_price <- Q1 - 1.5 * IQR_price
upper_price <- Q3 + 1.5 * IQR_price

price_outliers <- mydata$Price[mydata$Price < lower_price | mydata$Price > upper_price]

boxplot(mydata$Price, main = "Boxplot of Price (with Outliers)") 

mydata$Price <- ifelse(mydata$Price > upper_price, upper_price,
                       ifelse(mydata$Price < lower_price, lower_price, mydata$Price))



Q1_m <- quantile(mydata$Mileage, 0.25)
Q3_m <- quantile(mydata$Mileage, 0.75)
IQR_mileage <- Q3_m - Q1_m

lower_m <- Q1_m - 1.5 * IQR_mileage
upper_m <- Q3_m + 1.5 * IQR_mileage


mileage_outliers <- mydata$Mileage[mydata$Mileage < lower_m | mydata$Mileage > upper_m]

boxplot(mydata$Mileage, main = "Boxplot of Mileage (with Outliers)")

mydata$Mileage <- ifelse(mydata$Mileage > upper_m, upper_m,
                         ifelse(mydata$Mileage < lower_m, lower_m, mydata$Mileage))




current_year <- 2025
mydata$Car_Age <- current_year - mydata$Year

mydata$Age_Group <- cut(mydata$Car_Age,
                        breaks = c(-Inf, 5, 10, Inf),
                        labels = c("New", "Moderate", "Old"),
                        right = TRUE)

mydata$Engine_Category <- cut(mydata$Engine.Size,
                              breaks = c(-Inf, 2.0, 3.5, Inf),
                              labels = c("Small", "Medium", "Large"))


mydata$Price_z     <- scale(mydata$Price)
mydata$Mileage_z   <- scale(mydata$Mileage)
mydata$Engine_z    <- scale(mydata$Engine.Size)




minmax <- function(x) { (x - min(x)) / (max(x) - min(x)) }

mydata$Price_norm   <- minmax(mydata$Price)
mydata$Mileage_norm <- minmax(mydata$Mileage)
mydata$Engine_norm  <- minmax(mydata$Engine.Size)









data1 <- read.csv("F:/DS MID PROJECT/Car Price Prediction.csv")

data1

missing_before <- sum(is.na(data1$Price))
missing_before

data1 <- data1 %>% filter(!is.na(Price)) 

missing_after <- sum(is.na(data1$Price))
missing_after

q1  <- quantile(data1$Price, 0.01)
q99 <- quantile(data1$Price, 0.99)
q1; q99

low_out_before  <- sum(data1$Price < q1) 
high_out_before <- sum(data1$Price > q99)
low_out_before; high_out_before

data1 <- data1 %>% filter(Price >= q1, Price <= q99) 

low_out_after  <- sum(data1$Price < q1)
high_out_after <- sum(data1$Price > q99)
low_out_after; high_out_after

names(data1) 

data1 <- data1 %>% select(-`Car.ID`) 

names(data1)

n_final <- nrow(data1) 
n_final

set.seed(123)  
index <- sample(1:n_final, size = 0.8 * n_final)

train <- data1[index, ]
test  <- data1[-index, ]


nrow(train) 
nrow(test)

summary(train$Price)
summary(test$Price)
