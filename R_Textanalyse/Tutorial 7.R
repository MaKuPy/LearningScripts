#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Erster Task: GitHub Tutorials (Niekler & Wiedemann)
# https://tm4ss.github.io/docs/index.html
#
# Tutorial 7: Classification
#
# Basics of Textanalysis
options(stringsAsFactors=F)
library(dplyr)
library(quanteda)
library(tidyverse)
# library(topicmodels)

# I Datensatz einlesen
# Sotu-Datensatz in Paragraphform einlesen
textdata <- read.csv("data/sotu_paragraphs.csv", sep = ";", encoding = "UTF-8")

sotu_corpus <- corpus(textdata$text, docnames = textdata$doc_id)

# Lemma-Datei einlesen
lemma_data <- read.csv("ressources/baseform_en.tsv", encoding = "UTF-8")

# Stopwort-Liste einlesen
stopwords_extended <- readLines("ressources/stopwords_en.txt", encoding = "UTF-8")

# Vorerst werden nur einfache Schritte der Datenverarbeitung angewandt
# Tokenization und Vorbereitung der Daten
corpus_token <- sotu_corpus %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>% 
  tokens_tolower() 

# tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype = "fixed") %>% 
# tokens_remove(pattern = stopwords_extended, padding = T)

# library(quanteda.textstats)
# sotu_collocations <- textstat_collocations(corpus_tokens, min_count = 25)
# sotu_collocations <- sotu_collocations[1:250, ]
# corpus_tokens <- tokens_compound(corpus_tokens, sotu_collocations)

# II Trainingsdatensatz einlesen

# Der Trainingsdatensatz enthaelt 300 manuell kodierte Paragraphe, denen jeweils 
# eine Kategorie zugeordnet wurde (trainingdata: ID, Kategorie)
trainingData <-  read.csv2("data/paragraph_training_data_format.csv", stringsAsFactors = T)


dtm <- corpus_token %>% 
  dfm() %>% 
  dfm_trim(min_docfreq = 5)
dim(dtm)

# III Classification

# Laden der benoetigten Pakete
library(LiblineaR)
# Das Paket LiblineaR enthaelt zwei Algorithmen fuer die einfache Klassifikation
# von Texten via (1) logistischer Regression, (2) Support Vector Machines [SVM]

library(SparseM) # da liblineaR auf sparse Matrix zurueckgreift
source("ressources/utils.R") # enthaelt gewisse Funktionen (convertMatrixToSparseM)

# Datensatz in Training- (80 %) und Testset (20 %) unterteilen

# Paragraphen extrahieren, die bereits annotiert sind
# in sparse Matrix umwandeln
annotatedDTM <- convertMatrixToSparseM(dtm[trainingData[, "ID"], ])


# Label als Vektor extrahieren
annotatedLabels <- trainingData$LABEL

# Datensatz in Test und Trainingsset zerlegen
# in dem Fall wird 4 x TRUE und einmal FALSE wiederholt, um 80~20 Split zu erzeugen
# Funktioniert, da das Trainingsset ungeordnet ist
selector_idx <- rep(c(rep(TRUE, 4), FALSE), length.out = nrow(trainingData))

# Trainingsset erstellen
trainingDTM <- annotatedDTM[selector_idx, ]
trainingLabels <- annotatedLabels[selector_idx]

# Testset erstellen
testDTM <- annotatedDTM[!selector_idx, ]
testLabels <- annotatedLabels[!selector_idx]

# LR classification Model mit Loglinear
# Default L2 Regularization mit logistischer Regression
# Modell wird anhand des Klassikationsvekotrs (trainingLabels) gebaut
m1 <- LiblineaR(trainingDTM, trainingLabels)
summary(m1)


# Modell verwenden, um Werte im Testdetaset vorherzusagen
classification <- predict(m1, testDTM)

# Vektor mit Vorhersagen
classification$predictions

# Kontingenztabelle
(tab <- table(classification$predictions, testLabels))
# 26 Mal wurde Domestic richtig klassifiziert und 10 mal foreign
# 19 mal wurde ein domestic paragraph fälschlicherweise als foreign klassifizert 
# und 5 mal ein forein paragraph faelschlicherweise als domestic

# Bewertung des Modells
# Accuracy = Summe der richtigen Klassifizierung / Gesamtklassifizierung
# Anteil der richtigen Klassifizierung
(accuracy <- sum(diag(tab))/length(testLabels))
# acc = 0.6 >> 60% der Paragraphen wurden richtig klassifiziert

# Evaluation der Domestic-Klassifizierung mit relevanten statistischen Werten
F.measure(classification$predictions, testLabels, positiveClassName = "DOMESTIC")

# Precision (positive predictive value)
# Anteil der TRUE_Zielkondition an der Gesamt Zielkondition (% richtiger Zielkondition)
# TRUE-Positive/SUMME(TRUE-Positive + False-Positives)
tab[1]/rowSums(tab)[1] # 26/(26+5)
# 83.87 % der als Domestic klassifizierten Paragraphen sind tatsaechlich domestic


# Recall
# Anteil an Zielkondition, die richtig klassifiziert wurde (% der Zielkond., der richtig erkannt wurde)
# TRUE-Positive/SUMME(TRUE-Positive + False-Negative)
tab[1]/colSums(tab)[1] # 26/(26+19)

# 57.78 % Der Domestic-Paragraphen wurden auch als Domestic klassifiziert

# Specifity = S
# Recall der Negativ-Kondition


# F-Measure
# Harmonic Mean von Recall und Precision
# wird auch kritisiert...
# 2*(precision*recall/(precision + recall))
2*(0.8387097* 0.5777778/(0.8387097 + 0.5777778))
# >> alles .6 ok/ausreichend :(, > 0.8 richtig gut!

# Kennwerte fuer Foreign-Klassifizierung
F.measure(classification$predictions, testLabels, positiveClassName = "FOREIGN")
# es gibt viele False Positives fuer Foreign (precision)... aber insgesamt wurde ein Großteil der
# Foreign Faelle erkannt (recall)

# Klassifizieruung erstellen
# Nur Domestic
pseudoLabelsDOM <- factor(rep("DOMESTIC", length(testLabels)), levels(testLabels))
# Nur Foreign
pseudoLabelsFOR <- factor(rep("FOREIGN", length(testLabels)), levels(testLabels))

# Vergleich mit Pseudo-Klassifizierung # All DOMESTIC
F.measure(pseudoLabelsDOM, testLabels, positiveClassName = "DOMESTIC")

# All Foreign
F.measure(pseudoLabelsFOR, testLabels, positiveClassName = "FOREIGN")
# Recall in beiden Faellen = 1, da alles Zielkondition zugeordnet wurde
# aber Precision ist schlechter und specity d= 0 (gar kein recall v. TRUE Negatives)

# >> Um Maße genauer zu bestimmen, sollte die niedriger-frequentierte Kategorie als
# positiv gesetzt werden


# IV K-fold Cross-Validation
# Umgeht den Nachteil, dass ein Teil des Trainingsdatasets zum Testing verloren geht,
# indem das Trainingsset in K-Teile (K-1 Training und 1 Testteil) unterteilt wird

# Das ganze wird K mal mit der neuen Unterteilungen wiederholt


# Funktion erstellt einen logical Vektor mit T, F, mit dem der Datensatz j mal in 
# k Teile unterteilt werden kann fuer n Dateneintraege

get_k_fold_logical_indexes <- function(j, k, n) {
  if (j > k) stop("Cannot select fold larger than nFolds")
  fold_lidx <- rep(FALSE, k)
  fold_lidx[j] <- TRUE
  fold_lidx <- rep(fold_lidx, length.out = n)
  return(fold_lidx)
}

# Berechnen des Classifikations-Modells mit Cross-Validation

k <- 10
evalMeasures <- NULL

for (j in 1:k) {
  # Den j-ten logischen Vektor erstellen
  currentFold <- get_k_fold_logical_indexes(j, k, nrow(trainingDTM))
  
  # Datensatz und Label mit dem Vektor in ein Trainingsset unterteilen
  foldDTM <- annotatedDTM[!currentFold, ]
  foldLabels <- annotatedLabels[!currentFold]
  
  # create model
  model <- LiblineaR(foldDTM, foldLabels)
  
  # Testdatensatz auswaehlen
  testSet <- annotatedDTM[currentFold, ]
  testLabels <- annotatedLabels[currentFold]
  
  # Vorhersagevektor erstellen
  predictedLabels <- predict(model, testSet)$predictions
  
  # Kennwerte zur Beurteilung der Vorhersage ausgeben lassen
  kthEvaluation <- F.measure(predictedLabels, testLabels, positiveClassName = "FOREIGN")
  
  # combine evaluation measures for k runs
  evalMeasures <- rbind(evalMeasures, kthEvaluation)
}

# Final evaluation values of k runs:
print(evalMeasures)

# Mittelwerte ueber alle Schritte
colMeans(evalMeasures)

# V Optimization

# 5.1 c-Parameter
# Fuer eine lineare Klassifizierung ist c der wichtigste Parameter, der das Modell 
# beeinflusst (= Cost-Parameter)
# Hohe C: fuehren dazu, dass das Modell so wenige Missklassifizierungen, wie moeglich macht
#         >> Problem von Overfitting
# Kleine C: Fuehren zu mehr Fehlern aber ggf. einer besseren Uebertragbartkeit auf
#           andere Datensaetze >> Problem von underfitting

# Welches C am besten passt ist eine empirische Frage und muss getestet werden

# Wiederholen der Crossvalidierung fuer unterschiedliche c's
# mit der Funktion k_fold_cross_validation
cParameterValues <- c(0.003, 0.01, 0.03, 0.1, 0.3, 1, 3 , 10, 30, 100)
fValues <- NULL


# Extrahiert F-Statistik fuer unterscheidliche Level von c
for (cParameter in cParameterValues) {
  print(paste0("C = ", cParameter))
  evalMeasures <- k_fold_cross_validation(annotatedDTM, annotatedLabels, cost = cParameter)
  fValues <- c(fValues, evalMeasures["F"])
}

# Plottet F-Statistik fuer unterschiedliche level von c
plot(fValues, type="o", col="green", xaxt="n")
axis(1,at=1:length(cParameterValues), labels = cParameterValues)

bestC <- cParameterValues[which.max(fValues)]
print(paste0("Best C value: ", bestC, ", F1 = ", max(fValues)))



# 5.2 Optimiertes Preprocessing

# a) Entfernen von Stopwords
corpus_token_sw <- sotu_corpus %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>% 
  tokens_tolower() %>% 
  tokens_remove(pattern = stopwords_extended)

print(paste0("1: ", substr(paste(corpus_token_sw[4963],collapse = " "), 0, 400), '...'))


# Erstelle DTM
DTM <- corpus_token_sw %>% 
  dfm() %>% 
  dfm_trim(min_docfreq = 5)

# Cross-Vlaidation mit unterschiedlichen C ausfuehren
annotatedDTM <- convertMatrixToSparseM(DTM[trainingData[, "ID"], ])
best_C <- optimize_C(annotatedDTM, annotatedLabels)

# Evaluative Measures
k_fold_cross_validation(annotatedDTM, annotatedLabels, cost = best_C)

# b) Betrachten von Bigrammen
# Tokens aus zwei Begriffen. "This is funny" wird zu "This_is" und "is_funny"
corpus_token_bigrams <- sotu_corpus %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>% 
  tokens_tolower() %>% 
  tokens_remove(pattern = stopwords_extended) %>%
  tokens_ngrams(1:2)

# Beispiel
print(paste0("1: ", substr(paste(corpus_token_bigrams[4963], collapse = " "), 0, 400), '...'))

DTM <- corpus_token_bigrams  %>% 
  dfm() %>% 
  dfm_trim(min_docfreq = 5)
sample(colnames(DTM), 10)

# Cross-Validierung
annotatedDTM <- convertMatrixToSparseM(DTM[trainingData[, "ID"], ])
best_C <- optimize_C(annotatedDTM, annotatedLabels)
# Measures
k_fold_cross_validation(annotatedDTM, annotatedLabels, cost = best_C)

# fuehrt nicht zu einer Verbesserung

# 3) Anpassen der Minimal-Frequenz eines Features
# Zwei statt Fünf
DTM <- corpus_token_sw  %>% 
  dfm() %>% 
  dfm_trim(min_docfreq = 2)

annotatedDTM <- convertMatrixToSparseM(DTM[trainingData[, "ID"], ])
best_C <- optimize_C(annotatedDTM, annotatedLabels)
# Measures
k_fold_cross_validation(annotatedDTM, annotatedLabels, cost = best_C)

dim(trainingData)
dim(textdata)
# 4) Lemmatisierung
corpus_token_lemma <- sotu_corpus %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE) %>% 
  tokens_tolower() %>% 
  tokens_replace(lemma_data$inflected_form, lemma_data$lemma, valuetype = "fixed") %>%
  tokens_remove(pattern = stopwords_extended) %>%
  tokens_ngrams(1)

DTM <- corpus_token_lemma  %>% 
  dfm() %>% 
  dfm_trim(min_docfreq = 2)

annotatedDTM <- convertSlamToSparseM(DTM[trainingData[, "ID"], ])
best_C <- optimize_C(annotatedDTM, annotatedLabels)
# Measures
k_fold_cross_validation(annotatedDTM, annotatedLabels, cost = best_C)

# Optimierung braucht etwas Zeit!
# F = 0.68 vorerst das beste Ergebnis

# 6 Final Classification
# Nun wird das beste Modell auf den restlichen Datensatz uebertragen, um foreign 
# oder domestic Themen zu kategorisieren

# Finale Klassifizierung
# - ohne Stopwords
# - doc_Freq = 2
# - Lemmatisiert
# - keine Bigramme!

annotatedDTM <- convertMatrixToSparseM(DTM[trainingData[, "ID"], ])

# Besten C-Parameter finden
best_C <- optimize_C(annotatedDTM, annotatedLabels)

# Finale Klassifizierung
final_model <- LiblineaR(annotatedDTM, annotatedLabels, cost = best_C)


# DTM mit dem Modell vorhersagen
final_labels <- predict(final_model, convertSlamToSparseM(DTM))$predictions

table(final_labels) / sum(table(final_labels))

# Visualisierung der Paragraphen nach Praesident in einem Balkendiagramm

colnames(textdata)
View(textdata)
speech_year <- substr(textdata$date, 0, 4)
speech_id <- textdata$speech_doc_id
# Erstellt einen Vektor aus den Summen (table!) der speech ID
paragraph_position <- unlist(sapply(table(speech_id), FUN = function(x) {1:x}))

presidents_df <- data.frame(
  paragraph_position = paragraph_position,
  speech = paste0(speech_id, ": ", textdata$president, "_", speech_year),
  category = final_labels
)

# Reihenfolge der Reden mittels Faktor beibehalten
# Sonst alphabetische Ordnung
presidents_df$speech <- factor(presidents_df$speech, levels = unique(presidents_df$speech))

# Entfernen zweier sehr langer Reden, um den Graphen schoener zu machen
presidents_df <- presidents_df[!grepl("Carter_1981|Truman_1946", presidents_df$speech), ]

# plot classes of paragraphs for each speech as tile
require(ggplot2)
ggplot(presidents_df, aes(x = speech, y = paragraph_position, fill = category)) + 
  geom_tile(stat="identity") + coord_flip()
