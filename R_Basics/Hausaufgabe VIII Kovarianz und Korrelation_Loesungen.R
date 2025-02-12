########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe VIII Kovarianz und Korrelation  - Loesungen 
## 03.05.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("Hmisc")){install.packages("Hmisc")}
library(Hmisc)


# Aufgabe 1 
# Lest die Datei ESS7DE.sav ein:
dat <- read_sav("ESS7DE.sav")

# A 
# Wie haengt die politische Einstellung auf der Links-Rechts-Achse
# (lrscale) mit den folgenden Variablen zusammen?
# - Haeufigkeit des Alkoholkonsums (alcfreq)
# - Haeufigkeit des Rauchens (cgtsmke)
# - Gesamtfernsehnutzung (tvtot)
# - Fernsehnutzung zur pol. Information (tvpol)
# - Lebenszufriedenheit (stflife)
# - Gewicht (weight)
# - Alter (agea)

# Schritt 1: Ueberpruefen der Skalenniveaus
print_labels(dat$lrscale) # Quasimetrisch (0=Links; 10=Rechts)
print_labels(dat$alcfreq) # Ordinal, da ungleiche Abstaende
print_labels(dat$cgtsmke) # Ordinal, da ungleiche Abstaende
print_labels(dat$tvtot) # Streng genommen ordinal, gleiche Abstaende mit Auffangkategorie
print_labels(dat$tvpol) # Streng genommen ordinal, gleiche Abstaende mit Auffangkategorie
print_labels(dat$stflife) # Quasimetrisch (0=Extrem unzufrieden; 10=Extrem zufrieden)
print_labels(dat$agea) # Metrisch
print_labels(dat$weight) # Metrisch

# Schritt 2: Erstellen von Korrelationstest bzw. einer Korrelationsmatrix 

# Loesung mit Tests:
# Pearson-Korrelation fuer (quasi-)metrische Variablen
cor.test(dat$stflife, dat$lrscale, use="complete.obs", method="pearson")
cor.test(dat$agea, dat$lrscale, use="complete.obs", method="pearson")
cor.test(dat$weight, dat$lrscale, use="complete.obs", method="pearson")

# Spearman Rangkorrelation fuer (streng genommen) ordinale Variablen
# Berechnung mit cor.test dauert sehr langer
# >> Lieber rcorr() aus Hmisc verwenden
cor.test(dat$alcfreq, dat$lrscale, use="complete.obs", method="spearman")
cor.test(dat$cgtsmke, dat$lrscale, use="complete.obs", method="spearman")
cor.test(dat$tvtot, dat$lrscale, use="complete.obs", method="spearman")
cor.test(dat$tvpol, dat$lrscale, use="complete.obs", method="spearman")

# Alternative Berechnung mit rcorr()
# Fuer (quasi-)metrische Variablen
rcorr(as.matrix(dat[c("lrscale", "stflife", "agea", "weight")]), 
                type ="pearson")

# Fuer ordinale Variablen
rcorr(as.matrix(dat[c("lrscale", "alcfreq", "cgtsmke", "tvtot", "tvpol")]), 
      type ="spearman")
names(dat)
# Schritt 3: Interpretation der Effekte

# Die Variablen Gesamt-Fernsehnutzung (rho = .03; p = .146), 
# Fernsehnutzung zur politischen Information (rho = .02; p = .403), 
# Haeufigkeit des Alkoholkonsums (rho = -.03; p = .064) und Gewicht 
# (r = .034; p = .066) haengen nicht signifikant mit der politischen 
# Einstellung zusammen.

# Eine rechtere politische Einstellung haengt signifikant mit hoeherem 
# Alter (r = .059; p < .001) und haeufigerem Rauchen (rho = .04; 
# p < .05) zusammen. Die Zusammenhaenge sind sehr schwach und 
# spielen daher fuer die politische Selbsteinstufung eine sehr geringe
# Rolle, die nahezu vernachlaessigt werden kann.
# Lediglich bei der Lebenszufriedenheit (r = .11; p < .001) zeigt sich 
# ein schwacher Zusammenhang (r > .1): Rechtere Personen sind zufriedener.

# B
# Begruendet: In welchen Faellen muesst ihr weshalb die Rangkorrelation 
# bzw. die Produkt-Moment Korrelation verwenden? 

# Wenn einer der beiden Variablen, fuer die eine Korrelation berechnet 
# werden soll, ordinal skaliert ist (siehe oben), sollte die Rangkorrelation
# berechnet werden.
# Wenn beide Variablen (quasi-)metrisch sind, kann die Produkt-Moment
# Korrelation verwendet werden.

# Optional: Recherchiert die Funktionsweise des Shapiro-Wilk Tests fuer 
# Normalverteilung. 
# Was besagt die Signifikanz des Tests und wie kann dieser in R 
# angewandt werden? 

# Der Shapiro-wilk Test ist ein strenges Maﬂ, das die Normal-
# verteilung einer Variable ueberprueft. Wenn der Test signifikant
# ist, weichen die Daten signifikant von einer Normalverteilung ab.
# Wenn er nicht signifikant ist, kann eine Normalverteilung 
# angenommen werden.

# Allerdings ist der Test sehr streng und wird besonders bei 
# Datensaetzen mit groﬂer Stichprobenzahl schnell signifikant,
# weshalb dort oft visuelle Methoden zur Ueberpruefung der 
# Normalverteilung oft vorgezogen werden.

# Die Berechnung erfolgt mit der Funktion shapiro.test() aus Base-R
shapiro.test(dat$stflife)

# Die Signifikanz bedeutet, dass die Lebenszufriedenheit signfikant von einer
# Normalverteilung abweicht.
hist(dat$stflife) 
# Dies ist womoeglich auf die Linksschiefe der Verteilung zurueckzufuehren.

# Welche Alternativen gibt es, um zu ueberpruefen, ob eine Variable 
# normalverteilt ist?
  
# Alternativen sind: QQ-Plots, Histogramme mit Normalverteilung, 
# Betrachtung von Schiefe und Kurtosis

