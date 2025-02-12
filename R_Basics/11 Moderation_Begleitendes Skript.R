##########################################################
## Übung Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung XI Moderation - Begleitendes Skript 
## 15.05.2023

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/Arbeitsverzeichnis")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("lm.beta")){install.packages("lm.beta")}
library(lm.beta)

if(!require("psych")){install.packages("psych")}
library(psych)

if(!require("rockchalk")){install.packages("rockchalk")}
library(rockchalk)

# Einlesen de Datensatzes
dat <- read_sav("ESS7DE.sav")

# I Moderation
# Ein Moderator ist eine Variable Z, die die Staerke oder Richtung des 
# Effekts der UV auf die AV beeinflusst.

# Allgemeine Form der Regressionsgeraden:
# yi = a + b1*x1i + b2*X2i+ ei

# Diese wird um einen Interaktionsterm (X1i*X2) ergaenzt, der den gemeinsamen 
# Effekt zweier Variablen erfasst:
# yi = a + b1*x1i + b2*X2i + b3*X1i*X2i + ei


# A Beispiel: Regression mit dichotomem Moderator
# H1: Die Staerke des Zusammenhangs von Demokratie- (UV) und Lebens-
# zufriedenheit (AV) haengt vom Geschlecht (Mod.) der Proband:innen ab

m1 <- lm(stflife~stfdem*gndr, dat) # Erstellt das Modell
m1_beta <- lm.beta(m1) # Fuegt std. Regressionskoeffizienten hinzu
summary(m1_beta) # Gibt das Ergebnis der Analyse aus

# Die Interaktion von Geschlecht und Demokratiezufriedenheit ist im 
# Regressionsmodell signifikant, ?? = .17, p < .01. Deshalb kann 
# angenommen werden, dass das Geschlecht der Proband:innen den Einfluss 
# von Demokratiezufriedenheit auf die Lebenszufriedenheit moderiert. H2 
# hat sich somit der statistischen Pruefung bewaehrt und kann angenommen 
# werden.

# Das Modell ist fuer die Vorhersage von Lebenszufriedenheit geeignet und 
# erklaert 9.5% der Lebenszufriedenheit, adj. R² = .095, F(3,3013) = 106.5,
# p <.001.

# X Rechnerische Interpretation 
# Effekt von Demokratiezufriedenheit:
# 0.145* stfdem + 0.077*stfdem*gndr

# - Fuer gndr = 0 (maennlich)
print_labels(dat$gndr)
# 0.145 * stfdem + 0.077 * stfdem * 0 = 0.145*stfdem

# Bei maennlichen Versuchspersonen wird bei einem Anstieg von 
# Demokratiezufriedenheit um 1 ein Anstieg der Lebenszufriedenheit um 
# 0.145 erwartet.

# - Fuer gndr = 1 (weiblich)
# 0.145 * stfdem + 0.077 * stfdem * 1 = 0.222*stfdem

# Bei weiblichen Versuchspersonen wird bei einem Anstieg von Demokratie-
# zufriedenheit um 1 ein Anstieg der Lebenszufriedenheit um 0.222 
# erwartet.

# X Visualisierung des Zusammenhangs
plotSlopes(m3, plotx="stfdem", modx="gndr", 
           xlab="Demokratiezufriedenheit", ylab="Lebenszufriedenheit",
           modxVals = "table", legendArgs = list(x="bottomright",
                                                 title="Geschlecht"))
# legendArgs folgt den Argumenten von legend
?legend # Zeigt Anpassungsmoeglichkeiten fuer die Legende


# B Beispiel 2: Regression mit metrischem Moderator
# H2: Die Einfluss von Gewicht (UV) auf die Gesamtfernsehnutzung (AV) 
# haengt vom Alter (Moderator) der Proband:innen ab

# X Zentrierung der Variablen der UV und des Moderators 
# mithilfe der Funktion scale() 

dat$weight_c <- as.numeric(scale(dat$weight, center = T, scale =F))
dat$agea_c <- as.numeric(scale(dat$agea, center = T, scale =F))
# center = T zentriert die Variable, indem von jedem Wert der 
#            Mittelwert abgezogen wird. Dadurch entsteht eine 
#            Variable mit einem Mittelwert von 0.

# scale = F verhindert, dass die Skalierung der Variable standardisiert 
#           wird, indem die Werte durch die Standardabweichung geteilt
#           wird. Dadurch wuerde eine variable mit einer Standardabweichung 
#           von 1 entstehen.

describe(dat$agea_c)
describe(dat$weight_c)

# Beide Variablen weisen einen Mittelwert von 0 auf. Damit war die Zentrierung 
# erfolgreich.

# X Berechnung des Regressionsmodells
m2 <- lm(tvtot~weight_c*agea_c, dat)
m2_beta <- lm.beta(m2)
summary(m2_beta)

# Der Interaktionsterm von Gewicht und Alter ist signifikant, ?? = .04, 
# p < .05. Damit kann angenommen werden, dass das Alter der Proband:innen
# den Zusammenhang von Gewicht und Fernsehnutzung moderiert. H2 hat
# sich somit bewaehrt und kann angenommen werden. 

# Das Modell erklaert 14.22% der Varianz der Gesamtfernsehnutzung und ist 
# zur Vorhersage der Fernsehnutzung geeiget, adj. R²  = .1422, 
# F(3, 2965) = 165, p < .001.

# X Rechnerische Interpretation:
# 0.007*weight_c + 0.0002*weight_c*agea_c
# e.g. agea_c = -20: 	 
# 0.007*weight_c + 0.002*(-20)*weight_c 
0.007+0.0002*(-20)
# = 0.003*weight_c
describe(dat$agea)
# Das Durchschnittliche Alter ist 50, was bedeutet, dass es Werte gibt, die
# noch einmal weiter unter dem Mittelwert liegen als 20.

# Bei einem Alter von 15 waere der Effekt von Gewicht auf die Fernsehnutzung = 0
0.007+0.0002*(-35)
# Wahrscheinlich ist der Effekt allerdings schon vorher nicht mehr signfikant.

# Um das Intervall zu erhalten, in dem der Effekt von Gewicht auf die 
# Fernsehnutzung in Abhaegigkeit vom Alter nicht signifikant ist, muesste 
# die Johnson-Neyman-Technique angewandt werden.

# X Visualierung der Moderation
plotSlopes(m2, plotx="weight_c", modx="agea_c",
           xlab="Gewicht", ylab="Fernsehnutzung", 
           modxVals = "std.dev")
