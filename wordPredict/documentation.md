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
