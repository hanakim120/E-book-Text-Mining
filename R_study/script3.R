##################################################################
#
#     R data structure (vector, matrix, list, dataframe, factor)
#
##################################################################

#
#   벡터의 생성과 관리 (Vectors) 
#

x1 <- c(1,2,5,3,6,-2,4)
x1
x2 <- c("one", "two", "three")
x2
x3 <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
x3

x4 <- vector("numeric", length=10)
x4

x5 <- 1:10
x5

x6 <- seq(1,10)
x6
x7 <- seq(1,10, by=2)
x7

x8 <- rep(1:3,2)
x8

# Mixing different modes of objects

y1 <- c(1, 2, "one")
y1

y2 <- c(TRUE, FALSE, 2)
y2

#  mode() length() 함수 이용하기 

mode(x1)
mode(x2)

length(x1)
length(x2)

# 벡터 요소(element) 추출하기

x1

x1[3]
x1[c(3,1)]
x1[2:5]
x1[-3]
x1[c(T,F,T,F,F,F,F)]

# 벡터의 연산
x6
x7
x8

x6+2
x6+x7
x6+x8

#
#  행렬(matrices)의 생성과 관리 
#

m1 <- matrix(1:20, nrow=5, ncol=4)
m1

cells <- c(1,26,24,68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
m2 <- matrix(cells, nrow=2, ncol=2, byrow=TRUE,
                   dimnames=list(rnames, cnames))
m2

m3<- matrix(cells, nrow=2, ncol=2, 
            dimnames=list(rnames, cnames))
m3

# 행렬의 항목 추출 (subsetting)

m4 <- matrix(1:10, nrow=2)
m4

m4[1,4]
m4[2,]
m4[,2]
m4[1,c(4,5)]
m4[1, -c(4,5)]

#  행렬의 연산 

m2+2
m2*2
m2+m3
m2%*%m3
m2*m3
t(m2)
solve(m2)

#
# 리스트 (lists) 생성과 관리 
#

list1 <- list(1, "a", TRUE, 1+4i)
list1

g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow=5)
k <- list("a list witin a list", h)
mylist <- list(title=g, ages=h, j, k)
mylist

#  specify elements of the list

mylist[2]
mylist[[2]]
mylist$age

mylist[[4]]
mylist[[4]][[2]]
mylist[[4]][[2]][2]

mylist[[3]]
mylist[[3]][c(2,3),]

#
#  데이터프레임의 생성과 관리 
#

patientID <- c(1,2,3,4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
patientdata <- data.frame(patientID, age, diabetes, status)
patientdata

str(patientdata)
summary(patientdata)

# 데이터프레임의 항목추출 

patientdata
patientdata[1,2]
patientdata[1:2]
patientdata[1:2,]
patientdata[,1:2]
patientdata[c("diabetes", "status")]

patientdata$age
patientdata["age"]
patientdata[2]
patientdata[[2]]
patientdata[["age"]]

#
#  팩터의 생성과 관리 
# 

diabetes
status

str(patientdata)
summary(patientdata)

barplot(table(patientdata$status))
status <- factor(status, order=TRUE, levels=c("Poor","Improved","Excellent"))
patientdata <- data.frame(patientID, age, diabetes, status)
str(patientdata)
summary(patientdata)
barplot(table(patientdata$status))


# attributes

x1
mode(x1)
class(x1)
length(x1)
attributes(x1)

m1
mode(m1)
class(m1)
length(m1)
attributes(m1)

mylist
mode(mylist)
class(mylist)
length(mylist)
attributes(mylist)

patientdata
mode(patientdata)
class(patientdata)
length(patientdata)
attributes(patientdata)

status
mode(status)
class(status)
length(status)
attributes(status)


# attach, detach, and with functions for data frame

mtcars
summary(mtcars$mpg)
plot(mtcars$mpg, mtcars$disp)
plot(mtcars$mpg, mtcars$wt)

attach(mtcars)
summary(mpg)
plot(mpg, disp)
plot(mpg, wt)
detach(mtcars)

with(mtcars, {
  print(summary(mpg))
  plot(mpg, disp)
  plot(mpg, wt)
})


