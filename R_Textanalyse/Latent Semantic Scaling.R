#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Erster Task Ergaenzung 2: Latent Semantic Scaling
# Quanteda
# https://tutorials.quanteda.io/machine-learning/lss/
#

# Latent Semantic Scaling
# Train a word embedding model (with latent semantic analysis instead of gloVe)
# to find synonyms
# >> allows you to automatically create a dictionairy for a specific corpus 
#    based on a training dictionairy
# >> the target dictionairy could also be restricted to a specific context (eg. economy)
# >> A scale with two extremes (e.g. good vs. bad; fear vs. admiration)

# Reliable to measure trends (compares humanly coded trends with automatically 
# coded ones)

# install package and activate
install.packages("LSX")
library(LSX)

library(quanteda)
library(quanteda.corpora)
library(LSX)

# Download news article corpus
corp_news <- download("data_corpus_guardian")

# Segment text to sentences to estimate semantic proximity between words
corp_sent <- corpus_reshape(corp_news, to =  "sentences")
# could also be specified further (e.g. focus on adjectives or verbs)

# tokenize text corpus and remove various features
# (marimo = stopwords-list)
toks_sent <- corp_sent %>% 
  tokens(remove_punct = TRUE, remove_symbols = TRUE, 
         remove_numbers = TRUE, remove_url = TRUE) %>% 
  tokens_remove(stopwords("en", source = "marimo")) %>%
  tokens_remove(c("*-time", "*-timeUpdated", "GMT", "BST", "*.com"))  

# create a document feature matrix from the tokens object
dfmat_sent <- toks_sent %>% 
  dfm() %>% 
  dfm_remove(pattern = "") %>% 
  dfm_trim(min_termfreq = 5)

topfeatures(dfmat_sent, 20)

# seedwords represent the factor you want to code 
# (e.g. based on an existing dictionairy)

# Set generic sentiment seed words to perform sentiment analysis
seed <- as.seedwords(data_dictionary_sentiment)
print(seed) 
# containts positive and negative values to represent the extremes of the scale
# (positive and negative sentiment)

# identify context words 
# (words that are significantly more frequent in context of econom* ["economy"])
eco <- char_context(toks_sent, pattern = "econom*", p = 0.05)

# run LSS model (takes some time)
# k represents dimensions? >> see paper
tmod_lss <- textmodel_lss(dfmat_sent, seeds = seed,
                          terms = eco, k = 300, cache = TRUE)

head(coef(tmod_lss), 20) # most positive words

tail(coef(tmod_lss), 20) # most negative words

# Visualize the new dictionairy against an existing one
textplot_terms(tmod_lss, data_dictionary_LSD2015["negative"])


# Visualize the trend over time
# The general trend should be similar to human coders

dfmat_doc <- dfm_group(dfmat_sent)
dat <- docvars(dfmat_doc)
dat$fit <- predict(tmod_lss, newdata = dfmat_doc)

dat_smooth <- smooth_lss(dat, engine = "locfit")
head(dat_smooth)

plot(dat$date, dat$fit, col = rgb(0, 0, 0, 0.05), pch = 16, ylim = c(-0.5, 0.5),
     xlab = "Time", ylab = "Economic sentiment")
lines(dat_smooth$date, dat_smooth$fit, type = "l")
lines(dat_smooth$date, dat_smooth$fit + dat_smooth$se.fit * 1.96, type = "l", lty = 3)
lines(dat_smooth$date, dat_smooth$fit - dat_smooth$se.fit * 1.96, type = "l", lty = 3)
abline(h = 0, lty = c(1, 2))


