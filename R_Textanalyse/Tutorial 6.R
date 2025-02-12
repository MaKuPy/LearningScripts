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
library(topicmodels)
# install.packages("topicmodels")

textdata <- read.csv("sotu.csv", sep = ";", encoding = "UTF-8")

sotu_corpus <- corpus(textdata$text, docnames = textdata$doc_id)

# Lemma-Datei einlesen
lemma_data <- read.csv("ressources/baseform_en.tsv", encoding = "UTF-8")

# Stopwort-Liste einlesen
stopwords_extended <- readLines("ressources/stopwords_en.txt", encoding = "UTF-8")

# Tokenization und Vorbereitung der Daten
corpus_tokens <- sotu_corpus %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>% 
  tokens_tolower() %>% 
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype = "fixed") %>% 
  tokens_remove(pattern = stopwords_extended, padding = T)

library(quanteda.textstats)
sotu_collocations <- textstat_collocations(corpus_tokens, min_count = 25)
sotu_collocations <- sotu_collocations[1:250, ]

corpus_tokens <- tokens_compound(corpus_tokens, sotu_collocations)

# Tutorial 6: Topic Models
# I Modell Brechnung

# Erstelle dtm ohen Begriffe, die in weniger als 1% des Datensatzes vorkommen
DTM <- corpus_tokens %>% 
  tokens_remove("") %>%
  dfm() %>% 
  dfm_trim(min_docfreq = 0.01, max_docfreq = 0.935, docfreq_type = "prop")

# have a look at the number of documents and terms in the matrix
dim(DTM)

# Entfernen von besonderen Begriffen, die keinen Aussagegehalt haben, da sie
# so corpus spezifisch sind
top10_terms <- c( "unite_state", "past_year", "year_ago", "year_end", "government", "state", "country", "year", "make", "seek")

DTM <- DTM[, !(colnames(DTM) %in% top10_terms)]

# Leere Zellen entfernen, da diese zu einem Problem fuer das TopicModell werden koennen
sel_idx <- rowSums(DTM) > 0
DTM <- DTM[sel_idx, ]
textdata <- textdata[sel_idx, ]

# Topic Modelle
# - unsupervized learning und daher fuer explorative Untersuchungen geeignet
# - Es gibt unterschiedliche Parameter, die bei den Modellen angepasst werden koennen
#   (Experimentieren oder an wissenschaftlichen Standards in Literatur orientieren)

# Latent Dirichlet Allocation (Verfahren d. parameterized machine learnings)
# - k (Anzahl der Topics) ist der wichtigste Parameter
#   >> k zu klein sind Topics zu allgemein (fassen mehrere zusammen)
#   >> k zu groß, sind Topics zu spezifisch bzw. ueberlappen (schwer voneinander zu trennen)

# Topic Modelle erstellen
# Paket laden: topicmodels
require(topicmodels)
# Zahl der Modelle auf 20 gesetzt
K <- 20

# Berechnen eines LDA Modells, Inferenzen via iterations of Gibbs sampling
# 500 Wiederholungen
topicModel <- LDA(DTM, K, method="Gibbs", control=list(iter = 500, seed = 1, verbose = 25))

# Ergebnisdarstellung (posterior Verteilung)
tmResult <- posterior(topicModel)
# fuer jeden Term, die Wahrscheinlichkeit, dass er zu einem bestimmten Topic
# gehoert

# Format des Ergebnisobjekts
attributes(tmResult)

# Groeße des Vocabulars
ncol(DTM) 

# Probability Distribtions der Topics ueber das gesamte Vocabular
# Prozentanteile, den das Wort fuer das Topic ausmacht
# >> ein Topic wird zu 100% von den Verfuegbaren Begriffen erschlossen 
#    (so die Annahme, deswegen rowSums = 1)
# >> Und beta (pro Wort) bestimmt den Beitrag, den das Wort fuer das Topic
#    leistet

beta <- tmResult$terms   # betas rausspeichern
dim(beta)                # 20 topic (K Verteilungen) ueber ncol(DTM) terms
View(beta)
rowSums(beta)            # Summe der Zeilenwerte sollte 1 sein


# Fuer jede Dokument (!), Wahrscheinlichkeit ausgeben, dass sie ein 
# bestimmtes Topic enthalt
theta <- tmResult$topics 

dim(theta)               # nDocs(DTM) Verteilungen ueber K topics
# 223 docs und 20 topics
View(theta)
rowSums(theta)[1:10]     # rows in theta sum to 1

# Ersten 10 Worte, die mit groester Wahrscheinlichkeit zu einem gewissen
# Topics ausgeben lassen
terms(topicModel, 10)
head(sort(beta[1,], decreasing =T),20) # fuer erste Topic kontrollieren

top5termsPerTopic <- terms(topicModel, 5)
topicNames <- apply(top5termsPerTopic, 2, paste, collapse=" ")

# II Visualisierung
require(wordcloud2)

# Visualisierung eines Topics in einer Wordcloud
topicToViz <- 11 # Nummer des Topics, das visualisiert werden soll

topicToViz <- grep('mexico', topicNames)[1] # Auch moeglich nach einem Begriff im Namen zu suchen

# 40 wahrscheinlichsten Begriffe des Topics durch Sortieren in absteigender Reihenfolge des Betas
top40terms <- sort(tmResult$terms[topicToViz,], decreasing=TRUE)[1:40]

words <- names(top40terms)
# Wahrscheinlichkeiten fuer diese Begriffe extrahieren (sind eigentlich scon in top40 terms)
probabilities <- sort(tmResult$terms[topicToViz,], decreasing=TRUE)[1:40]

# Wordcloud erstellen
wordcloud2(data.frame(words, probabilities), shuffle = FALSE, size = 0.8)
wordcloud2(data.frame(names(top40terms), top40terms), shuffle = FALSE, size = 0.8)


# Betrachten der Verteilung der Topics in unterschiedlichen Reden
# Betrachten Rede 2, 100, 200 
textdata$president[c(2, 100, 200)] # von folgenden Praesidenten

# Texte ausgeben lassen
exampleIds <- c(2, 100, 200)
cat(sotu_corpus[exampleIds[1]])
cat(sotu_corpus[exampleIds[2]])
cat(sotu_corpus[exampleIds[3]])


# Lade noetige Pakete, reshape zum Umwandeln des Datenformats, ggplot2 zur Visualisierung
library("reshape2")
library("ggplot2")

N <- length(exampleIds)

# Topic Verteilungen fuer die Dokumente extrahieren
topicProportionExamples <- theta[exampleIds,]

# Topics benennen
colnames(topicProportionExamples) <- topicNames

# Dataframe in long-Format umwandeln mit document als id
# cbind(data.frame(topicProportionExamples), document = factor(1:N)) # erstellt ID var
vizDataFrame <- melt(cbind(data.frame(topicProportionExamples), document = factor(1:N)), variable.name = "topic", id.vars = "document")  

ggplot(data = vizDataFrame, aes(topic, value, fill = document), ylab = "proportion") + 
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +  
  coord_flip() +
  facet_wrap(~ document, ncol = N)

# Moeglichkeit auch Texte, bei der ein Thema am haeufigsten vorkommt ausgeben
# zu lassen, um den Text auch qualitativ zu erschließen

# III Topic Verteilungen
# Alpha Wert des vorherigen Modells betrachten
attr(topicModel, "alpha")

# alpha hat hier den Standardwert 2,5 >> normalerweise 1/k 
# kleineres Alpha fuehrt dazu, dass man eher ein Topic pro Text hat

topicModel2 <- LDA(DTM, K, method="Gibbs", control=list(iter = 500, verbose = 25, seed = 1, alpha = 0.2))
tmResult <- posterior(topicModel2)
theta <- tmResult$topics
beta <- tmResult$terms
topicNames <- apply(terms(topicModel2, 5), 2, paste, collapse = " ")  # reset topicnames

# Gleiche Vorgehensweise bei der Visualisierung
topicProportionExamples <- theta[exampleIds,]
colnames(topicProportionExamples) <- topicNames
vizDataFrame <- melt(cbind(data.frame(topicProportionExamples), document = factor(1:N)), variable.name = "topic", id.vars = "document")  

ggplot(data = vizDataFrame, aes(topic, value, fill = document), ylab = "proportion") + 
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +  
  coord_flip() +
  facet_wrap(~ document, ncol = N)

# Inzwischen gibt es auch Kennwerte, mit denne die Koheraenz von Topics berechent 
# werden koennen

# IV Topic Ranking
library(lda)
# Top Topic Terms fuer Namen des Topics neu ordnen
topicNames <- apply(lda::top.topic.words(beta, 5, by.score = T), 2, paste, collapse = " ")


# Um herauszufinden, was die wichtigesten Topics in Set sind, gibt es zwei Moeglichkeiten
# Topics anch der Wahrscheinlichkeit in der Kollektion aufzutauchen sortieren

# Mittelwert der Auftrittwahrscheinlichkeit im Dokument
topicProportions <- colSums(theta) / nrow(DTM)  
names(topicProportions) <- topicNames     # mit Namen benennen
sort(topicProportions, decreasing = TRUE) # in absteigender Reihenfolge ausgeben


# 2te Herangehensweise
# Auszaehlen wie oft ein Topic das wichtigste in einem Dokument war
countsOfPrimaryTopics <- rep(0, K)
names(countsOfPrimaryTopics) <- topicNames

for (i in 1:nrow(DTM)) {
  topicsPerDoc <- theta[i, ] # Topikverteilung fuer Dokument i waehlen
  # ordnen und erstes Element auswaehlen; und Zaehlung in der Liste erhoehen
  primaryTopic <- order(topicsPerDoc, decreasing = TRUE)[1] 
  countsOfPrimaryTopics[primaryTopic] <- countsOfPrimaryTopics[primaryTopic] + 1
}
sort(countsOfPrimaryTopics, decreasing = TRUE)

# Manche Topics koemmeni n dem Text nicht vor
# Koennte auch mit niedrier Dokumentenanzahl zusammenheangen


# V Dokumente Filtern
# Unterschiedliche Moeglichkeinten eine Topic zum Filtern auszuwaehlen
topicToFilter <- 6  # manuell
topicToFilter <- grep('mexico ', topicNames)[1]  # oder nach gewissem Begriff im Namen

# Alle Dokumente, bei denen die Wahrscheinlichkeit, dass Mexico-Topic vorkommt > 10% ist
# Rainer: evtl besser als 50% stellen, da die Topic dann dominant ist
View(beta)
topicThreshold <- 0.1 # Wahrscheinlichkeit, dass Topic vorkommt
selectedDocumentIndexes <- (theta[, topicToFilter] >= topicThreshold)
filteredCorpus <- sotu_corpus %>% corpus_subset(subset = selectedDocumentIndexes)

# show length of filtered corpus
filteredCorpus


# VI Topic Anteile ueber Zeit

# append decade information for aggregation
textdata$decade <- paste0(substr(textdata$date, 0, 3), "0")

# Durchschnittlicher Topic Wert fuer die Wahrscheinlichkeit einer Topic pro Jahrzehnt
topic_proportion_per_decade <- aggregate(theta, by = list(decade = textdata$decade), mean)

# set topic names to aggregated columns
colnames(topic_proportion_per_decade)[2:(K+1)] <- topicNames

# reshape data frame
vizDataFrame <- melt(topic_proportion_per_decade, id.vars = "decade")

# plot topic proportions per deacde as bar plot
require(pals) # Fuer Alphabet colering
16^2

ggplot(vizDataFrame, aes(x=decade, y=value, fill=variable)) + 
  geom_bar(stat = "identity") + ylab("proportion") + 
  scale_fill_manual(values = paste0(alphabet(20), "FF"), name = "decade") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
                     
