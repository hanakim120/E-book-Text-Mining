
#package 설치

install.packages("tidyverse")
install.packages("tm")
install.packages("wordcloud")
install.packages("rpart.plot")

#package 로딩

library("tidyverse")
library(tm)
library(wordcloud)
library(rpart)
library(rpart.plot)


#현재 작업 디렉토리 확인
getwd()

#csv파일 불러오기 
#문자가 있는 파일은 stringsAsFActors=F 설정해줘야 factor타입이 아닌
#문자 타입으로 불러옴
spam_raw <- read.csv("spam.csv", stringsAsFactors = FALSE)

#뷰어창에서 보기
View(spam_raw)

#행은 전체, 열은 1열, 2열
spam_raw <- spam_raw[, 1:2]
View(spam_raw)

#1열,2열에 이름 붙이기
names(spam_raw) <- c("label","text")
View(spam_raw)

#label 을 factor로 변경
spam_raw$label <- as.factor(spam_raw$label)
str(spam_raw)

#빈도표는 변수의 각 값들이 몇개씩 존재하는지 데이터 개수 나타낸 표
table(spam_raw$label)

#퍼센트로 나타내는 빈도표
prop.table(table(spam_raw$label))

#결측값 제거
length(which(!complete.cases(spam_raw)))

#1행 2열 데이터읽기
spam_raw[1,2]

#22행 2열 데이터 읽기
spam_raw[22,2]

#글자수세기, 셀 수 없으면 에러 뜸 (띄어쓰기까지 고려하는 것 같음)
#문자열 길이
nchar(spam_raw[1,2])

#셀 수 없는 건 error 뜸
nchar(spam_raw[22,2])

#allowNA=TRUE 로 NA를 허용하면 NA로 뜸
nchar(spam_raw[22,2], allowNA=TRUE)

#spam_raw 에 textlength변수 추가
#textlength는 text변수의 문자열길이이고, 타입은 chars, NA허용
spam_raw$textlength <-nchar(spam_raw$text, type="chars", allowNA=TRUE)


#spam_raw에 textlength변수의 NA값빼서 spam_clean만들기
#is.na() 는 값이 na인지 아닌지 true, false로 출력
#!is.na() : 결측치가 아닌값
#spam_clean <- spam_raw[!is.na(spam_raw$textlength),]의 결과는
#na의 행 번호가 삭제됨 번호가 비어있는 행이 존재
spam_clean <- na.omit(spam_raw)
#spam_clean <- spam_raw[!is.na(spam_raw$textlength),]
#spam_clean <- na.omit(spam_raw)을 해도 같은 결과 출력
#spam_clean <- spam_raw %>% filter(!is.na(spam_raw$textlength))
#na인 행이 삭제되고 행 번호는 1부터 순서대로 다 나옴
View(spam_clean)


#table :빈도표는 변수의 각 값들이 몇개씩 존재하는지 데이터 개수 나타낸 표
table(spam_clean$label)
prop.table(table(spam_clean$label))
#요약통계량
summary(spam_clean$textlength)

#spam_clean 데이터를 label로 그룹지어서 na값 제외한 textlength 변수의 평균과
#각각 개수 구하기
spam_clean %>%
  group_by(label) %>%
  summarise(mean=mean(textlength, na.rm=T), n=n())

#spam_clean 데이터로 x축은 label, y축은 textlength인 배경에
#boxplot그리기
ggplot(spam_clean, aes(x=label, y=textlength)) +
  geom_boxplot()

#spam_clean 데이터로 x축이 textlength
#fill = label : label에 따라 다른색 표현
#binwidth 가 5인 histogram 그리기 
#x축에 Length of text, y축에 Text Count, 제목은 
#Distribution of Text lengths with class labels라고 설정

ggplot(spam_clean, aes(x=textlength, fill=label)) +
  geom_histogram(binwidth=5) +
  labs(y="Text Count", x="Length of text", 
       title="Distribution of Text lengths with class labels")


# TermDocumentMatrix() 함수가 Corpus로만 인자를 받으므로
# text를 Corpus 형태로 바꿔서 spam_corpus데이터 만들기

spam_corpus <- Corpus(VectorSource(spam_clean$text))

#str(): 데이터 속성 출력

str(spam_corpus)
 
# 첫번째 문서 내용보기
inspect(spam_corpus[[1]])
View(spam_corpus)
spam_corpus[[1]]$meta
spam_corpus[[1]]$content

#DTM만들기
#DocumentTermMatrix형태의 spam_corpus로 spam_dtm데이터생성

spam_dtm <- DocumentTermMatrix(spam_corpus)
spam_dtm
inspect(spam_dtm[1:10, 1:20])

#apply(적용할 대상, 함수가 적용되는 방향, 적용할함수)
# 2는 열방향 적용
word_freq <- apply(spam_dtm,2,sum)

#word_freq를 내림차순 정렬시켜 sorted_word_freq데이터생성

sorted_word_freq <-sort(word_freq, decreasing=TRUE)

# 위에서 20개 보기
head(sorted_word_freq,20)

# 10개로 barplot 그리기
barplot(head(sorted_word_freq, 10))

#word_freq로 wordcloud만들기
#freq 빈도, scale 단어크기범위, max.words 표현단어수, random.order=F 고빈도 단어 중앙배치
wordcloud(names(word_freq), freq=word_freq, scale=c(8,0.2),
          max.words=100, random.order=FALSE)


View(corpus_clean)
# tolower 다 소문자로 바꾸기
corpus_clean <- tm_map(spam_corpus, tolower)
#removenumbers 숫자 다 지우기
corpus_clean <- tm_map(corpus_clean, removeNumbers)
#SMART 지우기
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords("SMART"))
#removepunctuation 느낌표,점 지우기
corpus_clean <- tm_map(corpus_clean, removePunctuation)
#stripwhitespace 빈칸 지우기
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

#DTM형태의 corpus_clean 으로 spam_dtm 생성
spam_dtm <- DocumentTermMatrix(corpus_clean)
spam_dtm


word_freq <-apply(spam_dtm, 2, sum)
sorted_word_freq <- sort(word_freq, decreasing=TRUE)
head(sorted_word_freq, 20)
barplot(head(sorted_word_freq, 10))

wordcloud(names(word_freq), freq=word_freq, scale=c(6, 0.1),
          max.words=100, random.order=FALSE)



# classifcation methods을 이용한 model building
# 자주 사용하지 않는 단어 삭제해서 dtm 줄이기

# findFreqTerms ( , 5) 5회 이상 사용한 단어 찾아줌
spam_dict <- findFreqTerms(spam_dtm, 5)

#5회 이상 사용한 단어만 사용해서 spam_reduced_dtm 생성
spam_reduced_dtm <- DocumentTermMatrix(corpus_clean, list(dictionary=spam_dict))
spam_reduced_dtm


#spam_df생성, spam_reduced_dtm을 dataframe형태로 바꾸기

spam_matrix <- as.matrix(spam_reduced_dtm)
spam_df <- as.data.frame(spam_matrix)

#cbind(데이터프레임1, 데이터프레임2) : 열 기준 결합
spam_df <- cbind(spam_clean$label, spam_df)

#spam_df의 첫번째 행에 label 이름 붙이기
names(spam_df)[1] <- "label"
spam_df[1:20, 1:10]

#  train data와 test data set으로 분류

#시드 설정해주는 함수
set.seed(1234)

#샘플링 명령문, 랜덤으로 70퍼센트 뽑아서 집어넣기

index <- sample(1:length(spam_clean[,1]), 0.7*length(spam_clean[,1]))

spam_train <-spam_df[index,]
spam_test <-spam_df[-index, ]

#랜덤으로 잘뽑혔는지 확인하기 위한 작업, 두개가 거의 비슷해야함

prop.table(table(spam_train$label))
prop.table(table(spam_test$label))


# rpart 이용한 classification trees 만들기

fit <- rpart(label ~ ., method="class", data=spam_train)

#시각화
prp(fit)

#예측
#데이터마이닝에 대한 이해가 부족해서 코드가 이해가 안가는것같습니다

train_pred <- predict(fit, spam_train, type="class")

df <- data.frame(actual=spam_train$label, pred=train_pred)
t <- table(df)
t

sum(diag(t))/sum(t)
(t[1,1]+t[1,2])/sum(t)

test_pred <- predict(fit, spam_test, type="class")

df <- data.frame(actual=spam_test$label, pred=test_pred)
t <- table(df)
t

sum(diag(t))/sum(t)
(t[1,1]+t[1,2])/sum(t)

