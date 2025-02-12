########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe VII Kontingenztabelle und Chiquadrat  - Loesungen 
## 26.04.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("descr")){install.packages("descr")}
library(descr)

if(!require("lsr")){install.packages("lsr")}
library(lsr)

# Aufgabe 1 
# Lest die Datei ESS7DE.sav ein:
dat <- read_sav("ESS7DE.sav")

# A 
# Unterscheiden sich Maenner und Frauen (gndr) darin, welche Parteien
# sie waehlen (prtvede)? Interpretiert beobachtbare Unterschiede.
CrossTable(dat$gndr, dat$prtvede2, exp=T, chisq = T)
print_labels(dat$gndr) # 1 Maennlich, 2 Weiblich
print_labels(dat$prtvede2) 
# 1 CDU, 2 SPD, 3 Die Linke, 4 Die Grünen, 5 FDP, 6 AFD, 7 Piraten, 
# 8 NPD, 9 Andere


# Die Kreuztabelle offenbart signifikante Geschlechterunterschiede in der
# Parteiwahl, Chi^2(8) = 34,93; p <= .001). Waehrend die SPD sowie "andere 
# Parteien" von beiden Geschlechtern annaehernd gleich haeufig gewaehlt wurden, 
# haben CDU/CSU, Buendnis 90/Die Gruenen sowie NPD unter den Frauen prozentual 
# mehr Anhaenger als unter den Maennern. Die Linke, FDP, AfD und Piratenpartei
# werden hingegen eher von Maennern gewaehlt.


# B 
# Unterscheiden sich Maenner und Frauen (gndr), ob in den letzten 
# zwoelf Monaten die folgenden Beschwerden aufgetreten sind: 
# - Zu hohen Blutdruck (hltprhb)
CrossTable(dat$gndr, dat$hltprhb, exp=T,
           chisq = T)

# Es besteht kein Zusammenhang zwischen Geschlecht und dem Auftreten von 
# Bluthochdruck in der Stichprobe, Chi^2(1) = 2.35; p > .05.

# - Allergien (hltpral)
CrossTable(dat$gndr, dat$hltpral, exp=T,
           chisq = TRUE)

# Das Geschlecht der Proband:innen steht in keinem signfikanten Zusammenhang 
# mit dem Auftreten von Allergien, Chi^2(1) = 3.44; p > .05.

# - Ernsthafte Kopfschmerzen (hltprsh) 
CrossTable(dat$gndr, dat$hltprsh, exp=T,
           chisq = TRUE)

# Es bestehen ein signifikanter Zusammenhang zwischen Geschlecht und dem
# Auftreten von ernsthaften Kopfschmerzen, Chi^2(1) = 63.53; p < .001. Dieser
# Unterschied ist darauf zurueckzufuehren, dass maennliche Personen in der 
# Stichprobe vergleichsweise selten unter Kopfschmerzen litten, weahrend 
# weibliche Personen haeufiger angaben, Kopfschmerzen zu haben.

# - Diabetes (hltprdi) 
CrossTable(dat$gndr, dat$hltprdi, exp=T,
           chisq = TRUE)

# In der Stichprobe bestehen keine singifikanten Geschlechtsunterunterschiede 
# in dem Auftreten von Diabetes,  Chi^2(1) = 2.84; p > .05.


# Welche Zusammenhang ist am stärksten?
cramersV(table(dat$gndr, dat$hltprsh))

# ANTWORT: Der einzige signifikante Geschlechterunterschied besteht bei 
# Kopfschmerzen (Chi^2(1) = 63,53; p <= ,001). Hierbei handelt es sich folglich 
# auch um den staerksten Zusammenhang.


# C
# Woran koennte es liegen, dass ein Chi-Quadrat-Test trotz deutlichen 
# Haeufigkeitsunterschiede nicht signifikant wird (Antwortsatz)


# Dies kann entweder daran liegen, dass die Fallzahl der Stichprobe zu gering 
# ist. Oder es liegt daran, dass die statistischen Voraussetzung des Chi-
# Quadrat-Tests nicht erfuellt ist, die darin besteht dass die erwartete
# Haeufigkeit in der Kreuztabelle mindestens 5 sind.

# Im ersten Fall muss die  Stichprobengroeße erhoeht werden. Im zweiten Fall 
# muessen Variablenauspraegungen mit sehr geringen Haeufigkeiten zu Gruppen 
# zusammengefasst werden.


