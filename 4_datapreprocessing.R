################################################################
#
#  데이터 전처리:  Data Preprocessing
#
###############################################################

#
#  DoIt 6장  데이터 가공하기
# 6-2 조건에 맞는 데이터(행) 추출하기

install.packages("dplyr")
library(dplyr)

exam <- read.csv("csv_exam.csv")
exam

filter(exam, class==1)
filter(exam, class==2)
filter(exam, class!=3)
filter(exam, math>50)

filter(exam, english<=80)

filter(exam, class==1 & math>=50)
filter(exam, math>=90 | english >=90)

filter(exam, class %in% c(1,3))

#  추출한 행으로 데이터 만들기

class1 <- filter(exam, class==1)
class1
mean(class1$math)


# 6-3 필요한 변수(열)만 추출하기

select(exam, math)
select(exam, class, math, english)
select(exam, -math)

# filter와 select 함수 조합하기

select(filter(exam, class==1), english)

exam_f <- filter(exam, class==1)
select(exam_f, english)

head(select(exam, id, class, math), 10)


#  6-4  순서대로 정렬하기

arrange(exam, math)
arrange(exam, desc(math))
arrange(exam, class, math)


# 변수명 바꾸기

str(mtcars)
rename(mtcars, num_cylinder=cyl)
mtcars_new <- rename(mtcars, cylinder=num_cylinder)
mtcars_new <- rename(mtcars, cylinder=cyl)
str(mtcars_new)
str(mtcars)
mtcars_new <- rename(mtcars_new, displacement=disp, transmission=am)
str(mtcars_new)

#  6-5  파생변수 추가하기 

mutate(exam, total=math+english+science)

mutate(exam, total=math+english+science,
             mean=(math+english+science)/3)

mutate(exam, test=ifelse(science>=60, "pass", "fail"))

arrange(mutate(exam, total=math+english+science), total)
head(arrange(mutate(exam, total=math+english+science), desc(total)), 10)

transmute(exam, 
          total = math + english + science,
          mean = (math + english + science) /3 )


# 6-5 집단별로 요약하기

summarise(exam, mean_math=mean(math))

group_by(exam, class)
summarise(group_by(exam, class), mean_math=mean(math))

summarise(group_by(exam, class), 
          mean_math=mean(math),
          sum_math=sum(math),
          median_math=median(math),
          n=n())

#  pipe operation (%>%)

exam %>% filter(class==1)
exam %>% filter(class==1) %>% select(english)

library(ggplot2)
mpg %>% 
  group_by(manufacturer, drv) %>% 
  summarise(mean_cty=mean(cty), n=n()) %>% 
  head(10)

# dplyr 조합하여 분석결과 출력하기

mpg %>% 
  group_by(manufacturer) %>%
  filter(class=="suv") %>%
  mutate(tot=(cty+hwy)/2) %>% 
  summarise(mean_tot=mean(tot), n=n()) %>%
  arrange(desc(mean_tot)) %>%
  head(5)



# 6-7   데이터 합치기

# 가로로 합치기 (열 추가)
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm=c(60,80,70,90,85))
test1

test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))
test2

total <- left_join(test1, test2, by="id")
total

t_name <- data.frame(class=c(1,2,3,4,5),
                   teacher =c("Kim", "Lee", "Park", "Choi", "Jung"))
t_name

exam_new <- left_join(exam, t_name, by="class")
exam_new

# 세로로 합치기 (행 추가) 

group_a <- data.frame(id=c(1,2,3,4,5), test=c(60,80,70,90,85))
group_a

group_b <- data.frame(id=c(6,7,8,9,10), test=c(70,83, 65,95,80))
group_b

group_all <- bind_rows(group_a, group_b)
group_all


##############################################################
#
#  Base 패키지의 함수를 이용한  데이터 전처리
#
##############################################################

# [] 연산자를 이용한 데이터 추출

a <- c("k", "j", "h", "a", "c", "m")
a 

a[3]
a[c(1,3,5)]
a[2:6]

x <- matrix(1:10, nrow=2)
x

x[2,]
x[,2]
x[1,4]
x[1,c(4,5)]


#  [], [[]], $ 연산자의 차이점 

g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow=5)
k <- list("a list witin a list", h)
mylist <- list(title=g, ages=h, j, k)
mylist

mylist[2]
mylist[[2]]
mylist["ages"]
mylist$age

class(mylist[2])
class(mylist[[2]])
class(mylist["ages"])
class(mylist$ages)

#
#  []  연산자의 다양한 유형의 인덱스 벡터 사용 방식 

a
a[3]
a[c(1,3,5)]
a[-3]
a[-c(1,3,5)]

b <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
b
a[b]

h
h[h>25]

#  [] 연산자를 이용하여 데이터 프레임의 행과 열 추출하기

exam

exam[1:6, ]
exam[exam$class==1, ]

exam[ , c(1,3)]
exam[ , c("class", "english")]


#  subset 함수 이용하기 

subset(exam, class==2, select=c(math))
subset(exam, class==2, select=c(-math))

subset(exam, class==2, select=c(math), drop=TRUE)
subset(exam, class==2, select=-c(math), drop=TRUE)

class(subset(exam, class==2, select=c(math)))
class(subset(exam, class==2, select=c(math), drop=TRUE))


#
# Sorting Data with Base functions

# sort함수 사용하여 벡터 sorting 하기

sort(exam$math)

sort(exam)
?sort

# order 함수 이용하여 데이터 프레임 sorting하기

order(exam$math)
?order

exam[order(exam$math), ]

exam[order(exam$english, decreasing=TRUE), ]
exam[order(exam$class, exam$math), ]


#
#   데이터 객체에 이름 지정하기

#  데이터 객체의 이름 조회하기 

names(mtcars)
names(exam)
names(mylist)

#  데이터 프레임 혹은 리스트에 변수명 지정하기

names(mylist)[4] <- "list_in_list"
names(mylist)
names(mtcars)[c(2,9,11)] <- c("cylinders", "trasmission", "carburetors")
names(mtcars)

#
# 새로운 변수 만들기Create new variables

exam$sum <- exam$math + exam$science + exam$english
exam$mean <- round(exam$sum/3,1)
exam

total
transform(total,
          sum = midterm + final,
          mean = (midterm + final) / 2)

library(ggplot2)

mpg$total <- (mpg$cty + mpg$hwy)/2
mpg
mean(mpg$total)

#  조건문에 따른 파생변수 만들기

mpg$test <- ifelse(mpg$total >= 20, "pass", "fail")
head(mpg, 10)
tail(mpg, 10)

mpg$grade <- ifelse(mpg$total>=30, "A",
                    ifelse(mpg$total>=20, "B", "C"))
head(mpg,10)
tail(mpg, 10)

#
#  데이터 합치기: 열 추가하기, 행 추가하기

# 가로로 합치기 (열 추가)
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm=c(60,80,70,90,85))
test1

test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))
test2

total_a <- cbind(test1, test2)
total_a

total_b <- merge(test1, test2, by="id")
total_b

t_name <- data.frame(class=c(1,2,3,4,5),
                     teacher =c("Kim", "Lee", "Park", "Choi", "Jung"))
t_name

exam_new <- merge(exam, t_name, by="class")
exam_new

# 세로로 합치기 (행 추가) 

group_a <- data.frame(id=c(1,2,3,4,5), test=c(60,80,70,90,85))
group_a

group_b <- data.frame(id=c(6,7,8,9,10), test=c(70,83, 65,95,80))
group_b

group_all <- rbind(group_a, group_b)
group_all


##############################################################################
#
#   데이터 정제  Handling Missing values, outliers
#
#############################################################################

#
# 비정상적 값의 정의: NA, NULL, inf, nan
#

x <- c(1,2,NA, Inf, NaN, 0, NULL)
x
length(x)

x[1] / x[2]
x[1] / x[3]
x[1] / x[4]
x[1] / x[5]
x[1] / x[6]

mean(x)
mean(x, na.rm=T)

is.na(x[3])
is.nan(x[3])

is.nan(x[5])
is.na(x[5])

is.na(x)

z1 <- c(1, NULL, 3)
z1
mean(z1)
length(z1)

z2 <- c(1, NA, 3)
z2
mean(z2)
length(z2)

y <- NULL
y
is.null(y)
length(y)


#
#  7-1  결측치 정제하기 : 빠진 데이터를 찾아라
#

df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score=c(5,4,3,4,NA))
df

is.na(df)
table(is.na(df))

is.na(df$sex)
table(is.na(df$sex))

is.na(df$score)
mean(df$score)

#   결측치 제거하기

library(dplyr)

df %>% filter(is.na(score))
df %>% filter(!is.na(score))

df_nomiss <- df %>% filter(!is.na(score))
df_nomiss

mean(df_nomiss$score)
sum(df_nomiss$score)

# base 함수 이용하기 
df_nomissB <- df[!is.na(df$score), ]
df_nomissB
mean(df_nomissB$score)

df_nomiss2 <- na.omit(df)
df_nomiss2


#  na.rm 파라미터 이용하기 

mean(df$score, na.rm=T)
sum(df$score, na.rm=T)

exam <- read.csv("csv_exam.csv")
exam
exam[c(3,8,15),"math"] <- NA
exam

exam %>% summarise(mean_math=mean(math))

exam %>% summarise(mean_math = mean(math, na.rm=T))

exam %>% summarise(mean_math = mean(math, na.rm=T),
                   sum_math =sum(math, na.rm=T),
                   median_math = median(math, na.rm=T))

#  결측값 대체하기 

exam$math <- ifelse(is.na(exam$math), 55, exam$math)
exam

mean(exam$math)



###################################################################
#
#   데이터 변환하기, 축소하기 
#
##################################################################

# scale 함수를 이용하여 정규화 분포로 변환하기

exam
exam %>% 
  mutate(total=math+english+science) %>% 
  arrange(desc(total)) %>%
  head()

math_s <- scale(exam$math)
english_s <- scale(exam$english)
science_s <- scale(exam$science)

score_s <- data.frame(math_s, english_s, science_s)
exam_s <- cbind(exam, score_s)

exam_s %>%
  mutate(total_s=math_s+english_s+science_s) %>%
  arrange(desc(total_s)) %>%
  head()

#  sample 함수

sample_1 <- sample(1:1000, 100)
sample_1
?sample
sort(sample_1)

titanic <- read.csv("Titanic_train.csv")
str(titanic)
View(titanic)

sample_size <- floor(0.75*nrow(titanic))

set.seed(1234)
titanic_s <- titanic[sample(1:nrow(titanic), sample_size), ]
str(titanic_s)
sample(1:nrow(titanic), sample_size)

titanic_v <- titanic[-sample(1:nrow(titanic), sample_size), ]
titanic_v


