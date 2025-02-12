##########################################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung VIII ANOVA - Begleitendes Skript 
## 25.04.2024

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("DescTools")){install.packages("DescTools")}
library(DescTools)

if(!require("lsr")){install.packages("lsr")}
library(lsr)

if(!require("psych")){install.packages("psych")}
library(psych)

# Einlesen de Datensatzes
dat <- read_sav("ESS7DE.sav")

# Umkodieren des Alters in eine kategorielle Variable
dat$agegrp <- ifelse(dat$agea <=35, "Junges Alter", 
                     ifelse(dat$agea<=60, "mittleres Alter", "hohes Alter"))

# Alternativ mit recode() aus dem Paket car
library(car)
dat$agegrp2 <- car::recode(as.numeric(dat$agea), "0:35 = 'Junges Alter'; 
                                                  36:60 = 'Mittleres Alter'; 
                                                  61:120 = 'Hohes Alter'")

# Beispiel: Effekt von Altersgruppen (agegrp) auf die Bewertung des 
#           Einflusses von Migrantion auf religioese Praktiken (rlgueim)

# A) ANOVA
# H1: Altersgruppen (junges, mittleres und hohes Alter) unterscheiden sich in 
#     der Bewertung des Einflusses von Migration auf religioese Praktiken

# H0: Die Altersgruppen (junges, mittleres und hohes Alter) bewerten den
#     Einflusses von Migration auf religioese Praktiken gleich

# I ANOVA
m1 <- aov(rlgueim~factor(agegrp), dat)
summary(m1)
# Es besteht ein signifikanter Unterschied in den Altersgruppen 
# hinsichtlich der Bewertung des Einflusses von Migration auf religioese 
# Praktiken, F(2, 2933) = 9.18, p < .001). H1 kann somit angenommen werden.


# B) Levene Test
# Der Levene-Test ueberprueft die Homogenitaet der Varianzen
# - Nullhypothese: Varianzen sind gleich (Varianzhomogenitaet besteht) 
# - Bei Signifikanz (p < .05) sind die Varianzen verschieden (die Annahme 
#   verletzt)

# Levene Test n R
LeveneTest(dat$rlgueim, as.factor(dat$agegrp))
# Die Varianzen der Bewertung des Einflusses von Migration auf religioese 
# Praktiken ist in den Altersgruppen gleich, F(2, 2933) = 1.58, p > .05.

# Die statistische Vorannahme der Varianzhomogenitaet ist somit erfuellt

# C) Post-hoc-Test
# I Bei Homogenitaet der Varianzen:
# Bonferroni
PostHocTest(m1, method = "bonf")

describeBy(dat$rlgueim, dat$agegrp) # benoetigt das Paket psych
# Der anschlie?ende post-hoc-Test nach Bonferroni offenbart, dass Personen 
# hohen Alters (M = 4.99, SD = 1.97) den Einfluss von Migration auf religioese 
# Praktiken signifikant negativer wahrnehmen als Personen mittleren (M = 5.33,  
# SD = 2.05) oder jungen Alters (M = 5.35,  SD = 2.13), jeweils p < .01. 
# Zwischen jungen und mittelalten Personen besteht kein Unterschied (p > .05) 


# II Bei Heterogenitaet der Varianzen:
PostHocTest(m1, method = "lsd") # aus dem Paket DescTools
# Gleiches Ergebnis

