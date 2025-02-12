#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Erster Task Ergaenzung: Word Embeddings
# Quateda
# https://quanteda.io/articles/pkgdown/replication/text2vec.html
#
#
# Word embeddings

library("quanteda")

# Beispiel-Korpus von Wikipedia
wiki_corp <- quanteda.corpora::download(url = "https://www.dropbox.com/s/9mubqwpgls3qi9t/data_corpus_wiki.rds?dl=1")

# Preprocessing/ DFM
wiki_toks <- tokens(wiki_corp)
feats <- dfm(wiki_toks, verbose = TRUE) %>%
  dfm_trim(min_termfreq = 5) %>%
  featnames()

# Coocurrance Matrix erstellen
# (mit Gesamten Tokens)
?fcm
# Kontext: Window (mit Standard, 5 Woerter vorher und nachher)
# Gewicht: Weiter entfernte Worte werden geringer gewichtet (1/(1:n-window))
wiki_fcm <- fcm(wiki_toks, context = "window", count = "weighted", 
                weights = 1 / (1:5), tri = TRUE)

# Paket benoetigt
install.packages("text2vec")
library("text2vec")

# Sehr hauefige Co-occurances sagen wenig aus (z.B. mit Artikel)
# Daher muessen diese umgewichtet werden 
# Außerdem muessen Dimensionen reduziert werden
glove <- GlobalVectors$new(rank = 50, x_max = 10)
# rank reduzierung auf Anzahl von n-rank Vektoren

# Erstellen des Glove Modells
# Wiederholungen werden ab einem gewissen Toleranzwert von loss (wird 
# immer ausgegeben) abgegebrochen >> auf Basis von convergence_tol
# Oder nach den Wiederholungen, die in niter angegeben werden
set.seed(123456)
wv_main <- glove$fit_transform(wiki_fcm, n_iter = 20,
                               convergence_tol = 0.01, n_threads = 8)

dim(wv_main)

# Normalwerte in Lit. fuer rank, convergence_tol, n_iter nachschlagen

## Average learned word vectors
wv_context <- glove$components
dim(wv_context)

# Werte von main und context werden summiert
word_vectors <- wv_main + t(wv_context)

# Examining term representations
# Naehe von einem einzelnen Wort zu anderen ausgeben lassen
fear <- word_vectors["fear", , drop = FALSE] 
cos_sim <- textstat_simil(as.dfm(word_vectors), y = as.dfm(fear),
                          margin = "documents", method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 20)


# Vektor Paris - Vektor Frankreich + Vektor Deutschland = Berlin
berlin <- word_vectors["paris", , drop = FALSE] -
  word_vectors["france", , drop = FALSE] +
  word_vectors["germany", , drop = FALSE]

# Mit Cos-Aehnlichkeit Vektor finden, der dem neuen am aehnlichsten ist
library("quanteda.textstats")
cos_sim <- textstat_simil(x = as.dfm(word_vectors), y = as.dfm(berlin),
                          method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 5)

# Beispiel London
london <-  word_vectors["paris", , drop = FALSE] -
  word_vectors["france", , drop = FALSE] +
  word_vectors["uk", , drop = FALSE] +
  word_vectors["england", , drop = FALSE]

cos_sim <- textstat_simil(as.dfm(word_vectors), y = as.dfm(london),
                          margin = "documents", method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 5)


View(word_vectors)
queen <-  word_vectors["king", , drop = FALSE] -
  word_vectors["emperor", , drop = FALSE] +
  word_vectors["land", , drop = FALSE]
cos_sim <- textstat_simil(as.dfm(word_vectors), y = as.dfm(queen),
                          margin = "documents", method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 5)

fear <- word_vectors["fear", , drop = FALSE] -
  word_vectors["feeling", , drop = FALSE]
cos_sim <- textstat_simil(as.dfm(word_vectors), y = as.dfm(fear),
                          margin = "documents", method = "cosine")
head(sort(cos_sim[, 1], decreasing = TRUE), 20)

# Moeglichkeit mit word-embedding Bias-Tests durchzufuehren
# Frau, sollte z.B nicht mehr mit Krankenschwester/ weniger mit Wissenschaft
# verbunden sein

# Ziel eigentlich bias rauszurechnen (auch in Suchmaschinen)

# LSS findet echte Synonyme in Zusammenhang mit Zielbegriffen 
# WE Bias Tests betrachten, ob es Synonyme zu Begriffen gibt, die einen Bias ausdruecken
# z. B. ob der begriff "Tuerke" etwas mit Furcht zusammenhaengt/ Ein Synonym davon ist

# >> EM Bias Tests gehen einen Schritt weiter: betrachten,ob diese Begriffe haeufiger
#    im Kontext von Begriffen vorkommen, der eine gewisse Semnatik zugeordnet wurde 
#    (z.B. Furcht)
# >> Standardisierun von Varianz im Prozess




