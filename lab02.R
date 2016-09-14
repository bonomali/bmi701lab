# The MIT License (MIT)
# 
#   Copyright (c) 2016 Wei-Hung Weng
# 
#   Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE. 
# 
# Title   : BMI701 Lab 2: R syntax / Database using R
# Author  : Wei-Hung Weng
# Created : 08/16/2016
# Comment : 


# List of packages for session
.packages <- c("ggplot2", "RMySQL")
# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
# Load packages into session 
lapply(.packages, library, character.only=TRUE)
# setup working directory
setwd("~/git/bmi701lab/")

# basic syntax
3 + 4
2^5
exp(log(4^3))

x <- 4 * 9
y <- c("Harvard", "MIT", "Beaver")

x
y

# data type
is.character(3)
is.numeric(3)
is.integer(3)
is.complex(3)
is.logical(3)
as.character(3)
as.numeric(3)
as.integer(3.5)
as.complex(3)
as.logical(3)

NA
is.na(NA)
na.omit(c(NA, "Zak", 5))

read.csv("ANY_PATH_ON_YOUR_LAPTOP_OR_ANY_URL")
read.table("ANY_PATH_ON_YOUR_LAPTOP_OR_ANY_URL", sep="\t")

write.csv("PATH")
write.table("PATH", sep="\t")

c(1, 2, 3)
c(1:10)
c(1, 2, "a", "b")
seq(from=5, to=100, by=20)
rep(c(3, 5), each=4, length=10)

y[1]

tolower(y)
toupper(y)
paste(y, "Adam")
paste("Adam", "Wright", sep="+")
paste("BMI", 701:705, sep=".", collapse="|")
paste0("Adam", "Wright")

strsplit("Adam is cool", " ")

x <- c(1, 2, 2, 6, 7, 6, 2, 5, 3)
factor(x)

matrix(c(1:25), nrow=5, ncol=5, byrow=FALSE)

df <- data.frame(iris)
df1 <- df[, c(1:2, 5)]
df1$idx <- rownames(df)
df2 <- df[, c("Sepal.Length", "Petal.Length", "Species")]
df2$idx <- rownames(df)

df3 <- cbind(df1, df2)
df4 <- merge(df1, df2, by=c("idx", "Species"))

df5 <- df[1:50, ]
df6 <- df[51:150, ]
df7 <- rbind(df5, df6)


# logic flow
if (10 > 5) {
  print("10 is larger than 5")
} else {
  print("5 is larger than 10")
}

for (i in 1:100) {
  print(i)
}

x <- 10
while (x > 5) {
  print(x)
  x <- x - 1
} 


# apply: lab 4
apply(iris$Sepal.Width, FUN=mean)


# regex: lab 6
grep(pattern="^a.*y$", x=c("ally", "awesome", "elly"), ignore.case=TRUE)
sub(pattern="^a.*y$", replacement="NO", x=c("ally", "awesome", "elly"), ignore.case=TRUE)


# plot: lab 7
plot(iris)


# other useful functions
str(iris)
head(iris)
summary(iris)
setwd()
# ctrl + l
# ?


# create your function
f <- function(x) {
  sum <- 0
  if (x == 1 | x == 2) {
    sum <- 1
  } else {
    sum <- f(x-1) + f (x-2)
  }
  return(sum)
}

for (i in 1:10) print(f(i))


# function demo
library(caret)
model <- train(Species ~ ., iris, method = "svmLinear")
pred <- predict(model, iris)
confusionMatrix(iris$Species, pred)


# database
con <- dbConnect(MySQL(), user="root", password="", 
                 dbname="gwas", host="localhost")
dbListTables(con)
dbGetQuery(con, "select * from gwas")

cons <- dbListConnections(MySQL())
for (con in cons) {dbDisconnect(con)}
