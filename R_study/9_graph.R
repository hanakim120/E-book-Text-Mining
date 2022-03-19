###################################################################
#
# R그래프 작성  Building graphs with R
#
##################################################################


#
#  Base 패키지의 그래픽 함수를 이용한 그림작성 
#  

mtcars
str(mtcars)

plot(mtcars$wt, mtcars$mpg)
abline(lm(mpg~wt, mtcars)) #직선을 그리라는 lowlevelfunction
title("Regression of MPG on Weight")#lowlevelfunction


#
#   High levelt plotting function: plot() function
#

# plot() function with one data object.

#  하나의 연속형 변수를 plot() 함수로 그래프를 작성한 경우 

plot(mtcars$mpg) #연속함수
plot(mtcars$vs) #번주형 데이터지만 numeric으로 되어있음
plot(mtcars$am)

# 하나의 범주형(factor) 변수를 plot() 함수로 그래프를 작성한 경우 

mtcars$vs <- factor(mtcars$vs, levels=c(0,1), labels=c("V-shaped", "straight"))
mtcars$am <- factor(mtcars$am, levels=c(0,1), labels=c("automatic", "manual"))
str(mtcars)

plot(mtcars$vs) #factor로 변경되었으므로 다른 그림이 나옴. 점이안찍히고 막대그래프가찍힘
plot(mtcars$am)

# 시계열 분석을 위한 line chart 작성하기 

plot(mtcars$mpg, type="l") #l로 설정해서 라인으로 나옴

library(ggplot2)
head(economics)
str(economics)
help(economics)
plot(economics$unemploy) #점이찍힘
plot(economics$unemploy, type="l") #라인으로 나옴

#
#  연속형 변수에 대한 high level plotting 함수의 사용 
#
#  hist() function : 연속형 변수 

hist(mtcars$mpg)
?hist
hist(mtcars$mpg, breaks=10)
hist(mtcars$mpg, breaks=10, col="blue")

hist(mtcars$vs)
hist(mtcars$cyl)

hist(economics$unemploy)

#
#  boxplot() funcion : y 축에는 연속형 변수가 사용됨 
#
#연속형 데이터만 써야 결과가 나옴
boxplot(mtcars$mpg)
boxplot(mtcars$wt)
boxplot(economics$unemploy)

boxplot(mtcars$vs)

#
#  범주형 변수에 대한 high level plotting 함수의 사용 
#

# 6-1 Bar plots

install.packages("vcd")
library(vcd)

head(Arthritis)
str(Arthritis)
help("Arthritis")
summary(Arthritis)

counts <- table(Arthritis$Improved)
counts

barplot(counts, main="Simple Bar Plot",
        xlab="Improvement", ylab="Frequency")

barplot(counts, main="Horizontal Bar Plot",
        xlab="Frequency", ylab="Improvement", horiz=TRUE)

#  barplot(), plot() functions for factor vector

barplot(Arthritis$Improved, main="Simple Bar Plot",
        xlab="Improvement", ylab="Frequency")

plot(Arthritis$Improved, main="Simple Bar Plot",
     xlab="Improvement", ylab="Frequency")


#  6-2 Pie Charts

pie(counts, main="Simple Pie Chart")

slices <- c(10,12,4,16,8)
lbls <- c("US", "UK", "Aurstralia", "Germany", "France")
pie(slices, labels=lbls, main="Simple Pie Chart")

pct <- round(slices/sum(slices)*100)
lbls2 <- paste(lbls, " ", pct, "%", sep=" ")
pie (slices, labels=lbls2, col=rainbow(length(lbls2)),
     main="Pie Chart with Percentages")

#
#   이변량(bivarite) 데이터의 그래프 작성 
#

#  plot() 함수를 이용한 이변량 데이터 그래프
#  두변수가 모두 연속형인 경우: 산점도 (scatter diagrams)

plot(mtcars$wt, mtcars$mpg)
plot(mtcars$cyl, mtcars$mpg)

#  y축에 연속형 변수, x축에 팩터 변수를 사용한 경우 : boxplot
plot(mtcars$vs, mtcars$mpg)

#  여러변수들 간의 산점도 행렬 (Scatter plot matrices)

pairs(~ mpg + disp + drat + wt, data=mtcars,
      main="Basic Scatter Plot Matrix")

#
#  boxplot() 함수를 이용한 이변량 데이터 그래프 
# formula를 이용하여 연속형 변수와 범주형 변수가 사용된 경우 

boxplot(mpg~vs, data=mtcars)
boxplot(mpg~am, data=mtcars)

boxplot(mpg ~ cyl, data=mtcars, main="Car Mileage Data",
        xlab="Number of Cyliners", ylab="Miles per Gallon")

#
# barplot() 함수를 이용항 이변량 데이터 그래프 
# Stacked and Grouped Bar Plot

counts <- table(Arthritis$Improved, Arthritis$Treatment)
counts

barplot(counts, main="Stacked Bar Plot",
        xlab="Treatment", ylab="Frequency",
        col=c("red","yellow","green"), legend=rownames(counts))

barplot(counts, main="Stacked Bar Plot",
        xlab="Treatment", ylab="Frequency",
        col=c("red","yellow","green"), 
        legend=rownames(counts), beside=TRUE)

#
#  Low level plotting 함수를 사용한 그래프 작성 
#

# lines() 함수를 이용한 라인 추가

women
str(women)

fit1 <- lm(weight ~ height, data=women)
plot(women$height, women$weight, main="Scatter plot between height and weight")
lines(women$height, fit1$fitted.values,  col="blue")
lines(lowess(women$height, women$weight), col="red")

#  abline() 함수를 이용한 라인 추가

attach(mtcars)
plot(wt, mpg, main="Basic Scatter plot of MOG vs. Weights",
     xlab="Car Weight", ylab="Mile per gallon", pch=19)
abline(lm(mpg~wt), col="blue", lwd=2, lty=1)
lines(lowess(wt,mpg), col="red", lwd=2, lty=2)
detach(mtcars)



#
#  How to change graphic options (by arguments, by par() function)
#

dose <- c(20,30,40,45,60)
drugA <- c(16,20,27,40,60)
drugB <- c(15, 18, 25, 31, 40)

plot(dose, drugA, type="b")      # by arguments within a plot() function

plot(dose, drugA)

opar <- par(no.readonly = TRUE)
par(lty=2, pch=17)              # by par() functions  
plot(dose, drugA, type="b")
par(opar)

plot(dose, drugA, type="b")

plot(dose, drugA, type="b", lty=3, lwd=3, pch=15, cex=2)


#  How to deterimine colors by specifying col arguments

plot(dose, drugA, type="b", col="red")

colors()
rainbow(7)

n <- 10
mycolors <- rainbow(n)
pie(rep(1,n), labels=mycolors, col=mycolors)

#
#  그래프의 글자, 크기 및 마진 설정 
#

opar <- par(no.readonly=TRUE)
par(pin=c(2,3))
par(lwd=2, cex=1.5)
par(cex.axis=.75, font.axis=3)
plot(dose, drugA, type="b", pch=19, lty=2, col="red")
plot(dose, drugB, type="b", pch=23, lty=6, col="blue", bg="green")
par(opar)


# Adding Text, customized axes, and legends

plot (dose, drugA, type="b", col="red", lty=2, pch=2, lwd=2,
      main="Clinical Trials for Drug A", sub="This is hypothetical data",
      xlab="Dosage", ylab="Drug Response", xlim=c(0,60), ylim=c(0,70))

title(main="My Title", col.main="red", sub="My Subtitle", col.sub="blue",
      xlab="My x label", ylab="My y label", col.lab="green", cex.lab=0.75)

#  상위수준 함수에서 title, sub, labels을 지정하지 않음 

plot (dose, drugA, type="b", col="red", lty=2, pch=2, lwd=2)

title(main="Clinical Trials for Drug A", col.main="red", 
      sub="This is hypothetical data", col.sub="blue",
      xlab="Dose", ylab="Drug Response", col.lab="green", cex.lab=0.75)

# 상위수준 함수에서 ann=FALSE로 지정  

plot (dose, drugA, type="b", col="red", lty=2, pch=2, lwd=2, ann=FALSE)

title(main="Clinical Trials for Drug A", col.main="red", cex.main=2,
      sub="This is hypothetical data", col.sub="blue", cex.sub=1.5,
      xlab="Dose", ylab="Drug Response", col.lab="green")


#
#  Example of  Adding text, customized axes, and legends
# 

x <- c(1:10)
y <- x
z <- 10/x
opar <- par(no.readonly=TRUE)
par(mar=c(5,4,4,8) + 0.1)

plot(x,y, type="b", pch=21, col="red", yaxt="n", ann=FALSE)
lines(x,z, type="b", pch=22, col="blue", lty=2)

axis(2, at=x, labels=x, col.axis="red", las=2)
axis(4, at=z, labels=round(z, digits=2), col.axis="blue", las=2, cex.axis=0.7)

mtext("y=1/x", side=4, line=3, col="blue", las=2)

title("An Example of Creative Axes", xlab="X values", ylab="Y=X")


#  Listing3.3:   Using Legends: Comparing drugA and drugB respose

opar <- par(no.readonly=TRUE)
par(lwd=2, cex=1.5, font.lab=2)

plot(dose, drugA, type="b", pch=15, lty=1, col="red", ylim=c(0,60),
     main="DrugA vs. DrugB", xlab="Dosage", ylab="Drug Response")

lines(dose, drugB, type="b", pch=17, lty=2, col="blue")

legend ("topleft", title="Drug Type", c("A","B"), 
        lty=c(1,2), pch=c(15,17), col=c("red","blue"))

par(opar)


#  3-4-5    Text annotations

attach(mtcars)
plot(wt, mpg, pch=18, col="blue", 
     main="Mileage vs. Car Weight", xlab="Weight", ylab="Mileage")
text(wt, mpg, row.names(mtcars), cex=0.75, pos=4, col="red")
detach(mtcars)


# 3-5   Combining graphs

attach(mtcars)
opar <- par(no.readonly=TRUE)
par(mfrow=c(2,2))

plot(wt, mpg, main="Scatterplot of wt vs. mpg")
plot(wt, disp, main="Scatterplot of wt vs. disp")
hist(wt, main="Histogram of wt")
boxplot(wt, main="Boxplot of wt")

par(opar)
detach(mtcars)

# 3.5.1   Creating a figure arrangement with fine control

attach(mtcars)
opar <- par(no.readonly=TRUE)
par(fig=c(0, 0.8, 0.,0.8))

plot(mpg, wt, xlab="Miles per Gallon", ylab="Car Weight")

par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(mpg, horizontal=TRUE, axes=FALSE)

par(fig=c(0.65, 1, 0, 0.8), new=TRUE)
boxplot(wt, axes=FALSE)

mtext("Enhanced Scatterplot", side=3, outer=TRUE, line=-3)
par(opar)
detach(mtcars)



##############################################################################
#
#    Advanced graphics with ggplot2
#
##############################################################################

library(ggplot2)

ggplot(data=mtcars, aes(x=wt, y=mpg)) + geom_point() +
  labs(title="Automobile Data", x="Weight", y="Miles per Gallon")

#   ggplot2의 그래프 작성 구조 

ggplot(data=mtcars, aes(x=wt, y=mpg))

ggplot(data=mtcars, aes(x=wt, y=mpg)) + geom_point()

ggplot(data=mtcars, aes(x=wt, y=mpg)) + geom_point() +
  labs(title="Automobile Data", x="Weight", y="Miles per Gallon")

ggplot(data=mtcars, aes(x=wt, y=mpg)) + 
  geom_point(pch=17, color="blue", size=2) +
  geom_smooth(method="lm", color="red", linetype=2) +
  labs(title="Automobile Data", x="Weight", y="Miles per Gallon")


# specifying the plot with geoms (with Salaries data)

install.packages("car")
library(car)
str(Salaries)

ggplot(Salaries, aes(x=salary)) + geom_histogram(alpha=0.5)

ggplot(Salaries, aes(x=salary)) + geom_density()
ggplot(Salaries, aes(x=salary, fill=rank)) +geom_density(alpha=0.3)

ggplot(Salaries, aes(x=rank, y=salary)) + geom_boxplot()

ggplot(Salaries, aes(x=rank, y=salary)) +
  geom_boxplot() + geom_point(position="jitter", alpha=.5) 

# Grouping by scatterplots

ggplot(data=Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_point()  

ggplot(data=Salaries, aes(x=yrs.since.phd, y=salary, color=rank)) +
  geom_point()  

ggplot(data=Salaries, aes(x=yrs.since.phd, y=salary, color=rank, shape=sex)) +
  geom_point()


# Various representation of bar charts

ggplot(Salaries, aes(x=rank)) + geom_bar()
ggplot(Salaries, aes(x=rank, fill=sex)) + geom_bar()
ggplot(Salaries, aes(x=rank)) + geom_bar(fill="red")

ggplot(Salaries, aes(x=rank, fill=sex)) +
  geom_bar(position="stack") +labs(title="position is stack")

ggplot(Salaries, aes(x=rank, fill=sex)) +
  geom_bar(position="dodge") +labs(title="position is dodge")

ggplot(Salaries, aes(x=rank, fill=sex)) +
  geom_bar(position="fill") +labs(title="position is fill")


# Faceting  (facet_wrap, facet_grid)

ggplot(Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_point() + facet_wrap(~sex)

ggplot(Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_point() + facet_grid(.~rank)

ggplot(Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_point() + facet_grid(sex~.)

ggplot(Salaries, aes(x=yrs.since.phd, y=salary, color=rank)) +
  geom_point() + facet_wrap(~sex)

ggplot(Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_point() + facet_grid(rank~sex)

ggplot(Salaries, aes(x=salary)) +
  geom_density() + facet_grid(rank~.)

ggplot(Salaries, aes(x=rank, y=salary)) +
  geom_boxplot() + facet_grid(sex~.)


# Grouping and facetting

mtcars$am <- factor(mtcars$am, levels=c(0,1), labels=c("Automatic", "Manual"))
mtcars$vs <- factor(mtcars$vs, levels=c(0,1), labels=c("V-Engine","Straight Engine"))
mtcars$cyl <- factor(mtcars$cyl)

ggplot(data=mtcars, aes(x=hp, y=mpg, shape=cyl, color=cyl)) +
  geom_point(size=3) + facet_grid(am~vs) +
  labs(title="Automobile data by Engine type", x="Horsepower", y="Mile per gallon")

# Adding Smoothed lines

ggplot(data=Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_smooth() + geom_point()

ggplot(data=Salaries, aes(x=yrs.since.phd, y=salary)) +
  geom_smooth(method="lm") + geom_point()

ggplot(Salaries, aes(x=yrs.since.phd, y=salary, linetype=sex, shape=sex, color=sex)) +
  geom_smooth(method=lm, formula=y~poly(x,2), se=FALSE, size=1) + geom_point(size=2)


# Multiple Graphs per one page

p1 <- ggplot(data=Salaries, aes(x=rank)) +geom_bar()
p2 <- ggplot(data=Salaries, aes(x=sex)) + geom_bar()
p3 <- ggplot(data=Salaries, aes(x=yrs.since.phd, y=salary)) + geom_point()

install.packages("gridExtra")
library(gridExtra)
grid.arrange(p1, p2, p3, ncol=3)


# Saving graphs

myplot <- ggplot(data=mtcars, aes(x=mpg)) +geom_histogram()
ggsave(file="mygraph.png", plot=myplot, width=5, height=4)

ggplot(data=mtcars, aes(x=mpg)) + geom_density()
ggsave(file="mygraph.pdf")

