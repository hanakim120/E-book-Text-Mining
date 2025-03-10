
library(tm)
library(tidyverse)
library(stringr)
library(topicmodels)
library(wordcloud)
library(RColorBrewer)
library(tidytext)
library(dplyr)

#데이터불러오기, corpus 구성
jekyll <- "C:/Users/lg/Desktop/Rproject/2019DAspecial/jekyll"
jekyll <- VCorpus(DirSource(jekyll))
summary(jekyll)

jekyll$content
inspect(jekyll)
jekyll[[1]]$content
jekyll[[1]]$meta

#Preprocessing

#특수문자 사용 전후의 단어 살피기
myfunc <- function(x) {str_extract_all(x, "[[:alnum:]]{1,}[[:punct:]]{1}?[[:alnum:]]{1,}")}
mypuncts <- lapply(jekyll, myfunc)
table(unlist(mypuncts))

#숫자표현 살피기
myfunc <- function(x) {str_extract_all(x,"[[:digit:]]{1,}")}
mydigits <-lapply(jekyll,myfunc)
table(unlist(mydigits))

#고유명사 살피기
myfunc <- function(x) {str_extract_all(x,"[[:upper:]]{1}[[:alpha:]]{1,}")}
myuppers <-lapply(jekyll,myfunc)
table(unlist(myuppers))

#숫자표현 제거
jekyllcorpus <- tm_map(jekyll, removeNumbers)

#특수문자 교체

trans <- content_transformer(function(x,from,to) gsub(from,to,x))
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(co-)","co")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "-like","like")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "-glass","glass")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(cross-)","cross")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(double-)","double")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(down-)","down")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(easy-)","easy")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "-will","will")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(half-)","half")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(hide-)","hide")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(horror-)","horror")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(knife-)","knife")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(light-)","light")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(lock-)","lock")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(loose-)","loose")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(old-)","old")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(passer-)","passer")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(post-)","post")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(re-)","re")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(ready-)","ready")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(to-)","to")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "-faced","faced")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(tut-)","tut")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "-for","for")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\b(jack-)","jack")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "O'clock","Oclock")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "_th","th")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\?","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\'s","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\'t","not")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\'ll","will")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\'m","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\'ve","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\\'re","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "-"," ")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\"","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\'","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\‘[[:alnum:]]*","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\’[[:alnum:]]*","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\“[[:alnum:]]*","")
jekyllcorpus <-tm_map(jekyllcorpus, trans, "\”","")
#특수문자 제거
jekyllcorpus <-tm_map(jekyllcorpus, removePunctuation)

#공란 제거
jekyllcorpus <-tm_map(jekyllcorpus, stripWhitespace)

#대소문자 통합
jekyllcorpus <-tm_map(jekyllcorpus, content_transformer(tolower))

#불용단어 제거
jekyllcorpus <-tm_map(jekyllcorpus, removeWords, words=stopwords("SMART"))

#어근 동일화 처리
jekyllcorpus <-tm_map(jekyllcorpus, stemDocument, language="en")

#전처리 전 후 비교
mycharfunc <-function(x) {str_extract_all(x,".")}
mywordfunc <-function(x) {str_extract_all(x,boundary("word"))}

#전처리 전
mychar <- lapply(jekyll, mycharfunc)
myuniquechar0 <-length(table(unlist(mychar)))
mytotalchar0 <-sum(table(unlist(mychar)))
myword <- lapply(jekyll, mywordfunc)
myuniqueword0 <-length(table(unlist(myword)))
mytotalword0 <-sum(table(unlist(myword)))

#전처리 후
mychar<- lapply(jekyllcorpus, mycharfunc)
myuniquechar1 <-length(table(unlist(mychar)))
mytotalchar1 <-sum(table(unlist(mychar)))
myword <- lapply(jekyllcorpus, mywordfunc)
myuniqueword1 <-length(table(unlist(myword)))
mytotalword1 <-sum(table(unlist(myword)))

#전처리 전 후 비교
results.comparing <- rbind(
  +c(myuniquechar0,myuniquechar1),
  +c(mytotalchar0,mytotalchar1),
  +c(myuniqueword0,myuniqueword1),
  +c(mytotalword0,mytotalword1))

colnames(results.comparing) <- c("before","after")
rownames(results.comparing) <- c("고유문자 수","총 문자 수","고유단어 수","총 단어 수")
results.comparing

#DTM 구축
dtm.j <- DocumentTermMatrix(jekyllcorpus)
dtm.j
View(dtm.j)
#빈도표
word.freq <- apply(dtm.j[,],2,sum)
head(word.freq,50)
sort.word.freq <- sort(word.freq,decreasing=TRUE)
sort.word.freq[1:20]

#누적 빈도 계산
cumsum.word.freq <- cumsum(sort.word.freq)
cumsum.word.freq[1:20]
prop.word.freq <- cumsum.word.freq/cumsum.word.freq[length(cumsum.word.freq)]
prop.word.freq[1:20]

#wordcloud
display.brewer.all()
pal<- brewer.pal(4,"Dark2")
wordcloud(names(word.freq),freq=word.freq,scale=c(4,0.2),rot.per = 0.2,min.freq=10,random.order=FALSE,col=pal)




#LDA
lda_out <- LDA(dtm.j, control=list(seed=11),k=5)
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


#  토픽의 개수를 3개로 k=5로 설정

lda_out <- LDA(dtm.j, control=list(seed=11),k=3)

dim(lda_out@beta)
dim(lda_out@gamma)

terms(lda_out,12)
posterior_lda <- posterior(lda_out)
round(posterior_lda$topics, 3)

#상관모형
ctm_out <- CTM(dtm.j, control=list(seed=44),k=5)
str(ctm_out)

terms(ctm_out, 12)
posterior_ctm <- posterior(ctm_out)


round(posterior_ctm$topics,3)
terms(posterior_ctm,12)


#감정분석
my.text.location <-"C:/Users/lg/Desktop/Rproject/2019DAspecial/jekyll"
mypaper<-VCorpus(DirSource(my.text.location),readerControl = list(language="en"))
mytxt<-c(rep(NA),1)
mytxt
for(i in 1){ mytxt[i] <- as.character(mypaper[[i]][1])}
my.df.text <- data_frame(paper.id=1,doc=mytxt)
my.df.text
my.df.text.word <-my.df.text %>% unnest_tokens(word,doc)
my.df.text.word
myresult.sa <- my.df.text.word %>% inner_join(get_sentiments("bing"))%>% count(word,paper.id,sentiment) %>% spread(sentiment,n,fill=0)
myresult.sa
myagg <-summarise(group_by(myresult.sa,paper.id), pos.sum=sum(positive), neg.sum=sum(negative), pos.sent=pos.sum-neg.sum)
myagg
