#####################################################################
#
#    3부  텍스트 데이터 분석 및 결과 제시 
#       01  텍스트 데이터에 대한 기술통계분석 
#
####################################################################

library(tidyverse)
library(tm)
library(SnowballC)

# tm 패키지 함수를 이용한 텍스트 데이터 사전처리 

my.text.location <- "E:/mypaper/hufs_eng"
mypaper <- VCorpus(DirSource(my.text.location))
mypaper
summary(mypaper)
mypaper[[2]]
mypaper[[2]]$content

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
#  빈도표 계산, 높은 빈도의 단어 추출 및 시각화
#

word.freq <- apply(dtm[,], 2, sum)
# dtm_m <- as.matrix(dtm)
# word>freq <- apply(dtm_m, 2, sum)
head(word.freq, 10)
length(word.freq)
sort.word.freq <- sort(word.freq, decreasing=TRUE)
sort.word.freq[1:20]

cumsum.word.freq <- cumsum(sort.word.freq)
cumsum.word.freq[1:20]

prop.word.freq <- cumsum.word.freq/cumsum.word.freq[length(cumsum.word.freq)]
prop.word.freq[1:20]

# 단어 빈도에 대한 시각화 

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
  rot.per=0.0, min.freq=3, random.order=FALSE)

# install.packages("RColorBrewer") and create pallets
library(RColorBrewer)

display.brewer.all()
pal <- brewer.pal(4, "Dark2")

wordcloud(words= names(word.freq), freq=word.freq, scale=c(4,0.2),
          rot.per=0.0, min.freq=5, random.order=FALSE, colors=pal)

#
#  상관관계 분석 (correlation analysis)
#

# 단어간 문서간 상관관계 파악 

findAssocs(dtm, "qualiti", 0.5)

var1 <- as.vector(dtm[,"qualiti"])
var2 <- as.vector(dtm[, "price"])
cor.test(var1, var2)
plot(var1, var2)
var <- data.frame(quality=var1, price=var2)
var
cor.test(var1, var2, method="kendall")
cor.test(var1, var2, method="spearman")

var1 <- as.vector(dtm[,"qualiti"])
var2 <- as.vector(dtm[, "manag"])
plot(var1, var2)
cor.test(var1, var2)
cor.test(var1, var2, method="kendall")


my.assoc.func <- function(mydtm, term1, term2){
  myvar1 <- as.vector(mydtm[,term1])
  myvar2 <- as.vector(mydtm[,term2])
  plot(myvar1, myvar2)
  cor.test(myvar1, myvar2)
}

my.assoc.func(dtm, "qualiti", "process")
my.assoc.func(dtm, "qualiti", "improv")
my.assoc.func(dtm, "qualiti", "price")


#  문서 간의 상관관계 

my.assoc.func(t(dtm), "1997ahufseng.txt", "2000ahufseng.txt")

# var1 <- as.vector(t(dtm)[,"1997ahufseng.txt"])
# var2 <- as.vector(t(dtm)[,"2000ahufseng.txt"])
# var1
# var2


length.doc <- dtm$nrow
my.doc.cor <- matrix(NA, nrow=length.doc, ncol=length.doc)

for(i in 1:length.doc){
  for(j in 1:length.doc){
    my.doc.cor[i,j] <- my.assoc.func(t(dtm), rownames(dtm)[i], rownames(dtm)[j])$est
  }
}

# f1 <- my.assoc.func(t(dtm), "1997ahufseng.txt", "2000ahufseng.txt")

rownames(my.doc.cor) <- rownames(dtm)
colnames(my.doc.cor) <- rownames(dtm)

round(my.doc.cor[1:5, 1:5], 2)

hist(my.doc.cor[lower.tri(my.doc.cor)], breaks=30)
head(sort(my.doc.cor[lower.tri(my.doc.cor)], decreasing=TRUE), 20)
summary(my.doc.cor[lower.tri(my.doc.cor)])

df.doc.cor <- data.frame()
for(i in 1:(length.doc-1)){
  for(j in (1+i):length.doc){
    paper1 <- rownames(my.doc.cor)[i]
    paper2 <- colnames(my.doc.cor)[j]
    correlation <- my.doc.cor[i,j]
    add.doc.cor <- data.frame(paper1, paper2, correlation)
    df.doc.cor <- rbind(df.doc.cor, add.doc.cor)
  }
}

df.doc.cor %>% arrange(desc(correlation)) %>% head(10)
df.doc.cor %>% arrange(correlation) %>% filter(correlation < 0)

hist(df.doc.cor$correlation, breaks=30)

#  상관계수 행렬을 이용해 EFA나 PCA를 실시 

factanal(factors=5, covmat=my.doc.cor, rotation="varimax")


#  위계적 군집분석  

dist.dtm <- dist(dtm)
as.matrix(dist.dtm)[1:4, 1:4]

myclusters <- hclust(dist.dtm, method="ward.D2")
plot(myclusters)

mygroup <- cutree(myclusters, k=5)
mygroup
table(mygroup)

install.packages("dendextend")
library(dendextend)

dend <- as.dendrogram(myclusters)
