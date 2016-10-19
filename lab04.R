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
# Title : BMI701 Lab 4: flow control / apply / parallel
# Author : Wei-Hung Weng
# Created : 09/24/2016
# Comment : 


# List of packages for session
.packages <- c("RMySQL", "RPostgreSQL", "sqldf")
# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
# Load packages into session 
lapply(.packages, library, character.only=TRUE)


# flow control

# for
v <- 1:10
vsq <- 0
for(i in 1:10)  {
  vsq[i] <- v[i] * v[i]
  print(paste0(i, ": ", vsq[i]))
}
print(vsq)


# while loop
meaningoflife <- function() {
  n <- readline(prompt="What is the meaning of life and everything: ")
}

response <- as.integer(meaningoflife())

while (response != 42) {
  print("Sorry, the answer to whaterver the question MUST be 42")
  response <- as.integer(meaningoflife())
}


# if/else
if (response %% 2 == 1) {
  ans <- "odd"
} else {
  ans <- "even"
}
print(ans)

# or use ifelse
ans2 <- ifelse(response %% 2 == 1, "odd", "even") 
print(ans2)

# use ifelse for indicator variable
(short <- ifelse(iris$Sepal.Length < 5, 1, 0))


# next / break: skip, to next iterator / exit the loop
for (i in 1:20) {
  if (i %% 5 == 0) next 
  print(i)
}

for (i in 1:20) {
  if (i %% 5 == 0) break 
  print(i)
}

# stop
n <- 1:5
r <- NULL

for (i in seq(n)) {
  if (n[i] < 3) {
    r <- n[i] - 1
    print(paste0("n:", n[i], " r:", r))
  } else {
    print(paste0("n:", n[i]))
    stop("values shall be < 3")
    print("show me this line")
  }
}


# apply
(mymat <- matrix(rep(seq(5), 4), ncol = 5))
apply(mymat, 1, sum)
apply(mymat, 2, sum)

y <- c('cba', 'jklmno', 'a', 'hijz')
(l <- lapply(y, nchar))
str(l)

(s <- sapply(y, nchar))
str(s)

# tapply(value var, group var, function)
(t <- tapply(iris$Sepal.Length, iris$Species, sd))
str(t)


# parallel function
library(foreach)
library(parallel) # detectCores, makeCluster, stopCluster

# e.g. 1 (foreach)
foreach(a=1:3, b=rep(10, 3)) %do% (a + b)
foreach(i=1:3, .combine='c') %do% sqrt(i)
foreach(a=1:3, b=rep(10, 3), .combine='c') %do% (a + b)

# e.g. 2 (mclapply)
processInput <- function(i) i * i
inputs <- 1:10

(numCores <- detectCores())
results <- mclapply(inputs, processInput, mc.cores=numCores)

# you need to use makeCluster/parLapply for Windows (Mac also works)
cl <- makeCluster(numCores)
results <- parLapply(cl, inputs, processInput)
stopCluster(cl)

# e.g. 3 (use foreach + doParallel)
library(doParallel)
numCores <- detectCores()
cl <- makeCluster(numCores)

registerDoParallel(cl)
results <- foreach(i=inputs) %dopar% {
  processInput(i)
}

stopCluster(cl)


# sqldf
library(sqldf)
str(iris)
sqldf("select * from iris limit 10", drv="SQLite")

i1 <- iris[1:10, c(1, 5)]
for (i in 1:10) {
  i1$idx[i] <- i
}
i2 <- iris[1:10, c(2, 5)]
for (i in 1:10) {
  i2$idx[i] <- i
}

sqldf("select * from i1 left join i2 on i1.idx = i2.idx", drv="SQLite")

# system
system("ls -l")
