########################################################################
#
#   2부  텍스트 데이터 사전처리  
#     05 한국어 텍스트 데이터 처리 
#
########################################################################

# install.packages("KoNLP")
library(KoNLP)
library(tm)
library(tidyverse)


#
#  KoNLP 기본함수 이해하기 
#

#  사전 구성과 명사 추출 

useSejongDic()
?useSejongDic

sentence1 <- c("롯데마트가 판매하고 있는 흑마늘 양념 치킨이 논란이 되고 있다")
extractNoun(sentence1)
?extractNoun

sentence2 <- c("R은 free 소프트웨어이고, 완전하게 무보증입니다", 
               "일정한 조건에 따르면, 자유롭게 이것을 재배포할 수 있습니다.")
extractNoun(sentence2)

#  품사 (POS part of speech) 태깅 

pos1_9 <- SimplePos09(sentence1)
pos1_9
str(pos1_9)
?SimplePos09

pos1_22 <- SimplePos22(sentence1)
pos1_22

pos2_9 <- SimplePos09(sentence2)
str(pos2_9)


# 형태소 분석 (Morph analysis)

mor_an <- MorphAnalyzer(sentence1)
mor_an
str(mor_an)
?MorphAnalyzer

# 다른 사전의 System, Sejong, NIA 활용의 차이점 

useSystemDic()

sentence3 <- c("성긴털제비꽃은 너무 예쁘다.")
extractNoun(sentence3)
SimplePos09(sentence3)
SimplePos22(sentence3)
MorphAnalyzer(sentence3)

useSejongDic()

extractNoun(sentence3)
SimplePos09(sentence3)
SimplePos22(sentence3)
MorphAnalyzer(sentence3)

useNIADic()

extractNoun(sentence3)
SimplePos09(sentence3)
SimplePos22(sentence3)
MorphAnalyzer(sentence3)


# 사용자 정의의  사전 구축

buildDictionary(ext_dic="woorimalsam")
sentence4 <- c("할리우드 톱스타 레오나르도 디카프리오는 선행전도가 다운 행보를 이어갔다.")
extractNoun(sentence4)

buildDictionary(ext_dic="woorimalsam", user_dic=data.frame("디카프리오","ncn"), replace_usr_dic=T)
extractNoun(sentence4)

head(get_dictionary("user_dic"))


#  AutoSpacing의 지정

sentence5 <- c("아버지가방에들어가셨다.")

useSystemDic()
extractNoun(sentence5)
SimplePos09(sentence5)
MorphAnalyzer(sentence5)

extractNoun(sentence5, autoSpacing = T)
SimplePos09(sentence5, autoSpacing = T)
MorphAnalyzer(sentence5, autoSpacing = T)

#
#  한국어 논문 초록 텍스트 분석 
#

# 한국어 논문 초록 읽어들이기 

my.text.location <- "C:/Users/lg/Desktop/Rproject/2019DAspecial/hufs_kor"
mypaper <- VCorpus(DirSource(my.text.location))
mypaper
mypaper[[19]]$content

#  한국어 텍스트 벡터에서 명사의 추출 

mykorean <- mypaper[[19]]$content
mykorean

useSejongDic()
noun.mytext <- extractNoun(mykorean)
noun.mytext
table(noun.mytext)
length(table(noun.mytext))
sum(table(noun.mytext))
SimplePos09(mykorean)

 #  영문과 특수문자의 사전처리 후 명사추출 

mytext <- str_replace_all(mykorean, "[[:alnum:]]", "")
mytext <- str_replace_all(mytext, "[[:punct:]]", "")
mytext

mytext <- str_replace_all(mykorean, "[[:lower:]]", "")
mytext <- str_replace_all(mytext, "[[:upper:]]", "")
mytext <- str_replace_all(mytext, "[[:digit:]]", "")
mytext <- str_replace_all(mytext, "[[:punct:]]", "")
mytext

noun.mytext <- extractNoun(mytext)
noun.mytext
table(noun.mytext)
length(table(noun.mytext))
sum(table(noun.mytext))

#
#  말뭉치 (corpus) 텍스트 데이터의 사전처리 
#  특수문자, 수치 확인 

#  특수문자의 확인 
myfunc <- function(x){str_extract_all(x, "[[:punct:]]{1}")}
mypuncts <- lapply(mypaper, myfunc)
table(unlist(mypuncts))

myfunc <- function(x) {str_extract_all(x, "[[:alnum:]]{1,}[[:punct:]]{1}[[:alnum:]]{1,}")}
mypuncts <- lapply(mypaper, myfunc)
table(unlist(mypuncts))


myfunc <- function(x) {str_extract_all(x, "[[:digit:]]{1,}")}
mydigits <- lapply(mypaper, myfunc)
table(unlist(mydigits))


#   사전처리 수행 
transfunc <- content_transformer(function(x, pattern) gsub(pattern, "", x))
mycorpus <- tm_map(mypaper, transfunc, "[[:lower:]]")
mycorpus <- tm_map(mycorpus, transfunc, "[[:upper:]]")

mycorpus <- tm_map(mycorpus, removePunctuation)
mycorpus <- tm_map(mycorpus, removeNumbers)
mycorpus <- tm_map(mycorpus, stripWhitespace)

mycorpus[[19]]$content

#  한글처리에서 우선 명사를 추출하여야 한다. 그 후 DTM 행렬을 작성한다.
#   extractNoun 함수는 corpus가 아니라 text vector를 받아들이고
#   tm 패캐지의 DocumentTermmatrix 함수는 corpus를 받아들인다
#   따라서 각각에 적합한 형태로 데이터를 전환하는 과정이 필요하다. 

mynounfun <- function(mytext){
  mynounlist <- paste(extractNoun(mytext), collapse= " ")
}

mynouncorpus <- mycorpus
for(i in 1:length(mycorpus)) {
  mynouncorpus[[i]]$content <- mynounfun(mycorpus[[i]]$content)
}
mynouncorpus[[19]]$content
str_extract_all(mynouncorpus[[19]]$content, boundary("word"))

mynounlist <- lapply(mynouncorpus, function(x) str_extract_all(x, boundary("word")))
mynounlist
table(unlist(mynounlist))
length(table(unlist(mynounlist)))
sum(table(unlist(mynounlist)))

# DTM matrix 만들기 

dtm.k <- DocumentTermMatrix(mynouncorpus)
dtm.k
inspect(dtm.k[1:22, 1:6])



4#
#  빈도표 계산, 높은 빈도의 단어 추출 및 시각화
#

word.freq <- apply(dtm.k[,], 2, sum)
head(word.freq, 10)
length(word.freq)
sort.word.freq <- sort(word.freq, decreasing=TRUE)
sort.word.freq[1:20]

cumsum.word.freq <- cumsum(sort.word.freq)
cumsum.word.freq[1:20]

prop.word.freq <- cumsum.word.freq/cumsum.word.freq[length(cumsum.word.freq)]
prop.word.freq[1:20]

# 단어 빈도에 대한 시각화 

word_d <- data.frame(freq=sort.word.freq, prop=round(prop.word.freq,3), cum=cumsum.word.freq)
word_d

plot(1:length(word.freq), prop.word.freq, type="l",
     xlab="Order of frequent word", ylab="Cumulative proportion", 
     main="cumulative proportion with the order of frequent words")

plot(1:length(word.freq), prop.word.freq, type="l",
     xlab="Order of word frequency", ylab="Cumulative proportion", 
     main="", axes=FALSE)
axis(1, at=round(67.8*(0:10)), labels=paste(10*(0:10),"%",sep=""))
axis(2, at=0.20*(0:5), labels=paste(20*(0:5),"%",sep=""))
for(i in 1:9){
  text(6.8*10*i, 0.05+prop.word.freq[6.8*10*i], 
       labels=paste(round(100*prop.word.freq[6.8*10*i]),"%",sep=""))
  points(6.8*10*i, prop.word.freq[6.8*10*i], pch=19)
}

library(qcc)
pareto.chart(word.freq)
pareto.chart(sort.word.freq[1:20])


#
#  말뭉치 그림 (word cloud)을 이용한 시각화 
# 


# install.packages("wordcloud")
library(wordcloud)

wordcloud(words= names(word.freq), freq=word.freq, scale=c(4,0.2),
          rot.per=0.2, min.freq=2, random.order=FALSE)

# install.packages("RColorBrewer") and create pallets
library(RColorBrewer)

pal <- brewer.pal(4, "Dark2")

wordcloud(words= names(word.freq), freq=word.freq, scale=c(4,0.2),
          rot.per=0.0, min.freq=5, random.order=FALSE, colors=pal)


#################################################################
#
#   품사 분석 
#
#################################################################

install.packages("openNLP")
library("NLP")
library("openNLP")
library("stringr")

R_wiki <- "R is a programming language and free software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, data mining surveys, and studies of scholarly literature databases show substantial increases in popularity; as of July 2019, R ranks 20th in the TIOBE index, a measure of popularity of programming languages.
A GNU package, source code for the R software environment is written primarily in C, Fortran and R itself, and is freely available under the GNU General Public License. Pre-compiled binary versions are provided for various operating systems. Although R has a command line interface, there are several graphical user interfaces, such as RStudio, an integrated development environment.
"
?annotate
?Maxent_Sent_Token_Annotator
R_wiki_sent <- annotate(R_wiki, Maxent_Sent_Token_Annotator())
R_wiki_sent

R_wiki_word <- annotate(R_wiki, Maxent_Word_Token_Annotator(),R_wiki_sent)
R_wiki_word

POStag <- annotate(R_wiki, Maxent_POS_Tag_Annotator(), R_wiki_word)
POStag

word.start <- 1 + length(R_wiki_sent)
word.end <- length(R_wiki_word)
all.POS.tagged <- unlist(POStag$features[word.start:word.end])
all.POS.tagged
table(all.POS.tagged)

my.PUNCT <- str_detect("[[:punct:]]", all.POS.tagged)
my.PUNCT
sum(my.PUNCT)

my.NN <- str_detect("NN", all.POS.tagged)
sum(my.NN)
