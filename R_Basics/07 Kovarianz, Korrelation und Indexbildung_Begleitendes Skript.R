##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung VII Kovarianz, Korrelation und Indexbildung - Begleitendes Skript 
## 18.04.2024

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("naniar")){install.packages("naniar")}
library(naniar)

if(!require("Hmisc")){install.packages("Hmisc")}
library(Hmisc)

if(!require("psych")){install.packages("psych")}
library(psych)

# Einlesen der Datensaetze
dat <- read.csv("mediaUsage.csv", header=T, stringsAsFactors = T)
dat <- replace_with_na_all(dat, condition=~.x==-99)
dat[dat$age==222,]$age <- 22
dat[dat$gender=="d",]$gender <- NA

# I Kovarianz
# Die Kovarianz ist ein bivariates Zusammenhangsma?, dass sich ueber
# die durchnitliche gemeinsame Varianz berechnen laesst
cov(dat$age, dat$soMedTime, use="complete.obs") # -399.46
cov(dat$age, dat$tvTime, use="complete.obs") # 10.41

# Positive Kovarianz: 	  Hohe x korrespondieren mit hohen y
# Negative Kovarianz:  	  Hohe x korrespondieren mit kleinen y
# Kovarianz gleich null:	Kein (linearer) Zusammenhang zwischen x und y

# Die hohe, negative Kovarianz zwischen Alter und der Social Media Nutzung
# deutet auf einen negativen Zusammenhang hin.

# Die niedrige, positive Kovarianz zwischen Alter und der TV Nutzung
# deutet darauf hin, dass kein Zusammenhang zwischen den Variablen besteht.


# II Korrelation
# Ma? fuer einen bivariaten, linearen Zusammenhang

# Standardisiert die Kovarianz, indem durch das Produkt der Standardabweichung
# beider Variablen getielt wird

# Interpretation
# r kann Werte zwischen -1 und 1 annehmen:
# Ab >= 0.1:  	Schwacher Zusammenhang
# Ab >= 0.3:  	Mittlerer Zusammenhang
# Ab >= 0.5:	  Starker Zusammenhang

# x Korrelationsmatrix mit Signifikanztest
# Um fuer mehrere Variablen gleichzeitig eine Korrelation mit Signifikanz-
# niveau zu bestimmen, muss die Funktion rcorr() aus dem Paket Hmsic 
# verwendet werden: rcorr(as.matrix(dat[c("age", "tvTime", "soMedTime")]), type="pearson")
rcorr(as.matrix(dat[c("age", "tvTime", "soMedTime")]), type="pearson")

# Output erscheint in unterschiedlichen Tabellen (r, n, p)

# Zwischen Alter und Social Media Nutzung besteht ein signifikanter 
# negativer Zusammenhang, r = -.58, p < .001. Hoeheres Alter korrespondiert 
# mit niedrigerer social Media Nutzung und umgekehrt.

# Zwischen Alter und Fernsehnutzung besteht kein signifikanter Zusammenhang,
# r =.03, p > .05. Es kann daher angenommen werde, dass die Variablen in 
# der Stichprobe voneinander unabhaengig sind.



# III Cronbachs Alpha
# Ein Schaetzmass fuer die Reliabilitaet einer Skala, das die
# interne Konsistenz zwischen den Items einer Skala misst

# >.9 	Exzellent
# >.8: 	Sehr gut
# >.7: 	Gut bis akzeptabel
# >.6:	Akzeptabel bis fragwuerdig
# >.5 	schlecht
# <.5   Inakzeptabel

dat <- read_sav("ESS10DE.sav")
psych::alpha(dat[c("stfedu", "stfdem", "stfgov", "stfhlth", "stfmjob")], 
             check.keys = T)
# Die interne Konsistenz des Zufriedenheitsindexes waere gut 
# bis akzeptabel (alpha > 0.71). Die Indexbildung waere also moeglich.

# Zufriedenheit mit den Beruf koennte (stfmjob) bei der Indexbildung 
# weggelassen werden (misst evtl. einen anderen Aspekt der 
# Zufriedenheit)

# X Indexbildung
# Wenn das Messmodell spezifiziert ist und die Daten erhoben 
# wurden, muss der Index manuell berechnet werden:

# a) Summenindex
dat$stf_idx1 <- rowSums(dat[c("stfedu", "stfdem", "stfgov", "stfhlth")]) 

# Die Werte des Indexes liegen zwischen 0 und 40

# b) Mittelwertindex
dat$stf_idx2 <- rowMeans(dat[c("stfedu", "stfdem", "stfgov", "stfhlth")])

# Die Werte des Indexes liegen zwischen 0 und 10

# Zur Ueberpruefung kann head() verwendet werden
head(dat[c("stfedu", "stfdem", "stfgov", "stfhlth","stf_idx1","stf_idx2")])

