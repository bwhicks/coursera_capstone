# Documentation

## PredictIt

This application uses an N-Gram language model up to quingrams to match phrases
up to four words deep at the tail of a phrase. You can expect it to be
reasonably quick, accurate at producing likely combinations from the dataset
(a provided training data set from US news sources, blogs, and Twitter),
and portable enough to load into an online webapp hosted on a shared service.

It will not handle novelty as well as some more complex machine learning models
because it uses a relatively simple stupid backoff model.

## About the app

The application uses a set of pre-trained models computed from
[nGramModel.R](https://github.com/bwhicks/coursera_capstone/blob/master/nGramModel.R)
using the [Quanteda](http://docs.quanteda.io/) package to create a training
corpus from the provided material.

The document feature matrices (dfms) were arranged into 1-5 N-Grams, sorted descending by their frequency in the given text.

The app's [code](https://github.com/bwhicks/coursera_capstone/blob/master/wordPredict/app.R), esepcially the function `backoff` searches for n-grams with the beginning set of words in sequence (i.e.
  in the phrase `I saw the cow and the` it will look for ngrams beginning `the cow and the`) backing off the number of words and the N-gram size starting
  with five and descending to bigrams backing off `.40` each time in ranking
  with each backoff until there are at least three matches in the data frame,
  which is then sorted and the top three are presented. This the so-called
  'Stupid Backoff' model adapted from [Brants, Popat, et. al (2007)](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.324.3653)

  If no matches are found, a random selection of three highly frequent unigrams
  are provided as possible matches. The random sampling is meant to keep some
  possibility for felicitious options in situation with no optima.
  
  
## Usage and deployment

  The application simply accepts a  phrase of any arbitrary length and attempts upon
  hitting submit to supply three possible completions in order of likelihood.

  To deploy the app using RStudio, install the `shiny`, `shinydashboard` and
  `markdown` packages. Git clone [the repo](https://github.com/bwhicks/coursera_capstone.git) and then after loading
  it in RStudio as a project, open `wordPredict/app.R` and run the shiny application which will be available on `localhost:3953`.
