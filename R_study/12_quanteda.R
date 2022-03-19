##############################################################
#
#   quanteda (quantitative analysis of text data)
#
##############################################################

install.packages("quanteda")
library(quanteda)
library(tidyverse)
library(tm)
library(wordcloud)
library(stringr)

#  Build a corpus from a character vector

data(data_char_ukimmig2010)
str(data_char_ukimmig2010)
View(data_char_ukimmig2010)

?corpus
corp_uk <- corpus(data_char_ukimmig2010)
corp_uk
summary(corp_uk)
str(corp_uk)

?texts
texts(corp_uk)[2]

?docvars
docvars(corp_uk, "Party") <- names(data_char_ukimmig2010) #각각 다큐먼트 수준에서 변수 확인? 
docvars(corp_uk, "Year") <- 2010
summary(corp_uk)

summary(corp_uk, showmeta=TRUE)
metadoc(corp_uk, "language") <- "english"
summary(corp_uk, showmeta=TRUE)

#
#  Use a built-in corpus data_corpus_inaugural

data("data_corpus_inaugural")
data_corpus_inaugural
summary(data_corpus_inaugural)
texts(data_corpus_inaugural)[58]

tokeninfo <- summary(data_corpus_inaugural)
str(tokeninfo)

ggplot(data=tokeninfo, aes(x=Year, y=Tokens)) + geom_point() + geom_line()

tokeninfo[which(tokeninfo$Tokens > 5000), ]
tokeninfo[which.min(tokeninfo$Tokens), ]

#
#  Tools for handling corpus objects 
#   Adding two corpus objects together

corp1 <- corpus(data_corpus_inaugural[1:5])
corp2 <- corpus(data_corpus_inaugural[53:58])
corp3 <- corp1 + corp2
summary(corp3)

#   Subsetting corpus objects

corp4 <- corpus_subset(data_corpus_inaugural, Year > 1990)
summary(corp4)

corp5 <- corpus_subset(data_corpus_inaugural, President == "Bush")
summary(corp5)

# Exploring corpus tesxts with kwic() keywords-in-context

?kwic
kwic(data_corpus_inaugural, pattern="terror")
kwic(data_corpus_inaugural, pattern="terror", valuetype="regex")
kwic(data_corpus_inaugural, pattern = "communist*")
kwic(data_corpus_inaugural, pattern = phrase("United States"))
kwic(data_corpus_inaugural, pattern = phrase("United States")) %>%
  head()

#
#   Extracting Features from a corpus
#
# Tokenizing texts

?tokens
text <- "An example of preprocessing techiques"
tokens(text)
tokens(text, what="character")

txt <- c(txt1="This is $10 in 999 different ways,\n up and down; left and right!",
         txt2="@kenbenoit working: on #quanteda 2day\t4ever, http://textasdata.com?page=123.")
tokens(txt)
tokens(txt, remove_numbers = TRUE, remove_punct = TRUE)

tokens(txt, remove_numbers = TRUE, remove_punct = TRUE) %>%
  tokens_tolower()
tokens(txt, remove_numbers = TRUE, remove_punct = TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(stopwords("en"))
tokens(txt, remove_numbers = TRUE, remove_punct = TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(stopwords("en")) %>%
  tokens_wordstem()

tokens("New York City is located in the United States.")
tokens("New York City is located in the United States.") %>%
  tokens_compound(pattern = phrase(c("New York City","United States")))


# Constructing a DFM (document feature matrix)

?dfm
corp_inaug_post1990 <- corpus_subset(data_corpus_inaugural, Year > 1990)
dfm_inaug <- dfm(corp_inaug_post1990)
dfm_inaug
str(dfm_inaug)
dfm_inaug[, 1:5]

#  Remove stopwords and stemming the tokens

dfm_inaug <- dfm(corp_inaug_post1990,
                 remove = stopwords("english"),
                 stem=TRUE, remove_punct=TRUE)
dfm_inaug
dfm_inaug[, 1:5]

#  Differnt Weighing : Construct tf_idf DFM

dfm_inaug_tfidf <- dfm_tfidf(dfm_inaug)
dfm_inaug_tfidf
dfm_inaug_tfidf[,1:5]

#
#  Constructing a DFM from a character vector
dfm_txt <- dfm(txt,
               tolower = TRUE, stem = TRUE,
               remove = stopwords("en"), remove_numbers = TRUE, remove_punct = TRUE)
dfm_txt

# Construct a DFM from a token
token_txt <- tokens(txt, remove_numbers = TRUE, remove_punct = TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(stopwords("en")) %>%
  tokens_wordstem()
token_txt
dfm_txt <- dfm(token_txt)
dfm_txt


#  Viewing the DFM

?topfeatures
topfeatures(dfm_inaug, 20)

?textstat_frequency
textstat_frequency(dfm_inaug, 30)

?docfreq
docfreq(dfm_inaug, threshold=3)
docfreq(dfm_inaug, threshold=3) %>%
  sort(decreasing=TRUE) %>%
  head(30) 

textplot_wordcloud(dfm_inaug, min_count=10)
textplot_wordcloud(dfm_inaug, min_count=10, rotation = 0,
                   color=RColorBrewer::brewer.pal(8, "Dark2"))

