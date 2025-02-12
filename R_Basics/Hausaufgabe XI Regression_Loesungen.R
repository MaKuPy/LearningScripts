########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe XI Regression - Loesungen 
## 31.05.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("lm.beta")){install.packages("lm.beta")}
library(lm.beta)


# Einlesen des Datensatzes
dat <- read_sav("ESS7DE.sav")
print_labels(dat$eduade1)

# Wir interessieren uns dafuer wie das Vertrauen in politische Institutionen 
# (Index aus Hausaufgabe VIII) durch die folgenden Variable vorhergesagt wird:

# Gesamtfernsehnutzung (tvtot)
# Nutzung von politischen Informationsprogrammen im Fernsehen (tvpol)
# Alter (agea)
# Geschlecht (gndr)
# Abitur (Zuerst zu einer Dummyvariable umkodieren: ja oder nein) 

# A
# Erstellt zunaechst ein einfaches lineares Regressionsmodell fuer jede 
# Praediktorvariable. Interpretiert die Ergebnisse: Sind die Zusammen-
# haenge signifikant? In welche Richtung weisen Sie? Wieviel Varianz wird
# erklaert? Gebt die relevanten Kennwerte an (beta, R², F, df, p)

# Indexbildung
dat$trst_idx <- rowMeans(dat[c("trstprl", "trstlgl", "trstplc", "trstplt", 
                               "trstprt", "trstep", "trstun")])


# a) Zufriedenheit mit den Lebensumstaenden (Index aus Hausaufgabe VI)

dat$stf_idx <- rowMeans(dat[c("stfdem", "stfgov", "stfeco")], na.rm=T)

m1 <- lm(trst_idx~stf_idx, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# Die Zufriedenheit mit den Lebenumstaenden hat einen signfikanten, positiven 
# Einfluss auf das Vertrauen in politische Institutionen, beta = .70, p < .001. 
# Das Regressionmodell ist fuer die  Vorhersage der AV geeignet und erklaert
# 4.86% der Varianz der abhaengigen Variable, F(1, 2673) = 0.52, p > .05.


# b) Nutzung von politischen Informationsprogrammen im Fernsehen (tvpol)

m1 <- lm(trst_idx~tvpol, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# Fernsehnutzung zum Konsum politischer Informationen hat keinen 
# signifikanten Einfluss auf das Vertrauen in politische Institutionen,
# beta = -.01, p > .05. Das Regressionmodell ist somit auch nicht fuer die
# Vorhersage der AV geeignet, F(1, 2673) = 0.52, p > .05.

# Alter (agea)
m1 <- lm(trst_idx~agea, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# Das Alter der Proband:innen hat einen signifikant negativen Einfluss
# auf das Vertrauen in pol. Institutionen, beta = -.11, p < .001. Ein
# Anstieg des Alters um 1 korrespondiert in der Stichprobe mit einem um 0.01
# sinkenden Vertrauen in politische Institutionen. Das Modell ist fuer die
# Vorhersage des Vertrauensindexes geeignet und erklaert 1.19% von dessen 
# Varianz, F(1,2821) = 33.92, p <.001.

# Geschlecht (gndr)
m1 <- lm(trst_idx~gndr, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

print_labels(dat$gndr) # 1 = Male, 2 = Female 
# (Anstieg um 1 = Wechsel von Maennlich zu Weiblich)

# Das Geschlecht der Versuchspersonen beeinflusst deren Vertrauen in 
# politische Insitutionen signfikant, beta = -.05, p < .01. Bei Frauen
# wird im Gegensatz zu Maennern ein um 0.19 niedrigeres Vertrauen in pol.
# Institutionen prognostiziert. Das Modell ist zur Vorhersage geeignet
# und erklaert 0.26% der Varianz der AV, F(1, 2832) = 7.507, p < .01.

# Abitur (Zuerst zu einer Dummyvariable umkodieren: ja oder nein) 
print_labels(dat$eduade1)
table(dat$eduade1)
 
dat$abi <- ifelse(dat$eduade1 ==5, T, F)
# T = 1 und F = 0 
# Ein Anstieg um eins entspricht dem Wechsel von kein-Abitur zu Abitur

m1 <- lm (trst_idx~abi, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# Das Vertrauen in politische Institutionen von Personen mit Abitur 
# ist signifikant hoeher als das Vertrauen von Personen ohne Abitur,
# beta = .15, p  < .001. Bei Besitz des Abiturs (im Vergleich zu
# Personen ohne Abitur) wird ein um 0.62 hoeheres Vertrauen in politische
# Institutionen prognostiziert. Das Modell eignet sich zur Vorhersage der
# AV, F(1, 2818) = 68.88, p <.001.


# B
# Ueberprueft die Zusammenhaenge nun in einem einzelnen (multiplen) 
# Regressionsmodell. Interpretiert die Ergebnisse und vergleicht, ob sich 
# die Regressionskoeffizienten, die Signifikanz und die erklaerte Varianz 
# geaendert haben. Woran koennte das liegen? 
  
m1 <- lm(trst_idx~stf_idx + tvpol + agea + gndr + abi, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# In dem multiplen Regressionsmodell hat die allgemeine Lebenszufriedenheit
# (beta = .69, p < .001) und der Besitz des Abiturs (beta = .05, p < .001)
# einen signifikanten positiven Einfluss auf das Vertrauen in politsche 
# Institutionen. Das Alter der Versuchspresonen (beta = -.11, p < .001),
# hat hingegen einen signifikant negativen Einfluss auf die AV. Die 
# Fernsehnutzung zur politische Information und das Geschlecht haben keinen
# signfikanten Einfluss auf das Vertrauen in politsche Institutionen, p > .05.

# Das Modell ist fuer die Vorhersage des Vertrauens in pol. Institutionen
# geeignet und erklaert 5.07% von dessen Varianz, F(5, 2649) = 554.6, p < .001.


## Veraenderung der Ergebnisse

# Die Regressionskoeffizienten und Irrtumswahrscheinlichkeiten fuer die 
# Zufriedenheit mitden Lebensumstaenden, das Alter und Fernsehnutzung zur
# politischen Information unterscheiden sich nur geringfuegig von den 
# bivariaten Modellen.

# Der Einfluss von Geschlecht ist im multiplen Regressionsmodell jedoch nicht 
# mehr signfikant, und der Einfluss des Besitzes des Abiturs (beta1 = 0.15, 
# beta2 = 0.5) nimmt etwas stärker ab.

# Die Ursache leigt vermutlich daran, dass der zuvor erklaerte Anteil der 
# Varianz durch die Variablen Geschlecht und Besitz des Abiturs im multiplen 
# Regressionsmodell von Variablen mit staerkerer ERklaerungskraft absorbiert 
# wird. Daher ist ihr Einfluss im multiplen Regressionsmodell nicht signifikant
# bzw. geringer.

# Das multivariate Modell erklaert insgesamt 5.07 % der Varianz der 
# Kriteriumsvariable, was ueber dem Wert der jeweiligen Einfach-
# Regressionen liegt. Dies bedeutet, dass die Kombination an 
# Praediktorvariablen  erwartungsgemaeß eine groeßere  Vorhersagekraft 
# besitzt, als die bivariaten Modelle.



