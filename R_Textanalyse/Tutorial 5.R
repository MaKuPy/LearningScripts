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

textdata <- read.csv("data/sotu.csv", sep = ";", encoding = "UTF-8")

# Erstellt Korpus mit Jahreszahl als zusaetliche Variable
sotu_corpus <- corpus(textdata$text, docnames = textdata$doc_id, docvars = data.frame(year = substr(textdata$date, 0, 4)))
summary(sotu_corpus)

# Tutorial 5: Co-Occurance
# I Satzerkennung
# Verwendet diverse Signfikanzmaße, um semantische Verbindung zwischen Worten
# zu erkennen

# 1. Satzerkennung
# Ein wichtiger Bestandteil der Co-Occurance Analyse ist das unterteilen der Texte
# in semantische Einheiten (kann ein Satz, ein Paragraph oder ein ganzer Text sein)

# auf der Satzebene, um zu schauen, welche Konzepte zusammenhaengen
ndoc(sotu_corpus) # Aktuell ist der Korpus in Texte unterteilt, die jeweils mehrere Saetze haben
substr(as.character(sotu_corpus)[1], 0, 200) # ersten 200 Worte

# Verschiedene Moeglichkeiten Saetze zu erkennen
# - corpus_sentences() in quanteda (nicht unbedingt die Beste)
# - auch komplexere Moeglichkeiten mit Python

# corpus_reshape(corpus, to = "sentences") # macht aus jeden Satz ein neues Dokument
corpus_sentences <- corpus_reshape(sotu_corpus, to = "sentences")

# Anzahl von Dokumenten
ndoc(corpus_sentences)

# Erste Satz ausgeben lassen
as.character(corpus_sentences)[1]


# Lemma-Datei einlesen
lemma_data <- read.csv("ressources/baseform_en.tsv", encoding = "UTF-8")

# Stopwoerter Liste
stopwords_extended <- readLines("ressources/stopwords_en.txt", encoding = "UTF-8")

# Vorbereitung wie gewoehnlich
corpus_tokens <- corpus_sentences %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>% 
  tokens_tolower() %>% 
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype = "fixed") %>% 
  tokens_remove(pattern = stopwords_extended, padding = T)

# Collocations bestimmen und markieren
sotu_collocations <- textstat_collocations(corpus_tokens, min_count = 25)
sotu_collocations <- sotu_collocations[1:250, ]

corpus_tokens <- tokens_compound(corpus_tokens, sotu_collocations)

# Seltene Worte (seltener als 10 mal vorkommen) werden rausgenommen
# Create DTM, prune vocabulary and set binary values for presence/absence of types
binDTM <- corpus_tokens %>% 
  tokens_remove("") %>%
  dfm() %>% 
  dfm_trim(min_docfreq = 10) %>% 
  dfm_weight("boolean")



# II Co-Occurance auszaehlen

# Matrix multiplication for cooccurrence counts
coocCounts <- t(binDTM) %*% binDTM

# Worte, die zusammen vorkommen
as.matrix(coocCounts[1:10, 1:10])

# III Statistische Signifikanz
# Es koennen unterschiedliche Maße verwendet werden, um das gemeinsame Auftreten
# zweier Begriffe 
coocTerm <- "spain"

# Anzahl an Units
k <- nrow(binDTM)

# Occurances Zielwort
ki <- sum(binDTM[, coocTerm])

# Occurances insgesamt
kj <- colSums(binDTM)
names(kj) <- colnames(binDTM)

# Cooccurance mit anderen Worten
kij <- coocCounts[coocTerm, ]

########## MI: log(k*kij / (ki * kj) ########
# mutual Information kommt aus der Informationstheorie
# und quantifiziert, wie viel Informationen ueber eine Zufallsvariablen durch
# eine andere ausgedrueckt werden kann.

# Es setzt das gemeinsame Auftreten der Zufallsvariable P(x, Y) in das Verhaeltnis
# zu deren Produkt Px * Py

# Bei 0 sind die Merkmale vollkommen unabhängig

# (Amount of information obtained about one random variable by observing the other)
mutualInformationSig <- log(k * kij / (ki * kj))
mutualInformationSig <- mutualInformationSig[order(mutualInformationSig, decreasing = TRUE)]

# Sehr verwirrent... Drueckt irgendwie auch eine Seltenheit aus
coocCounts["spain", "amistad"]
coocCounts["spain", "connect"]


########## DICE: 2 X&Y / X + Y ##############
# = 1 wenn Worte immer gemeinsam auftreten
# = 0 wenn Worte nie gemeinsam auftreten
dicesig <- 2 * kij / (ki + kj)
dicesig <- dicesig[order(dicesig, decreasing=TRUE)]

########## Log Likelihood ###################
# Einfacher zu interpretieren
# Funktionieren die zuvor verwendeten Thresholds noch?
logsig <- 2 * ((k * log(k)) - (ki * log(ki)) - (kj * log(kj)) + (kij * log(kij)) 
               + (k - ki - kj + kij) * log(k - ki - kj + kij) 
               + (ki - kij) * log(ki - kij) + (kj - kij) * log(kj - kij) 
               - (k - ki) * log(k - ki) - (k - kj) * log(k - kj))
logsig <- logsig[order(logsig, decreasing=T)]


# Alles in einen Dataframe machen
resultOverView <- data.frame(
  names(sort(kij, decreasing=T)[1:10]), sort(kij, decreasing=T)[1:10],
  names(mutualInformationSig[1:10]), mutualInformationSig[1:10], 
  names(dicesig[1:10]), dicesig[1:10], 
  names(logsig[1:10]), logsig[1:10],
  row.names = NULL)
colnames(resultOverView) <- c("Freq-terms", "Freq", "MI-terms", "MI", "Dice-Terms", "Dice", "LL-Terms", "LL")
print(resultOverView)


# IV Visualisierung von Co-Occurance
# Funktion einlesen, die dabei hilft die Co-occurance signifikanz zu berechnen
source("calculateCoocStatistics.R")

coocs <- calculateCoocStatistics("california", binDTM, measure="LOGLIK")

# Die 15 wichtigsten Begriffe anzeigen
print(coocs[1:15])

# Das semantische Feld eines Begriffes kann schließlich mit Hilfe eines 
# Netzwerk-Graphen visualisiert werden, in dem neben den co-occurances auch die
# senkundaeren Co-Occurances geplottet werden

# Fuer Netzwerkanalysen eignet sich das Packet igraph
# Um einen Netzwerkgraphen zu visualisieren werden drei Punkte benoetigt
# ein Zielbegriff, eine Co-Occurance und ein Signifikanzmaß, dass deren Assoziation
# quantifiziert (e.g. logLikelihood)

library(igraph)

resultGraph <- data.frame(from = character(), to = character(), sig = numeric(0))

# In Schritt eins werden alle Informationen fuer die relevanten Co-Occurences mit
# dem Zielbegriff gesammelt und in einem naechsten Schritt die Informationen fuer
# die sekundaeren Co-Occurances mit den Primaeren.

# Es wird ein temporaeres Graph-Objekt erstellt, in dem Triples zunaechst abgelegt werden
# bevor sie mit rbind() an den result_graph angeschlossen werden
tmpGraph <- data.frame(from = character(), to = character(), sig = numeric(0))

# Dataframe mit den richtigen Informationen fuellen
# Signifikanzwerte
tmpGraph[1:15, 3] <- coocs[1:15]

# Zielbegriff in die erste Zeile
tmpGraph[, 1] <- "california"

# Name der Co-Occurences in die zweite Zeile
tmpGraph[, 2] <- names(coocs)[1:15]


# Ergebnis im dem result Graph objekt binden
resultGraph <- rbind(resultGraph, tmpGraph)

# Wiederholung der Vorgehensweise fuer die sekundaeren Co-Occurences
for (i in 1:15){
  
  # Term i aufrufen und eine neue Cooc-Statistik fuer diesen Term berechnen
  newCoocTerm <- names(coocs)[i]
  coocs2 <- calculateCoocStatistics(newCoocTerm, binDTM, measure="LOGLIK")
  
  # Temporaeres Graph-Objekt fuellen
  tmpGraph <- data.frame(from = character(), to = character(), sig = numeric(0))
  tmpGraph[1:15, 3] <- coocs2[1:15]
  tmpGraph[, 1] <- newCoocTerm
  tmpGraph[, 2] <- names(coocs2)[1:15]
  tmpGraph[, 3] <- coocs2[1:15]
  
  #Append the result to the result graph
  resultGraph <- rbind(resultGraph, tmpGraph[2:length(tmpGraph[, 1]), ])
}

# Den Graph visualisieren
# Random Seed festlegen
set.seed(1)

# Graph als undirected Graph erstellen
graphNetwork <- graph.data.frame(resultGraph, directed = F)

# Alle Nodes mit weniger als zwei Edges identifizieren
verticesToRemove <- V(graphNetwork)[degree(graphNetwork) < 2]
# Diese Edges werden entfernt
graphNetwork <- delete.vertices(graphNetwork, verticesToRemove) 

# Farben erstellen fuer Nodes (Verbindung zum Zielterm Blau, Rest Orange)
V(graphNetwork)$color <- ifelse(V(graphNetwork)$name == "california", 'cornflowerblue', 'orange') 

# Edge Farben festlegen
E(graphNetwork)$color <- adjustcolor("DarkGray", alpha.f = .5)
# Signifikanz nach Edge Laenge zwischen 1 und 10 skalieren
E(graphNetwork)$width <- scales::rescale(E(graphNetwork)$sig, to = c(1, 10))

# Edge Radius festlegen
E(graphNetwork)$curved <- 0.15 
# Groeße der nodes nach Grad des Networkings zwischen 5 und 15 skalieren
V(graphNetwork)$size <- scales::rescale(log(degree(graphNetwork)), to = c(5, 15))

# Frame und Spacing des Plots festlegen
par(mai=c(0,0,1,0)) 

# Finaler
plot(
  graphNetwork,             
  layout = layout.fruchterman.reingold, # Force Directed Layout 
  main = "California Co-Occ. Graph",
  vertex.label.family = "sans",
  vertex.label.cex = 0.8,
  vertex.shape = "circle",
  vertex.label.dist = 0.5,          # Labels of the nodes moved slightly
  vertex.frame.color = adjustcolor("darkgray", alpha.f = .5),
  vertex.label.color = 'black',     # Color of node names
  vertex.label.font = 2,            # Font of node names
  vertex.label = V(graphNetwork)$name,      # node names
  vertex.label.cex = 1 # font size of node names
)
