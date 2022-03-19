#데이터불러오기, corpus 구성
cin <- "C:/Users/lg/Desktop/Rproject/2019DAspecial/cinderella"
cin <- VCorpus(DirSource(cin))
summary(cin)

cin$content
inspect(cin)
cin[[1]]$content
cin[[1]]$meta

#Preprocessing

#특수문자 사용 전후의 단어 살피기
myfunc <- function(x) {str_extract_all(x, "[[:alnum:]]{1,}[[:punct:]]{1}?[[:alnum:]]{1,}")}
mypuncts <- lapply(cin, myfunc)
table(unlist(mypuncts))

#숫자표현 살피기
myfunc <- function(x) {str_extract_all(x,"[[:digit:]]{1,}")}
mydigits <-lapply(cin,myfunc)
table(unlist(mydigits))

#고유명사 살피기
myfunc <- function(x) {str_extract_all(x,"[[:upper:]]{1}[[:alpha:]]{1,}")}
myuppers <-lapply(cin,myfunc)
table(unlist(myuppers))

#숫자표현 제거
cincorpus <- tm_map(cin, removeNumbers)

#특수문자 교체

trans <- content_transformer(function(x,from,to) gsub(from,to,x))

cincorpus <-tm_map(cincorpus, trans, "\\?","er")
cincorpus <-tm_map(cincorpus, trans, "\\,","")
cincorpus <-tm_map(cincorpus, trans, "o'clock","oclock")
cincorpus <-tm_map(cincorpus, trans, "\\'s","")
cincorpus <-tm_map(cincorpus, trans, "\\b(good-)","good")
cincorpus <-tm_map(cincorpus, trans, "\\b(head-)","head")
cincorpus <-tm_map(cincorpus, trans, "\\b(ill-)","ill")
cincorpus <-tm_map(cincorpus, trans, "-looking","looking")
cincorpus <-tm_map(cincorpus, trans, "\\b(light-)","light")
cincorpus <-tm_map(cincorpus, trans, "\\b(looking-)","looking")
cincorpus <-tm_map(cincorpus, trans, "\\b(point-)","point")
cincorpus <-tm_map(cincorpus, trans, "\\b(stay-)","stay")
cincorpus <-tm_map(cincorpus, trans, "\\b(step-)","step")
cincorpus <-tm_map(cincorpus, trans, "\\b(thistle-)","thistle")
cincorpus <-tm_map(cincorpus, trans, "\\b(bad-)","bad")
cincorpus <-tm_map(cincorpus, trans, "-room","room")
cincorpus <-tm_map(cincorpus, trans, "-ROOM","ROOM")
cincorpus <-tm_map(cincorpus, trans, "-woman","woman")
cincorpus <-tm_map(cincorpus, trans, "-corner","corner")
cincorpus <-tm_map(cincorpus, trans, "-gray","gray")
cincorpus <-tm_map(cincorpus, trans, "-glass","glass")
cincorpus <-tm_map(cincorpus, trans, "-dressed","dressed")
cincorpus <-tm_map(cincorpus, trans, "-print","print")
cincorpus <-tm_map(cincorpus, trans, "\\b(full-)","full")
cincorpus <-tm_map(cincorpus, trans, "\\b(god-)","god")
cincorpus <-tm_map(cincorpus, trans, "\\b(GOD-)","GOD")
cincorpus <-tm_map(cincorpus, trans, "\\b(gold-)","gold")
cincorpus <-tm_map(cincorpus, trans, "\\b(three-)","three")
cincorpus <-tm_map(cincorpus, trans, "-"," ")
cincorpus <-tm_map(cincorpus, trans, "\"","")
cincorpus <-tm_map(cincorpus, trans, "\'","")

#특수문자 제거
cincorpus <-tm_map(cincorpus, removePunctuation)

#공란 제거
cincorpus <-tm_map(cincorpus, stripWhitespace)

#대소문자 통합
cincorpus <-tm_map(cincorpus, content_transformer(tolower))

#불용단어 제거
cincorpus <-tm_map(cincorpus, removeWords, words=stopwords("SMART"))

#어근 동일화 처리
cincorpus <-tm_map(cincorpus, stemDocument, language="en")

#전처리 전 후 비교
mycharfunc <-function(x) {str_extract_all(x,".")}
mywordfunc <-function(x) {str_extract_all(x,boundary("word"))}

#전처리 전
mychar <- lapply(cin, mycharfunc)
myuniquechar0 <-length(table(unlist(mychar)))
mytotalchar0 <-sum(table(unlist(mychar)))
myword <- lapply(cin, mywordfunc)
myuniqueword0 <-length(table(unlist(myword)))
mytotalword0 <-sum(table(unlist(myword)))

#전처리 후
mychar<- lapply(cincorpus, mycharfunc)
myuniquechar1 <-length(table(unlist(mychar)))
mytotalchar1 <-sum(table(unlist(mychar)))
myword <- lapply(cincorpus, mywordfunc)
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
dtm.c <- DocumentTermMatrix(cincorpus)
dtm.c


#빈도표
word.freq <- apply(dtm.c[,],2,sum)
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
wordcloud(names(word.freq),freq=word.freq,scale=c(5,1),rot.per = 0.2,min.freq=5,random.order=FALSE,col=pal)

