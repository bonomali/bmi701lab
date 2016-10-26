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
# Title : BMI701 Lab 6: Topic modeling / cTAKES
# Author : Wei-Hung Weng
# Created : 10/26/2016
# Comment : 


.packages <- c("data.table", "tm", "SnowballC", "topicmodels", "caret")
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
lapply(.packages, library, character.only=TRUE)

setwd("~/git/bmi701lab/lab05_text/")

fname <- list.files(path=".")[grepl("lab05", list.files(path="."))]
data <- data.table()

for (i in 1:length(fname)) {
  con <- file(fname[i], open='r')
  tmp <- readLines(con)
  tmp <- data.table(sentence=sapply(tmp, gsub, pattern=",", replacement=" "))
  tmp$polarity <- i
  tmp <- tmp[1:500, ]
  data <- rbind(data, tmp)
  rm(tmp)
}
text <- data$sentence
text <- gsub("[[:punct:]]", "", text)
text <- iconv(text, "latin1", "ASCII", sub="")

corpus <- Corpus(VectorSource(text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, PlainTextDocument)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, c(stopwords("english")))
corpus <- tm_map(corpus, stemDocument)

freq <- DocumentTermMatrix(corpus)

dtm <- data.frame(as.matrix(freq))
fit.lda <- LDA(dtm, 2)
topic.lda <- data.frame(doc = rownames(dtm), 
                        truth = data$polarity,
                        class = topics(fit.lda), 
                        topic = fit.lda@gamma)

confusionMatrix(topic.lda$class, topic.lda$truth)

tdm <- data.frame(t(as.matrix(freq)))
fit.lda2 <- LDA(tdm, 2)
topic.lda2 <- data.frame(concept = names(topics(fit.lda2)), 
                         class = topics(fit.lda2), 
                         topic = fit.lda2@gamma)

# cTAKES
system("sh ~/CTAKES_HOME/bin/runctakesCVD.sh")
system("sh ~/CTAKES_HOME/bin/runctakesCPE.sh")

system("sh ~/CTAKES_HOME/bin/pipeline.sh")
