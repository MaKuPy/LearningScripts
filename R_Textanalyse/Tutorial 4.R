#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Erster Task: GitHub Tutorials (Niekler & Wiedemann)
# https://tm4ss.github.io/docs/index.html
#
# Basics of Textanalysis
options(stringsAsFactors=F)
library(dplyr)
library(quanteda)
library(quanteda.textstats)

# Tutorial 4: Key Term Extraction
# I Multiword Tokenization

# Einige Worte bestehen aus zwei oder mehr getrennten Begriffen (z.B. machine learning)
# (oefter im Englischen als im Deutschen)
# Diese Multiword Units (MWU) oder ling. Collocations, koennen statistisch identifiziert
# werden, um sie in der Analyse als Einheit zu betrachten

# Einlesen des Corpus
list.files()

# Datensaetz einlesen und Corpus erstellen
textdata <- read.csv("sotu.csv", sep = ";", encoding = "UTF-8")
sotu_corpus <- corpus(textdata$text, docnames = textdata$doc_id)
summary(sotu_corpus)

# Lemma Datei einlesen
lemma_data <- read.csv("ressources/baseform_en.tsv", encoding = "UTF-8")

# Extended Stopwords Liste einlesen
stopwords_extended <- readLines("ressources/stopwords_en.txt", encoding = "UTF-8")

# Tokenizing
corpus_tokens <- sotu_corpus %>%
  tokens(remove_punct = T, remove_symbols = T, remove_numbers = T) %>%
  tokens_tolower() %>%
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype="fixed") %>%
  tokens_remove(pattern = stopwords_extended, padding=T) # padding erhaelt Leerzeichen

# MWU Kandidaten identifizieren
sotu_collocations <- textstat_collocations(corpus_tokens, min_count = 25)
# Basiert auf Blaheta and Johnson's (2001), siehe ?textstat_collocations

# Ersten 250 fuer den Corpus behalten
sotu_collocations <- sotu_collocations[1:250,]

# MWUs im Corpus markieren (Compounding)
corpus_tokens <- tokens_compound(corpus_tokens, sotu_collocations)
# MWUs werden mit _ getrennt

dtm <- corpus_tokens %>% tokens_remove(c("","--")) %>% dfm()

# II TF-IDF
# Die term frequency - inverse document frequency measure (TD-IDF) ist 
# ein Maß mit dem die relative Bedeutung eines Wortes fuer die Semantik
# eines Textes bestimmt werden kann

# Kann verwendet werden, um eine gewisse Textqualitaet auszuweisen
# z. B. Beleidigende Texte und nicht beleidigende Texte
#       Top Worte der Beleidigenden Texte sind wahrscheinlich Beleidigung

# a) IDF berechnen: IDF: log(N/n_i)
#    Misst die Spezifizitaet eines Terms fuer die Gesamtmenge der Dokumente

num_of_docs <- nrow(dtm)
term_in_docs <- colSums(dtm > 0)
# kA warum man die 0 braucht; terms_in_docs <- colSums(dtm) macht das gleiche

idf <- log(num_of_docs/term_in_docs) # keine Ahnung, was der Wert aussagt
# log der Frequenz, der Dokumente, die einen gewisses Wort enthalten
# jedes nom_of_docs/term_of_docs (z.B. 12te) Dokumente taucht das Wort auf

# Irgendwie ein Maß, das quantifiziert wie selten ein Term ist (je seltener, 
# desto hoeher ist der Wert)


# b) TF berechnen - der ersten Rede von Obama
first_obama_speech <- which(textdata$president == "Barack Obama")[1]
tf <- as.vector(dtm[first_obama_speech, ])
# wird als Vektor benoetigt, aber enthalet im Prinzip die Information von 
dtm[first_obama_speech, ]

# c) TF-IDF - der ersten Rede von Obama
#    Also wenn ein Wert allgemein selten ist (Hohe idf) aber haeufig in dem Dokument 
#    vorkommt (hohe tf) dann hat es einen großen semantischen Beitrag im Dokument

# >> erlaubt die Unterscheidung von spezifischen Begriffen fuer ein Dokument
#    von allgemeinen Begriffen, die im Korpus haeufig vorkommen (z. B. Fachjargon
#    in einem Fachkorpus)
tf_idf <- tf * idf
names(tf_idf) <- colnames(dtm)

# Sortieren, um die wichtigsten Worte in Obamas Rede zu erhalten
sort(tf_idf, decreasing =T)[1:20]

# Mit der Funktion dfm_tfidf(dtm) kann das Maß fuer eine ganze dtm berechner werden
dtm_tf_idf <- dfm_tfidf(dtm)

# Einzelne Reden genauer betrachten
first_speach <-as.vector(dtm_tf_idf[232,])
names(first_speach) <- colnames(dtm_tf_idf)
sort(first_speach, decreasing =T)[1:20]
textdata$president[232]

# III Log Likelihood
# a) Erstellen einer Ziel-DTM, aus der relevante Terme extrahiert werden sollen
target_dtm <- dtm

# Fokus auf einen einzelnen Text
termCountsTarget <- as.vector(target_dtm[first_obama_speech, ])
names(termCountsTarget) <- colnames(target_dtm)

# Frequenzen groeßer 0 beibehalten
termCountsTarget <- termCountsTarget[termCountsTarget > 0]

# b) Vorbereitung des Vergleichskorpus
#    30.000 zufaellige Saetze aus dem englischsprachigen Wikipedia (2010)
lines <- readLines("ressources/eng_wikipedia_2010_30K-sentences.txt", encoding ="UTF-8")

corpus_compare <- corpus(lines)
summary(corpus_compare)

# Aufbereitung des Korpus
# muss genauso stattfinden wie beim Ursprungs/ Ziel-Korpus


# Tokenization 
corpus_compare_tokens <- corpus_compare %>% 
  tokens(remove_punct = T, remove_symbols = T, remove_numbers = T) %>%
  tokens_tolower() %>% 
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype="fixed") %>%
  tokens_remove(pattern= stopwords_extended, padding=T)

# Erstellen einer DTM
dtm_compare <- tokens_compound(corpus_compare_tokens, sotu_collocations) #
dtm_compare <- dtm_compare %>% tokens_remove(c("","--")) %>%
  dfm()

# Kurzer Ueberblic ueber haeufigste Begriffe
head(sort(colSums(dtm_compare), decreasing=T), 20)

# Term Frequenz berechnen
termCountsCompare <- colSums(dtm_compare)

# c) Berechnen des Log Likelihoods Tests 
#    Zunaechst fuer ein Wort
term <-"health_care"

a <- termCountsTarget[term]
b <- termCountsCompare[term]
c <- sum(termCountsTarget)
d <- sum(termCountsCompare)

# Berechnen des Log Likelihood Test
expected1 <- c*(a+b)/(c+d)
expected2 <- d*(a+b)/(c+d)

# Expected entspricht der Formel für erwartete Haeufigkeiten im Chi-Quadrat-Test


t1 <- a*log((a/expected1)) 
t2 <- b*log((b/expected2))

(logLikelihood <- 2*(t1+t2))

# Ab einem Wert von 3.84 (p < .05), ab 6.63 ( p < .01), ab 10.83 (p < 10.83)


# d) Zunaechst werden Worte betrachtet, die nur in dem Zielcorpus drin sind

uniques <- setdiff(names(termCountsTarget), names(termCountsCompare))
# nicht colnames(dtm), da in termCountsTarget nur die Obama Rede drin ist

sample(uniques, 20)

# Um jetzt den Loglikelihood-Test zu berechnen, werden die Einzigartigen Worte 
# als 0 Haeufigkeiten dem Vergleichsvektor hinzugefuegt

zeroCounts <- rep(0, length(uniques))
names(zeroCounts) <- uniques

termCountsCompare <- c(termCountsCompare, zeroCounts)
# Vektor enthaelt nun die 0 Counts

# intersect findet Werte, die sowohl in a als auch in b enthalten sind
termsToCompare <- intersect(names(termCountsTarget), names(termCountsCompare))

a <- termCountsTarget[termsToCompare]
b <- termCountsCompare[termsToCompare]
c <- sum(termCountsTarget)
d <- sum(termCountsCompare)

# Erwartet Haeufigkeiten
Expected1 = c * (a+b) / (c+d)
Expected2 = d * (a+b) / (c+d)

# t
# + a/b == 0 wird ergenzt fuer den Fall, dass a/b == 0 sind, da log in dem Fall
# NaN ausgeben wuerde...
# mit a == 0 wird der Wert in dem Fall, dass die Expression wahr ist gleich 1 und in dem 
# Fall wird das Ergebnis des logLikelihood tests == 0, da log(a == 0) = log(1)

t1 <- a * log((a/Expected1) + (a == 0))
t2 <- b * log((b/Expected2) + (b == 0))

# Log Likelihood Test
logLikelihood <- 2 * (t1 + t2)

# Vergleich der Relativen Haeufigkeiten, um Ueber und Unterverwendung zu berechnen
relA <- a / c
relB <- b / d

# underused terms are multiplied by -1
logLikelihood[relA < relB] <- logLikelihood[relA < relB] * -1

sort(logLikelihood, decreasing=TRUE)[1:50]


llTop100 <- sort(logLikelihood, decreasing=TRUE)[1:100]
frqTop100 <- termCountsTarget[names(llTop100)]
frqLLcomparison <- data.frame(llTop100, frqTop100)
View(frqLLcomparison)

# Number of signficantly overused terms (p < 0.01)
sum(logLikelihood > 6.63)

# Visualisierung
# Visualierung der 50 wichtigesten Begriffe (nach LogL) in einer Wortwolke

require(wordcloud2)
top50 <- sort(logLikelihood, decreasing = TRUE)[1:50]
top50_df <- data.frame(word = names(top50), count = top50, row.names = NULL)

wordcloud2(top50_df, shuffle = F, size = 0.5)


# Alternative Referenz-Corpora
# Es ist ebenfalls moeglich Key-Worte fuer einen ganzen Korpus zu extrahieren

# z.B. Koennen die Reden eines Praesidenten mit den Reden aller restlichen Praesidenten
# vergleichen werden, um Key-Begriffe zu extrahieren

# Dazu wird zunachst die Log Likelihood brechnung in eine Funktion extrahiert, die
# mit source geladen werden kann
source("calculateLogLikelihood.R")

# mithilfe des for-loops werden dann die Berechnungen durchgefuehrt und die DTM
# unterteilt (Teil von Reden von einem Praesident vs. Rest der Reden)
presidents <- unique(textdata$president)

for (president in presidents) {
  
  cat("Extracting terms for president", president, "\n")
  
  presidentDTM <- targetDTM[textdata$president == president, ]
  termCountsTarget <- colSums(presidentDTM)
  
  otherDTM <- targetDTM[textdata$president != president, ]
  termCountsComparison <- colSums(otherDTM)
  
  loglik_terms <- calculateLogLikelihood(termCountsTarget, termCountsComparison)
  
  top50 <- sort(loglik_terms, decreasing = TRUE)[1:50]
  
  fileName <- paste0("wordclouds/", president, ".pdf")
  pdf(fileName, width = 9, height = 7)
  wordcloud::wordcloud(names(top50), top50, max.words = 50, scale = c(3, .9), colors = RColorBrewer::brewer.pal(8, "Dark2"), random.order = F)
  dev.off()
  
}
