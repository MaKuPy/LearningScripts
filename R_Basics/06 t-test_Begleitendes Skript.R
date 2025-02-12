##########################################################
## Uebung Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung VI t-Test - Begleitendes Skript 
## 11.04.2024

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("naniar")){install.packages("naniar")}
library(naniar)

if(!require("psych")){install.packages("psych")}
library(psych)

if(!require("lsr")){install.packages("lsr")}
library(lsr)

if(!require("DescTools")){install.packages("DescTools")}
library(DescTools)


# Einlesen der Datensaetze
dat <- read.csv("mediaUsage.csv", stringsAsFactors=T, header=T)
dat[dat$age==222,]$age<-22 # falschen Wert ersetzen
dat <- replace_with_na_all(dat, ~.x==-99) # fehlende Werte ersetzen


#### I t-Test
## a) unabhaengiger t-Test
# Der unabhaengige t-Test ueberprueft den Zusammenhang zwischen einer 
# dichotomen und einer metrischen Variable

## Beispiel 1: Ueberpruefen, ob sich Studierende hinsichtlich ihrer Social Media
# Nutzungsdauer unterscheiden

# Schritt 1: Ueberpruefen der Varianzhomogenitaet mit dem Levene-Test
# >> Bei Signifikanz (p < .05) sind die Varianzen verschieden (die Annahme verletzt)
LeveneTest(dat$soMedTime~ as.factor(dat$student), center = median)

# Die Varianz der Nutzungsdauer sozialer Medien unterscheidet sich signifikant 
# hinsichtlich des Studierendenstatuses F(1, 66) = 12.267, p < .001. Somit besteht
# keine Varianzhomogenitaet und es muss ein Welch t-Test durchgefuehrt werden.


# Schritt 2: Welch t-Test fuer den Zusammenhang
t.test(dat$soMedTime ~ dat$student, alternative = "two.sided", var.equal = F)

# Schritt 3: Effektstaerke berechnen
cohensD(dat$soMedTime ~ dat$student)

# Studierende haben in der Stichprobe eine signifikant hoehere social Media
# Nutzungsdauer (M = 212.09, SD = 110.12) als Nichtstudierende (M = 89.14, SD =
# 49.55), t(43.88) = -5.88, p < .001, Cohen's d = 1.45.

describeBy(dat$soMedTime, dat$student) 
# Gibt Mittelwert und Standardabweichung der Gruppen aus



# Beispiel: H2: Maenner sind zufriedener mit ihren Lebensumstaenden als Frauen

dat2 <- read_sav("ESS7DE.sav")

# Indexbildung
dat2$stf_idx2 <- rowMeans(dat2[c("stfdem", "stfgov", "stfeco")])

# Schritt 1: Uberpruefung der Varianzhomogenitaet
LeveneTest(dat2$stf_idx2~ as.factor(dat2$gndr))

# Die Varianz der Zufriedenheit mit den Lebensumstaenden ist fuer Maenner 
# und Frauen gleich, F(1, 2913) = 1.4, p = .23.

# Schritt 2: Students t-Test (mit gerichteter Hypothese)

# Wie das Argument alternative gesetzt wird, haengt in dem Fall von der Skalierung 
# der Variable ab. 
print_labels(dat2$gndr) # 1 = male; 2 = female

# Dabei wird die Differenz der Mittelwerte von Gruppe 1 (Maenner) und Gruppe 2
# betrachtet: M_male - M_female
# - Wenn die erwartete Differenz positiv ist, also der Mittelwert fuer Maenner groeßer
#   ist als der fuer Frauen, schreiben wir "greater"
# - Wenn die erwartete Differenz negativ ist, also der Mittelwert fuer Maenner kleiner
#   ist als der fuer Frauen, schreiben wir "less"

t.test(dat2$stf_idx2~dat2$gndr, alternative = "greater", var.equal=T)


# Zur Berechnung der Standardabweichung des Indexes nach Geschlecht.
describeBy(dat2$stf_idx2, dat2$gndr) 

# Schritt 3: Effektstaerke berechnen
cohensD(dat2$stf_idx2~dat2$gndr)

# Maennliche Versuchspersonen (M = 5.8, SD = 1.9) waren in der 
# Stichprobe signifikant zufriedener mit den Lebensumst. als 
# weibliche Versuchspersonen (M = 5.5, SD = 1.84), t(2912) = 3.96,
# p < .001, Cohen's d = 0.147. Damit hat sich der in H1 postulierte 
# Zusammenhang bewaehrt.


## b) abhaengiger t-Test
# Der abhaengige t-Test wird eingesetzt, um Mittelwerte von zwei 
# unterschiedlichen Merkmalen in derselben Gruppe miteinander zu 
# verglichen (z. B. bei Messwiederholung)

t.test(dat$stflife, dat$stf_idx2, paired =T, alternative= "greater")

psych::describe(dat$stflife)
psych::describe(dat$stf_idx2)
# Die Versuchspersonen in der Stichprobe waren signifikant 
# zufriedener mit ihrem Leben (M = 7.42, SD = 2.02) als mit ihren 
# Lebensumstaenden (M = 5.66, SD = 1.9), t(3033) = 45.79, p < .001. 
# Damit hat sich der H1 postulierte Unterschied bew?hrt.

