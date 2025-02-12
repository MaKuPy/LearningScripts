########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Uebungsaufgaben - R Basics 
## 15.04.2023

library(haven)

# Aufgabe 1
# Importiert den Datensatz "ESS8DE.sav" (auf ILIAS) in R.
dat <- read_sav("ESS8DE.sav")

# a) Wie viele Faelle und Variablen sind in dem Datensatz enthalten?
dim(dat)

# 2852 Faelle und 85 Variablen sind im Datensatz enthalten.


# b) Lasst Euch die ersten sechs Faelle im Datensatz ausgeben.
head(dat)
dat[1:6,] # alternativ


# c) Verschafft Euch einen Überblick über den Datensatz. Sind fehlende Werte
#    bereits mit NA gekennzeichnet?
View(dat)
summary(dat)

# Fehlende Werte sind bereits im Datensatz gekennzeichnet.


# Aufgabe 2: Auswahl
# a) Welches Merkmal wird mit der Variable clmchng erfasst?
#    Welche Werte kann diese annehmen? Und wie kann der 
#    Wert von Versuchsperson 1026 interpretiert werden?

print_labels(dat$clmchng)
dat$clmchng

# Die Variable erfasst, ob Personen glauben, dass sich das Klima der Welt 
# veraendert.

dat[1026, "clmchng"]
# Versuchs Person Nr. 1026 hat den Wert 4 angegeben. Das bedeutet, dass sie
# glaubt, dass sich das Klima definitiv nicht verändert.


# b) Wie viele Personen haben die gleiche Auspraegung in clmchng
#    wie Versuchsperson 1026?
table(dat$clmchng)

# 36 weitere Personen haben die gleiche Angabe wie Versuchsperson Nr. 1026 gemacht.

dim(subset(dat, dat$clmchng == 4)) # Alternative Lösung


# c) Vergleicht die Faelle 20 bis 30 im Datensatz. Wer nutzt das Internet 
#    pro Tag am längsten (netustm)? Wie alt ist diese Person (agea) und wie
#    glücklich ist diese Person (happy)?

dat[20:30,]$netustm
# Versuchsperson Nr. 35 nutzt das Internet am laengsten mit 180 Minuten.

dat[25,]$happy
dat[25,]$agea

# Sie ist 26 Jahre alt und gab 8 Punkte auf der Glücklichkeitsskale an und 
# damit eher glücklich.

# d) Erstellt einen Datensatz, in dem nur Personen enthalten sind,
#    die jeden Tag das Internet nutzen (netusoft). Wie viele Fälle enthaelt
#    der neue Datensatz?
print_labels(dat$netusoft) # 5 entspricht täglicher Internetnutzung

dat2 <- subset(dat, dat$netusoft == 5)
dim(dat2)

# Der neue Datensatz enthaelt 1831 Faelle.


# Aufgabe 3: Datenmodifikation und -transformation

# a) Versuchsperson 300 gab nachtraeglich an, einen Fehler bei der
#    Angabe seines Alters (agea) gemacht zu haben. Statt 68
#    ist die Person 86 Jahre alt. Korrigiert den Wert im Datensatz.

dat[300,]$agea <- 86

# b) Berrechnet aus dem Alter der Versuchspersonen (agea) eine Variable, 
#    die das Geburtstjahr erfasst. Die Studie wurde im Jahr 2018 erhoben.

dat$birth_year <- 2018 - dat$agea


# c) Erstellt aus der Variable netustm (Internetnutzung pro Tag in Minuten)
#    eine neue Variable, die die Internetnutzung in Stunden erfasst.
#    Kontrolliert, ob alle Werte in einem sinnvollen Wertebereich liegen.

dat$netustm2 <- dat$netustm/60


# d) Erstellt eine neue Variable, die die taegliche Rezeption von Nachrichten 
#    dichotom erfasst. Weist Personen, die weniger als 1 Stunde Nachrichten
#    rezipieren die Auspraegung low zu und Personen, die darueber liegen
#    den Wert high.

dat$nwspol # in Minuten erfasst
dat$nwspol2 <- ifelse(dat$nwspol < 60, "low", "high")


# e) Wie groß sind die in 3 d) angelegten Gruppen der Fernsehnutzung?

table(dat$nwspol2)
# 1395 Personen wurde der Wert low zugewiesen. 1456 der Wert high.
