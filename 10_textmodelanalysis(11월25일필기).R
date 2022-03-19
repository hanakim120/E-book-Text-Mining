#####################################################################
#
#    3부  텍스트 데이터 분석 및 결과 제시 
#       02  토픽 모형 (LDA: latent Dirichlet allocation)
#
####################################################################

install.packages("topicmodels")

library(tidyverse)
library(tm)
library(stringr)
library(topicmodels)

# tm 패키지 함수를 이용한 텍스트 데이터 사전처리 

my.text.location <- "C:/Users/lg/Desktop/Rproject/2019DAspecial/hufs_eng"
mypaper <- VCorpus(DirSource(my.text.location))
mypaper

#   사전처리 수행
#  특수문자의 처리  

transfunc <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
mycorpus <- tm_map(mypaper, transfunc, "(:)|(/)|(\\()|(\\))|(-)|(&)")

mycorpus <- tm_map(mycorpus, removePunctuation)

#  나머지 사전 처리 

mycorpus <- tm_map(mycorpus, removeNumbers)
mycorpus <- tm_map(mycorpus, stripWhitespace)
mycorpus <- tm_map(mycorpus, content_transformer(tolower))
mycorpus <- tm_map(mycorpus, removeWords, words=stopwords("SMART"))
mycorpus <- tm_map(mycorpus, stemDocument, language="en")


# 문서-단어 행렬(DTM: document term matrix) 만들기 

dtm <- DocumentTermMatrix(mycorpus)
dtm


#  TF_IDF (term frequency - inverse document frequency) 매트릭스 만들기 

dtm_tfidf <- DocumentTermMatrix(mycorpus,
    control=list(weighting=function(x) weightTfIdf(x, normalize=FALSE)))
dtm_tfidf

#
#  LDA 토픽모형 구축 
#

#  토픽의 개수를 5개로 k=5로 설정 

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

#
#  상관토픽모형 CTM correlated topic models 
#

ctm_out <- CTM(dtm, control=list(seed=44),k=5)
str(ctm_out)

terms(ctm_out, 12)
posterior_ctm <- posterior(ctm_out)


round(posterior_ctm$topics,3)
terms(posterior_ctm,12)
