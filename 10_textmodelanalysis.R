#####################################################################
#
#    3부  텍스트 데이터 분석 및 결과 제시 
#       02  토픽 모형 (LDA: latent Dirichlet allocation)
#
####################################################################

# install.packages("topicmodels")

library(tidyverse)
library(tm)
library(stringr)
library(topicmodels)

# tm 패키지 함수를 이용한 텍스트 데이터 사전처리 

my.text.location <- "d:/mypaper/hufs_eng"
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


##########################################################
#
#  3부   텍스트 데이터 분석 및 결과 제시
#   03   감정분석  (sentiment analysis)
#       tidytext 패키지를 이용한 텍스트 분석 
#
##########################################################

install.packages("tidytext")
install.packages("textdata")
library(tidytext)
library(textdata)
library(tm)
library(tidyverse)

#
#  텍스트 감정분석을 위한  감정어휘 사전

get_sentiments("afinn")
AFINN <- data.frame(get_sentiments("afinn"))
summary(AFINN)
head(AFINN, 20)
hist(AFINN$value, breaks=20, main="sentiment value in AFINN")
table(AFINN$value)
AFINN %>% filter(value==-5)
AFINN %>% filter(value==0)
AFINN %>% filter(value==5)

get_sentiments("bing")
oplex <- data.frame(get_sentiments("bing"))
head(oplex, 20)
table(oplex$sentiment)

get_sentiments("nrc")
emolex <- data.frame(get_sentiments("nrc"))
head(emolex, 20)
table(emolex$sentiment)
emolex %>% filter(sentiment == "anger")

#
#  텍스트 데이터 호출 

my.text.location <- "G:/mypaper/hufs_eng"
mypaper <- VCorpus(DirSource(my.text.location))
mypaper

length.corp <- length(mypaper)
mytext <- c(rep(NA, length.corp))
for (i in 1:length.corp) {
  mytext[i] <- as.character(mypaper[[i]][1])
}

my.df.text <- data.frame(paper.id=1:length.corp, doc=mytext, stringsAsFactors = FALSE)
View(my.df.text)
str(my.df.text)

# unnest_token() 함수를 이용하여 text변수를 word로 구분함 

my.df.text.word <- my.df.text %>%
                       unnest_tokens(output="word", input="doc")
my.df.text.word
str(my.df.text.word)


#  감정어휘(bing) 사전을 이용한 감정분석

my_sa <- my.df.text.word %>% 
            inner_join(oplex, by="word")
str(my_sa)
View(my_sa)

count(my_sa, sentiment)
count(my_sa, word, sentiment)
count(my_sa, paper.id, sentiment)
count(my_sa, word, paper.id, sentiment)

my_sa %>% 
  count(word, sentiment) %>% 
  spread(sentiment, n, fill=0)
my_sa %>% 
  count(paper.id, sentiment) %>% 
  spread(sentiment, n, fill=0)
my_pattern <- my_sa %>% 
  count(paper.id, sentiment) %>% 
  spread(sentiment, n, fill=0) %>%
  group_by(paper.id) %>%
  summarise(pos.sum=sum(positive),
            neg.sum=sum(negative),
            pos.prop=pos.sum/(pos.sum+neg.sum))
my_pattern

ggplot(my_pattern, aes(x=paper.id, y=pos.sum)) + geom_line() + ylim(0,13)
ggplot(my_pattern, aes(x=paper.id, y=neg.sum)) + geom_line() + ylim(0,13)
ggplot(my_pattern, aes(x=paper.id, y=pos.prop)) + geom_line() + ylim(0,1.2)


#  감정어휘 (affin) 사전을 이용한 감정분석 

my_sa2 <- my.df.text.word %>%
              inner_join(AFINN, by="word")
my_sa2
str(my_sa2)

count(my_sa2, word, value)
count(my_sa2, paper.id, word, value)

my_sa2 %>% 
  group_by(word) %>% 
  summarise(sum_value=sum(value), n=n())

my_sa2 %>% 
  group_by(paper.id) %>% 
  summarise(sum_value=sum(value), n=n())


my_pattern2 <- my_sa2 %>% 
                  group_by(paper.id) %>% 
                  summarise(sum_value=sum(value), n=n())


ggplot(my_pattern2, aes(x=paper.id, y=sum_value)) + geom_line()
