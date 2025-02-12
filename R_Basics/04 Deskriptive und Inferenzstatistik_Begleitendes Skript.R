##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung IV Deskriptive und Inferenzstatistik - Begleitendes Skript 
## 14.03.2024

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
# setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("psych")){install.packages("psych")}
library(psych)

if(!require("questionr")){install.packages("questionr")}
library(questionr)

if(!require("naniar")){install.packages("naniar")}
library(naniar)

if(!require("lsr")){install.packages("lsr")}
library(lsr)


# I Haeufigkeiten 
dat <- read.csv("mediaUsage.csv", stringsAsFactors=T, header=T)
dat[dat$age==222,]$age<-22 # falschen Wert ersetzen
dat <- replace_with_na_all(dat, ~.x==-99) # fehlende Werte ersetzen

# Einfache Auszaehlung am Beispiel der Variable prefMed
table(dat$prefMed)
prop.table(table(dat$prefMed))  
round(prop.table(table(dat$prefMed)),3) # Koennte auch mit round gerundet werden
# Erstellt eine Haeufigkeitstabelle fuer die Variable praeferiertes
# Medium. z. B. gaben 11 Personen (15.71%) an, Facebook als SN zu bevorzugen.


# Fortgeschrittenere und uebersichtlichere Variante mit frequency
# Zuerst das Paket aktivieren und installieren (siehe oben)

questionr::freq(dat$prefMed) 
# Die Haeufigkeitstabelle oeffnet sich in einem neuen Fenster


# Kontingenztabellen (auch: Kreuztabellen genannt)
# Erfassen die absoluten bzw. relativen Haeufigkeiten aller moeglichen
# Merkmalskombinationen zweier Variablen

table(dat$student, dat$prefMed)
# Erstellt eine einfache Kreuztabelle, die absoluten Haeufigkeiten der 
# Merkmalskombinationen von var1 und var2 enthaelt



# Fuer diskrete Variablen mit vielen Kategorien oder kontinuierliche
# Variablen koennen solche Tabellen jedoch trotzdem schnell 
# unuebersichtlich werden.

questionr::freq(dat$soMedTime) # z. B. Dauer der social Media Nutzung 

# Dann ist es besser, auf andere statistische Methoden umzusteigen.


# II Ma?e der zentralen Tendenz

# a) Modus
table(dat$prefMed)
# Das beliebste soziale Netzwerk in der Stichprobe ist Instagram,
# welche von 25 Personen angebenen wurde. Instagram ist der Modus
# der Variable praeferiertes SN.

# b) Median
median(dat$soMedTime, na.rm=T) 
# Der Median der Variable social Media Nutzung liegt bei 116 Minuten
# D.h. 50% des Datensatzes nutzen SN ca. 2 Stunden oder mehr
# taeglich.



# c) Mittelwert
mean(dat$soMedTime, na.rm=T)
# Der Mittelwert der Variable social Media Nutzung liegt bei 148.81

mean(dat$age) # 25.5 
# Bei Alter muss na.rm=T nicht gesetzt werden, da keine fehlenden 
# Werte enthalten sind
sd(dat$age) # Die Standardabweichung des Alters betraegt 6.52


# III Dispersionsma?e
# a) Spannweite
range(dat$soMedTime, na.rm=T)
# Die Spannweite der sozialen Mediennutzung im Datensatz betraegt
# zwischen 22 und 517 Minuten taeglich

# b) Quartile
summary(dat$soMedTime)

# c) Varianz und Streuung
sd(dat$soMedTime, na.rm=T)^2
# Die Varianz der SN-Nutzung btraegt 10869.35

sd(dat$soMedTime, na.rm=T) 
# Die Standardabweichung der SN-Nutzung btraegt 104.26


# IV Deskriptive Statistik in R
# Obwohl es moeglich ist, die genannten Kennwerte fuer eine 
# Variable einzeln zu berechnen, gibt es i n R einige 
# praktische Funktionen, die eine Uebersicht ausgeben

# a) summary
summary(dat)
# Gibt eine zusammenfassende Uebersicht ueber den Datensatz mit
# Quartilen und Haeufigkeitsauszaehlungen je nach Variablentyp

# b) describe
# Voher das Paket psych installieren und aktivieren (siehe oben)
psych::describe(dat$age) 


# V Inferenzstatistik

# a) Punktschaetzung
# Berechnung des Standardfehler mithilfe von describe() oder 
# stat.desc()

psych::describe(dat$age)
# Der Standardfehler fuer das Alter im mediaUsage Datensatz betraegt
# SE = 0.78

# b) Intervallschaetzung
ciMean(dat$age)

# Das 95% Konfidenzinterval fuer Alter betraegt
# CI [23.95, 27.05]

# Koennte auch manuell berechnet werden
mean(dat$age)+ 1.96*0.78
mean(dat$age)- 1.96*0.78 
# Kleine Abweichungen kommen durch systeminterne Rundungen zu Stande

