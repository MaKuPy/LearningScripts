########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe II Basics und Datenimport - Loesungen 
## 01.03.2022


# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)


# Aufgabe 1
# Lest die Dateien ESS7DE.csv und ESS7DE.sav (unter zwei unterschiedlichen 
# Objektnamen) ein. Die Dateien findet Ihr auf ILIAS (zuerst im Arbeitsverzeichnis abspeichern)
dat <- read.csv("ESS7DE.csv", sep=";", header=T)
dat2 <- read_sav("ESS7DE.sav")


# a) Ueberprueft den Import der beiden Datensaetze und beschreibt kurz, 
#    was Euch dabei auffaellt (Antwortsaetze)


# A) ESS7DE.csv (dat) und des ESS7DE.sav (dat2) Datensatzes
# a) Anzahl der Variablen und Faelle
dim(dat)
dim(dat2)
# Der csv.Datensatz enthaelt 3045 Faelle und 43 Variablen.
# Der sav. Datensatz hat 4 Variablen mehr.

# b) Betrachten der Faelle
View(dat) # Datei enthaelt auffaellig hohe Werte
head(dat, 10) # z. B. 666 bei der Variable cgtsday (=Zigarettenkonsum pro Tag)
tail(dat, 10)

View(dat2) # Fehlende Werte sind als NA hinterlegt
head(dat2, 10) # Output ist verkleinert
tail(dat2, 10)


# c) Ueberblick ueber Kennwerte
summary(dat)
# Fuer manche kategorielle Variablen (z. B. eduade1 = Bildungsstand) wird 
# ein Mittelwert ausgegeben. Dieser kann nicht sinnvoll interpretiert werden.

# Ausserdem werden einige Kennwerte durch die fehlende Kennzeichnung
# von fehlenden Werten verzerrt (z.B. 666 oder 888 bei cgtsday, eine Variable,
# die den durchschnittlichen Zigarettenkonsum pro Tag erfasst).
# Deswegen liegt der Mittelwert des taeglichen Zigarettenkonsums bei 498, was 
# nicht logisch ist.

summary(dat2)
# Fuer manche kategorielle Variablen (z. B. eduade1 = Bildungsstand) wird 
# weiterhin ein Mittelwert ausgegeben, der nicht sinnvoll interpretiert werden
# kann.

# Allerdings sind die fehlenden Werte richtig gekennzeichnet und verzerren 
# die Angaben nicht mehr (z. B. Mittelwert des taeglichen Zigarettenkonsums bei 13.25)


# b) Was ist der hoechste und was ist der niedrigste Wert, den die Variable trstprl
#    annehmen kann? Was besagen die Variable und ihre Werte? (Antwortsaetze)
#    (Verwendet dafuer die Funktion print_labels())
print_labels(dat2$trstprl)

# Die Variabl eerfasst das Vertrauen in das Parlament des eigenen Landes. 
# (Die dafuer benoetigten Informationen findet Ihr in der Variablenuebersicht
# oder in der Kopfzeile des Datensatzes mit View(dat2))

# Sie kann Werte zwischen 0 (niedrigster Wert) und 10 (hoechster Wert) annehmen.
# 0 entspricht ueberhaupt keinem Vertrauen und 10 vollkommenem Vertrauen.

View(dat2)

# Aufgabe 2
# Waehlt im .sav-Datensatz, die geeigneten Zellen aus, um die 
# folgenden Fragen zu beantworten (Antwortsaetze)


# a) Wie alt (agea) ist Versuchsperson Nr. 7?
dat2$agea[7]

# Versuchsperson Nr. 7 ist 63 Jahre alt.


# b) Welcher Wert befindet sich in Zeile 1308, Spalte 17? Was sagt dieser aus?

# Wenn Ihr sie sav-Datei verwendet:
dat2[1308,17]
print_labels(dat2$stflife)
# Der Wert 9 befindet sich in Zeile 1308, Spalte 17 und entspricht dem zweit-
# hoechsten Wert fuer die Variable Lebenszufriedenheit (stflife). Es handelt sich
# bei dem Fall also um eine Person, die sehr mit ihrem Leben zufrieden ist.

# Wenn ihr die csv-Datei funktioniert print_labels nicht. 


# c) Vergleicht das Alter (agea) der Versuchspersonen 10-20. Welche 
# Person ist am ?ltesten und wie alt ist diese Person? 
dat2$agea[10:20]
dat2[10:20, "agea"] # Alternative

# Person Nr. 15 ist die mit 75 Jahren die aelteste Person.

# d) Wer raucht mehr pro Tag (cgtsday), Person Nr. 134 oder Person 
#    Nr. 1005?
dat2[c(134,1005),"cgtsday"]
# Person Nr. 134 raucht mehr als Person Nr. 1005 

# (Optional: ?berpr?ft die Frage mit einer einzelnen Zeile Code, ohne Euch die      Werte f?r Personen 134 und 1005 anzuschauen)
dat2$cgtsday[134] > dat2$cgtsday[1005]


# d) Wie viele Personen schauen mehr als 3 Stunden fern (tvtot)
# (Tipp: Schaut Euch zunaechst die Skalierung der Variable an. Wenn ihr die 
#  richtigen Faelle ausgewaehlt habt, verwendet dim() oder nrow(), um sie Anzahl der 
#  Faelle zu bestimmen)

print_labels(dat2$tvtot) # Wert 7 entspricht der Auspraegung "mehr als 3 Stunden"

dim(dat2[dat2$tvtot==7,])
# 378 Personen schauen mehr als 3 Stunden fern.

# Optional: e) Wie viele 82-jaehrige Personen schauen mehr als 3 Stunden fern?

# Mit der sav Datei ist das etwas komplizierter
dim(dat2[dat2$tvtot == 7 & dat2$agea == 82 & !is.na(dat2$agea),])

# 6 Personen sind 82 Jahre alt und mehr als 3 Stunden pro Tag fern
