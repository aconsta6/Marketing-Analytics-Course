# Class: 6

# Date: 6/17/2021

# Author: Ken Faro, Ph.D.

# Copyright: All Documents © Dr. Kenneth R. Faro or © Inkblot Holdings, LLC

# License: Faro and Inkblot Educational License For One Semester Use

# Disclosure: These materials are subject to the terms of the "Notice of Faro and 
#             Inkblot Educational License For One Semester Use", posted in this repository. 

####################################################
########## Learning Basic Statistics in R ########## 
####################################################

# Why use social media in marketing Analytics

## Identify the trends of what people are talking about
## Identify the trends of style of appeal 

# What do we want to look at in the data?

## Freuency of keywords
## Demographics of the keywords
## Form of content (video/ static) people usually browse (or engage with)
## Type of content (Listicles, buzzfeed quizes)
## Look at engagement of the audience (how they're engaging)

# Marketing POV, what strategies can we implemen?

## Use what content they're browsing to serve future content
## Promotions - what kind of messaging to use / appeal to target
## Could be used to optimize SEO on web
## Whatever content is trending, developing

# n-grams
# 2-grams
# 3-grams 

#Text Specific packages
library(tm)
library(wordcloud)
library(topicmodels)
library(stringr)

#Twitter specific packages
library(twitteR)
library(streamR)
library(rtweet)

#Time Related Packages
library(zoo)
library(smooth)
library(datetime)
library(lubridate)

tweets <- read.csv("/Users/Ken/Desktop/data4.csv")

#Step 1: Make readable by computer
tweets$tweets2 <- iconv(tweets$text, 'latin1', 'ASCII', sub="")

#step 2: Make into a VCorpus (readable text-based document)
tweets_corpus <- VCorpus(VectorSource(tweets$tweets2))

#step 3: remove puncuation
tweets_corpus <- tm::tm_map(tweets_corpus, removePunctuation)

#Step 4: remove whitespaces
tweets_corpus <- tm::tm_map(tweets_corpus, stripWhitespace)

#Step 5: remove numbers
tweets_corpus <- tm_map(tweets_corpus, removeNumbers)

#Step 6: remove captials
tweets_corpus <- tm_map(tweets_corpus, content_transformer(tolower))

#step 7: remove stop words
tweets_corpus <- tm::tm_map(tweets_corpus, removeWords, stopwords("en"))

Comprehension_dict <- c("need", "grammy")

dtm_comprehend <- DocumentTermMatrix(tweets_corpus, control = list(dictionary=Comprehension_dict))

#####

Textdoc <- tm::TermDocumentMatrix(tweets_corpus)
Textdoc_matrix <- as.matrix(Textdoc)

###Sorting word frequecies

dtm_v <- sort(rowSums(Textdoc_matrix), decreasing = TRUE)

dtm_d <- data.frame(word = names(dtm_v), freq=dtm_v)

#### plot top 5 terms

barplot(dtm_d[1:5,]$freq, las = 2, names.arg=dtm_d[1:5,]$word,
        col="green", main="Top 5 frequent words from the grannys", ylab = "frequencies (n)"
        )

#### Install Wordcloud

library(wordcloud)

library(wesanderson)

wordcloud(words = dtm_d$word, freq = dtm_d$freq, min.freq = 5, 
          max.words = 50, random.order=FALSE,
          colors=wes_palette("Moonrise1")
          )

#### find associations

x <- tm::findAssocs(Textdoc,c("follotrick", "lipa"), corlimit = 0.80)

#### Sentiment

library(syuzhet)
library(ggplot2)

s_vector1 <- get_sentiment(tweets$text[1:500], method = "syuzhet")

summary(s_vector)

s_vector

tweets$text[372]

min(s_vector)

s_vector2 <- get_sentiment(tweets$text[1:500], method = "bing")

s_vector3 <- get_sentiment(tweets$text[1:500], method = "afinn")

### Emotion via NRC

y <- get_nrc_sentiment(as.character(tweets$text[1:500]))

library(dplyr)

z <- y %>%
  summarise_all(funs(mean))

ggplot(z) + geom_bar()

###

td <- data.frame(t(y))
td_new <- data.frame(rowSums(td))    
names(td_new)[1]<- "count"
td_new <- cbind("sentiment" = rownames(td_new),td_new)
rownames(td_new) <- NULL
td_new2 <- td_new[1:8,]
quickplot(sentiment,data=td_new2, weight = count, geom="bar", fill =sentiment, ylab="count")+ggtitle("Emotions")



