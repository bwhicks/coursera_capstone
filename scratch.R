load('ngram-freqs.Rdata')


no_num <- "Being alone is better than being with the wrong"
wordvec <- tail(strsplit(no_num, " +"), 3)[[1]]

# get three, two and one last word
three <- paste('^', paste(tail(wordvec, 3), collapse='_'), '_', sep='')
two <- paste('^', paste(tail(wordvec, 2), collapse='_'), '_', sep='')
one <- paste('^', paste(tail(wordvec, 1), collapse='_'), '_', sep='')

# find their matches
quad_matches <- quad.freq.df[grep(three, quad.freq.df$ngram),]
tri_matches <- tri.freq.df[grep(two, tri.freq.df$ngram),]
bi_matches <- bi.freq.df[grep(one, bi.freq.df$ngram),]

# if there are matches at any level, use the stupid backoff
# to assign them a rating
if (nrow(quad_matches) != 0) {
  quad_matches$rating <- quad_matches$count / nrow(quad.freq.df)
} else {
  quad_matches$rating <- character(0)
}

full_df <- quad_matches

if (nrow(full_df) < 3) {
  if (nrow(tri_matches) != 0) {
    tri_matches$rating <- tri_matches$count * 0.4/ nrow(tri.freq.df)
  } else {
    tri_matches$rating <- character(0)
  }
  full_df <- rbind(full_df, tri_matches)
  
}


if (nrow(full_df) < 3) {
  if (nrow(bi_matches) != 0 ) {
    bi_matches$rating <- bi_matches$count * 0.4 * 0.4 / nrow(bi.freq.df)
  } else {
    bi_matches$rating <- character(0)
  }
  full_df <- rbind(full_df, bi_matches)
}

if (nrow(full_df) < 3) {
  top50 <- uni.freq.df[1:20, ]
  random3 <- uni.freq.df[sample(15, 3), ]
  random3$rating <- random3$count * 0.4 * 0.4 * 0.4 / nrow(uni.freq.df)
  full_df <- rbind(full_df, random3)
}


sorted <- full_df[order(-full_df$rating), ]
match_df <- sorted[1:3,]
get_pred <- function(x) {
  tail(strsplit(as.character(x), "_")[[1]], 1)
}

word_matches <- as.character(lapply(match_df$ngram, get_pred))
word_matches







  
