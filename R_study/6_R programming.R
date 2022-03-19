#################################################################
#
# 제어문 (Control Structures)
#
##################################################################

# Vectorized Operations

x <- 1:4
y <- 6:9

z <- x + y
z

x > 2
x >= 2

x[x>2] <- 10
x

# vectozied operations for matrices

x <- matrix(1:4, 2,2)
x
y <- matrix (rep(10, 4), 2, 2)
y

x+y
x*y
x/y

x%*%y


#  if-else 문 

x <- runif(1, 0, 10)
if (x >5) {print("x = ", x, "is bigger than 5")}

x <- runif(1, 0, 10)
if (x >5) {
  cat("x = ", x, "is bigger than 5")
  } else {
    cat ("x = ", x, "is smaller than 5")
    }

# install.packages("dplyr")

library(dplyr)
library(ggplot2)

exam <- read.csv("csv_exam.csv")
exam

#   파생변수 추가하기 

mutate(exam, total=math+english+science)

exam_new <- mutate(exam, total=math+english+science,
                    mean=round((math+english+science)/3,2))

exam_new <- mutate(exam_new, test=ifelse(science>=60, "pass", "fail"))

exam_new %>% arrange(desc(mean))

# mpg 통합연비 만들기 

mpg
mpg$total <- (mpg$cty+mpg$hwy)/2

summary(mpg$total)

mpg$test <- ifelse(mpg$total>=20, "pass","fail")

mpg$grade <- ifelse(mpg$total >=30, "A",
                    ifelse(mpg$total>=20, "B", "C"))
table(mpg$grade)


#
#  반복문 for() 함수 이용하기
#

for(i in 1:10) {
  print(i)
}

x <- c("a", "b", "c", "d")
for(i in 1:length(x)) {
  print(x[i])
}

for (i in seq_along(x)){
  print(x[i])
}


#  seq_along(),  seq_int() functions

seq_along(x)
?seq_along
y <- 5:10
y
seq_along(y)

seq_len(5)
seq_len(10)

for(i in 1:4) {
  print(x[i])
}

for(letter in x) {
  print(letter)
}

#  Nested for loop

mx <- matrix(1:6, 2,3)
mx

for(i in 1:nrow(mx)){
  for(j in 1:ncol(mx)){
    print(mx[i,j])
  }
}

# While loop

count <- 0
while(count < 10) {
  print(count)
  count <- count +1
}

#
#   함수(funcion) 만들기
#   

f1 <- function(){
}

f1
class(f1)
f1()


f2 <- function() {
  cat("Hello! it is my first function \n")
}

f2
class(f2)
f2()

# function with arguments

f3 <- function(num) {
  for(i in seq_len(num)){
    cat("Hello! world! \n")
  }
}

f3()
f3(3)

seq_len(3)

#  function with an argument and retuned values

f4 <- function(num) {
  hello <- "Hello, world! \n"
  for(i in seq_len(num)){
    cat(hello)
  }
  chars <- nchar(hello)*num
  chars
}

f4()
f4(3)

vf4 <- f4(3)
vf4
str(vf4)

# function with default values for arguments

f5 <- function(num=1){
  hello <- "Hello, world! \n"
  for(i in seq_len(num)){
    cat(hello)
  }
    chars <- nchar(hello) *num
    chars
}

f5()

f5(2)
f5(num=3)


#  Argument matching

str(rnorm)
mydata <- rnorm(100, 2, 1)

str(sd)
sd(mydata)     # positional match
sd(x=mydata)   # specify argument with name, default for na.rm
mydata[10] <-NA
sd(mydata)
sd(x=mydata, na.rm=TRUE)   # specify both argument by name


# specify both arguments by name
sd(na.rm=TRUE, x=mydata)

# mix positional matching with matchin by name
sd(na.rm=TRUE, mydata)  # mixing position is no recommended

args(lm)

# lazy evaluation

f6 <- function(a,b) {
  a^2
}
f6(2)

f7 <- function(a,b){
  print(a)
  print(b)
}
f7(45)

#   The ... arguments

args(mean)
args(paste)
args(rnorm)

rnorm(10, m=0, s=1)
paste("a", "b", sep=":")
paste("a", "b", se=":")

#  함수의 사례: 홀수의 개수

oddcount <- function(x){
  k <-0
  for(n in x) {
    if(n%%2==1) k <- k+1
  }
  return(k)
}

oddcount(c(1,2,3))
oddcount(c(1,3,5))


#
#  apply() 함수의 사용 
#

x <- matrix(1:12, nrow=3)
x

?apply
apply(x, 1, mean)
apply(x, 2, mean)


# lapply() 함수의 사용 

x <- list(a=1:5, b=rnorm(10), c=rnorm(10,5))
lapply(x, mean)
lapply(x, sd)

# sapply() 함수

sapply(x, mean)
sapply(x, sd)

#
#   base 패키지에서 그룹별로 요약 통계량을 만들기 위하여기 split() 함수를 사용하기
#

#  벡터에  split() 함수와 lapply() 함수 사용하기 

?split

x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3, 10)
f

x_s <- split(x, f)
x_s
lapply(x_s, mean)
sapply(x_s, mean)


#  데이터프레임에  split() 함수와 lapply() 함수 사용하기 

exam <- read.csv("csv_exam.csv")
exam
str(exam)

lapply(exam[, c("math", "english", "science")], mean)
colMeans(exam[,c("math", "english", "science")])


exam_s <- split(exam, exam$class)
exam_s
str(exam_s)

lapply(exam_s[[1]][,c("math","english","science")], mean)
lapply(exam_s[[5]][,c("math","english","science")], mean)

lapply(exam_s, function(x){
  colMeans(x[,c("math","english","science")])
})

sapply(exam_s, function(x){
  colMeans(x[,c("math","english","science")])
})


# tapply() 함수 

str(tapply)

x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3, 10)
f

tapply(x, f, mean)
tapply(x, f, mean, simplify=FALSE)

#
#  집단별로 요약하기 dplyr 패키기 사용하기, aggregate() 함수 이용하기
#

exam %>% 
  group_by(class) %>%
  summarise(mean_math=mean(math),
            mean_science=mean(science),
            mean_english=mean(english))

#  aggregate () 함수  

scores <- c("math", "english", "science")

?aggregate
aggregate(exam[scores], by=list(class=exam$class), mean)
aggregate(math~class, data=exam, mean)
aggregate(cbind(math, science, english)~class, data=exam, mean)





