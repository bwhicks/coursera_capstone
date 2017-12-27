PredictIt Pitch
========================================================
author: Benjamin Hicks
date: 12/27/2017
autosize: true

PredictIt
========================================================

[PredictIt](https://bwhicks.shinyapps.io/predictit/) aims to capture, in Shiny form, the familiar
interface of a smartphone. We are all used to the general
model where the next word in a text or message prompts 
three fill-ins for possible next words.

This app does the same thing using a simple, relatively quick
N-gram language model that has been previously computed so that
it can respond quickly. This trades accuracy for speed to a certain extent.

Training Set and Model
========================================================

The training set for this came from a corpus provided in the
Cousera R [Data Science capstone](https://www.coursera.org/learn/data-science-project)
that drew on Twitter, blog, and news data to form an English corpus.

Key features:
- Corpus was normalized and filtered into N-Grams using [Quanteda](http://docs.quanteda.io/), an R-package for analyzing text
- N-gram models are lightweight computationally and using the so-called 
`Stupid Backoff`, the application quickly iterates through possible matches.


Model Production
========================================================
For details, please see the project [Github repository](https://github.com/bwhicks/coursera_capstone), especially [nGramModel.R](https://github.com/bwhicks/coursera_capstone/blob/master/nGramModel.R). 

Using Quanteda each data set was read into R and normalized for lower case, removing punctuation, and stopwords that were not part of a multiword n-gram. n-Gram models rely on repeated patterns in languages
and after computation, quick lookups of possible phrase completions.

Profanity was allowed in because of its (relatively) low
frequency and predictive value as part of the language. I also removed any N-Grams with an occurence of less than 10 times, which left a still quite
detailed set of document feature matrices.


Web App
=================
The app provides a familiar simple interface, along with documentation about the 
methods used to produce it under a `Documentation` tab that expands on this slide. The user need merely enter a phrase, submit it, and wait for a response!

The Stupid Backoff approach introduced by [Brants, Popat, et. al (2007)](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.324.3653) is used to search the n-gram models for best matches until three are found. 
