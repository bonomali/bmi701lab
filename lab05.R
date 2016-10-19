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
# Title : BMI701 Lab 5: NLP text mining
# Author : Wei-Hung Weng
# Created : 10/17/2016
# Comment : 


# List of packages for session
.packages <- c("data.table", "tm", "SnowballC", "wordcloud", "ggplot2", 
               "rpart", "caret", "fpc", "cluster")
# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
# Load packages into session 
lapply(.packages, library, character.only=TRUE)


setwd("~/git/bmi701lab/lab05_text/")

# Read files
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

# Transforms
corpus <- Corpus(VectorSource(text))
corpus
head(summary(corpus))

corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, PlainTextDocument)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, c(stopwords("english")))
corpus <- tm_map(corpus, stemDocument)

dtm <- DocumentTermMatrix(corpus)
# dtm <- DocumentTermMatrix(corpus,
#                            control=list(weighting=function(x) weightTfIdf(x, normalize=TRUE),
#                                         stopwords=TRUE))

dtm <- removeSparseTerms(dtm, 0.995)

findFreqTerms(dtm, lowfreq=100)

findAssocs(dtm, "like", corlimit=0.05)

df <- data.frame(as.matrix(dtm))

# word cloud
wordcloud(colnames(df), colSums(df), scale=c(5, 1), max.words=250, min.freq=10, 
          color=brewer.pal(6, "Dark2"), vfont=c("sans serif", "plain"))

# plot
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)
p <- ggplot(subset(wf, freq > 30), aes(word, freq)) 
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p


# clustering
d <- dist(t(dtm), method="euclidian")
km <- kmeans(d, 2)
clusplot(as.matrix(d), km$cluster, color=T, shade=T, labels=2, lines=0)


# supervised learning
df$polarity <- as.factor(data$polarity)

set.seed(123)
inTraining <- createDataPartition(df$polarity, p=0.7, list=F)
training <- df[ inTraining, ]
testing <- df[-inTraining, ]

# CART
model = rpart(polarity~., data=training)
summary(model)
plot(model, uniform=TRUE)
text(model, use.n=TRUE)

tst <- testing
tst$polarity = NULL
pred <- predict(model, tst, type="class")
confusionMatrix(testing$polarity, pred)

# svm
control <- trainControl(method="cv", number=5)
model <- train(polarity~., data=training, method='svmLinear', trControl=control, verbose=F)
pred <- predict(model, tst, type="raw")
confusionMatrix(testing$polarity, pred)


# regex
text <- "Indication: Endocarditis. Valvular heart disease."

grepl("Indication: (.*)", text)
gsub("(Indication: )(.*)(.*)", "\\2", text)
gsub("(Indication: )([aA-zZ]+)(.*)", "\\2", text)
gsub("(Indication: [aA-zZ]+. )([aA-zZ ]+)(.*)", "\\2", text)


text <- "
Indication: Endocarditis. Valvular heart disease.
Height: (in) 64
Weight (lb): 170
BSA (m2): 1.83 m2
BP (mm Hg): 92/61
"

grepl("Height: \\(in\\) (.*?)\n", text)
gsub("(.*Height: \\(in\\) )([0-9]{2})(\n.*)", "\\2", text) # ht

gsub("(.*BP \\(mm Hg\\): )([0-9]+)(/[0-9]+\n.*)", "\\2", text) # sbp

