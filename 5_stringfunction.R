################################################
#
#   2부   텍스트 데이터 사전처리 
#
#     02  텍스트 분석을 위한 base 함수
#
##############################################

# letters, LETTERS built-in constant  

letters
LETTERS
letters[3]
LETTERS[3]
letters[1:5]
LETTERS[1:5]

class(letters)
length(letters)

# tolower(), toupper() 함수 

tolower("Eye for eye")
toupper("Eye for eye")

# nchar() 함수 

nchar("Korea")
nchar("Korea", type="bytes")

nchar("한국")
nchar("한국", type="bytes")

nchar("Korea")
nchar("Korea ")
nchar("Korea\t")
nchar("Korea, Republic of")

x <- c("ab", "cde", "fghij")
nchar(x)
nchar(x[3])

# strsplit() 함수 

mysentence <- "Learning R is so interesting"
strsplit(mysentence, split=" ")
strsplit(mysentence, split="")

mywords <- strsplit(mysentence, split=" ")
mywords
class(mywords)
strsplit(mywords[[1]][5], split="")

strsplit(x, split="")


# paste() 함수 

paste("var", 1:3, sep="")
paste("var", 1:3, sep=" ")
paste("var", 1:3, sep="", collapse=" ")
paste(letters, 1:26, LETTERS, sep="_")
paste(letters, 1:26, LETTERS, sep="", collapse=" ")

paste(x)
paste(x, sep="")
paste(x, collapse=" ")

paste(x, 1:3)
paste(x, 1:3, sep="")
paste(x, 1:3, sep="", collapse=" / ")

# grep(), grepl():  특정 표현이 텍스트데이터에서 등장하는지를 확인 

?state.name
state.name

grep("New", state.name)
grep("New", state.name, value=TRUE)
grepl("New", state.name)

r_grep <- grep("New", state.name)
class(r_grep)
attributes(r_grep)

# regexpr(), gregexpr(), regexec(): 텍스트 데이터체서 특정표현의 위치정보 

mysentence <- "Learing R is so interesting"


regexpr("ing", mysentence)
r_regexpr <- regexpr("ing", mysentence)
class(r_regexpr)
attributes(r_regexpr)

loc_begin <- as.vector(r_regexpr)
loc_begin
loc_length <- as.vector(attr(r_regexpr, "match.length"))
loc_length
loc_end <- loc_begin + loc_length -1
loc_end

gregexpr("ing", mysentence)
r_gregexpr <- gregexpr("ing", mysentence)
class(r_gregexpr)
attributes(r_gregexpr)
r_gregexpr
r_gregexpr[[1]]
attributes(r_gregexpr[[1]])
length(r_gregexpr)
length(r_gregexpr[[1]])

loc_begin <- as.vector(r_gregexpr[[1]])
loc_begin
loc_length <- as.vector(attr(r_gregexpr[[1]], "match.length"))
loc_length
loc_end <- loc_begin + loc_length - 1
loc_end

#  sub(), gsub(): 지정표현을 다른표현으로 교체 

mysentence
sub("ing", "ING", mysentence)
gsub("ing", "ING", mysentence)

sub("New", "_new_", state.name)


# regmatch() 원하는 표현만 추출 

mysentence
mypattern <- regexpr("ing", mysentence)
regmatches(mysentence, mypattern)
regmatches(mysentence, mypattern, invert=TRUE)

mypattern <- gregexpr("ing", mysentence)
regmatches(mysentence, mypattern)
regmatches(mysentence, mypattern, invert=TRUE)

strsplit(mysentence, split="ing")
gsub("ing", "", mysentence)

# substr() 함수 

substr(mysentence, 1,10)
substr(mysentence, 1, 20)

#
#  stringr 패키지  문자열 함수 
#

library(stringr)

mysentence2 <- c("Learing R is so interesting", "He is a fascinating singer")

# str_extract(), str_extract_all() 함수: 지정된 표현 추출하기 

str_extract(mysentence, "ing")
str_extract_all(mysentence, "ing")

str_extract(my2sentence, "ing")
str_extract_all(my2sentence, "ing")

#  str_view(), str_view_all() 함수 

str_view(mysentence, "ing")
str_view_all(mysentence, "ing")
str_view_all(mysentence2, "ing")

# str_locate(), str_locate_all() 함수 

str_locate(mysentence, "ing")
str_locate_all(mysentence, "ing")

str_locate(mysentence2, "ing")
str_locate_all(mysentence2, "ing")

# str_replace(), str_relpace_all() 함수 

str_replace(mysentence, "ing", "ING")
str_replace_all(mysentence, "ing", "ING")

str_replace(mysentence2, "ing", "ING")
str_replace_all(mysentence2, "ing", "ING")

# str_split(), str_split_fixed() 함수 

str_split(mysentence, " ")
str_split_fixed(mysentence, " ", 3)

str_split(mysentence2, " ")
str_split_fixed(mysentence2, " ", 4)

# str_c() 함수 

str_c("var", 1:3)
str_c("var", 1:3, sep=" ")
str_c("var", 1:3, collapse=" ")

# str_count() 함수 

str_count(mysentence, "ing")
str_count(mysentence2, "ing")

# str_sub() 함수 

str_sub(mysentence, 1, 10)
str_sub(mysentence2, 1, 10)

# str_length() 함수 

str_length(mysentence)
str_length(mysentence2)


#
#  텍스트 데이터 분석에서 유용한 정규표현 (regular expression)
#

# "ing"에 매칭되는 문자열 추출 

mypattern1 <- gregexpr("ing", mysentence2)
regmatches(mysentence2, mypattern1)

str_extract_all(mysentence2, "ing")

# "ing" 앞에 1글자  알파벳이 있는 문자열을  추출 

mypattern2 <- gregexpr("[[:alpha:]](ing)", mysentence2)
regmatches(mysentence2, mypattern2)

str_extract_all(mysentence2, "[[:alpha:]]ing")

# "ing" 앞에 1개 이상 글자의 알파벳이 있는 문자열을 추출 

mypattern3 <- gregexpr("[[:alpha:]]+(ing)", my2sentence)
regmatches(my2sentence, mypattern3)

str_extract_all(mysentence2, "[[:alpha:]]+(ing)")

# /"ing" 앞에 알파벳이 존재하고, 마지막 글자인 문자열을 추출 

mypattern4 <- gregexpr("[[:alpha:]]+(ing)\\b", my2sentence)
regmatches(my2sentence, mypattern4)

str_extract_all(mysentence2, "[[:alpha:]]+(ing)\\b")


#  정규표현식의 특수문자 및 character class 처리 

mystring <- "abcABC123\t.!?\\(){}\n"
print(mystring)
cat(mystring)

str_see <- function(rx) str_view_all(mystring, rx)
reg_exp <- function(rx) regmatches(mystring, regexpr(rx, mystring))

str_see("a")
reg_exp("a")

str_see("\.")
str_see("\\.")
reg_exp("\.")
reg_exp("\\.")

str_see("\\!")
reg_exp("\\!")

str_see("\\(")
reg_exp("\\(")

str_see("\\\\")
reg_exp("\\\\")

str_see("\\t")
reg_exp("\\t")

str_see("\\n")
reg_exp("\\n")

str_see("\\b")
reg_exp("\\b")

str_see("[:alpha:]")
reg_exp("[:alpha:]")
reg_exp("[:alpha:]+")
reg_exp("[[:alpha:]]+")

str_see("[:alnum:]")
str_see("[[:alnum:]]")
reg_exp("[[:alnum:]]+")

#  quantifiers(정량자: 얼마나 많이 반복할 것인가?) 이용하기

strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")

grep("ac*b", strings, value=TRUE)
grep("ac+b", strings, value=TRUE)
grep("ac?b", strings, value=TRUE)
grep("ac{2}b", strings, value=TRUE)
grep("ac{2,}b", strings, value=TRUE)
grep("ac{2,3}b", strings, value=TRUE)
#   grep("ac{,2}b", strings, value=TRUE)

# 문자열, 단어 패턴의 위치 (anchors)

strings <- c("abcd", "cdab", "cabd", "c abd")

grep("ab", strings, value=TRUE)
grep("^ab", strings, value=TRUE)
grep("ab$", strings, value=TRUE)
grep("\\bab", strings, value=TRUE)
grep("ab\\b", strings, value=TRUE)
grep("\\bab\\b", strings, value=TRUE)
grep("\\Bab", strings, value=TRUE)
grep("ab\\B", strings, value=TRUE)

#  character classes and groups

strings <- c("^ab", "ab", "abc", "abd", "abe", "ab 12", "bc", "bcd")

grep("ab.", strings, value=TRUE)
grep("ab[cd]", strings, value=TRUE)
grep("ab[c-e]", strings, value=TRUE)
grep("ab[^c]", strings, value=TRUE)
grep("(a|b)c", strings, value=TRUE)
grep("^ab", strings, value=TRUE)
grep("\\^ab", strings, value=TRUE)


#  텍스트 데이터에서 원하는 부분이 어디에 있는지 인덱싱하기 

R_wiki <- "R is a programming language and free software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, data mining surveys, and studies of scholarly literature databases show substantial increases in popularity; as of July 2019, R ranks 20th in the TIOBE index, a measure of popularity of programming languages.
A GNU package, source code for the R software environment is written primarily in C, Fortran and R itself, and is freely available under the GNU General Public License. Pre-compiled binary versions are provided for various operating systems. Although R has a command line interface, there are several graphical user interfaces, such as RStudio, an integrated development environment.
"
R_wiki
class(R_wiki)
length(R_wiki)

# wikipedia에서 설명함 R 문장을 단락, 문장, 단어로 분리함 

R_wiki_para <- strsplit(R_wiki, split="\n")
R_wiki_para

R_wiki_sent <- strsplit(R_wiki_para[[1]], split="\\.")
R_wiki_sent

R_wiki_word <- list(length(R_wiki_sent))
for(i in 1:length(R_wiki_sent)){
  R_wiki_word[[i]] <- strsplit(R_wiki_sent[[i]], split=" ")
}
R_wiki_word
R_wiki_word[[1]][[2]][4]

# 문장 단위에서 list 형식을 vector 형식으로 변환 

mysentences <- unlist(R_wiki_sent)
R_wiki_sent
mysentences


# 특정한 패턴을 지니는  단어를  추출 

# ing로 끝나는 단어를 추출 
mypattern <- gregexpr("[[:alpha:]]+(ing)\\b", mysentences)
myings <- regmatches(mysentences, mypattern)
myings
table(unlist(myings))

table(unlist(str_extract_all(mysentences, "[[:alpha:]]+(ing)\\b")))

lower_mysentences <- tolower(mysentences)
mypattern <- gregexpr("[[:alpha:]]+(ing)\\b", lower_mysentences)
myings <- regmatches(lower_mysentences, mypattern)
table(unlist(myings))

table(unlist(str_extract_all(lower_mysentences, "[[:alpha:]]+(ing)\\b")))

# stat으로 시작하는 단어를 추출 
mypattern <- gregexpr("(stat)[[:alpha:]]+", lower_mysentences)
regmatches(lower_mysentences, mypattern)
table(unlist(regmatches(lower_mysentences, mypattern)))

table(unlist(str_extract_all(lower_mysentences, "(stat)[[:alpha:]]+")))

#  software라는 단어가 들어 있는 부분을 식별하고 추출함 

regexpr("software", mysentences)
gregexpr("software", mysentences)

mytemp <- regexpr("software", mysentences)
my_begin <- as.vector(mytemp)
my_begin[my_begin == -1] <- NA

my_end <- my_begin + as.vector(attr(mytemp, "match.length")) -1
my_locs <- matrix(NA, nrow=length(my_begin), ncol=2)
colnames(my_locs) <- c("begin", "end")
rownames(my_locs) <- paste("sentence", 1:length(my_begin), sep="_")
for(i in 1:length(my_begin)){
  my_locs[i,] <- cbind(my_begin[i], my_end[i])
}
my_locs

grep("software", mysentences)
grepl("software", mysentences)

str_locate_all(mysentences, "software")
str_locate_all(R_wiki, "software")
unlist(str_locate_all(mysentences, "software"))

# 고유명사가 되는 부분을 하나의 단어로 변환 

sent1 <- R_wiki_sent[[1]][1]
new_sent1 <- gsub("R Foundation for Statistical Computing", 
                  "R_Foundation_for_Statistical_Computing", sent1)
sum(table(strsplit(sent1, split=" ")))
sum(table(strsplit(new_sent1, split=" ")))

drop_sent1 <- gsub("and", "", new_sent1)
sum(table(strsplit(drop_sent1, split=" ")))


#  텍스트에서 사용된 대문자, 소문자를 구분함 

mypattern <- gregexpr("[[:upper:]]", mysentences)
my_uppers <- regmatches(mysentences, mypattern)
table(unlist(my_uppers))

mypattern <- gregexpr("[[:lower:]]", mysentences)
my_lowers <- regmatches(mysentences, mypattern)
table(unlist(my_lowers))

mypattern <- gregexpr("[[:lower:]]", lower_mysentences)
my_alphas <- regmatches(lower_mysentences, mypattern)
mytable <- table(unlist(my_alphas))
mytable

mytable[mytable==max(mytable)]
length(mytable)
sum(mytable)

#  ggplot을 이용한 시각화 

library(ggplot2)
mydata <- data.frame(mytable)

ggplot(data=mydata, aes(x=Var1, y=Freq)) +
  geom_bar(stat="identity") +
  geom_hline(aes(yintercept=median(mytable))) +
  xlab("알파벳(대문자와 소문자 구분 없음)") + ylab("빈도수")
