#############################################################
#
#    Intoduction to Text Analytics with R
#
##############################################################

# install.packages("tidyverse")
# install.packages("tm")
# install.packages("wordcloud")
# install.packages("rpart.plot")

library(tidyverse)
library(tm)
library(wordcloud)
library(rpart)
library(rpart.plot)

#
# Import spam dataset from spam.csv
#

spam_raw <- read.csv("spam.csv", stringsAsFactors = FALSE )
View(spam_raw)

# Build a data fream for text analysis

spam_raw <- spam_raw[, 1:2]
names(spam_raw) <- c("label", "text")
View(spam_raw)
spam_raw$label <- as.factor(spam_raw$label)
str(spam_raw)

#
#  Explore the data
#

# the ratio of ham vs spam ?

table(spam_raw$label)
prop.table(table(spam_raw$label))
length(which(!complete.cases(spam_raw)))

# Compute the character length of text messages (ham vs. spam)
# Clean the invalid mutibyte string

spam_raw[1,2]
spam_raw[22,2]

nchar(spam_raw[1,2])
nchar(spam_raw[22,2])
nchar(spam_raw[22,2], allowNA=TRUE)

spam_raw$textlength <- nchar(spam_raw$text, type="chars", allowNA=TRUE)
spam_clean <- spam_raw[!is.na(spam_raw$textlength),]
View(spam_clean)

table(spam_clean$label)
prop.table(table(spam_clean$label))
summary(spam_clean$textlength)

spam_clean %>%
  group_by(label) %>%
  summarise(mean=mean(textlength, na.rm=T), n=n())

ggplot(spam_clean, aes(x=label, y=textlength)) +
  geom_boxplot()

ggplot(spam_clean, aes(x=textlength, fill=label)) +
  geom_histogram(binwidth=5) +
  labs(y="Text Count", x="Length of text", 
       title="Distribution of Text lenths with class labels")

#
#    text handling with the tm package
#

#  Building and inspecting a corpus

spam_corpus <- Corpus(VectorSource(spam_clean$text))
str(spam_corpus)
inspect(spam_corpus[[1]])
spam_corpus[[1]]$meta
spam_corpus[[1]]$content

#  Building Document-Term Matrix (DTM) : Tokenization

spam_dtm <- DocumentTermMatrix(spam_corpus)
spam_dtm
inspect(spam_dtm[1:10, 1:20])

# compute and display word frequencies

word_freq <- apply(spam_dtm, 2, sum)
sorted_word_freq <- sort(word_freq, decreasing=TRUE)
head(sorted_word_freq, 20)
barplot(head(sorted_word_freq, 10))

wordcloud(names(word_freq), freq=word_freq, scale=c(8, 0.2),
          max.words=100, random.order=FALSE)
  
# Building DTM (Tokenization) after text pre-processing

corpus_clean <- tm_map(spam_corpus, tolower)
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords("SMART"))
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

spam_dtm <- DocumentTermMatrix(corpus_clean)
spam_dtm

# compute and display word frequencies

word_freq <- apply(spam_dtm, 2, sum)
sorted_word_freq <- sort(word_freq, decreasing=TRUE)
head(sorted_word_freq, 20)
barplot(head(sorted_word_freq, 10))

wordcloud(names(word_freq), freq=word_freq, scale=c(6, 0.1),
          max.words=100, random.order=FALSE)


#
#  Model building with classifcation methods
#

# reduce DTM by eliminating infrequenct words

spam_dict <- findFreqTerms(spam_dtm, 5)

spam_reduced_dtm <- DocumentTermMatrix(corpus_clean, list(dictionary=spam_dict))
spam_reduced_dtm

# Change class of dtm into dataframe for rpart()

spam_matrix <- as.matrix(spam_reduced_dtm)
spam_df <- as.data.frame(spam_matrix)
spam_df <- cbind(spam_clean$label, spam_df)
names(spam_df)[1] <- "label"
spam_df[1:20, 1:10]

#  Divide data into train and test data sets

set.seed(1234)
index <- sample(1:length(spam_clean[,1]), 0.7*length(spam_clean[,1]))
spam_train <- spam_df[index, ]
spam_test <- spam_df[-index, ]
prop.table(table(spam_train$label))
prop.table(table(spam_test$label))

# build classification trees with rpart

fit <- rpart(label ~ ., method="class", data=spam_train)

prp(fit)

# predict and compute the accuracy within train data set.

train_pred <- predict(fit, spam_train, type="class")

df <- data.frame(actual=spam_train$label, pred=train_pred)
t <- table(df)
t

sum(diag(t))/sum(t)
(t[1,1]+t[1,2])/sum(t)

# predict and compute the accuracy within test data set.

test_pred <- predict(fit, spam_test, type="class")

df <- data.frame(actual=spam_test$label, pred=test_pred)
t <- table(df)
t

sum(diag(t))/sum(t)
(t[1,1]+t[1,2])/sum(t)
