library(KoNLP)
library(stringr)
library(tm)
library(quanteda)
library(dplyr)
library(tidyverse)
library(topicmodels)

alice <-readLines("alice.csv")

str(alice)
class(alice)
View(alice)
head(alice,50) #41부터 3368까지 내용

alice <- as.data.frame(alice, stringsAsFactors=T)

alice <-  alice[41:3368,]
str(alice)
table(unlist(alice))
alice <-rename(alice, word=Var1)



str(alice)
View(alice)
alice_word <-filter(alice, nchar()>=2)



View(alice)
alice <-as.vector(alice)
str(alice)

alicesentence <-str_split(alice, " ")
View(alicesentence)

alice <- "C:/Users/lg/Desktop/Rproject/2019DAspecial/alice"
alice <- VCorpus(DirSource(alice))
alice
View(alice)
alice <- tm_map(alice, removeNumbers)
alice <- tm_map(alice, stripWhitespace)
alice <- tm_map(alice, content_transformer(tolower))







dtm <- DocumentTermMatrix(alice)
dtm
View(dtm)
inspect(dtm)

dtm_tfidf <- DocumentTermMatrix(alice,
                                control=list(weighting=function(x) weightTfIdf(x, normalize=FALSE)))
dtm_tfidf
inspect(dtm_tfidf)



lda_out <- LDA(dtm, control=list(seed=11),k=5)
#랜덤하게 결과가 변화되기 때문에 seed값을 주는것, k=5토픽5개로 결정하라고
str(lda_out)

# 토픽 * 단어 행렬 
dim(lda_out@beta)
lda_out@beta[,1:20]

terms(lda_out,12)

head(sort(lda_out@beta[1,], decreasing=TRUE),20)

#  문서 * 토픽 행렬 
dim(lda_out@gamma)
lda_out@gamma

posterior_lda <- posterior(lda_out)
round(posterior_lda$topics, 3)

#
#  토픽의 개수를 3개로 k=5로 설정

lda_out <- LDA(dtm, control=list(seed=11),k=3)

dim(lda_out@beta)
dim(lda_out@gamma)

terms(lda_out,12)
posterior_lda <- posterior(lda_out)
round(posterior_lda$topics, 3)

#상관모형
ctm_out <- CTM(dtm, control=list(seed=44),k=5)
str(ctm_out)

terms(ctm_out, 12)
posterior_ctm <- posterior(ctm_out)


round(posterior_ctm$topics,3)
terms(posterior_ctm,12)
