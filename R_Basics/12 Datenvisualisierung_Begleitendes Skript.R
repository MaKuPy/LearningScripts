##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung V Datenvisualisierung - Begleitendes Skript 
## 24.03.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/MA Aufbaukurs Datenanalyse/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("naniar")){install.packages("naniar")}
library(naniar)

# Einlesen der Datensaetze
dat <- read.csv("mediaUsage.csv", header=T, stringsAsFactors = T)
dat <- replace_with_na_all(dat, condition=~.x==-99)
dat[dat$age==222,]$age <- 22
dat2 <- read_sav("ESS7DE.sav")

# I Univariate Analyse
# Mit dem Hinzufuegen von Geoms werden grafische Darstellung
# in den Koordinatensystemen ergaenzt

# a) Balkendiagramm (barplot)
# Fuer die Visualisierung von absoluten oder relative Haeufigkeiten in 
# Balkendiagramme nominale und ordinale Daten

# Visualisierung von absoluten Haeufigkeiten
barplot(table(dat$prefMed))

# Visualisierung von relativen Haeufigkeiten
barplot(prop.table(
  table(dat$prefMed)))

# b) Boxplots (geom_boxplot)
# Fuer die Darstellung von ordinalen und metrischen Daten
boxplot(dat$soMedTime)
boxplot(dat$soMedTime, horizontal =T)

# Zwei Variablen im selben Koordinatensystem
boxplot(dat$tvTime,dat$soMedTime)

# c) Histogramme (geom_hist)
# Fuer die Darstellung von metrischen Daten
hist(dat$soMedTime)
# Die Darstellung deutet auf eine linkssteile Verteilung hin

# Zur Ueberpruefung der Schiefe kann describe verwendet werden
describe(dat$soMedTime) # 1.25 

# breaks = 36 legt die Anzahl der Unterteilungen der Variable 
# fest (groeßere Zahlen fuehren zu feineren Abstufungen im 
# Histogramm)
hist(dat$soMedTime, breaks=36)

# freq = F wandelt die Y-Achse von absoluten Haeufigkeiten
# in Dichte um
hist(dat$soMedTime, freq=F)


# II Bivariate Visualisierung
# Meistens interessiert man sich nicht nur fuer ein einziges, 
# sondern gleichzeitig fuer zwei oder mehrere Merkmale und 
# ihr Verhaeltnis zueinander.

# a) boxplots nach Gruppen
# Fuer die Visualisierung des Zusammenhangs zwischen einer nominalen oder 
# ordinalen UV und einer metrische AV
boxplot(dat$soMedTime~dat$student)

# Um die Darstellung umzudrehen, kann horizontal = T verwendet 
# werden
boxplot(dat$soMedTime~dat$student, horizontal = T)

# b) Streudiagramme (geom_point)
# Fuer die Visualisierung des Zusammenhangs zwischen zwei metrischen 
# Variablen
dat2 <- read_sav("ESS7DE.sav")

plot(dat2$stflife~dat2$lrscale)

# Verwendung von jitter()
# jitter() Ergaenzt die Daten um eine zufaellige Streuung, damit die Verteilung 
# der Datenpunkte besser sichtbar wird
plot(jitter(dat2$stflife)~jitter(dat2$lrscale))

## Zum Interpretieren
ggplot(dat, aes(age, soMedTime)) + geom_jitter() + 
  ylab("Social Media Nutzung [min]") +xlab("Alter")
# Der erkennbare Abwaertstrend deutet auf einen negativen Zusammenhang 
# von Alter und Social Media Nutzung hin

ggplot(dat, aes(age,tvTime)) + geom_jitter() + 
  ylab("Fernsehnutzung [min]") +xlab("Alter")
# Die zufaellige Punktverteilung deutet darauf hin, dass Alter und 
# Fernsehnutzung in keinem Zusammenhang stehen


# III Essenzielle Gestaltungselemente

# Achsenbeschriftung ung Titel
# Eine grafische Darstellung sollte stets einen deskriptiven Titel und 
# Achsenbeschriftungen (idealerweise mit Messeinheiten) haben
hist(dat$soMedTime, 
     main="Histogramm der Social Media Nutzung",
     ylab="Absolute Haeufigkeiten", 
     xlab ="Dauer der Social Media Nutzung [min]")

# Achsenbegrenzungen
# Die x- und die y-Achse sollte außerdem den dargestellten Wertebereich 
# abdecken
hist(dat$soMedTime, 
     main="Histogramm der Social Media Nutzung",
     ylab="Absolute Haeufigkeiten", 
     xlab ="Dauer der Social Media Nutzung [min]",
     xlim = c(0,650), ylim=c(0,20))

# Bezeichnung von kategoriellen Variablen
# Die Kategorien einer Variable sollten stets benannt werden
boxplot(dat$soMedTime~dat$student, ylab="Social Media Nutzung [min]", xlab="Schuelerstatus",
        main="Boxplots der Social Media Nutzung 
 nach Schuelerstatus",names=c("non-student", "student"))

# IV Optionale Gestaltungselemente
# Farbe und Zeichen
plot(dat2$trstplc~dat2$trstprt, col="Royalblue", )
plot(dat2$stflife~dat2$lrscale, xlab="politische Orientierung", 
     ylab="Lebenszufriedenheit", main="Streudiagramm zum Zusammenhang von politscher 
     Orientierung und Lebenszufriedenheit", col="Royalblue", pch=18)

boxplot(dat$soMedTime~dat$student, ylab="Social Media Nutzung [min]", xlab="Schuelerstatus",
        main="Boxplots der Social Media Nutzung 
 nach Schuelerstatus",names=c("non-student", "student"), col = "Royalblue")

boxplot(dat$soMedTime~dat$student, ylab="Social Media Nutzung [min]", xlab="Schuelerstatus",
        main="Boxplots der Social Media Nutzung 
 nach Schuelerstatus",names=c("non-student", "student"), col = c("Aquamarine3","Royalblue"))

# Einfaerben nach logischen Operatoren
plot(jitter(dat2$stflife)~jitter(dat2$lrscale), xlab="politische Orientierung", 
    ylab="Lebenszufriedenheit", main="Streudiagramm zum Zusammenhang von politscher 
     Orientierung und Lebenszufriedenheit", col = c("Grey","Royalblue")[factor(dat2$eduade1 == 5)])
legend("bottomright", col=c("Grey","Royalblue"), pch=1, legend=c("Ohne Abitur","Mit Abitur"))


# Trendlinien und Regressionsgerade
plot(jitter(dat2$trstplt)~jitter(dat2$trstprl), xlab="Vertrauen in das Parlament", 
     ylab="Vertrauen in Politiker:innen", main="Streudiagramm zum Zusammenhang von Vertrauen 
     in das Parlament und in Politiker:innen")
abline(lm(dat2$trstplt~dat2$trstprl), col="Blue", lwd=2)


