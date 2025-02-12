#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Erster Task: GitHub Tutorials (Niekler & Wiedemann)
# https://tm4ss.github.io/docs/index.html
#
# Tutorial 8: Part-of-Speech-Tagging
#
# install.packages("NLP")
# install.packages("openNLP")
# install.packages("openNLPdata")

# Basics of Textanalysis
options(stringsAsFactors=F)
library(dplyr)
library(quanteda)
library(tidyverse)
library(NLP)

# Sotu in paragraph-form und Stopwords Einlesen
textdata <- read.csv("data/sotu_paragraphs.csv", sep = ";", encoding = "UTF-8")
english_stopwords <- readLines("ressources/stopwords_en.txt", encoding = "UTF-8")

# Korpus-Obj. erstellen
sotu_corpus <- corpus(textdata$text, docnames = textdata$doc_id)

library(openNLP)
library(openNLPdata)

# openNLP Annotator Objekte
sent_token_annotator <- openNLP::Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
pos_tag_annotator <- Maxent_POS_Tag_Annotator()
annotator_pipeline <- Annotator_Pipeline(
  sent_token_annotator,
  word_token_annotator,
  pos_tag_annotator
)

# Funktion fuer das Annotieren
annotateDocuments <- function(doc, pos_filter = NULL) {
  doc <- as.String(doc)
  doc_with_annotations <- NLP::annotate(doc, annotator_pipeline)
  tags <- sapply(subset(doc_with_annotations, type=="word")$features, `[[`, "POS")
  tokens <- doc[subset(doc_with_annotations, type=="word")]
  if (!is.null(pos_filter)) {
    res <- tokens[tags %in% pos_filter]
  } else {
    res <- paste0(tokens, "_", tags)
  }
  res <- paste(res, collapse = " ")
  return(res)
}

# Annotieren am Beispiel Korpus ausfuehren
annotated_corpus <- lapply(texts(sotu_corpus)[1:10], annotateDocuments)

# Erstes Dokument betrachten
annotated_corpus[1]