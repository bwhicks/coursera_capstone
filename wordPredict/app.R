#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(data.table)
library(shiny)
library(shinydashboard)
library(markdown)
# Load previously produced n-gram model
# all models are in order of their frequency from highest to
# lowest already to save computing time on Shiny App.
load('../ngram-freqs.Rdata')

# Uses a stupid backoff through quad, tri, and bigrams
# to make a guess at completing a sequence in an autocomplete.

backoff <- function(wordvec) {
  if (length(wordvec) == 0) {
    return(character(0))
  }
  # get four, three, two and one last word of the phrase
  four <-
    paste('^', paste(tail(wordvec, 4), collapse = '_'), '_', sep = '')
  three <-
    paste('^', paste(tail(wordvec, 3), collapse = '_'), '_', sep = '')
  two <-
    paste('^', paste(tail(wordvec, 2), collapse = '_'), '_', sep = '')
  one <-
    paste('^', paste(tail(wordvec, 1), collapse = '_'), '_', sep = '')
  
  # find their matches
  quin_matches <- quin.freq.df[grep(four, quin.freq.df$ngrams),]
  quad_matches <- quad.freq.df[grep(three, quad.freq.df$ngram),]
  tri_matches <- tri.freq.df[grep(two, tri.freq.df$ngram),]
  bi_matches <- bi.freq.df[grep(one, bi.freq.df$ngram),]
  
  
  # if there are three auin_matches, that is all that needs to be
  # calculated
  if (nrow(quin_matches) != 0) {
    quin_matches$rating <- quin_matches$count / nrow(quin.freq.df)
  } else {
    quin_matches$rating <- character(0)
  }
  
  full_df <- quin_matches
  
  if (nrow(full_df) < 3) {
    if (nrow(quad_matches) != 0) {
      quad_matches$rating <- quad_matches$count * 0.4 / nrow(quad.freq.df)
    } else {
      quad_matches$rating <- character(0)
    }
  }
  
  full_df <- rbind(full_df, quad_matches)
  
  
  if (nrow(full_df) < 3) {
    if (nrow(tri_matches) != 0) {
      tri_matches$rating <-
        tri_matches$count * 0.4 * 0.4 / nrow(tri.freq.df)
    } else {
      tri_matches$rating <- character(0)
    }
    full_df <- rbind(full_df, tri_matches)
    
  }
  
  # if not bigrams
  if (nrow(full_df) < 3) {
    if (nrow(bi_matches) != 0) {
      bi_matches$rating <-
        bi_matches$count * 0.4 * 0.4 * 0.4 / nrow(bi.freq.df)
    } else {
      bi_matches$rating <- character(0)
    }
    full_df <- rbind(full_df, bi_matches)
  }
  
  
  # As a last resort, take the 50 most common words in the
  # training corpus and add them in randomly to round out the
  # selections
  if (nrow(full_df) < 3) {
    top50 <- uni.freq.df[1:50,]
    random3 <- uni.freq.df[sample(15, 3),]
    random3$rating <-
      random3$count * 0.4 * 0.4 * 0.4 * 0.4 / nrow(uni.freq.df)
    full_df <- rbind(full_df, random3)
  }
  
  
  # sort the weighted matched based on their backoff
  sorted <- full_df[order(-full_df$rating),]
  # get the top three
  match_df <- sorted[1:3, ]
  
  # define a function to extract the actual word guess
  get_pred <- function(x) {
    tail(strsplit(as.character(x), "_")[[1]], 1)
  }
  
  word_matches <- as.character(lapply(match_df$ngram, get_pred))
  # return a character vector with the three words
  word_matches
  
}



# Define UI for application that draws a histogram
ui <- dashboardPage(
  skin = 'yellow',
  dashboardHeader(title = 'PredictIt'),
  dashboardSidebar(sidebarMenu(
    menuItem("PredictIt", tabName = "predict"),
    menuItem("Documentation", tabName = "documentation")
  )),
  dashboardBody(# Application title
    tabItems(
      tabItem(
        tabName = "predict",
        titlePanel("PredictIt"),
        
        # Sidebar with a slider input for number of bins
        sidebarLayout(sidebarPanel(
          textInput('caption',
                    label = "Phrase"),
          submitButton("Predict three possible next words.")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          h4('The three most likely words from the model are:'),
          h4(textOutput("prediction"))
        ))
      ),
      tabItem(tabName = "documentation",
              fluidPage(includeMarkdown('documentation.md')))
    ))
)

# Define server logic required to make a prediction
server <- function(input, output) {
  output$prediction <- renderText({
    # strip punctuation and numbers except for apostrophes
    no_punct <- gsub("[^[:alnum:][:space:]']", "", input$caption)
    # tokenize and get last four
    wordvec <- tail(strsplit(no_punct, " +"), 4)[[1]]
    # perform the backoff on lower cased vector
    backoff(tolower(wordvec))
  })
}




# Run the application
shinyApp(ui = ui, server = server)
