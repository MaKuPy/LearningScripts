########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe V Datenvisualisierung - Loesungen 
## 29.03.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

# Aufgabe 1 
# Lest die Datei ESS7DE.sav ein:
dat <- read_sav("ESS7DE.sav")

# A) Erstellt eine geeignete Visualisierung fuer die politische Fernsehnutzung 
# (tvpol) mitsamt relevanter Beschriftungen (Titel, Achsenbeschriftung etc.).
# Begruendet Eure Entscheidung und beschreibt die Darstellung in eigenen 
# Worten. 
print_labels(dat$tvpol) 
# Die Variable wurde ordinal erfasst und enthaelt Werte von
# 1 = No time at all bis 7 = more than 3 hours.

# Des es sich um eine ordinale Variable relativ vielen Kategorien handelt,
# ist ein Boxplot fuer die Visualisierung am besten geeignet.
boxplot(dat$tvpol, ylab="Politische Fernsehnutzung", 
        main="Boxplot zur politischen Fernsehnutzung",
        col="Royalblue")

# Der Boxplot zeigt, dass ein Großteil der Versuchspersonen sich im 
# unteren Bereich der Skala zugeornet hat. Der Median liegt bei 2
# = 0,5 hour to 1 hour und faellt mit dem dritten Quartil zusammen.
# Das heißt 75 Prozent der Versuchspersonen der Stichprobe schauen 
# taeglich durchschnittlich bis zu eine Stunde fern. Werte ueber 3
# werden im Boxplot als Ausreißer markiert und erscheinen als Punkte.
# Alle Werte sind jedoch vertreten.

# Es waere auch moeglich ein Balkendiagramm zu erstellen
# (boxplot ist bei relativen vielen Auspraegungen der Variable
# allerdings vorzuziehen):
barplot(table(dat$tvpol), ylab="Absolute Hauefigkeiten", 
        xlab="Politische Fernsehnutzung",
        main="Boxplot zur politischen Fernsehnutzung",
        col="Royalblue")

# B) Erstellt eine geeignete Visualisierung fuer die Lebenszufriedenheit der 
# Versuchspersonen (stflife) mitsamt relevanter Beschriftungen (Titel, 
# Achsenbeschriftung etc.). Begruendet Eure Entscheidung und beschreibt die 
# Verteilung in eigenen Worten. 
print_labels(dat$stflife)

# Da es sich bei Lebenszufriedenheit um eine (quasi)metrische Variable handelt,
# sollte ein Histogramm oder ein Boxplot erstellt werden

hist(dat$stflife, 
main="Lebenszufriedenheit in der Stichprobe", 
xlab="Lebenszufredenheit 
[0=extrem unzufrieden; 10=extrem zufrieden]", 
ylab="Haeufigkeiten", ylim=c(0,1000),col="Royalblue", breaks =11) 

# Aus der Abbildung geht hervor, dass die Verteilung fuer Lebenszufriedenheit
# linksschief und rechtssteil ist. Das heißt großer Teil der Versuchspersonen
# ordnet sich am oberen Ende der Skala ein. In der Stichprobe sind die meisten
# Versuchspersonen also eher zufrieden. Der Hoehepunkt der Verteilung liegt 
# bei 8.


# C) Visualisiert den Zusammenhang von Geschlecht (gndr) und Vertrauen in 
# die Polizei (trstplct). Schaetzt auf Basis der Darstellung ein, ob es 
# signifikante Geschlechtsunterschiede fuer das Vertrauen in die Polizei 
# gibt (mit Begruendung).

# Fuer den Zusammenhang zwischen einer nominalen und einer (quasi)metrischen 
# Variable sind Boxplots am besten geeignet.

boxplot(dat$trstplc~dat$gndr, names=c("Maennlich", "Weiblich"),
        ylab="Vertrauen in die Polizei",
        xlab="Geschlecht [binaer]",
        main="Zusammenhang von Geschlecht und 
      Vertrauen in die Polizei", col="Royalblue")

# Da die Boxplots nahezu identisch sind kann vermutet werden, dass ein Zusammenhang
# zwischen dem Geschlecht der Versuchspersonen und dem Vertrauen in die 
# Polizei besteht.

# D) Visualisiert den Einfluss der Zufriedenheit mit der eigenen Regierung 
# (stfgov) auf die Zufriedenheit mit der Demokratie (stfdem). Schaetzt den 
# Zusammenhang auf Basis der Visualisierung ein: Besteht ein positiver oder
# negativer Einfluss? Kann ein signifikanter Effekt erwartet werden oder
# nicht? (mit Begruendung). 

# Fuer die Visualisierung des Zusammenhangs zweier (quasi)metrischer Variablen
# ist ein Scatterplot am besten geeignet
plot(jitter(dat$stfdem)~jitter(dat$stfgov),
     ylab="Vertrauen in die Demokratie",
     xlab="Vertrauen in die Regierung",
     main="Einfluss des Vertrauens in die Regierung auf 
     das Vertrauen in die Demokratie")

# Es ist erkennbar, dass sich ein Großteil der Datenpunkte in einer Geraden
# mit einem Aufwaertstrend anordnen. Damit kann ein positiver Zusammenhang
# zwischen dem Vertrauen in die Regierung und dem Vertrauen in die Demokratie 
# vermutet werden.


# Ohne jitter() ließe sich der Zusammenhang nicht richtig einschaetzen.
plot(dat$stfdem~dat$stfgov,
     ylab="Vertrauen in die Demokratie",
     xlab="Vertrauen in die Regierung",
     main="Einfluss des Vertrauens in die Regierung auf 
     das Vertrauen in die Demokratie")
# Deswegen sollte jitter immer bei diskrete Variablen (mit einer begrenzten
# Anzahl an Skalenpunkten) verwendet werden. Fuer kontinuierliche Variablen
# (z.B. Alter waere das nicht noetig).

# Optional: Ergaenzt die Darstellung aus D um eine Regressionsgerade. Stimmt 
# diese mit Euren Vorueberlegungen zu dem Zusammenhang ueberein?
plot(jitter(dat$stfdem)~jitter(dat$stfgov),
     ylab="Vertrauen in die Demokratie",
     xlab="Vertrauen in die Regierung",
     main="Einfluss des Vertrauns in die Regierung auf 
     das Vertrauen in die Demokratie")
abline(lm(dat$stfdem~dat$stfgov), col="Blue")
