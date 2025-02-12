##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung III Datenaufbereitung - Begleitendes Skript 
## 07.03.2024

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
# setwd()
getwd()

## Verwendete Pakete
if(!require("naniar")){install.packages("naniar")}
library(naniar)

if(!require("dplyr")){install.packages("dplyr")}
library(dplyr)

if(!require("car")){install.packages("car")}
library(car)

# Einlesen des Skript-Datensatzes
dat <- read.csv("mediaUsage.csv", stringsAsFactor=T, header=T)

# I Datenaufbereitung

# A) Fehlende Werte
# In R muessen alle fehlenden Werte mit NA beschriftet sein.

# Fehlende Werte sind in der Regel in der Variablenuebersicht aufgefuehrt. 
# In R kann ueberprueft werden, ob diese bereits mit NA gekennzeichnet 
# wurden oder noch als Zahlenwerte (z.B. -99) vorliegen.

# Oft reicht es bereits aus mit View() einen Blick in den 
# Datensatz zu werfen
View(dat) # -99 in soMedTime und tvTime enthalten

summary(dat) # Oft einfacher, fehlende Werte im Max oder Min zu erkennen
table(dat$soMedTime) # Detailbetrachtung einer einzelnen Variable
table(dat$tvTime)

# Fehlende Werte kennzeichnen

# Moeglichkeit 1: Einen fehlenden Wert (z. B. -99) fur alle 
# Variablen im Datensatz mit NA kennzeichnen

# naniar installisieren und aktivieren (siehe oben)

newDat <- replace_with_na_all(dat, condition = ~.x==-99)
table(newDat$soMedTime, useNA="always")
# Fehlende Werte (-99) wurden mit NA ersetzt


# Moeglichkeit 2: Einen fehlende Wert (z. B. -99) fuer bestimmte 
# Variablen mit NA ersetzen

# Da beim Kennzeichnen der fehlenden Werte oben ein neues Objekt (newDat)
# erstellt wurde, sind die fehlende Werte in dem Original-Datensatz 
# noch nicht gekennzeichnet. 
table(dat$soMedTime) # enthaelt wieder -99
table(dat$tvTime) # enhaelt wieder -99

# Bei der Variable Social Media Nutzung (soMedTime) liegen 
# mehrere Werte (-99) vor, die mit NA gekennzeichnet werden muessen

newDat2 <- replace_with_na_at(dat, .vars=c("soMedTime"), condition = ~.x == -99)

# Kontrolle der Ergebnisse
table(newDat2$soMedTime, useNA="always")
table(newDat2$tvTime, useNA="always")
# fehlende Werte wurden nur f?r soMedTime ersetzt

# Alternative zu naniar: Einen fehlenden Wert (z. B. -99) fuer bestimmte 
# Variablen mit NA ersetzen

# Auswahl der fehlenden Werte und ueberschreiben mit NA
dat[dat$soMedTime == -99,]$soMedTime <- NA
# Ersetzt jede -99 in der Variable soMedTime mit NA
table(dat$soMedTime, useNA="always")# zur ueberpruefung
# Wichtig: diese Form ueberschreibt den Wert direkt im Datensatz


# Zuweisung mithilfe der Funktion ifelse()

# Ersetzen der Werte in tvTime mit ifelse 
dat$tvTime <- ifelse(dat$tvTime==-99, NA, dat$tvTime)
table(dat$tvTime, useNA="always")


# B) Ungueltige Werte
# Fehler bei der Datenerfassung koennen zu ungueltigen Werten im 
# Datensatz fuehren, die die Analyse verzerren und daher korrigiert
# oder entfernt werden sollten.

# Ungueltige Werte finden:
# Datensatz anschauen
View(dat) # falsche Werte etwas schwer zu erkennen

# uebersicht ueber den gesamten Datensatz
summary(dat) 

# Haeufigkeitstabellen
table(dat$age) # gibt eine Haeufigkeitstabelle aus

# Sichtpruefung: Alter von 222 ist unmoeglich. Daher handelt 
# es sich dabei um einen ungueltigen Wert
grep(222, dat$age) # sucht den Wert 222 in Variable age (gibt Zeilenindex zur?ck)

# Schritt 2: Ungueltigen Wert korrigieren oder entfernen
dat[38,"age"] <- 22 # alternative
dat$age[38] <- 22 # alternative


# View(), summary(), table() koennen anschlie?end eigesetzt werden,
# um die Korrektur zu ueberpruefen
View(dat) 
summary(dat) 
table(dat$age)

# Entfernen des Wertes
# Alternativ kann der Datenpunkt entfernt werden, wenn keine
# Korrektur moeglich/ sinnvoll ist

# Datensatz muss neu eingelesen werden, damit die folgende 
# Funktion tatsaechlich etwas veraendert
dat <- read.csv("mediaUsage.csv", stringsAsFactor=T, header=T)

dat[dat$age == 222,]$age <- NA
dat[38,"age"] <- NA 
dat$age[38] <- NA

# View(), summary(), table() koennen anschlie?end eigesetzt werden,
# um die Korrektur zu ueberpruefen
View(dat) 
summary(dat) 
table(dat$age, useNA="always")


# C) Subsets aus dem Datensatz auswaehlen

# Klassische Weise 
# Durch Auswahl von Zeilen und Spalten zu einem neuen Datensatz
# newDat <- dat[Zeile, Spalte]

# Beispiele
newDat <- dat[,-1] 
View(newDat)
# Erstellt einen Datensatz ohne die erste Spalte

newDat <- dat[dat$student==T,]   
View(newDat)
# Erstellt einen Datensatz mit Schuelerinnen/Studierenden

newDat <- dat[c("prefMed","soMedTime")] 
View(newDat)
# Erstellt einen Datensatz mit den gekennzeichneten Variablen

# Wichtig: durch die Auswahl mit logischem Operator in [] werden
#          fehlende Werte nicht automatisch mitentfernt


# Funktion filter() aus dem Paket dplyr
# newDat <- filter(dat, Auswahlkriterium) 
# Erstellt einen Datensatz, der dem Auswahlkriterium entspricht

newDat2 <- filter(dat, dat$student==T)

# Unterschiedliche Auswahlkriterien in subset() werden mit & oder | verbunden
newDat2 <- dilter(dat, dat$student == F & dat$age > mean(dat$age))

# Mit subset() werden fehlende Werte automatisch von der Auswahl ausgeschlossen


# D) Umkodieren von Variablen

# D.1) Neue Variablen berechnen
# dat$varName <- Berechnung

# Wenn varName bereits im Datensatz enthalten ist, wird diese
# Variable ueberschrieben. Wenn nicht, wird eine neue Variable 
# erstellt.

dat$year_birth <- 2023 - dat$age  
# Berechnet das Geburtsjahr der Versuchspersonen

dat$tvTime2 <- dat$tvTime/60
# Rechnet die Zeit der Fernsehnutzung von Minuten in Stunden um  
  
dat$medTime <- rowMeans(dat[c("tvTime", "soMedTime")])
#Berechnet den Mittelwert der Fernseh- und Social Media Nutzung

View(dat) # Die Tabelle enthaelt nun drei weitere Variablen
 
# Neue Variablen koennen mit head() ueberprueft werden
head(dat[c("age","year_birth", "soMedTime", "tvTime","medTime")])


# D.2) Metrische Variablen in kategorielle Umwandeln

# ifelse
dat$soMedUsage <- ifelse(dat$soMedTime >= 120, "high","low")
# In der neuen Variable wird einer Nutzungsdauer von mindestens 2 Stunden die Auspraegung „high“ zugeordnet. Dem Rest wird „low“ zugeordnet.

# Die Gruppengroe?e kann mithilfe von table() ueberprueft werden
table(dat$soMedUsage) 
# 33 Personen haben das Merkmal high und 35 das Merkmal low 

# Wenn gewollt kann der neue Datensatz fuer mediaUsage gespeichert 
# werden:
# write.csv(newDat, "mediaUsage2.csv", row.names=F)

# Die Funktion mutate()
# Erm?glicht das gleichzeitige Erstellen mehrerer Variablen
dat2 <- mutate(dat, 
               year_birth = 2023 - age,
               tvTime2 = tvTime/60,
               tvTime3 = ifelse(tvTime2 > 1, "high", "low"))


# Exkurs: Piping
library(tidyverse) # wird benoetigt
dat <- read.csv("mediaUsage.csv", stringsAsFactor=T, header=T)

# Der Piping-Operator %>%
# Das Ergebnis des Codes vor dem Pipe (%>%) der Funktion hinter dem 
# Pipe als erstes Argument mitgegeben


# Beispiel:
# Ein Subset aus vollj?hrigen Personen wird erstellt, fehlende Werte
# fuer die Fernsehnutzung entfernt und die Fernsehnutzung in Stunden 
# umgerechnet

# Standard (ohne piping)
newDat <-subset(dat, dat$age >= 18)
newDat <- replace_with_na_at(newDat, .vars = c("tvTime"), condition = ~.x ==-99)
newDat <- mutate(newDat, tvTime2= tvTime/60)


# Fortgeschrittene Variante (mit piping)
newDat2 <- dat %>%  subset(dat$age>=18) %>%
  replace_with_na_at(.vars = c("tvTime"), condition = ~.x ==-99) %>%
  mutate(tvTime2= tvTime/60) 	     

  