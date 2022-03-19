#######################################################################
#         
#       Data input and output
#
#######################################################################

#   R 세션에서 직접 데이터 객체를 생성하기 

age <- c(25, 30, 18)
gender <- c("m","f", "f")
weight <- c(166, 115, 120)

mydata1 <- data.frame(age, gender, weight)
mydata1
str(mydata1)

#  Entering data from the keyboard

mydata2 <- data.frame(age=numeric(0),
                      gender=character(0),
                      weight=numeric(0))
mydata2 <- edit(mydata2)
mydata2
str(mydata2)


#   패키지에 저장된 데이터 파일 사용하기

data()

mtcars
str(mtcars)
help(mtcars)

iris
str(iris)
help(iris)

library(ggplot2)

#
#  외부 데이터 이용하기
#

# CSV 파일 불러오기
# (우선 해당파일은 현 working directory에 옮김)

df_exam <- read.csv("csv_exam.csv")
df_exam

# 다른 working directory에 파일이 있는 경우 pathname을 지정함 

df_midterm2 <- read.csv("df_midterm.csv")
# df_midterm2 <- read.csv("E:/Ranalysis/Data_for_class/df_midterm.csv")
df_midterm2


# 엑셀 파일 불러오기기

install.packages("readxl")
library("readxl")

df_exam <- read_excel("excel_exam.xlsx")
df_exam

mean(df_exam$english)
mean(df_exam$science)
summary(df_exam)

# 데이터 프레임을 CSV 파일 및 rda파일로 저장하기

write.csv(mydata1, file="mydata1.csv")

save(mydata1, file="mydata1.rda")

# workspace에서 데이터객체 지우기, working directory에서 불러들이기

rm(mydata1)
mydata1

load("mydata1.rda")
mydata1

#
#   엑셀파일을 csv 파일로 변경하고 읽어들이기 
# (엑셀파일을 csv파일로 저장한 수 csv파일을 읽음) 
#

grades <- read.csv("E:/Rlecture/Data_for_class/studentgrades.csv")
grades
str(grades)

######################################################################
#
#     Base R의 기본적 함수들 활용하기
#
######################################################################

#  데이터 파악하기 

mtcars
help(mtcars)

head(mtcars)
head(mtcars, 10)
tail(mtcars)
tail(mtcars, 8)
View(mtcars)

str(mtcars)
summary(mtcars)
attributes(mtcars)

mtcars$vs <- factor(mtcars$vs, levels=c(0,1), labels=c("V-shaped", "straight"))
mtcars$am <- factor(mtcars$am, levels=c(0,1), labels=c("automatic", "manual"))
str(mtcars)

table(mtcars$vs)
table(mtcars$vs, mtcars$am)
summary(mtcars)

#
#   Functions for working with data objects
#

mystring <- c("Hello", "World", "!")
mymatrix <- matrix(1:20, nrow=5)
mylist <- list(title="my list", mymatrix, grades)
myfactor <- factor(gender)

ls()

age
mystring
mymatrix
df_midterm
mylist
myfactor

length(age)
length(mystring)
length(mymatrix)
length(mylist)
length(df_midterm)
length(myfactor)

dim(age)
dim(mystring)
dim(mymatrix)
dim(mylist)
dim(df_midterm)
dim(myfactor)

str(age)
str(mystring)
str(mymatrix)
str(mylist)
str(df_midterm)
str(myfactor)

class(age)
class(mystring)
class(mymatrix)
class(mylist)
class(df_midterm)
class(myfactor)

mode(age)
mode(mystring)
mode(mymatrix)
mode(mylist)
mode(df_midterm)
mode(myfactor)

names(age)
names(mystring)
names(mymatrix)
names(mylist)
names(df_midterm)
names(myfactor)

ob_cbind <- cbind(age, gender, weight)
ob_cbind
str(ob_cbind)
class(ob_cbind)
mode(ob_cbind)

ob_rbind <- rbind(age, gender, weight)
ob_rbind
str(ob_rbind)
class(ob_rbind)
mode(ob_rbind)

ls()
rm(ob_cbind, ob_rbind)
ls()

attributes(age)
attributes(mystring)
attributes(mymatrix)
attributes(mylist)
attributes(df_midterm)
attributes(myfactor)


#
#  Data Identification &Conversion function
#

is.numeric(age)
is.numeric(mystring)
is.numeric(mymatrix)
is.numeric(mylist)
is.numeric(df_midterm)

mode(mymatrix)
class(mymatrix)

mode(mylist)
class(mylist)

mode(df_midterm)
class(df_midterm)

mylist2 <- list(1,2,3)
mylist2
mode(mylist2)
class(mylist2)


is.character(mystring2)
is.vector(age)

is.vector(mymatrix)
is.matrix(mymatrix)

is.data.frame(df_midterm)
is.list(df_midterm)

is.factor(myfactor)
is.factor(gender)

# Data type conversion

as.character(age)
age
age_c <- as.character(age)
age_c

gender_n <- as.numeric(gender)
gender_n

y<-c(0, 1, -1, 0, 1, 2)
y
y_logical <- as.logical(y)
y_logical

is.data.frame(mymatrix)
class(as.data.frame(mymatrix))
class(mymatrix)


# 
#   R in Action  chapter 5  Advanced data management
#   5.2.1  Mathematical functions

#  산술 / 논리 연산자

x <- 4
y <- 2

x+2
x*2
x/2
x**2
x^2
x%%2

x>4
x>=4

x>=4 & y<=2
x>4 & y <=2 
x>4 | y<=2
!x>4

#  수학 함수 (mathematical functions)

xabs(-4)
sqrt(25)
ceiling(3.475)
floor(3.475)
trunc(5.99)
round(3.475, digits=2)
signif(3.475, digits=2)
cos(2)
log(10, base=10)
log(10)
exp(2.3026)

x <- 1:10
y <- 1:5

x+y
x*y

sqrt(x)
log(x)

#
#  5.2.2  Statistical functions
#

x <- c(1,2,3,4,5,6,7,8)
mean(x)
median(x)
sum(x)

sd(x)
quantile(x, 0.25)
range(x)
diff(range(x))

scale(x)
df_exam
scale(scale(df_exam[, c(3,4,5)]))

#  5.2.3 Probability functions

pnorm(1.96)
pnorm(0)
pnorm(1)

qnorm(0.9)
qnorm(0.975)

qnorm(0.9, mean=500, sd=100)

rnorm(10)
rnorm(10, mean=50, sd=10)

# setting the seed for random number generation

runif(5)
runif(5)

set.seed(1234)
runif(5)
set.seed(1234)
runif(5)

#
# attach, detach, and with functions for data frame
#

mtcars
summary(mtcars$mpg)
plot(mtcars$mpg, mtcars$disp)
plot(mtcars$mpg, mtcars$wt)

attach(mtcars)
summary(mpg)
plot(mpg, disp)
plot(mpg, wt)
detach(mtcars)

mpg <- c(25, 36, 47)
attach(mtcars)
plot(mpg, wt)
detach(mtcars)


with(mtcars, {
  print(summary(mpg))
  plot(mpg, disp)
  plot(mpg, wt)
})
