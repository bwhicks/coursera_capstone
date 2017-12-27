# Load Quanteda
library(quanteda)

# Read in all of the sources as text files
blogs <- file('en_US/en_US.blogs.txt')
news <- file('en_US/en_US.news.txt')
twitter <- file('en_US/en_US.news.txt')
blog_snip <- readLines(blogs, -1)
news_snip <- readLines(news, -1)
twitter_snip <- readLines(twitter, -1)

# close file handles
close(blogs)
close(news)
close(twitter)

# create a joint sample of the three different contexts for one model set
sample <- c(blog_snip, news_snip, twitter_snip)

# function to make a quanteda dfm, then trim it to ngrams that 
# occur only more than 10 times in the corpus
full_clear <- function(ngrams = 1) {
  myDfm <- dfm(sample, ngrams = ngrams, remove = stopwords('english'), 
      remove_punct = TRUE, remove_numbers = TRUE, 
      remove_symbols=TRUE)
  dfm_trim(myDfm, min_count = 10)
}

# create 1 - 4 grams
unigrams <- full_clear()
bigrams <- full_clear(2)
trigrams <- full_clear(3)
quadgrams <- full_clear(4)
quingrams <- full_clear(5)

# Make frequency data frames for matching using
# data.table
uni_sums <- sort(colSums(unigrams), decreasing = TRUE)
uni.freq.df <- data.frame(ngram = names(uni_sums), count = uni_sums )
bi_sums <- sort(colSums(bigrams), decreasing = TRUE)
bi.freq.df <- data.frame(ngram = names(bi_sums), count = bi_sums )
tri_sums <- sort(colSums(trigrams), decreasing = TRUE)
tri.freq.df <- data.frame(ngram = names(tri_sums), count = tri_sums )
quad_sums <- sort(colSums(quadgrams), decreasing = TRUE)
quad.freq.df <- data.frame(ngram = names(quad_sums), count = quad_sums)
quin_sums <- sort(colSums(quingrams), decreasing = TRUE)
quin.freq.df <- data.frame(ngram = names(quin_sums), count = quin_sums)


# save dataframes as raw RData
save(quin.freq.df, quad.freq.df, tri.freq.df, bi.freq.df, uni.freq.df, file='ngram-freqs.Rdata')
