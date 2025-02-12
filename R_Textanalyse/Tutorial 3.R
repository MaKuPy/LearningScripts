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
library(quanteda) # Textdatenmagement

# Tutorial 3: Frequency Analysis
# I Text Preprocessing

# Den Sotu-Datensatz laden und ein Corpus-Objekt erzeugen
textdata <- read.csv("sotu.csv", sep=";", encoding ="UTF-8")

# Metadaten ergaenzen

textdata$year <- substr(textdata$date, 0, 4)
textdata$decade <- paste0(substr(textdata$date, 0,3), "0")

# Corpus.Objekt erstellen
sotu_corpus <- corpus(textdata$text, docnames=textdata$doc_id)

# Vorbereitung der Anaylse
# - entfernen von Punktuation, Nummern und Symbolen (unicode)
# - Transformation der Worte in Kleinschreibung
# - Lemmatization: Reduzieren von Worten auf ihre Basisform (eg. spielst > spielen)
# - Entfernen von Stopwoertern

# Alternative von Lemma ist Stemming >> Wort auf Basisform zurueckbringen
# Funktioniert jedoch besser bei sehr regelmaeßigen Sprachen

# Worttree Packet ermoeglicht das Erstellen eines deutschen Lemma

# Erstellen eines Lemma-Dictionairy
lemma_data <- read.csv("ressources/baseform_en.tsv", encoding = "UTF-8")

library(tidyverse)

corpus_tokens <- sotu_corpus %>%
  tokens(remove_punct = T, remove_symbols = T, remove_numbers = T) %>%
  tokens_tolower() %>%
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype="fixed") %>%
  tokens_remove(pattern = stopwords())

# Zeigt die Ergebnisse, indem die ersten 400 Token (durch substr, ausgewaehlt) mit LZ
# verbunden werden (durch paste und collapse)
print(paste0("1: ", substr(paste(corpus_tokens[1],collapse = " "), 0, 400), '...'))

# Erstellen der Document-Term-Matrix
dtm <- dfm(corpus_tokens)
dim(dtm)

# (Optional)
# Wortliste erstellen
freqs <- colSums(dtm)
words <- colnames(dtm)

wordlist <- data.frame(words, freqs)
wordlist <- wordlist[order(wordlist$freq, decreasing =T),]
head(wordlist)

# II Time series
# Ziel: Auftauchen bestimmter Begriffe über die Jahre zu visualisieren

dtm_red <- as.matrix(dtm[,c("nation", "war", "god", "terror", "security")])

counts_per_decade <- aggregate(dtm_red, by = list(decade = textdata$decade), sum)

# Erstellen einer Visualisierung
# Extrahieren der Vektoren für die X und Y-Achse
decades <- counts_per_decade$decade
frequencies <- counts_per_decade[,c("nation", "war", "god", "terror", "security")]

# Mehrere Frequenzen mit matplot visualisieren
matplot(decades, frequencies, type = "l", lwd  =2)

# Legende ergaenzen
l <- length(c("nation", "war", "god", "terror", "security"))
legend('topleft', legend = c("nation", "war", "god", "terror", "security"), col=1:l, text.col = 1:l, lty = 1:l) 


# Sentiment Analysis
# Mit einer Liste von positiven und negativen Worten, kann auch einfach der Sentiment
# eines Textes ausgezaehlt werden

# Beispiel: Sentiment der Reden eines Praesidenten bestimmen

# a) Einlesen der Wortlisten

list.files(path="ressources")
positive_words <- readLines("ressources/positive-words.txt")
negative_words <- readLines("ressources/negative-words.txt")

## weitere Wortliste
afinn_terms <- read.csv("ressources/AFINN-111.txt", header=F, sep="\t")
positive_words_a <- subset(afinn_terms, subset = afinn_terms$V2 >0)$V1 
negative_words_a <- subset(afinn_terms, V2<0)$V1

# b) Reduzieren der Wortlisten auf das tatsaechliche Vokabular des Corpuses
positive_term_in_suto <- intersect(colnames(dtm), positive_words)
negative_term_in_suto <- intersect(colnames(dtm), negative_words)


# c) Auszahelen der positiven und negativen Worte im Corpus pro Text
positive_counts <- rowSums(dtm[,positive_term_in_suto])
negative_counts <- rowSums(dtm[,negative_term_in_suto])

# Da die Laenge der Reden stark variiert, wird durch die Laenge geteilt um ein relatives Maß zu erhalten
# Prozentanteil der positiven/ negativen Worte im Gesamttext

# positive und negative Worte relativ zu allen
# ( Alternative wäre relativ zu negativen Worten)
sentiment_data <- data.frame(positive = positive_counts/rowSums(dtm), negative = negative_counts/rowSums(dtm))

# Nach Praesident aggregieren
sentiment_per_president <- aggregate(sentiment_data, by = list(president = textdata$president), mean)

require(reshape2)
# Transformieren in ein weites Datenformat
df <- melt(sentiment_per_president, id.vars = "president")
?melt

# Erstellen eines Balkendiagramms
require(ggplot2)
ggplot(data = df, aes(x = reorder(president, value, head, 1), y = value, fill = variable)) + 
  geom_bar(stat="identity", position=position_dodge()) + coord_flip()

# Schwierigere Alternative
# Ergebnisse leicht anders durch rundungen
# Absolute Haeufigkeiten per Praesident
pres_posi <- aggregate(positive_counts, by = list(president = textdata$president), sum)
pres_nega <- aggregate(negative_counts, by = list(president = textdata$president), sum)

pres_sentiment <- data.frame(president = pres_posi$president, positive = pres_posi$x, pres_nega = pres_nega$x)
# relative Haeufigkeiten ableiten
pres_sentiment_rel <- cbind(pres_sentiment[,1], pres_sentiment[,-1]/ aggregate(rowSums(dtm), by= list(president = textdata$president), sum)$x)


# Heutzutage gibt es bessere Methoden als Dictionaire...
# Stattdessen eher komplexe und Kontextabhaengige Verfahren anwenden
# (Semantic Scaling, Word Embedding etc.)

# >> Daher eher als deskriptive Verfahren verwenden
# >> Grobe Trends beobachten
# >> Selbst Dictionaire, die mit einer Inhaltsanalyse validiert wurde, keine
#    besonders reliaben Ergebnisse erzielen

# IV Heatmaps
# Alternative die Frequenz von Worten in Zeitserien zu visualisieren
# Eine Reihe entspricht dann einer Zeitserie

terms_to_observe <- c("war", "peace", "health", "terror", "islam", 
                      "threat", "security", "conflict", "job", 
                      "economy", "indian", "afghanistan", "muslim", 
                      "god", "world", "territory", "frontier", "north",
                      "south", "black", "racism", "slavery", "iran")
dtm_reduced <- as.matrix(dtm[, terms_to_observe])
rownames(dtm_reduced) <- ifelse(as.integer(textdata$year) %% 2 == 0, textdata$year, "")
heatmap(t(dtm_reduced), Colv=NA, col = rev(heat.colors(256)), keep.dendro= F, margins = c(5, 10))


# V Optional Exercises
# a) Create a timeseries for "environment" "climate" "planet" and "space"

words_observed <- c("environment", "climate", "planet", "space")

dtm_reduced <- as.matrix(dtm[,words_observed])
words_count_decade <- aggregate(dtm_reduced, by = list(decade = textdata$decade), sum)

# Frequency Plot mit matplot
matplot(words_count_decade$decade, words_count_decade[,words_observed], type="l", lwd =2,
        main = "Timeseries Word Frequency", ylab = "Frequency", xlab = "Decade")
legend("topleft", legend = words_observed, col = 1:4, text.col = 1:4, lty=1:4)

# Das ganze noch mal mit ggplot

dtm_reduced_wide <- melt(words_count_decade, id.vars= "decade")
ggplot(dtm_reduced_wide, aes(x=decade, y = value, group = variable, color = variable)) + geom_line(lwd=1) +
  ylab("Frequency") + xlab("Decade")


# b) Nutze eine anderes Maß der Sentiment-Analyse
#    Statt Anteil der postiven/negativen Worte in der Gesamten Rede, nutze den 
#    Anteil positver/negativer Worte von den Gesamten Sentiment Worten

positive_term_in_suto
negative_term_in_suto

positive_counts
negative_counts
all_sentiments <- positive_counts+ negative_counts

rel_sentiment_freq <- data.frame(positive= positive_counts/all_sentiments, 
                                 negative=negative_counts/all_sentiments)
sentiment_per_president2 <- aggregate(rel_sentiment_freq, by=list(president=textdata$president), mean)

# barplot
df <- melt(sentiment_per_president2, id.vars="president")
ggplot(df, aes(x=reorder(president,value, head, 1), y= value, fill = variable)) + geom_bar(stat="identity") + coord_flip()

# c) afinn verwendet nicht nur positive und negative Worte, sondern auch eine Valenzbewertung
#    Nutze die Valenz für die Berechnung des Sentimentwertes

# Berechnen der Summe des Sentimentes
afinn_terms # Datei mit Sentiment scores

# Zunaechst brauche ich eine dtm, die nur die terms enthält, die auch in der afinn-Datei sind
sent_words_in_situ <- intersect(colnames(dtm), afinn_terms$V1)


dtm_sent <- dtm[,sent_words_in_situ]
dtm_sent_t <- t(dtm[,sent_words_in_situ])
# Ich brauche eine Moeglichkeit den Wert eine Zelle mit dem Wert einer Spalte
# einer anderen Tabelle zu mutliplizieren, in abhängigkeit von dem Namen der Spalte
# und der häufigkeit

dtm_sent_score <- dtm_sent_t

for (x in 1:nrow(dtm_sent_t)) {
  dtm_sent_score[x,] <- if(rownames(dtm_sent_t)[x] %in% afinn_terms$V1) {dtm_sent_t[x,] * afinn_terms[afinn_terms$V1 == rownames(dtm_sent_t)[x],"V2"]}
}

# Idee zwar gut... aber macht leider die besondere Matrix kaputt...

# Versuch 2: Direkt in einen sentiment Wert umwandeln

# Matrix erstellen
dtm_sent_score <- as.data.frame(matrix(nrow=nrow(dtm_sent_t), ncol = ncol(dtm_sent_t)))
rownames(dtm_sent_score) <- rownames(dtm_sent_t)

# iflse() funktioniert nicht, da es nur einen einzelnen Wert zurückgibt, 
# wenn nur ein einzelner geprüft wird...

# for (x in 1:nrow(dtm_sent_t)) {
#  dtm_sent_score[x,] <- ifelse(rownames(dtm_sent_t) %in% afinn_terms$V1, as.matrix(dtm_sent_t[x,] * afinn_terms[afinn_terms$V1 == rownames(dtm_sent_t)[x],"V2"])[1,], dtm_sent_score[x,])
#}


# Um einen Vektor nach einer Einzelprüfung zuzuweisen, sollte daher if() verwendet werdebn
for (x in 1:nrow(dtm_sent_t)) {
  dtm_sent_score[x,] <- if(rownames(dtm_sent_t)[x] %in% afinn_terms$V1) {dtm_sent_t[x,] * afinn_terms[afinn_terms$V1 == rownames(dtm_sent_t)[x],"V2"]}
}

# Text des Codes im For-Loop
# dtm_sent_score[x,] <- if(rownames(dtm_sent_t)[x] %in% afinn_terms$V1) {dtm_sent_t[x,] * afinn_terms[afinn_terms$V1 == rownames(dtm_sent_t)[x],"V2"]}

# Ueberpruefen des Ergebisses
head(dtm_sent_score[0:10,1:10])
head(dtm_sent_t[30:50,])
View(dtm_sent_t)

# Datafarme mit Sentiment pro Text
negative_sentiment_per_text<- colSums()
sent_score_data <- data.frame(doc = 1:233, 
                              neg_sent_per_text = colSums(dtm_sent_score[row.names(dtm_sent_score) %in% afinn_terms$V1[afinn_terms$V2 <0],]),
                              pos_sent_per_text = colSums(dtm_sent_score[row.names(dtm_sent_score) %in% afinn_terms$V1[afinn_terms$V2 >0],])
                              )

sent_score_data$overall_sent <- rowSums(sent_score_data[,2:3])
head(sent_score_data)
textdata
sent_score_pres <- aggregate(sent_score_data[,2:4], by=list(president=textdata$president), sum)

# barplot
df <- melt(sent_score_pres[,1:3], id.vars="president")
ggplot(df, aes(x=reorder(president,value, head, 1), y= value, fill = variable)) + geom_bar(stat="identity") + coord_flip()


# evtl relative Werte nach sentimented words im text
dtm_sent # enthaelt alle sented words
sent_count_text <- rowSums(dtm_sent)
sent_score_data <- data.frame(doc = 1:233, 
                              neg_sent_per_text = colSums(dtm_sent_score[row.names(dtm_sent_score) %in% afinn_terms$V1[afinn_terms$V2 <0],]),
                              pos_sent_per_text = colSums(dtm_sent_score[row.names(dtm_sent_score) %in% afinn_terms$V1[afinn_terms$V2 >0],]),
                              rel_neg_sent = (colSums(dtm_sent_score[row.names(dtm_sent_score) %in% afinn_terms$V1[afinn_terms$V2 <0],]))/sent_count_text,
                              rel_pos_sent =(colSums(dtm_sent_score[row.names(dtm_sent_score) %in% afinn_terms$V1[afinn_terms$V2 >0],]))/sent_count_text
)
rel_sent_pres <- aggregate(sent_score_data[,4:5], by = list(president=textdata$president), mean)
df <- melt(rel_sent_pres, id.vars="president")
ggplot(df, aes(x= reorder(president, value, head, 1), y= value, fill = variable)) +
  geom_bar(stat="identity") + coord_flip()

# Die offizielle Loesung

corpus_afinn <- sotu_corpus %>%
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols =
           TRUE) %>%
  tokens_tolower() %>%
  tokens_remove(pattern = stopwords())

# AFINN sentiment lexicon by Nielsen 2011
afinn_terms <- read.csv("ressources/AFINN-111.txt", header = F, sep = "\t")

pos_idx <- afinn_terms$V2 > 0
positive_terms_score <- afinn_terms$V2[pos_idx]
names(positive_terms_score) <- afinn_terms$V1[pos_idx]

neg_idx <- afinn_terms$V2 < 0
negative_terms_score <- afinn_terms$V2[neg_idx] * -1
names(negative_terms_score) <- afinn_terms$V1[neg_idx]


pos_DTM <- corpus_afinn %>%
  tokens_keep(names(positive_terms_score)) %>%
  dfm()
# Reduzieren zu Worten in DTM UND Ordnen!
positive_terms_score <- positive_terms_score[colnames(pos_DTM)]
# caution: to multiply all rows of a matrix with a vector of
#ncol(matrix) length
# you need to transpose the left matrix and then the result again
pos_DTM <- t(t(as.matrix(pos_DTM)) * positive_terms_score)
counts_positive <- rowSums(pos_DTM)

neg_DTM <- corpus_afinn %>%
  tokens_keep(names(negative_terms_score)) %>%
  dfm()
# Reduzieren zu Worten in DTM UND Ordnen!
negative_terms_score <- negative_terms_score[colnames(neg_DTM)]
# caution: to multiply all rows of a matrix with a vector of ncol(matrix) length
# you need to transpose the left matrix and then the result again
neg_DTM <- t(t(as.matrix(neg_DTM)) * negative_terms_score)
counts_negative <- rowSums(neg_DTM)

counts_all_terms <- corpus_afinn %>% dfm() %>% rowSums()

# Warum basiert die dann doch nur auf der Auszaehlung?
relative_sentiment_frequencies <- data.frame(
  positive = counts_positive / (counts_positive + counts_negative),
  negative = counts_negative / (counts_positive + counts_negative)
)

sentiments_per_president <- aggregate(
  relative_sentiment_frequencies, 
  by = list(president = textdata$president), 
  mean)

head(sentiments_per_president)

df <- melt(sentiments_per_president, id.vars = "president")
# order by positive sentiments
ggplot(data = df, aes(x = reorder(president, value, head, 1), y = value, fill = variable)) + geom_bar(stat="identity", position="stack") + coord_flip()

# 4 Zeichne eine Heatmap fuer die Begriffe "I", "You" "he", "she", "we", "they"

# Die Pronomen gelten als Stopwords, die erst einmal nicht aus der dtm entfernt 
# werden sollten

dtm <- sotu_corpus %>%
  tokens(remove_punct = T, remove_symbols = T, remove_numbers = T) %>%
  tokens_tolower() %>%
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype="fixed") %>% dfm()

dtm_pronouns <- as.matrix(dtm[,c("i", "you", "he", "she", "we", "they")])

pres_pronouns <- aggregate(dtm_pronouns, by = list(president = textdata$president), sum)

# in numerische Matrix umwandeln
rownames(pres_pronouns) <- pres_pronouns$president
pres_pronouns <- as.matrix(pres_pronouns[,-1])

# relativer Anteil pro president
pres_count <- aggregate(rowSums(dtm), by = list(president= textdata$president), sum)
rel_pres_pronouns <- pres_pronouns/pres_count$x

# zeitliche Ordnung
temporally_ordered_presidents <- unique(textdata$president)
rel_pres_pronouns <- rel_pres_pronouns[temporally_ordered_presidents, ]


heatmap(t(rel_pres_pronouns), scale="none",Colv=NA, col = rev(heat.colors(256)), keep.dendro= F, margins = c(5, 10))


