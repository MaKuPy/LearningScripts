##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung II Basics und Datenimport - Begleitendes Skript 
## 29.02.2024

if(!require("haven")){install.packages("haven")}
library(haven)


## I Datentypen

# A) Character
# Jede Form von Text (Namen, Worte, Saetze, Absaetze etc.)
# Wird in R mit " ... "  gekennzeichnet

string <- "Das ist ein Text"
class(string) # ueberprueft die Klasse des Objektes


# Mathematische Operationen sind nicht moeglich
string*2 # gibt einen Error zurueck


# B) Numeric
# Jede Form von Zahlen (1, 3.5, 1e-10 etc.)

number <- 13.5 
(number2 <- 12e-5) # e-5 verschiebt das Komma um 5 Stellen nach links
class(number)

# Mathematische Operationen koennen angewendet werden
number*2


# C) Logicals
# Dichotome Erfassung einer Variable mit FALSE (0) oder TRUE (1)

boolean <- TRUE 
boolean <- T # macht das Gleiche
class(boolean)

# Mathematische Operationen sind tendenziell moeglich, aber nicht 
# immer sinnvoll. FALSE wird der Wert 0 und TRUE der Wert 1 zugeordnet
boolean + 1 # Ergibt bspw. 2

# Logische Operatoren
# > groeßer als; >= groeßer gleich; < kleiner als; <= kleiner gleich
# != ungleich; == gleich       
10 < 13  

number > 13 # Funktioniert auch mit Variablen
boolean == TRUE 
string != "Das ist ein Text" # und unterschiedlichen Variablentypen

# Kombination von logischen Aussagen
# & (und)   Um TRUE zu erhalten muessen beide Aussagen wahr sein
# | (oder)	Um TRUE zu erhalten muss eine der Aussagen wahr sein

number > 13 & number == 13.5 # Beide Aussagen wahr
number < 13 & number == 13.5 # Eine Aussagen wahr
number < 13 | number == 13.5 # Eine Aussagen wahr


# II Koplexere Datentypen

# A) Vektoren
# Listen von gleichartigen Elementen
vector <- c(1, 2, 3, 4)
# Alternativ: vector <- 1:4 
# Erstellt einen Vektor mit den Zahlen von 1 bis 4 
is.vector(vector) # ueberprueft, ob die erstellte Variable ein Vektor ist

# Vektoren koennen auch characters oder logicals beinhalten
vector2 <- c("Hund", "Katze", "Maus")
vector3 <-c(T, F, F, F)

# Auswahl von Vektorelementen
# Vektoren in R sind indexiert, d.h. jedem Element des Vektors wird 
# eine Nummer zugeordnet (beginnend mit 1 fuer das erste Element), ), die es 
# erlaubt die Elemente des Vektors mit [Index] auszuwaehlen

vector2[2] # waehlt das zweite Element von vector2 aus („Katze“)
vector[1:3] # waehlt das erste bis dritte Element von vector aus (1, 2, 3)
vector[c(1, 3, 2)] # waehlt Elemente in der angegebenen Reihenfolge aus (1, 3, 2)


# B) Faktoren
# Kategorische Variable mit einer limitierten Anzahl an Auspraegungen

# Ungeordnete Faktoren
factor <- factor(c("green", "blue", "green", "green"), ordered=F)

# Geordnete Faktoren
factor2 <- factor(c("high", "low", "low", "high"), levels=c("low","high"), ordered=T)

class(factor)

# C) Dataframes und tibbles
# Zweidimensionales Datenobjekt (Zeilen = Faelle, Spalten = Variablen),
# das unterschiedliche Datentypen aufnehmen kann


## II Datenimport
# Datensaetze muessen zunaechst eingelesen werden

# A1) Einlesen von csv-formatierten Dateien

# Um den folgenden Code auszufuehren, muesst Ihr diesen von ILIAS 
# downloaden als csv-Datei in Eurem Arbeitsverzeichnis ablegen. 
# (Datei vorher nicht oeffnen, da die Formatierung von Excel oder 
# Numbers zu Problemen beim Import fuehrt)

dat <- read.csv("mediaUsage.csv", header=T, stringsAsFactors=T)
class(dat) # Gibt den Datentyp des Objektes an

### Bei Problemen folgenden Anweisungen befolgen:
list.files() # verweden
# Dateiname fuer den Import kann aus der Liste kopiert werden.
# (vermeidet Fehler bei der Bennenung der Datei in der Funktion
# und zeigt an, ob sich die Zieldatei tatsaechlich im Arbeits-
# verzeichnis befindet)

# Wenn sich die Datei nicht im Arbeitsverzeichnis befindet muss 
# diese dort hinzugefuegt werden oder ggf. das Arbeitsverzeichnis
# angepasst werden.
getwd() # Gibt Euer aktuelles Arbeitsverzeichnis aus

# Zur Anpassung des Arbeitsverzeichnisses waehlt
# Session > Set Working Directory und waehlt den Ordner aus in 
# dem sich die Datei befindet.

###############


# Der mediaUsage Datensatz enthaelt folgende Variablen:
# (Dabei handelt es sich um einen kuenstlich erstellten Datensatz)

# id        - Identifikationsnummer der Teilnehmenden
# age       - Alter
# gender    - Geschlecht
# student   - Schueler:innen- bzw. Studierendenstatus
# prefMed   - Bevorzugtes soziales Netzwerk
# tvTime    - Dauer der Fernsehnutzung pro Tag [min]
# soMedTime - Dauer der Social Media Nutzung pro Tag [min]
# Fehlende Werte sind mit -99 gekennzeichnet


# A2) Einlesen von tibbles
# Benoetigt das Funktionpaket haven 
# (wird am Anfang des Skriptes aktiviert)

# Einlesen des Datensatzes mit read_sav()
dat2 <- read_sav("ESS7DE.sav")
# uebersicht ueber die Variablen in der Datei "ess7de_var_list" auf ILIAS

# Vorteile von tibbles
# Daten enthalten Label mit Name und Skalierung der Variablen
print_labels(dat2$tvpol) # zeigt Skalierung der Variable politische Fernsehnutzung

# Fehlende Werte muessen in der Regel nicht mehr manuell 
# gekennzeichnet werden

# B) ueberpruefen des Imports

# 1 Kontrolliere, ob Spalten und Zeilen richtig uebernommen wurden
# (keine Variablen oder Faelle geloescht wurden)
dim(dat) # Der mediaUsage-Datensatz hat 70 Faelle mit 7 Variablen

# 2 Betrachte einige Faelle, um Fehler beim Import innerhalb 
#   der Variablen zu erkennen

View(dat) # oeffnet den Datensatz in einem separaten Fenster in R
head(dat) # Gibt die 6 ersten Zeilen des Datensatzes zurueck 
tail(dat) # Gibt die 6 letzten Zeilen des Datensatzes zurueck

head(dat, 10) # mit einem optionalen Argumet kann die Anzahl 
              # der angepasst werden

# Es faellt auf, dass fehlende Werte noch nicht gekennzeichnet sind
# (-99) bei soMedTime


# 3.Verschaffe Dir einen ersten ueberblick ueber Variablen und Kennwerte
summary(dat)
# Verdichtet jede Variable zu wenigen Kennwerten. Die Ausgabe ist 
# abhaengig vom Variablentyp:

# Numerics: Minimum, Maximum, Quartile und Mittelwert 
# z. B. soMedTime oder tvTime als Nutzungsvariablen

# Character: Gesamtzahl der Zeichen

# Logicals oder Factors: Absolute Haeufigkeiten der Kategorien
# z.B. student und  prefMed


# III Auswahl von Faellen und Variablen
# A) Auswahl durch Indexierung

# Datensaetze sind ebenfalls indexiert. Daher koennen einzelne oder 
# mehrere Faelle mithilfe der Zeilen und Spalten ausgewaehlt werden

# Dafuer verwendet man: data[Zeile, Spalte] 
dat[1,1] # selektiert die Zelle in der ersten Zeile, erste Spalte

# mehrere Faelle auswaehlen
dat[,1] # selektiert alle Werte der ersten Spalte (Erste Variable)
dat[1,] # selektiert alle Werte in der ersten Zeile (Erster Fall)

# Doppelpunkt (kennzeichnet Bereiche von:bis)
dat[1:10, ] # selektiert die ersten zehn Zeilen

# Mithilfe von Vektoren
dat[c(1, 3, 25),] # selektiert alle Werte in den Zeilen 1, 3 und 25
dat[c(1:5,30), 6:7] # Kann mit Bereichauswahl kombiniert werden

# B) Auswahl von Spalten mithilfe der Variablennamen

# data$varName 
# data["varName"] 
# waehlt alle Datenpunkte der benannten Variable aus

dat$prefMed # selektiert die Variable prefMed 
#(mit allen darin enthaltenen Werten)
dat["prefMed"] # macht das Gleiche 
dat[c("prefMed","soMedTime")] # es koennen mehrere Variablen benannt werden

# Aus dem resultierenden Vektor koennen ebenfalls einzelne Elemente 
# ausgewaehlt werden
dat$prefMed[7] # selektiert das praeferierte Medium der siebten Versuchsperson


# C) Auswahl mithilfe von logischen Operatoren

# Eine fortgeschrittene Form der Auswahl, die es ermoeglicht, Faelle 
# nach einem logischen Auswahlkriterium zu selektieren

# dat[Auswahlkriterium,] Selektiert Faelle, auf die das 
# Auswahlkriterium zutrifft

dat[dat$student == T,] # selektiert alle Schueler:innen/ Studierenden
dat[dat$prefMed == "Instagram",]  # selektiert alle Proband:innen, 
# die Instagram bevorzugen

# Wichtig: Komma in der eckigen Klammer nicht vergessen, damit R weiß,
# welche Spalten ausgewaehlt werden sollen.


# Fehlende Werte nicht automatisch herausgefiltert
# Dafur muss der Zusatz & !is.na() ergaenzt werden
dat[dat$student == T & !is.na(dat$student),] 
# Stellt sicher, dass keine fehlende Werte bei der Auswahl von 
# Studierenden enthalten sind
