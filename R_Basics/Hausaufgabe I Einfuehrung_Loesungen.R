########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe I Einfuehrung - Loesungen 
## 22.02.2022

## Aufgabe 1 
## Legt das Arbeitsverzeichnis fest und ueberprueft Euren Erfolg.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Gibt "C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R" 
# in der Konsole zurueck. Damit wurde das Arbeitsverzeichnis 
# erfolgreich festgelegt.


# Aufgabe 2
# Lest die Datei ESS7DE.csv ein (Trennzeichen ist ein ;) , die Ihr 
# auf ILIAS findet (zuerst im richtigen Ordner abspeichern; auf
# Mac nicht öffnen).

dat <- read.csv("ESS7DE.csv", header=T, sep=";", dec=".")
# Wenn das Trennzeichen (sep=";") nicht richtig angegeben wurde,
# wird der Datensatz falsch eingelesen. Das Objekt dat enthaelt 
# dann nur eine Variable.

# Tipp:
list.files() # verweden
# Dateiname fuer den Import kann aus der Liste kopiert werden.
# (vermeidet Fehler bei der Bennenung der Datei in der Funktion
# und zeigt an, ob sich die Zieldatei tatsaechlich im Arbeits-
# verzeichnis befindet)



# Aufgabe 3
# Installiert und aktiviert das Paket haven.
install.packages("haven") 
library(haven)

# Da der Befehl install.packages() das benannte Funktionspaket immer 
# installiert (unabhaengig davon, ob es bereits auf dem Rechner
# installiert ist), kann alternativ die folgende Funktion verwendet
# werden:

if(!require("haven")){install.packages("haven")} 
# !require(), ueberprueft zunaecht, gibt TRUE zurueck, wenn das Paket 
# nicht verfuegbar ist. Mit if wird das Paket daher nur installiert, 
# wenn es nicht bereits installiert wurde.




# Aufgabe 4 
# Erledigt folgende Rechenaufgaben in R. 
# Weist das Ergebnis stets einer sinnvoll benannten Variable zu:

# A) Wie alt werdet ihr, wenn Ihr in dem Jahr 2050 Euren 
#    Geburtstag feiert?

(futureAge <- 2050-1994)
# Die Klammern sorgen dafuer, dass die Loesung sofort mit-
# ausgegeben wird. Sonst muesstet ihr das Objekt futureAge
# einmal seperat ausfuehren, um die Loesung zu erhalten.
futureAge
# Im Jahr 2076 werde ich 82 Jahre alt sein.


# B) Wie viele Stunden pro Woche muesst Ihr in R investieren, 
#    um bis dahin 15.000 Stunden geuebt zu haben? 
#    (Verwendet "volle" Jahre)

(rPerDay <- 15000/(futureAge-28)/365)
# oder
(rPerDayk <- 15000/((futureAge-28)*365))

# Ich muesste jeden Tag 1.46771 Stunden ueben, um bis zu meinem Geburtstag 2050
# 15000 geuebt zu haben.

# C) Nutzt die Funktion round(), um das Ergebnis aus B auf zwei 
#    Kommastellen zu runden. 
#    (Tipp: Verwende ?round, um die Dokumentation aufzurufen)

?round # gibt Euch die Dokumentation aus

# Dokumentation:
# round(x, digits = 0)
#
# digits	    integer indicating the number of decimal 
#             places (round) or significant digits 
#             (signif) to be used. Negative values are 
#             allowed (see Details).

round(rPerDay, 2)

# Die Funktion rundet das Ergebnis auf 1.24.
