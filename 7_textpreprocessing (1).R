#####################################################################
#
#    2부   텍스트 데이터 사전처리
#       04  말뭉치(corpus) 텍스트 데이터 사전처리(pre-processing)
#
####################################################################

library(tidyverse)
library(stringr)
library(tm)

# 1. 공란 처리 (stripping white space)

mytext <- c("software environment", "software  environment", "software\tenvironment")
mytext

str_split(mytext, " ")
sapply(str_split(mytext, " "), length)
sapply(str_split(mytext, " "), str_length)

mytext.nowhitespace <- str_replace_all(mytext,"[[:space:]]{1,}", " ")
mytext.nowhitespace
sapply(str_split(mytext.nowhitespace, " "), length)
sapply(str_split(mytext.nowhitespace, " "), str_length)

# 2. 대/소 문자 통일

mytext <- "The 45th President of the United States, Donald Trump, states that he knows how to play trump with the former president"
myword <- unlist(str_extract_all(mytext, boundary("word")))
table(myword)

myword <- str_replace(myword, "Trump", "Trump_unique_")
myword <- str_replace(myword, "States", "States_unique_")
table(tolower(myword))

# 3. 숫자표현 제거 

mytext <- c("He is one of statisticians agreeing that R is the No. 1 statistcal software.", "He is one of statisticians agreeing that R is the No. one statistical software.")
mytext
str_split(mytext, " ")

mytext2 <- str_split(str_replace_all(mytext, "[[:digit:]]{1,}[[:space:]]{1,}",""), " ")
str_c(mytext2[[1]], collapse=" ")
str_c(mytext2[[2]], collapse=" ")

mytext3 <- str_split(str_replace_all(mytext, "[[:digit:]]{1,}[[:space:]]{1,}", "_number_"), " ")
str_c(mytext3[[1]], collapse=" ")
str_c(mytext3[[2]], collapse=" ")

# 4. 문장부호 및 특수문자 제거 

mytext <- "Baek et al. (2014) argued that the state of default-setting is critical for people to protect their own personal privacy on the Internet."
mytext
str_split(mytext, "\\. ")
str_split(mytext, " ")

str_extract_all(mytext, "[[:punct:]]+")
str_extract_all(mytext,"[[:alnum:]]*[[:punct:]][[:alnum:]]*")

mytext2 <- str_replace_all(mytext, "-", " ")
mytext2 <- str_replace_all(mytext2, "[[:upper:]]{1}[[:alpha:]]{1,}[[:space:]](et al\\.)[[:space:]]\\([[:digit:]]{4}\\)", "_reference_")
mytext2 <- str_replace_all(mytext2, "\\.$", "")
mytext2

# 5. 불용단어 (stopword) 제거 

mytext <- c("She is an actor", "She is the actor")
mystopwords <- "(\\ba )|(\\ban )|(\\bthe )"
str_replace_all(mytext, mystopwords, "")

length(stopwords("en"))
stopwords("en")
length(stopwords("SMART"))
stopwords("SMART")


#  어근 동일화 처리 

mystemmer.func <- function(mytectobject){
  mytext <- str_replace_all(mytext,
        "(\\bam )|(\\bare )|(\\bis )|(\\bwas )|(\\bwere )|(\\bbe )", "be ")
  mytext
}

mytext <- c("I am a boy. You are a boy. He might be a boy.")
mytext.stem <- mystemmer.func(mytext)

table(str_split(mytext, " "))
table(str_split(mytext.stem, " "))

# 엔그랜(n-gram) 적용 

mytext <- "The United States comprise fifty states. In the United States, each state has its own laws. However, federal law overrides state law in the United States."
myword <- unlist(str_extract_all(mytext, boundary("word")))
length(table(myword))
sum(table(myword))

mytext.2gram <- str_replace_all(mytext, "\\bUnited States", "United_States")
myword2 <- unlist(str_extract_all(mytext.2gram, boundary("word")))
length(table(myword2))
sum(table(myword2))

#
# tm 패키지 함수를 이용한 텍스트 데이터 사전처리 
#

# tm을 이용한 말뭉치 (Corpus) 입력 및 확인   

my.text.location <- "E:/mypaper/hufs_eng"
mypaper <- VCorpus(DirSource(my.text.location))
mypaper
summary(mypaper)
str(mypaper)
mypaper[[2]]
mypaper[[2]]$content
mypaper[[2]]$meta
meta(mypaper[[2]], tag="author") <- "JaeWook Yoon"
meta(mypaper[[2]])
inspect(mypaper)
inspect(mypaper[[2]])

mytext_c <- VCorpus(VectorSource(mytext))
mytext_c
summary(mytext_c)
mytext_c[[1]]
mytext_c[[1]]$content
mytext_c[[1]]$meta


#
#  특수문자, 수치, 대문자 확인 
#

#  특수문자의 확인 
myfunc <- function(x){str_extract_all(x, "[[:punct:]]{1}")}
mypuncts <- lapply(mypaper, myfunc)
table(unlist(mypuncts))

# 특수문자 사용 전후에 단어를 함께 확인하기 
myfunc <- function(x) {str_extract_all(x, "[[:alnum:]]{1,}[[:punct:]]{1}[[:alnum:]]{1,}")}
mypuncts <- lapply(mypaper, myfunc)
table(unlist(mypuncts))


#  숫자의 확인 
myfunc <- function(x) {str_extract_all(x, "[[:digit:]]{1,}")}
mydigits <- lapply(mypaper, myfunc)
table(unlist(mydigits))

#  대문자 확인 
myfunc <- function(x) {str_extract_all(x, "[[:upper:]]{1}[[:alpha:]]{1,}")}
myuppers <- lapply(mypaper, myfunc)
table(unlist(myuppers))

myfunc <- function(x) {str_extract_all(x, "[[:upper:]]{2,}[[:alnum:]]*")}
myuppers2 <- lapply(mypaper, myfunc)
table(unlist(myuppers2))

#
#   사전처리 수행
#
#  특수문자의 처리  

transfunc <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
mycorpus <- tm_map(mypaper, transfunc, "(-)|(&)|(\\()|(\\))|(/)|(:)")

myfunc <- function(x){str_extract_all(x, "[[:punct:]]{1}")}
mypuncts <- lapply(mycorpus, myfunc)
table(unlist(mypuncts))

mycorpus <- tm_map(mycorpus, removePunctuation)

# 특수문자 사용 전후에 단어를 함께 확인하기 
myfunc <- function(x) {str_extract_all(x, "[[:alnum:]]{1,}[[:punct:]]{1}[[:alnum:]]{1,}")}
mypuncts <- lapply(mycorpus, myfunc)
table(unlist(mypuncts))


# transfunc <- content_transformer(function(x, pattern) gsub(pattern, "", x))
# mycorpus <- tm_map(mycorpus, transfunc, "(\\')")
# (', ") 처리가 되지 않음 (지우지 못함) 

myfunc <- function(x){str_extract_all(x, "[[:punct:]]{1}")}
mypuncts <- lapply(mycorpus, myfunc)
table(unlist(mypuncts))


#  대문자 처리:  대문자 2개이상은 약어로 남겨둠 (처리 못함)

#  tm_map()함수를 이용한 사전 처리 

mycorpus <- tm_map(mycorpus, removeNumbers)
mycorpus <- tm_map(mycorpus, stripWhitespace)
mycorpus <- tm_map(mycorpus, content_transformer(tolower))
mycorpus <- tm_map(mycorpus, removeWords, words=stopwords("SMART"))
mycorpus <- tm_map(mycorpus, stemDocument, language="en")


#  사전처리된 corpus 확인하기

mycharfunc <- function(x){str_extract_all(x, ".")}
mywordfunc <- function(x){str_extract_all(x, boundary("word"))}

#  사전처리 이전의 corpus (mypaper) 글자와 단어수 확인 
mychar <- lapply(mypaper, mycharfunc)
myuniquechar0 <- length(table(unlist(mychar)))
mytotalchar0 <- sum(table(unlist(mychar)))
myword <- lapply(mypaper, mywordfunc)
myuniqueword0 <- length(table(unlist(myword)))
mytotalword0 <- sum(table(unlist(myword)))

#  사전처리 이후 corpus(mycorpus) 글자와 단어수 확인 
mychar <- lapply(mycorpus, mycharfunc)
myuniquechar1 <- length(table(unlist(mychar)))
mytotalchar1 <- sum(table(unlist(mychar)))
myword <- lapply(mycorpus, mywordfunc)
myuniqueword1 <- length(table(unlist(myword)))
mytotalword1 <- sum(table(unlist(myword)))

#  변화된 내용 확인하기 
results.comparing <- rbind( 
  c(myuniquechar0, myuniquechar1), 
  c(mytotalchar0, mytotalchar1),
  c(myuniqueword0, myuniqueword1), 
  c(mytotalword0, mytotalword1))
colnames(results.comparing) <- c("before", "after")
rownames(results.comparing) <- c("고유문자수","총문자수", "고유단어수", "총단어수")
results.comparing

#
# 문서-단어 행렬(DTM: document term matrix) 만들기 
#

dtm <- DocumentTermMatrix(mycorpus)
dtm
str(dtm)

rownames(dtm)
colnames(dtm)

dtm[1:5, 1:10]
inspect(dtm)
inspect(dtm[1:10, 1:10])

#  TF_IDF (term frequency - inverse document frequency) 매트릭스 만들기 

dtm_tfidf <- DocumentTermMatrix(mycorpus,
    control=list(weighting=function(x) weightTfIdf(x, normalize=FALSE)))
dtm_tfidf

#  DTM vs TF-IDF 행렬의 비교 

inspect(dtm[1:10, 5:10])
inspect(dtm_tfidf[1:10, 5:10])

#  DTM과  DTM-TFIDF의 상관관계 분석 

value.tf.dtm <- as.vector(as.matrix(dtm))
value.tfidf.dtm <- as.vector(as.matrix(dtm_tfidf))
word.label.dtm <- rep(colnames(dtm), each=dtm$nrow)
doc.label.dtm <- rep(rownames(dtm), dtm$ncol)
mydata <- data.frame(word.label.dtm, doc.label.dtm, value.tf.dtm, value.tfidf.dtm)
colnames(mydata) <- c("word.label", "doc.label", "tf", "tfidf")
head(mydata, 100)

cor.test(mydata$tf, mydata$tfidf, method="kendall")

nonzero.data <- mydata %>%  filter(mydata$tf > 0)
cor.test(nonzero.data$tf, nonzero.data$tfidf, method="kendall")  

nonzero.data %>%
  arrange(desc(tf)) %>%
  head(50)

