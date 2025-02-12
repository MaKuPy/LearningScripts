########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe VI Grundlagen der Inferenzstatistik - Loesungen 
## 05.04.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("psych")){install.packages("psych")}
library(psych)

if(!require("lsr")){install.packages("lsr")}
library(lsr)

# Aufgabe 1 
# Lest die Datei ESS7DE.sav ein:
dat <- read_sav("ESS7DE.sav")

# A) Beurteilt die Guete der Schaetzung des Mittelwertes anhand des 
# Standardfehlers fuer die folgenden Variablen:
# - Befragungsdauer (Variable `inwtm`)
# - politische Selbsteinschaetzung auf der Links-Rechts-Achse (Variable `lrscale`)
# - Koerpergewicht (Variable `weight`)

names(dat)
describe(dat$inwtm)
describe(dat$lrscale)
describe(dat$weight)


# Der Standardfehler des Mittelwerts ist bei allen drei Variablen sehr niedrig 
# (inwtm: SE = 0,43; lrscale: SE = 0,04; weight: SE = 0,30). Dies duerfte vor 
# allem daran liegen, dass die Fallzahl der Stichprobe sehr hoch ist. Dies 
# minimiert die Fehlerwahrscheinlichkeit jeglicher Schaetzung.

# B) (Wie) Ließe sich die Guete der Schaetzung erhoehen? (Nur Antwortsatz)

# Grundsaetzlich laesst sich die Guete der Schaetzung erhoehen, wenn a) eine andere 
# Form der Operationalisierung fuer ein Konstrukt gewaehlt wird, welche zu einer 
# niedrigeren Varianz fuehrt, oder b) die Stichprobengroeße erhoeht. Bei dem 
# geringen ausgewiesenen Standradfehler des Mittelwerts erschient dies aber nicht
# unbedingt notwendig.

# C) Berechnet fuer die Interviewdauer (inwtm) ein 95%- sowie ein 
# 99%-Konfidenzintervall. Ueberlegt, welches der beiden Intervalle besser fuer 
# die Schaetzung geeignet ist.
ciMean(as.numeric(dat$inwtm), conf = 0.95, na.rm = TRUE)
ciMean(as.numeric(dat$inwtm), conf = 0.99, na.rm = TRUE)

# Das 99%-Konfidenzintervall (UGKI = 69,50; OGKI = 71,71) ist nur geringfuegig 
# breiter als das 95%-Konfidenzintervall (UGKI = 69,77; OGKI = 71,45). Damit 
# ueberwiegt die noch einmal deutlich erhoehte Sicherheit des 99%-Intervalls 
# gegenueber der groeßeren Ungenauigkeit. Dies liegt erneut an der 
# Stichprobengroeße. Bei einer kleineren Fallzahl wuerden sich die beiden 
# KI-Varianten deutlich staerker unterscheiden. Dann waere das 95%-Intervall 
# vorzuziehen. Die Wahl des Konfidenzintervalls sollte also in Abhaengigkeit 
# von der StichprobengroeÃŸe getroffen werden.


