########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe III Datenaufbereitung - Loesungen 
## 08.03.2022


# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

# Fuer die optionale Aufgabe
if(!require("car")){install.packages("car")}
library(car)

# Aufgabe 1
# Lest die Datei ESS7DE.csv ein und ladet die Variablenübersicht 
# (ess7de_var_list) aus ILIAS herunter
dat <- read.csv("ESS7DE.csv", header=T, sep=";")

# a) Versuchsperson Nr. 184 hat bei der Variable Vertrauen in das 
#    Parlament (trstprl) die Ausweichoption (88) gewählt. 
#    Ersetzt diesen Wert mit NA
dat[184,]$trstprl <- NA
dat[184,"trstprl"] <- NA
dat$trstprl[184] <- NA # viele Moeglichkeiten


# b) Ersetzt die fehlenden Werte (siehe Variablenübersicht) der 
# Variable Alter (agea). 

# Aus der Variablenuebersicht geht hervor, dass der 999 gewaehlt wurde, 
# um fehlende Wert zu kennzeichnen.

# Verteilung kann zunaechst mit einer Tabelle betrachtet werden
table(dat$agea) # Der Wert 999 kommt 13 mal vor
dat[dat$agea==999,]$agea <- NA
table(dat$agea, useNA ="always") # 13 Werte wurden als NA gekennzeichnet

## Alternativ kann ifelse verwendet werden
dat <- read.csv("ESS7DE.csv", header = T, sep =";") 
# Der Datensatz muss neu eingelesen werden damit die Funktion funktioniert
table(dat$agea)
dat$agea <- ifelse(dat$agea == 999, NA, dat$agea)
table(dat$agea, useNA ="always")
table(dat$agea) # ohne useNA werden fehlende Werte nicht angegeben

# Aufgabe 2
# Lest die Datei ESS7DE.sav ein
dat2 <- read_sav("ESS7DE.sav")

# A Die Daten wurden im Jahr 2015 erhoben. Berechnet das Alter (agea) 
#   der befragten Personen im Jahr 2022 in einer neuen Variable.
dat2$ageaToday <- dat2$agea + 7

# Kann ueberprueft werden, indem man sich die neuen Variablen anzeigen laesst.
head(dat2[c("agea","ageaToday")])# Transformation war erfolgreich

# b) Berechnet eine neue Variable aus dem täglichen Zigarettenkonsum 
#    (cgtsday) der Versuchspersonen, die den Konsum in Packungen 
#    angibt. Geht von einer Packungsgröße von 20 Zigaretten aus.
dat2$cgtsday_pck <- dat2$cgtsday/20

# Kann ebenfalls durch gegenueberstellung der beiden Variablen geprueft 
# werden (Alledings muessen erst Zeilen gefunden werden, die nicht NA sind)
dat2[10:20,c("cgtsday","cgtsday_pck")]


# c) Codiert die Bildungsvariable (eduade1) so um, dass zwei Gruppen
#    entstehen: Befragte mit und ohne Abitur. Wie viele der Befragten
#    fallen in die beiden Gruppen? (Mit Antwortsatz)
print_labels(dat2$eduade1) 
# Personen, bei denen eduade1 == 5 ist haben Abitur.
# (Hoehere Bildungsabschuluesse sind nicht enthalten und muessen
# daher auch nicht beruecksichtigt werden)

dat2$abitur <- ifelse(dat2$eduade1 == 5, T, F)
# Es ist auch moeglich andere Bezeichnungen zu waehle 
# (z. B. "Abitur", "kein Abitur")

table(dat2$abitur)
# In der Stichprobe befinden sich 2167 Personen ohne Abitur und
# 864 Personen mit Abitur.

# Aufgabe 3 Unterteilung des Datensatzes in kleinere Subsets
# a) Erstellt ein Subset des Datensatzes, ohne die ersten vier Spalten.
newDat <- dat2[,-1:-4]

# (Oft wurde mit newDat <- dat2[,-4] nur die vierte Zeile entfernt)
# (Das ist leider nicht ganz richtig)

# b) Erstellt ein Subset des Datensatzes, das nur Abiturien:innen
#    enthaelt.

newDat2 <- subset(dat2, dat2$eduade1 == 5)
# Alternativ kann die Variable aus 2c verwendet werden
newDat3 <- subset(dat2, dat2$abitur == T) 
# Es ist wichtig, dass ihr das von euch gewaehlte Label der Auspraegung
# verwendet (in dem Fall T/ F)

# Ohne subset muessen die fehlenden Werte separat entfernt 
# werden
newDat4 <- dat2[dat2$eduade1==5,] # NA im Datensatz enthalten
newDat5 <- dat2[dat2$eduade1==5 & !is.na(dat2$eduade1),] # NA werden entfernt

# Optional: 
# Dreht die Skalierung der Variable stfgov (Zufriedenheit mit der 
# Regierung um). Wie ist die Skalierung der neuen Variable und wie 
# koennte das Konstrukt , das diese erfasst, benannt werden?
print_labels(dat2$stfgov)

dat2$stfgov_rev <- car::recode(dat2$stfgov, 
                          "0=10; 1=9; 2=8; 3=7; 4=6; 5=5; 6=4; 7=3; 8=2; 9=1; 10=0")

# Ueberpruefung mit table() moeglich
table(dat2$stfgov)
table(dat2$stfgov_rev)

# Die neue Variable misst ein Konstrukt, das Unzufriedenheit
# mit der Regierung genannt werden koennte. Es wird mit einer Skale von
# 0 = extrem zufrieden bis 10 = extrem unzufrieden erfasst.