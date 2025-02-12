########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe X t-Test  - Loesungen 
## 23.05.2023

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("psych")){install.packages("psych")}
library(psych)

if(!require("lsr")){install.packages("lsr")}
library(lsr)

# Einlesen des Datensatzes
dat <- read_sav("ESS7DE.sav")

# A Unterscheiden sich Maenner und Frauen (gndr) hinsichtlich des Vertrauens 
# in politische Institutionen (Index aus Hausaufgabe VI) oder der Einstellung
# gegenueber Migrant:innen (Index aus Hausaufgabe VI)? Welcher Zusammenhang ist
# stärker?

# Vertrauen in politische Institutionen
dat$trst_idx <- rowMeans(dat[c("trstprl", "trstlgl", "trstplc", "trstplt", 
                               "trstprt", "trstep", "trstun")])
print_labels(dat$gndr) # 1 = Maennlich; 2 = Weiblich
t.test(dat$trst_idx~dat$gndr) # t-Test
by(dat$trst_idx, dat$gndr, describe) # Gruppenabhaengige deskriptive Statistik
cohensD(dat$trst_idx~dat$gndr) # Effektstaerke

# In der Stichprobe haben Maenner (M = 4.94, SD = 1.85) ein signifikant hoeheres 
# Vertrauen in politische Institutionan als Frauen (M = 4.75, SD = 1.79), 
# t(2826.1) = 2.74, p < .01.


# Einstellung gegenueber Migrant:innen
dat$mig_idx <- rowMeans(dat[c("imtcjob", "imbleco", "imwbcrm", "rlgueim")])
t.test(dat$mig_idx ~ dat$gndr) 
by(dat$mig_idx, dat$gndr, describe)
cohensD(dat$mig_idx ~ dat$gndr)

# In der Stichprobe sind Maenner (M = 4.87, SD = 1.49) gegenueber Migrant:innen
# signifikant positiver eingestellt als Frauen (M = 4.7, SD = 1.46), 
# t(2787.1) = 3.05, p < .001.


# B Stellt eine gerichtete Hypothese für einen der Zusammenhänge aus A auf
# und ueberprueft diese mit einem einseitigen t-Test.

# H1: Maennliche Personen haben ein groeßeres Vertrauen in politische
# Instutionen als weibliche
t.test(dat$trst_idx~dat$gndr, alternative = "greater")
by(dat$trst_idx,dat$gndr, psych::describe)

# Maennliche Personen (M = 4.93, SD = 1.85) haben ein signifikant groeßeres
# Vertrauen in politische Institutionen als weibliche Personen (M = 4.75,
# SD = 1.79), t(2826.1) = 2.74, p < .01. H1 hat sich bewaehrt.


# H2: Maennliche Personen haben ein geringeres Vertrauen in politische
# Instutionen als weibliche
t.test(dat$trst_idx~dat$gndr, alternative = "less")

# Maennliche Personen (M = 4.93, SD = 1.85) kein signfikant geringeres
# Vertrauen in politische Institutionen als weibliche Personen (M = 4.75,
# SD = 1.79), t(2826.1) = 2.74, p > .997. Damit hat sich H2 nicht bewaehrt.

# H3: Männliche Personen sind Migrant:innen gegenueber positiver eingestellt als
# weibliche.
t.test(dat$mig_idx~dat$gndr, alternative ="greater")
by(dat$mig_idx, dat$gndr, psych::describe)

# Männer (M = 4.87, SD = 1.49) haben in der Stichprobe eine singifikant bessere
# Einstellung gegenüber Migrant:innen als Frauen (M = 4.7, SD = 1.46), 
# t(2787.1) = 3.0547, p <.01.


# H4: Männliche Personen sind Migrant:innen gegenueber negativere eingestellt als
# weibliche.
t.test(dat$mig_idx~dat$gndr, alternative ="greater")
by(dat$mig_idx, dat$gndr, psych::describe)
158*2
# C Unterscheidet sich das durchschnittliche Vertrauen Politiker:innen 
# (trstplt) von dem durchschnittlichen Vertrauen in die politische Parteien 
# (trstprt)?



# D Liegt das durchschnittliche Vertrauen in das Europaeische Parlament (trstep) 
# in der Stichprobe über dem durchschnittlichen Vertrauen in die UN (trstun)?
  


# C: 
# Unterscheiden sich Maenner und Frauen (gndr) hinsichtlich des
# Vertrauens in politische Institutionen (Index 1 A), der politischen 
# Orientierung (Irscale) oder der Einstellung gegenueber Migrant:innen 
# (Index 1 A)?

# Zur ueberpruefung der Gruppenunterschiede muessen drei unabhaengige t-Tests 
# durchgefuehrt werden


# D: Unterscheidet sich die durchschnittliche Vertrauen in politische 
# Institutionen (Index 1 A) von dem durchschnittlichen Vertrauen in die 
# Polizei (trstplc)?
t.test(dat$trst_idx, dat$trstplc, paired = TRUE)

describe(dat$trst_idx) # Deskriptive Statistik
describe(dat$trstplc)

# Ja, die Vertrauen in politische Institutionen (M = 4.85, SD = 1.83) faellt 
# signifikant niedriger aus als das Vertrauen in die Polizei (M = 6.72, 
# SD = 2.2),  t(2833) = -60.01; p < .001).
