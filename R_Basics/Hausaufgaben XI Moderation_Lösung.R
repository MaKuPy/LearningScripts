############################################
## �bung - Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe XI Moderation  - Loesungen 
## 23.05.2023

# Ggf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/Arbeitsverzeichnis")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("lm.beta")){install.packages("lm.beta")}
library(lm.beta)

if(!require("rockchalk")){install.packages("rockchalk")}
library(rockchalk)

# Aufgabe 1 
# Lest die Datei Analysedatensatz.sav ein:
dat<-read_sav("ESS7DE.sav")

# A
# �berpr�ft, ob das Geschlecht der Versuchspersonen (gndr) den Einfluss von 
# Vertrauen in politische Institutionen (Index aus VI) auf die 
# Demokratiezufriedenheit (stfdem) moderiert. Plottet die Interaktion und 
# interpretiert die Moderation inhaltlich.

# Indexbildung
dat$trst_idx <- rowMeans(dat[c("trstprl", "trstlgl", "trstplc", "trstplt", 
                               "trstprt", "trstep", "trstun")])

# Regressionsmodell mit Interaktion
m1 <- lm(stfdem~trst_idx*gndr, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# Das multiple Regressionsmodell offenbart einen signifikanten Interaktionsterm
# von Vertrauen in politische Institutionen und Geschlecht, beta = -.13, p < .05.
# Damit moderiert das Geschlecht der Veruchspersonen den Einfluss von Vertrauen
# in politische Institutionen auf die Demokratiezufriedenheit.

print_labels(dat$gndr) # 1 = Male; 2 = Female

# Visualisierung der Moderation 
plotSlopes(m1, plotx="trst_idx", modx="gndr",
           ylab= "Demokratiezufriedenheit", xlab="Vertrauen in pol. Institutionen", 
           modxVals="table", legendArgs = list(x="bottomright", cex= .8))

# Aus der Visualisierung der Regressionsgeraden f�r die beiden Auspr�gungen
# des Moderators geht hervor, dass der positive Einfluss von Vertrauen in 
# politische Institutionen auf die Demokratiezufiredenheit bei weiblichen 
# Personen schw�cher ist als bei m�nnlichen Personen. 

# Optional: Rechnerische Interpretation
# W�hrend bei m�nnlichen Personen, ein Anstieg des Vertauen in pol. Institutonen
# um eins mit enem Anstieg der Demokratiezufriedenheit um 0.98 korrespondiert, 
# wird bei weiblichen Personen bei einem Anstieg der UV um eins eine um 0.9 
# h�here Demokratiezufriedenheit prognostiziert.

# Das Modell ist insgesamt f�r die Vorhersage von Dekomkratiezufriedenheit
# geeignet und erkl�rt 43.4% von dessen Varianz, adj. R� = .434, 
# F(3, 2823) = 34.05, p < .001.


# B
# �berpr�ft, ob die politische Orientierung der Proband:innen (lrscale)
# den Einfluss von Alter (agea) auf die Zufriedenheit mit dem 
# Lebensumst�nden (Index aus VI) moderiert. Zentriert daf�r zun�chst 
# die Variablen f�r Alter und politische Orientierung. Plottet die 
# Interaktion und interpretiert die Moderation inhaltlich.

# Indexbildung
dat$stf_idx <- rowMeans(dat[c("stfeco", "stfgov", "stfdem")])
names(dat)
# Zentrierung der UV und des Moderators
dat$agea_c <- as.numeric(scale(dat$agea, center=T, scale =F))
dat$lrscale_c <- as.numeric(scale(dat$lrscale, center=T, scale =F))

# �berpr�fung der Zentrierung
psych::describe(dat$agea_c)
psych::describe(dat$lrscale_c)

# Regressionsmodell mit Interaktionsterm
m1 <- lm(stf_idx~agea_c*lrscale_c, dat)
m1_beta <- lm.beta(m1)
summary(m1_beta)

# Die Analyse mit einem multiplen Regressionsmodell verweist auf eine
# signfikanten, positiven Interaktionsterm f�r den gemeinsamen Einfluss
# von Alter und politischer Orientierung auf die Zufriedenheit mit den
# Lebensumst�nden, beta = 0.06, p < .01. Damit moderiert die politische 
# Orientierung der Proband:innen den Einfluss von Alter auf die Zufriedenheit
# mit den Lebensumst�nden.


# Visualisierung der Moderation
plotSlopes(m1, plotx="agea_c", modx="lrscale_c", col=c("Red","Blue","Green"),
           xlab= "Alter", ylab="Zufriedenh. mit Lebensumstaenden", 
           modxVals="std.dev", legendArgs = list(x="topright", cex=.6))

print_labels(dat$lrscale)
describe(dat$lrscale)
# Zur Interpretation der Moderation wurden der Effekt von Alter auf 
# die Zufriedenheit mit den Lebensumst�nden f�r den Mittelwert der
# politischen Selbsteinstufung (0 = links, 10 = rechts; M = 4.5, SD = 1.91) 
# der Teilnehmer:innen, sowie eine Standardabweichung darunter und dar�ber 
# mit einer Regressionsgeraden visualisiert.

# In der Visualisierung ist zu erkennen, dass das Alter bei Proband:innen, 
# die ihre politische Orientierung weiter links einstufen, einen leichten
# negativen Einfluss auf die Zufriedenheit mit den Lebensumst�nden hat.

# Mit einer zunehmend rechteren politischen Orientierung wird der negative Einfluss 
# von Alter jedoch schw�cher, sodass die Regressionsgerade bei mittlerem
# Alter schon fast einer Horizontalen gleicht. Bei einer politischen
# Orientierung um den Mittelwert (M = 4.5) ist der Einfluss von Alter auf
# die Zufriedenheit mit den Lebensumst�nden nicht signifikant, beta = -.005,
# p > .05. 

# Bei einer politischen Orientierung, die eine Standardabweichung �ber 
# dem Mittelwert liegt ist ein sehr leichter Anstieg in der Regressionsgeraden 
# zu erkennen. Daher w�re es m�glich, dass eine starke rechte Orientierung
# dazu f�hrt, dass die Zufriedenheit mit den Lebensumst�nden bei 
# steigendem Alter zunimmt. Somit kehrt eine stark rechte politische 
# Orientiertung den zun�chst negative Einfluss von Alter auf die AV um.


# Bonus: Johnson-Neyman-Technique
if(!require("interactions")){install.packages("interactions")}
library(interactions)

johnson_neyman(m1, pred = agea_c, modx = lrscale_c) 

mean(dat$lrscale, na.rm=T) - 1.24 # linke Grenze
mean(dat$lrscale, na.rm=T) + 1.77 # rechte Grenze
# Der Effekt von Alter auf die Zufriedenheit mit den Lebensumst�nden ist bei 
# einer politischen Orienierung unter 3.3 mit mindestens p < .05 signifikant
# negativ. Ab einer politischen Orientierung von 6.3 hat das Alter der 
# Proband:innen einen signfikant positiven Einfluss auf die Zufriedenheit mit
# den Lebensumst�nden, mindestens p < 05.

