x1<- c(1,2,5,3,6,-2,4)
x1

x2<-c("one","two","three")
x2

x3<-c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
x3

x4<-c(0,0,0,0,0,0,0,0,0,0)
x4

x5<-1:10
x5

x6<-seq(1,10)
x6

x7<-seq(1,10,by=2)
x7

x8<-rep(1:3,2)
x8

y1<-c(1,2,"one")
y1

y2<-c(TRUE, FALSE,2)
y2

mode(x1)
mode(x2)
length(x1)

x1
x6+2
x6+x7
x7+x8
x6+x8

m1<-matrix(1:20, nrow=5, ncol=4)
m1

cells<-c(1,26,24,68)

rnames<-c("R1","R2")
cnames<-c("C1","C2")

m2<-matrix(cells, nrow=2, ncol=2,byrow=TRUE)
m2

m3<-matrix(cells,nrow=2,ncol=2,
           dimnames=list(rnames,cnames))
m3   

m4<-matrix(1:10,nrow=2)          
m4      

m4[1:4]
m4[2,]
m4[1,c(4,5)]

solve(m2)



list<-list(1,"a",TRUE,1+4i)
list1
list


g<-"My first list"
h<-c(25,26,18,39)
j<-matrix(1:10,nrow=5)
k<-list("a list witin a list", h)
mylist<-list(title=g, ages=h, j, k)
mylist


mylist[2]
mylist[[2]]
mylist$age

mylist[[4]]
mylist[[4]][[2]]
mylist[[4]][[2]][2]


mylist[[3]]
mylist[[3]][[c(2,3,)]]


patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabetes<-c("Type1","Type2","Type3")
status<-c("Poor","Improved","Excellent","Poor")
patientdata <- data.frame(patientID,age,diabetes,status)
