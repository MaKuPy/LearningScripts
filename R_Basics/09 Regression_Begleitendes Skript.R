##########################################################
## Uebung: Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung IX Regression - Begleitendes Skript 
## 02.05.2024

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("lm.beta")){install.packages("lm.beta")}
library(lm.beta)


# Einlesen de Datensatzes
dat <- read_sav("ESS7DE.sav")

# I Einfache lineare Regression
# Die einfache lineare Regression versucht den Einfluss einer metrischen
# oder dichotomen UV uf eine metrische AV mithilfe einer Schaetzgeraden 
# vorherzusagen 

# Allgemeine Form der Geraden:
# yi = a + b1*x1i + ei

# A Beispiel: lineare Regression
# H1: Das Vertrauen in Politiker:innen hat einen positiven Einfluss auf 
# die Zufriedenheit mit der Demokratie des Landes

m1 <- lm(stfdem ~ trstplt, dat) # Erstellt das Modell
m1_beta <- lm.beta(m1) # Ergaenzt std. Regressionskoeffizienten
summary(m1_beta) # Gibt die Ergebnisse aus

# Die Analyse des Zusammenhangs mit einer einfachen linearen Regression, 
# offenbart einen signifikanten positiven Einfluss von Vertrauen in 
# Politiker:innen auf Demokratiezufriedenheit, β = .571, p < .001. 
# Ein Anstieg von Vertrauen in Politiker:innen um 1 korrespondiert in 
# der Stichprobe mit einem Anstieg in Demokratiezufriedenheit um 0.619. 
# Damit hat sich H1 der statistischen Prufung bewaehrt und kann angenommen
# werden.

 
# Beispiel mit Dichotomen UVs
# Dichotome UVs (0, 1) koennen einfach in die Regression mitaufgenommenen
# werden:
print_labels(dat$gndr) # 1 = Male, 2 = Female
# Der Regressionkoeffizient vergleicht die Auspraegung mit der niedrigeren
# Zahl mit der Auspraegung mit der hoeheren Zahl.
# b stellt den Unterschied zwischen den Mittelwerten der AV von weiblichen
# und maennlichen Versuchspersonen dar.

m1 <- lm(stfdem ~ as.factor(gndr), dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)
# Geschlecht hat einen signifikanten Einfluss auf die Demokratiezufriedenheit,
# beta =  -.036, p < .05. Bei weiblichen Versuchspersonen wird im Vergleich 
# zu maennlichen eine um 0.17 geringere Demokratiezufriedenheit prognostiziert.


# II Multiple Regression
# Die multiple lineare Regression untersucht den Einfluss mehrerer 
# UVs auf eine AV. Daher wird die Regressionsgleichung um die 
# Effekte der anderen Variablen ergaenzt.

# Allgemeine Form der Gerade:
# yi = a + b1*x1i + b2*x2i ... + bnXni + ei

# - Die Interpretation der Ergebnisse funktioniert genauso wie bei der 
#   einfachen linearen Regression. 
# - b repraesentieren die Veraenderung der AV bei einem Anstieg der 
#   UV um 1, waehrend die uebrigen Variablen des Modells konstant gehalten werden
# - Haupteffekte sollten stets ausfuehrlich interpretiert werden. 
#   Signifikante Effekte der Kontrollvariablen sollten genannt werden.

# Beispiel: 
# H1: Vertrauen in Politiker:innen erhoeht die Demokratiezufriedenheit
# H2: Eine hoehere allg. Lebenszufriedenheit fuehrt zu mehr Demokratiezufriedenheit
# Kontrollvariablen: Geschlecht, Alter, politische Orientierung 

m1 <- lm(stfdem ~ trstplt + stflife+ gndr + agea + lrscale, dat)
# Da der R-Standard eine hierarchische Regression ist, ist die 
# Reihenfolge, in der der Variablen in das Modell gegeben werden 
# entscheidend. 
# Die maximale Varianz wird der Reihe nach extrahiert (Haupteffekte 
# sollten zuerst benannt werden dann Kontrollvariablen)

m1_beta <- lm.beta(m1)
summary(m1_beta)

# Interpretation:
# H2: Lebenszufriedenheit hat einen signifikanten positiven Einfluss
# auf die Zufriedenheit mit der Demokratie, beta = 0.17, p < .001. In der
# Stichprobe wird bei einem Anstieg der Lebenszufriedenheit um eins, 
# ein Anstieg der Demokratiezufriedenheit um 0.195 prognostiziert. 
# Damit kann H2 angenommen werden. 
# Von den aufgenommenen Kontrollvariablen weist lediglich die 
# politische Orientierung einen signifikanten Effekt auf, beta = 0.05, 
# p < .001. 

# Modell: Fuer die Interpretation des Modells sollte adjusted R? 
# verwendet werden

# Das Modell erklaert 35.26 % der Varianz der Demokratiezufriedenheit


