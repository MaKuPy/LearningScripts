##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung VII Kontingenztabelle und Chi-Quadrat - Begleitendes Skript 
## 21.03.2023

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("naniar")){install.packages("naniar")}
library(naniar)

if(!require("lsr")){install.packages("lsr")}
library(lsr)

if(!require("descr")){install.packages("descr")}
library(descr)


# Einlesen der Datensaetze
dat <- read.csv("mediaUsage.csv", header=T, stringsAsFactors = T)
dat <- replace_with_na_all(dat, condition=~.x==-99)
dat[dat$age==222,]$age <- 22
dat[dat$gender=="d",]$gender <- NA

# Erstellen der Variable Intensitaet der Social Media Nutzung
dat$soMedUse <- ifelse(dat$soMedTime > mean(dat$soMedTime, na.rm=T), "High", "Low")


# I Kontingenztabllen
# Erfasst die absoluten bzw. relativen Haeufigkeiten aller moeglicher
# Merkmalskombinationen zweier Variablen 

# a) Einfachste Form der Kontingenztabelle
table(dat$student, dat$soMedUse)
# Enthaelt nur absolute Haeufigkeiten

# b) Randverteilungen ergaenzen
addmargins(table(dat$student, dat$soMedUse))

# c) Komplexere Kotingenztabelle
CrossTable(dat$student, dat$soMedUse)
# Enthaelt absolute, relative und bedingte Haeufigkeiten sowie die 
# Randverteilung


# II Chi-Quadrat-Test
# Bivariates Zusammenhangsma? fuer zwei kategorielle Variable fuer 
# unabhaengige Stichproben. Dabei werden die beobachteten Haeufigkeiten der 
# Merkmalskombinationen mit den Haeufigkeiten, die man erwarten wuerde, 
# wenn kein Zusammenhang bestuende, in Bezug gesetzt und die Abweichung 
# bestimmt.

CrossTable(dat$student, dat$soMedUse, expected=T, chisq = T, 
           sresid=T , prop.c = F, prop.r = F)

# Die Erwarteten Haeufigkeiten sind alle > 5, womit die Voraussetzungen
# fuer den Chi-Quadrat-Test erfuellt sind.

# H0 kann abgelehnt und damit angenommen werden, dass der 
# Schueler:innenstatus mit der Intensitaet der Social Media Nutzung 
# zusammenhaengt Chi²(1) = 140, p <  .001.

# Mithilfe der standardisierten Residuen kann der Effekt verortert werden:
# Beispielweise liegt die beobachtete Haeufigkeit von Nicht-Schueler:innen 
# mit hohen social Medianutzung signifikant unter dem Erwartungswert

# Cramers V als Mass der Effektgroe?e
cramersV(table(dat$student, dat$soMedUse), correct = F)

# Mit dem Cramers V kann der Einfluss von anderen Faktoren auf die 
# Intensitaet der Social Media Nutzung mit dem Schueler:innenstatus 
# vergleichen werden

