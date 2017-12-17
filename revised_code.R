library(quanteda)
blogs <- file('final/en_US/en_US.blogs.txt')
news <- file('final/en_US/en_US.news.txt')
twitter <- file('final/en_US/en_US.news.txt')

blog_snip <- readLines(blogs, 10000)
news_snip <- readLines(news, 10000)
twitter_snip <- readLines(twitter, 10000)

close(blogs)
close(news)
close(twitter)

sample <- c(blog_snip, news_snip, twitter_snip)

full_clear <- function(ngrams = 1) {
  dfm(sample, ngrams = ngrams, remove = stopwords('english'), 
      remove_punct = TRUE, remove_numbers = TRUE, 
      remove_symbols=TRUE)
}

unigrams <- full_clear()
bigrams <- full_clear(2)
trigrams <- full_clear(3)

topfeatures(unigrams, 50)
topfeatures(bigrams, 50)
topfeatures(trigrams, 50)

all_in <- full_clear(1:3)
topfeatures(all_in, 50)
