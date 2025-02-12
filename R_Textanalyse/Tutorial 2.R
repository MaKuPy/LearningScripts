#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Erster Task: GitHub Tutorials (Niekler & Wiedemann)
# https://tm4ss.github.io/docs/index.html
#
# Basics of Textanalysis

# Tutorial 2: Processing of textual data

#install.packages("readtext")
library(readtext)

# Erstelle eine Liste mit den Pfadnamen der Dateien, die extrahiert werden sollen
data_files <- list.files(path = "data", full.names=T, recursive=T)


# Laden der Dateien mit readtext
# readtext() erkennt automatisch unterschiedliche Dateitypen und laedt diese in
# einen dataframe

data <- readtext(data_files, docvarnames = "filepath", dvsep="/")
cat(data$text)

## II Text in Corpus-Objekt umwandeln
# Beispiel mit State of Union Addresses
# csv Datei mit ID, Type, President, Datum, Text
textdata <- read.csv("sotu.csv", header = TRUE, sep = ";", encoding = "UTF-8")

# Dimensionen betachtem
dim(textdata)
names(textdata)

# Reden pro Präsident
sort(table(textdata$president), decreasing =T)

# Umwandeln des Textes in ein Corpus-Objekt
library(quanteda)

# Wichtig, dass nur Text in ein Corpus-Objekt umgewandelt werden kann.
# Deswegen textdata$text auswaehlen. textdata$doc_id dient zur Identifikation der Texte.

sotu_corpus <- corpus(textdata$text, docnames = textdata$doc_id)
summary(sotu_corpus)

# Elemente in einem Corpus-Objekt muessen mit [[]] ausgewaehlt werden
cat(sotu_corpus[[1]])

# alternativ: um ein einzelnes Textdocument zu bekommen
cat(as.character(sotu_corpus[1]))


# III Text Statistiken
# Um einen Text besser analyisieren zu koennen, muss jedes Wort einzeln betrachtet
# werden. Der Text wird also in kleinere Bestandteile zerlegt = tokenization

# Dazu wird jede Wortform (genannt Type = Oberkategorie) gezählt. Das vorkommen 
# eines types im text wird Token genannt (konkreter Datenpunkt) 
# Eine Document-Term-Matrix erstellen

###############################################
# Grundidee: Text in Form von ausgezaehlten   #
# Haeugifkeiten der Worttypen zu beschreiben  #
###############################################

# - Alle vorkommenden Types zusammengefasst ergeben das Vokabular eines Corpus

# > Damit kann fuer jeden Text das Vorkommen eines Types in einem sog. frequency
#   Vektor erfasst werden (Laenge = Groeße des Vokabulars)
# > Jeder Vektor ist gleich lang also kann daraus eine Document-Term-Matrix erstellt
#   werden, die in den Zeilen jeweils die Frequency Vektoren der einzelnen Texte 
#   enthaelt

# dfm-Funktion von quanteda
dtm <- dfm(sotu_corpus)

# Dimensionen koennen ausgegeben werden
dim(dtm) # Vokabular = 33.223 Typen

# Alternativ: Geht schneller und gibt keinen Aerger von R
tokens_dat <- tokens(sotu_corpus)
dtm2 <- dfm(tokens_dat)

# Erstellen einer Wortliste mit Haeufigkeiten

# Summe der Spalten bilden und Vektor mit Namen
freqs <- colSums(dtm)
word <- colnames(dtm)

wordlist <- data.frame(word, freqs)
head(wordlist)

# Sortieren der Wortliste
wordlist <- wordlist[order(wordlist$freqs, decreasing =T),]
head(wordlist, 30)

# Damit kann eine Zipf-Verteilung erstellt werden 
# X-Achse = Rang des Wortes; y-Achse = Frequenz
plot(wordlist$freqs, type="l", lwd =2, main = "Rank Frequency Plot", xlab ="Rank",
     ylab = "Frequency")

# Verlaeuft fuer fast alle Spraachen gleich: 
# Extreme Power Law (wenige Begriffe mit sehr hoher Frequenz; Viele mit sehr niedriger)

# Zur besseren Lesbarkeit koennen X- und Y-Achsenwerte logarithmisiert werden
plot(wordlist$freqs, type ="l", lwd ="2", log = "xy", main = "Rank Frequency Plot",
     xlab ="log-Rank", ylab = "log-Frequency")

# zwei Exteme Bereiche erkennbar: 
# - Worte ab Rang 10.000 erscheinen lediglich 10 mal oder weniger
# - Worte bis Rang 100 erscheinen 1000 mal oder haufiger

# Oft sind Worte, in diesen Extrembereichen nicht geeignet, um Aussagen ueber 
# den Korpus zu treffen, da sie wenig ueber die Texte aussagen.

# Verdeutlichen, dass die Worte in den Bereichen irrelevant sind
# Stopwords sind Worte ohne semantische Bedeutung
englishStopwords <- stopwords("en")

# Which gibt den INdex wieder fuer den die Aussage, die darin ueberprueft 
# wird wahr ist
stopwords_idx <- which(wordlist$word %in% englishStopwords)
lowfreq_idx <- which(wordlist$freq < 10)

## Liste mit Idx von unbedeutsamen Worten
# Mit Union-BaseR koennen zwei Vektoren kombiniert werden (Doubletten
# werden automatisch entfernt)
insig_idx <- union(stopwords_idx, lowfreq_idx)

# Bestimmen der Indexe bedeutsamer Worte
meaning_idx <- setdiff(1:nrow(wordlist), insig_idx)

plot(wordlist$freqs, type ="l", lwd ="2", log = "xy", main = "Rank Frequency Plot",
     xlab ="log-Rank", ylab = "log-Frequency")
lines(meaning_idx, wordlist[meaning_idx,]$freqs, col="royalblue", lwd=2, type="p", pch =20)

# Exercise
# print out a word-list without stopwords and low frequency word
wordlist[meaning_idx,]
wordlist

# what is the share of words regarding the entire vocalary that occur only once
dim(wordlist[wordlist$freqs ==1,])
dim(subset(wordlist, wordlist$freqs == 1))
dim(wordlist)
14667/33223

# 44.15 % of words occur only once

# official solution sum(wordlist$freqs == 1) / nrow(wordlist)

# compute the type-token-ration (TTR) = fraction of the number of tokens/number of types

nrow(wordlist)/sum(wordlist$freqs)
# TTR betraegt 0.017

# offizielle Loesung: ncol(dtm) / sum(dtm)
