######################################################
#
#  R 
#
######################################################

# 3-1: 데이터 객체 : 벡터 (vector) 이해하기

a <- 1
a

b<- 2
c <- 3
d <- 3.5

a+b
a+b+c
4/b
5*b


# 여러값으로 구성된 Vector

var1 <- c(1,2,5,7,8)
var1

var2 <- c(1:5)
var3 <- seq(1,5)
var4 <- seq(1,10, by=2) 
var5 <- seq(1,10, by=3)

var1 + 2
var1+var2


# 문자로 된 vector 만들기

str1 <- "a"
str1

str2 <-"text"
str3 <-"Hello World!"
str4 <- c("a", "b", "c")
str4

str5 <- c("Hello", "World", "is", "good!")
str5

str1+2


# 3-2:  함수(function) 이해하기

x <- c(1,2,3)

mean(x)
max(x)
min(x)

#  함수기능이 궁금할 때 (help, ?) 함수 활용하기기 

help(mean)
?max


# 함수의 결과물로 새 변수 만들기

x_mean <- mean(x)
x_mean


# 3-3 함수 꾸러미 패키지(Packaages) 이해하기 

search()

install.packages("ggplot2")
library("ggplot2")

?mpg
head(mpg)
str(mpg)

# base package를 이용한 mpg 그래프 작성 

hist(mpg$hwy, breaks=15)
boxplot(mpg$hwy)
boxplot(mpg$hwy~mpg$drv)
plot(mpg$displ, mpg$hwy)


# ggplot2로 mpg 데이터 그래프 만들기

ggplot(data=mpg, mapping=aes(x=hwy)) + geom_histogram(bins=15)
ggplot(data=mpg, mapping=aes(y=hwy)) + geom_boxplot()
ggplot(data=mpg, mapping=aes(x=drv, y=hwy)) + geom_boxplot()

ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) + geom_point()
ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ, y=hwy))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color=drv))
ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y= hwy, color=drv)) +
  geom_smooth(mapping=aes(x=displ, y=hwy, group=drv))

