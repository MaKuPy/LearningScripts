# R fuer Einsteiger
# Luhmann, 2020

# Buchempfehlungen
## Wickham und Grolemund (2017) "R for Data Science" 
## Sauer (2019) "Moderne Datenanalyse mit R"
## Chang (2013) "R Graphics Cookbook"


## I Neue Informationen zu den R-Basics

search() # gibt eine Liste der bereits geladenen Pakete
# update.packages(ask=F) # Dated auf einmal alle verwendeten Pakete

help.search("Chi-Square") # gibt alle Funktionen aus, bei denen der Begriff
# in der Beschreibung ist

library(tidyverse)
library(dplyr)
# Warnmeldung:
# Das folgende Objekt ist maskiert ‘package:car’:
# recode

# >> gibt an, dass diese Funktion bereits in einem anderen geladenen Paket verfuegbar ist

dir() # entspricht list.files()


# Einzelne Objekte speichern und laden
# save(objekt, file = "name.RData") speichert ein Objekt im Arbeitsverzeichnis
# save(file = "name.RData) speichert den kompletten Arbeitspeicher

# load("name.RData") # laedt das gespeicherte Objekt wieder ein


## II Datenaufbereitung mit tidyverse
# Aufbereitung mit tidyverse ist oft besser fuer komplexere Prozesse geeignet
# Pakete: tidyverse, tidy, dplyr

# Mit einem %>% koennen Funktionen verbunden werden
# Tastenkombination Strg + Shift + M = %>%

# Arbeiten mit einem Datensatz
simDat <- data.frame(id = 1:100,
                     alter = round(rnorm(100, 34, 3)), 
                     trust = round(rnorm(100, 2.41 ,0.5)))

## x mutate
simDat <- simDat %>% mutate(year_birth = 2024 - alter,
                            age_std = scale(alter, center = T, scale = T))

# Bei der Zentrierung mit scale wird die Variable durch die SD geteilt (scale = T)
# und der Mittelwert subtrahiert (center = T), es ensteht eine Var mit M = 0 und SD = 1

## rename
simDat <- simDat %>%
  rename(age = alter) # NeuerName = AlterName

## x Umpolen einer Variable
table(simDat$trust)
# mit (max_Wert + 1) - Variable, funktionier umpolen am schnellsten
simDat$trust2 <- (4+1) - simDat$trust
table(simDat$trust2)

## which() 
# damit koennen Zeilen gegeben werden, auf die eine gewisse Bedingung zutrifft
# z.B.
which(simDat$trust == 1) # in ausgegebenen Zeilen ist trust == 1
simDat[which(simDat$trust == 1),]$trust

grep(1, simDat$trust) # Alternative


## x recode aus tidyverse
# statt einer if-else Funktion
simDat <- simDat %>% mutate(trust_txt = recode(trust,
                                               '1' = 1,
                                               '2' = 2,
                                               .default = 3))
table(simDat$trust_txt)

# Funktioniert auch mit Text
simDat <- simDat %>% mutate(trust_txt = recode(trust,
                                               '1' = "low",
                                               '2' = "middle",
                                               .default = "high"))
table(simDat$trust_txt)

# 'alterWert' = neuer Wert
# .default gibt den Rest der Werte an
simDat$trust_txt

## select() aus dem Paket dplyr 
# bietet eine Vielzahl von Moeglichkeiten Variablen nach Name auszuwaehlen

dplyr::select(simDat, c("trust_txt", "trust"))

# contains, ends_with, starts_with
# beginnend mit einem Wort
dplyr::select(simDat, contains("trust"))
simDat %>% dplyr::select(ends_with("t"))

head(dplyr::select(dat2, starts_with("trst")))
## x Sortieren der Faelle
# klassisch
simDat_ord <- simDat[order(simDat$age, decreasing = T),]

# tidyverse
# arrange() sortiert Daten aufsteigend nach der aggebenen Variable
simDat_ord <- simDat %>% arrange(age) 

simDat_ord <- simDat %>% arrange(desc(age)) # desc() wird verwendet, um absteigend zu sortieren

# Kann auch mehrschrittig angewandt werden
simDat_ord <- simDat %>% arrange(age, trust)
# Zunaechst wird nach Alter sortiert und innerhalb des Alters nach trust


## x Datensaetze zusammenfuegen
# Um Zeilen zu ergaenzen einfach rbind() verwenden


# Ergaenzen von Spalten

# Datensatz erstellen
simDat2 <- data.frame(id = sample(1:120, 120, replace = F),
                      tvtime = round(rnorm(120, 145, 25)))

# klassisch
bothSim <- merge(simDat, simDat2, by = "id") 
# merge() matcht die Faelle via Teilnehmer-ID
# Faelle 101 - 120 werden entfernt, da diese nicht im Datensatz 1 vorkommen

bothSim <- merge(simDat, simDat2, by = "id", all = T) 
# uebernimmt Faelle 101 - 120 und traegt fehlende Werte ein

# tidyverse
bothSim <- inner_join(simDat, simDat2, by = "id") # Erhaelt nur Faelle, die in beiden enthalten sind
bothSim <- full_join(simDat, simDat2, by = "id") # Erhaelt alle Faelle
bothSim <- left_join(simDat, simDat2, by = "id") # Erhaelt linke Faelle
bothSim <- right_join(simDat, simDat2, by = "id") # Erhaelt rechte Faelle


## x Dataframes umstrukturieren
# Wide und Long Format
simDat <- data.frame(id = 1:100,
                     trust_1 = round(rnorm(100, mean = 3.31, sd = 1.1)),
                     trust_2 = round(rnorm(100, mean = 2.91, sd = 0.8)),
                     trust_3 = round(rnorm(100, mean = 3.01, sd = 1.3)),
                     age = round(rnorm(100, mean = 33.31, sd= 21.1)))
# Annahme bei trust1 bis trust3 handelt es um Messwiederholungen der Variable trust

# Gerade liegt simDat im Wide-Format vor, da jedem Wert eine einzelne Spalte zugeordnet wird

# Im Long Format wird fuer jeden Messzeitpunkt eine eigene Zeile gewaehlt und 
# jede Person erhaelt so viele Zeilen, wie Messzeitpunkte
# Eine Variable erfasst dann die unterschiedlichen Messzeitpunkte

# Umwandeln mit pivot_longer
# - Die Variablen trust soll in einer Spalte erfasst und nach dem Messzeitpunkt aufgeschluesselt werden
# - Die Variablen id und age sollen erhalten bleiben

# Klassische Methode (echt bläh)
simDat_long <- reshape(simDat, direction = "long", varying = c("trust_1", "trust_2", "trust_3"), v.names = "Trust", times = names(simDat)[2:4])
# direction gibt Wandel an "to wide" oder "to long"
# wide to long
# varying = Variablen, die mehr Informationen enthalten (z.B. Messzeitpunkt)
# times = Name der Auspraegungen
# v.names = Name des Wertlabels
# id = Name der Schluesselvariable

# Neue Methode mit tidyverse
simDat_long <- simDat %>% pivot_longer( # Erstellt einen tibble
  cols = c(trust_1, trust_2, trust_3), # waehlt Var aus, die umgewandelt werden sollen
  names_to = "varname", 
  values_to = "wert")

# in simDat_long existieren fuer jede Versuchsperson drei Werte

simDat_long <- simDat %>% pivot_longer( 
  cols = -c(id, age), # waehlt Variablen aus, die bei der Umwandlung nicht berücksichtigt werden
  names_to = "varname", 
  values_to = "wert")

# Name der Variable und Meddzeitpunkt koennen auch in einer
# seperaten Spalte gespeichert werden
simDat_long <- simDat %>% pivot_longer( 
  cols = -c(id, age), # waehlt Variablen aus, die bei der Umwandlung nicht berücksichtigt werden
  names_to = c("varname", "time"),
  names_sep = "_", # Trennzeichen im Namen der Variable
  values_to = "wert")

# von long zu vide mit tidyverse
simDat_wide <- simDat_long %>% pivot_wider(
  names_from = c("varname", "time"), # Kombiniert Name aus varname und time
  names_sep = "_", # trennt Name mit _ 
  values_from = "wert" # nimmt Werte aus
)





## III Univariate deskriptive Statistik
# Erstellen einer kategoriellen Var
country <- rep(c("GER", "GB", "GER", "GER", "FR", "GER","GB", "FR", "GER", "GB"), 10)
simDat <- cbind(simDat, country)

sort(table(simDat$country), decreasing = T) # Moeglichkeit Tabelle zu sortieren

# Dispersionsmaße fuer nominale Variablen
# Der relative Informationsgehalt
# Annahme: Wenn alle Gruppen gleichmaeßig vorkommen ist die Streuung maximal
#          Wenn nur ein Merkmal gewaehlt wird, ist die Streuung minimal

# Formel: H = (- 1/ln(k)) * sum(hrel*ln(hrel))
# Hrel = relative Haeufigkeit
# k Anzahl der Kategorien

# >> 0 Entspricht alle haben dieselbe Kategorie gewaehlt (kleine Dispersion)
# >> 1 Entspricht die unterschiedlichen Kategorien wurden gleichoft gewaehlt (hohe Dispersion)

# Da es keine Funktion in R gibt, muss das Maß selbst berechnet werden
hj <- prop.table(table(simDat$country))       # Relative Haeufigkeiten erstellen
ln_hj <- log(hj)            # log. der relativen Haeufigkeiten

-1/log(dim(hj))*sum(hj*ln_hj)


# Moeglichkeit IQR mit describe ausgeben zu lassen
library(psych)
psych::describe(simDat$trust_1, IQR = T)

# describeBy, um sich Kennwerte fuer Gruppen ausgeben zu lassen
describeBy(simDat$trust_1, simDat$country)
by(simDat$trust_1, simDat$country, describe) # Alternative

# mit mat = T werden Werte in Tabellenform ausgegeben
describeBy(simDat$trust_1, simDat$country, mat = T)




## IV Bivariate Inferenzstatistik
# Kontingenztabelle mit Spalten- & Zeilensumme
status <- dplyr::recode(sample(1:2, 100, replace=T, c(0.6, 0.4)), 
                        '1' = "student",
                        '2' = "teacher")
simDat <- cbind(simDat, status)
addmargins(table(simDat$country, simDat$status))

# Moeglich relative Haeufigkeiten in Bezug auf Zeilen- (1) oder 
# Spaltensumme (2) anzeigen zu lassen
prop.table(table(simDat$country, simDat$status), 1)
# 11 Franzoesische Studierende / 20 Franzoesische Persoenen
# = 55% der Franz. Personen sind Studierende
11/20 

prop.table(table(simDat$country, simDat$status), 2)
# 11 Franz. Studierende/ 62 Studierende
11/62 
# 17.7 % der Studerenden sind franzoesisch

## Zusammenhangsmaße fuer nicht-metrische Variablen (S. 135)
# - siehe Eid et al. (2017) >> S 539 im Reg. Kapitel
# - Die Funktionen association.measures() aus dem Paket oii
#   (Hale et al., 2017)
# - psych: polychoric(), tetrachoric(), byserial() und polyserial() 
#   fuer die jeweilige Art von Korrelation
# - vcd-Paket (Meyer et al., 2020) fuer spezielle Analysen von kat. Var




## V Wahrscheinlichkeitsverteilungen (S. 183)
# Es gibt verschiedene Wahrscheinlichkeitsverteilungen (norm. (norm()), 
# t- (t()), Chi²- (chisq()), F- (f()), binom (binom- etc.), 
# die in der Statistik relevant sein  koennen, um p-Werte 
# zu bestimmen

# Der Anfang der Funktion entscheidet, was bestimmt wird
# d = Dichte, q = Quantile, p = Wahrscheinlichkeit

# Visualisierung von Wahrscheinlichkeitsverteilungen
curve(dt(x, df = 100), lwd=2, -3, 3) # Visualisierung einer t-Verteilung mit df = 100
curve(dt(x, df = 1), col = "Royalblue", lty = 2, lwd=2, add = TRUE) 
curve(dt(x, df = 10), col = "Darkred", lty = 3, lwd=2, add = TRUE) 
## Skip fuer nicht im Zug... mit Laerm 9.9
legend("topright", 
       c("df = 1", "df = 10", "df = 100"), 
       lty = c(1, 2,3),
       lwd=2,
       col = c("Black", "Royalblue", "Darkred")) 

# mit ggplot
ggplot(data.frame(x = c(-3,3)), aes(x = x)) + 
  stat_function(fun = dt, args = list(df = 1), 
                linetype = 2, lwd = 1) + 
  stat_function(fun = dt, args = list(df = 10), 
                linetype = 3, lwd = 1, col = "blue") + 
  stat_function(fun = dt, args = list(df = 100), 
                linetype = 1, lwd = 1, col = "darkred")


# Quantile 
# diese werden benoetigt, um den kritischen Wert eines Verfahrens zu bestimmen
# z.B. fuer einen zwei-seitigen t-Test mit df = 128
qt(p = 0.025, df= 128) # bei einem t-Wert von |1.98| ist das Ergebnis mit p < .05 sig.
qt(p = 0.975, df= 128) # positive Seite pruefen


# Fuer einen einseitigen t-Test werden die 5% auf einer Seite der Verteilung ueberprueft
qt(p = 0.05, df = 128)  # - 1.66
# dementsprechen muessen niedrigere Testwerte fuer eine Sig. erreicht werden


# Berechnung von Flaechenanteilen bzw. p-Werten
# Wenn ein z-Werte einer Variable vorliegen (Standardisierung, M = 0, S = 1) kann
# der Anteil an Personen bestimmt werden, die einen niedrigeren oder hoeheren Wert haben

# z-Werte im 95% Konfidenzintervall im Bereich von [0.025, 0.975]
pnorm(-1.96, mean= 0, sd = 1) 
pnorm(1.96, mean= 0, sd = 1) # bei p < 0.5 im kritischen Test 

# z-Werte im 99% Konfidenzintervall
pnorm(2.57, mean= 0, sd = 1) 

# Oder zur Pruefung von Testwerten (t-Wert, F-Wert etc.) in Abhaenhigkeit der Freiheitsgrade
pt(q = c(-1.978671, 1.978671),  df = 128) # kritische Testwerte fuer t mit df = 128
# Unterhalb des Wertes von -1.978671 liegen, 2.499 % der Werte der Verteilung
# Die Wahrscheinlichkeit einen so niedrigen Testwert unter geltender Nullhypothese zu
# findenn ist also (bei einem gerichteten Test) < 2.5%


# Normalverteilungs-Tests
# Das Paket nortest (Gross & Ligges, 2015) enthaelt verschiedene statistische Tests
# zur Ueberpruefung der Normalverteilungsannahme: 
# - den Anderson-Darling-Test (ad.test)
# - den Cramer-von Mises-Test (cvm.test)
# - den Lilliefors-Test (lillie.test) 
# - den χ²-Test nach Pearson (pearson.test) 
# - den Shapiro-Francia-Test (sf.test). 

# >> Die Test sind jedoch sehr sensibel, weshalb sich nie ausschließlich 
#    auf diese verlassen werden sollte (v.a. bei großen Stichproben sind
#    leichte Abweichungen oft nicht relevant)



### VI Inferenzstatistische Verfahren
## x t-Test
# Der Mittelwert von trust unterscheidet sich nicht-sig von der GG (3.1)
t.test(simDat$trust_1, mu = 3.1) 

# Der Mittelwert fuer trust_1 unterscheidet sich nicht sig. von der GG;
# t(99) = 1.18, p = .24.



# H1: Lehrer (status = 2) haben ein groeßeres Vertrauen als Schueler
describeBy(simDat$trust_3, simDat$status)

t.test(simDat$trust_3~simDat$status, alternative = "less")
pt(-0.88, 73.046, lower.tail = T) # manuelle Bestimmung d. p-Wertes

# Bestimmung der Grenze, bei der p < 0.5
qt(0.05, df = 73.046,lower.tail = T)

## Alternative mit Levene-Test
library(DescTools)
LeveneTest(simDat$trust_3, as.factor(simDat$status), center=median)
# nicht-sig. deswegen liegt Varianz-Homogenitaet vor >> Students-t-Test

t.test(simDat$trust_3 ~ simDat$status, var.equal=T, alternative ="less")
# immernoch nicht signifikant

# Teststaerke mit Paket lsr
# relatives Maß
library(lsr)
cohensD(simDat$trust_3 ~ simDat$status)
0.857/0.143

# Alternativ mit Paket effsize
if(!require(effsize)){install.packages("effsize")}
library(effsize)

effsize::cohen.d(simDat$trust_3 ~ simDat$status) # gibt Interpretation mit aus

psych::cohen.d(simDat$trust_3, as.factor(simDat$status), data=simDat)

names(simDat)
## t-Test fuer abhaengige Stichproben
t.test(simDat$trust_1, simDat$trust_2, paired = T, alternative = "greater") 

# signifikanterUnterschied zwischen trst_1 und trust_2
lapply(list(simDat$trust_1, simDat$trust_2), psych::describe)

# Effektstaerke mit Cohens D
# unterschiedliche Formen der Berechnung denkbar, siehe ?cohensD, method-Argument

effsize::cohen.d(d = simDat$trust_1, f = simDat$trust_2, 
                 paired = TRUE, na.rm = TRUE, within = F)
cohensD(simDat$trust_1 - simDat$trust_2) # takes within subject variation into account
cohensD(simDat$trust_1, simDat$trust_2, method = "paired") # takes within subject variation into account


# Wilcoxon-Test (Alternative zum t-Test) 
# Wenn Bedingung der Normalverteilung der AV innerhalb der Testgruppen nicht erfuellt ist.
# Außerdem fuer ordinale AV geeignet
wilcox.test(simDat$trst ~ simDat$status, simDat, alternative = "less")

# Es gibt keinen signfikanten Unterschied mit dem Wilcoxon-Test


## x Varianzanalyse ohne Messwiederholung
# Die einfache aov()-Funktion aus Base-R ist gut fuer einfaktorielle Analysen
# geeignet, aber nicht fuer die ANOVA mit Messwiederholung oder mehrfaktorielle
# Analysen (deswegen wird aov_car() aus dem Paket afex verwendet)


# aov_car aus dem Paket afex (Singmann et al., 2020)
if(!require(afex)){install.packages("afex")}
library(afex)

simDat$trst_mean <- rowMeans(select(simDat, starts_with("trust")))
simDat[simDat$country == "FR",]$trst_mean <- round(simDat[simDat$country == "FR",]$trst_mean +0.2)


describeBy(simDat$trst_mean, country)
m1 <- aov_car(trst_mean ~ factor(country) + Error(id), simDat)
# Warnmeldung Converting to factor, fuer einfaktorielle ANOVA nicht relevant

summary(m1)
# Es gibt einen signifikanten Unterschied zwischen den Laendern im Bezug auf
# den Vertrauensindex, F(2, 97) = 7.36, p < .01.

# ANOVA als Regression
m1 <- aov(trst_mean ~ factor(country), simDat) # mit aov koennen auch Ergebnisse der Regression betrachtet werden
summary.lm(m1) # Gibt die Ergebnisse als Regression aus


# Leventest und Post-Hoc

LeveneTest(simDat$trst_mean, as.factor(simDat$country))
# nicht signfikant, daher liegt Varianzhomogenitaet vor.

# Klassische PostHocTest-Funktion nicht mit aov_car moeglich
PostHocTest(m1, method = "bonf")# Fehlermeldung
# Bei regulaerem Modell jedoch schon
m1_2 <- aov(trst_mean ~ country, simDat)
summary(m1_2)
PostHocTest(m1_2, method = "bonf")

# Stattdesen koennte die Funktion emmeans() aus dem Paket emmeans verwendet werden
if(!require("emmeans")){install.packages("emmeans")}
library(emmeans)
emmeans(m1, specs = "country") # gibt jeweils Mittelwerte und SE fuer jede Var aus

pairs(emmeans(m1, specs = "country")) # Ergebnis der paarweisen Mittelwertvergleiche


afex_plot(m1, x = "country") # aus dem Paket afex
# Zeigt Errorbars auf dem 95%tigen Konfidenzintervall


plot(emmeans(m1, specs = "country")) # mit Ergebnis von emmeans
# etwas schoenere Darstellung der Fehlerterme

ggplot(simDat, aes(x=as.factor(country), y = trst_mean)) + geom_point()

# j-Tools enthaelt eine Funktion, mit der die Darstellung apa-konform gemacht wird
ggplot(simDat, aes(x=as.factor(country), y = trst_mean)) + geom_point() + theme_apa()
# kann auch bei Funktionen oben ergaenzt werden



## x Kurskal-Wallis Test (Alternative zur einfaktoriellen ANOVA)
# - Wenn parametrische Voraussetzungen nicht erfuellt sind
kruskal.test(trst_mean ~ country, simDat)
# Es gibt einen sig. Unterschied zwischen den Laendern in ihrem Vertrauen, 
# Chi2(2) = 7.251, p < .05.

# Anschließend muss ein Post-Hoc-Test durchgefuehrt werden, um die Effekte zu verorten



## x Mehrfaktorielle ANOVA
# Dabei wird eine metrische UV mit 2 kategoriellen AV in Verbindung gesetzt
therapy <- c(rep(TRUE, 200), rep(F, 200))
intensity <- rep(c("high", "low"), 200)
height <- rep(NA, 400)

simDat2 <- data.frame(therapy, intensity, height)
simDat2[simDat2$therapy == T,]$height <- rnorm(200, mean = 24, sd = 2)
simDat2[simDat2$therapy == F,]$height <- rnorm(200, mean = 16, sd = 1)

simDat2[simDat2$therapy == T & simDat2$intensity == "high",]$height <- simDat2[simDat2$therapy == T & simDat2$intensity == "high",]$height + 3
simDat2[simDat2$therapy == F & simDat2$intensity == "low",]$height <- simDat2[simDat2$therapy == F & simDat2$intensity == "low",]$height -2


# Ausgeben der Mittelwerte in Abhaengigkeit der Gruppen
print(describeBy(simDat2$height, list(simDat2$therapy, simDat2$intensity), mat = T), digits = 3)

# Ausfuehren der ANOVA
simDat2 <- cbind(id= 1:400, simDat2)
m2 <- aov_car(height ~ therapy * intensity + Error(id), data = simDat2) 
# m2 <- aov_car(height ~ therapy * intensity + Error(id), data = simDat2, type="II") 

summary(m2)

# Bei einer mehrfaktoriellen ANOVA, muessen die richtigen Quadratsummen gewaehlt werden

# Typ-II (simultanes Testen der Haupteffekte ohne Interaktion) und Typ-III (Alle 
# Effekte werden simultan getestet >> klaert ob es Effekte ueber die Interaktion hinaus
# gibt) sind relevant und wirken sich auf die  F-Statistik der Haupteffekte aus 
# (jedoch nur wenn die Gruppen unterschiedlich groß sind)

# PostHocTests
# Unterschiedliche Moeglichkeiten Gruppen zu vergleichen
plot(emmeans(m2, specs = ~therapy*intensity)) # Visualisierung mit plot

# z. B. alle Mittelwerte
# aus einem 2 X 2 Design ergebnen sich 4 Mittelwerte
# = 3 + 2 + 1 = 6 Vergleiche
pairs(emmeans(m2, specs = ~therapy*intensity))


# z.B. bedingte Vergleiche
# Vergleich der Therapieform unter der Bedingung, dass die Intensitaet hoch oder niedrig ist
pairs(emmeans(m2, specs = ~ therapy | intensity))

pairs(emmeans(m2, specs = ~ intensity | therapy))

# Visualisierung des Zusammenhangs
afex_plot(m2, x = "therapy", trace = "intensity") # Visualisiert den Zusammenhang




## x Varianzanalyse mit Messwiederholung
# Dafuer muessen Daten im long-Format vorliegen
# also mehrere Messzeitpunkte vorliegen, die dann verglichen werden koennen
head(simDat_long)
describeBy(simDat_long$wert, simDat_long$time)

m3 <- aov_car(wert~ Error(id/time), simDat_long)
# in der Formel wird bei der Messwiederholung die Messzeitpunkt-Variable
# unter Error(id/var) aufgefuerht und dann eine Messwiederholungs-ANOVA durchgefuerht

# Ergebnisse mit m3 ausgeben lassen
m3 # Interpretiert, wie standard ANOVA
# df sind etwas komisch, da die Greenhouse-Geisser-Korrektur angewandt wurde, die
# relevant ist, wenn die Annahme der sphericity nicht erfuellt ist (siehe summary(m3))

summary(m3) # enthaelt Standard-Ausgabe ohne Korrektur und einen Test fuer Sphericity

# Mauchly Test fuer Sphericity
# >> bei sig. liegt keine Sphericity vor

# In dem Fall werden die Freiheitsgrade mit dem unter GG eps oder HF eps
# angegebenen Korrekturfaktor multipliziert
2* 0.91779 # z.B. fuer die ANOVA
198* 0.91779 # z.B. obere df = Output von m3
# was zum neu-angegebenen p-wert fuehrt

# Ausgabe der Mittelwerte
emmeans(m3, specs = "time")

# Vergleiche mit tukey
pairs(emmeans(m3, specs = "time"))

# Skip: Mehrfaktorielle gemischte Varianzanalyse (S. 228)



## x Regressionsanalyse
# alles klar # folgendes Interessant :D

# Hierarchische Regression
# Statt bei eine multiplen Regression alle Praediktoren auf einmal in das Modell
# aufzunehmen, koennen diese auch schrittweise (Var. fuer Var.) oder blockweise
# (in einer Gruppe von Variablen) aufgenommen werden.

# Das zentrale Maß zuer Bewertung der hierarchischen Regression ist der Deter-
# minationskoeffizient R2. Wenn das sparsamere Modell mit wenigen UVs mit dem
# Modell mit mehr UVs vergleichen wird, kann bestimmt werden wie viel Varianz
# die zusaetlich aufgenommenen Praediktoren erklaeren.

# Diese zusaetliche Erklaerkraft gegenueber dem sparsameren Modell kann mit einem 
# F-Test ueberprueft werden (wenn sig. ist das zweite Modell signifikant besser 
# fuer die Erklaerung geeignet).

# Wichtig ist, dass die Variablen aus der gleicher Grundgesamtheit stammen
# >> D.H. die Zeilen, die fehlende Werte enthalten muessen aus beiden Modellen 
# entfernt werden

dat <- read.csv("young_people.csv", header = T, stringsAsFactors = T)

# Hierarchische Regression 

# Zeilen mit fehlenden Werten entfernen
# Insgesamt gibt es 16 fehlende Werte in den Betrachteten Variablen
sum(is.na(dat[c("Happiness.in.life", "Unpopularity", "Mood.swings", "Number.of.friends", "Energy.levels")]))
newDat <- na.omit(dat[c("Happiness.in.life", "Unpopularity", "Mood.swings", "Number.of.friends", "Energy.levels")])

names(dat)
# Modell mit negativen Aspekten
m1 <- lm(Happiness.in.life ~ Unpopularity + Mood.swings, newDat)
summary(m1)

# Modell mit negativen + positiven Aspekten
m2 <- lm(Happiness.in.life ~ Unpopularity + Mood.swings + Number.of.friends + Energy.levels, newDat)
summary(m2)

# Als naechstes wird der Wert R2 fuer beide Modelle betrachtet
summary(m1)$r.squared
summary(m2)$r.squared

# Un die Differenz der Werte gebildet
summary(m2)$r.squared - summary(m1)$r.squared
# Das zweite Modell erklaert zusaetzlich 17.3% der Varianz der AV

# Vergleich der Modelle mit ANOVA
# Um zu ueberpruefen, ob der unterschied signifikant ist, wird eine ANOVA ausgefuehrt
# (Dies ist nur meoglich, wenn es sich um geschachtelte Modelle handelt, also 
# das kleinere Modell im großeren enthalten ist, sonst koennte das Akaike Information
# Criterion verwendet werden)

anova(m1, m2)
# Das zweite Modell erklaert signfikant mehr Varianz als das erste, F(2, 989) = 
# 112.81, p < .001.

# AIC(m1, m2) # zum Berechnen von AIC

# Annahmen der Regression pruefen
# - Normalverteilung + Homoskedastizitaet der Residuen
# - Ausreißer + stark einflussreiche Faelle entfernen
# - Keine Multikollinearitaet 
# - Unabhaengigkeit der Residuen
# >> Regressionsdiagnostik, Eid et al. (2017), S. 678

plot(m2)
# In Plot 1 sollten die Punkte unsystematisch sein und die rote Linie moeglichst
# parellel zur X-Achse, dann wurde das Modell richtig spezifiziert

# Plot 2 ist ein Q-Q Plot, in dem geprueft werden kann, ob die Residuen normal-
# verteilt sind. Dann sollten die Punkte auf der Diagonalen liegen

# Plot 3 Ueberprueft Homoskedastizitaet, die gegeben ist, wenn die Werte Punkte
# unsystematisch verteilt sind

# Plot 4 ist dazu da, um Ausreißer zu visualisieren (X =  Hebelwerte), Ausreißer
# haben hohe Hebelwerte. Diese sind nicht so schlimm, so lange sie nicht zu sehr 
# von den von der Regression vorhergesagten Werten abweichen (y = Std. Residuen
# nicht so groß sind).
# >> Besonders Einflussreiche Faelle werden mit Zeilennummern markiert


# Es gibt weitere Moeglichkeiten, um einflussreiche Faelle zu identifizieren
# Eid et al. (2017)
# - resid(modell) Unstandardisierte Residuen
# - rstandard(modell) Standardisierte Residuen
# - rstudent(modell) Ausgeschlossene studentisierte Residuen
# - dfbeta(modell) DfBETA
# - dfbetas(modell) DfBETAS
# - dffits(modell) DfFits
# - cooks.distance(modell) Cook’s Distanc


# Multikollinearitaet ueberpruefen
# Die Korrelation eines Praediktors mit den anderen wird ueber den Variance Inflation
# Factor (VIF) oder die Toleranz bestimmt (1/VIF) 

# VIF
# sollten nahe 1 und nicht > 10 sein  
library(car)
vif(m2)

# Toleranz
# sollte nahe 1 seien und nicht < 0.1
1/vif(m2)

# Unabaengigkeit d. Residuen
# Diese Annahme ist idR nur dann verletzt, wenn die Daten eine hierarchische 
# Struktur haben oder die Werte bei einer Laengsschnittstudie in serialer 
# Abhaengigkeit stehen.

# Hierarchische Daten
# Dabei besteht die Gesamtstichprobe aus mehreren Gruppen (z.B. Schulklassen,
# Therapiegruppen etc.). Dadurch sind die Personen haeufig den Gruppen aehnlich
# aus denen sie stammen. Diese Aehnlichkeit drueckt sich in Intraklassenkorrelationen
# aus. Wenn diese signifikant ist, sollte sie im Regressionsmodell beruecksichtigt
# werden.

# Seriale Daten
# Dabei kann es vorkommen, dass die Auspraegung eines Residuums zu einem bestimmten
# Zeitpunkt von einem frueheren Zeitpunkt abhaengt, wenn das der Fall ist, sollte 
# man ein geeignetes laengsschnittverfahren einsetzen.
# Dies kann mit dem Durbin-Watson_Test (durbinWatsonTest() aus dem Paket car) 
# geprueft werden.


# x Regression mit kategorieller Variable
newDat <- filter(dat, Education != "currently a primary school pupil" &
                   Education != "doctorate degree")

newDat$Education <- factor(newDat$Education, ordered = F, levels = c("primary school",
                                                                     "secondary school",
                                                                     "college/bachelor degree",
                                                                     "masters degree"))
# contrasts, gibt die bisher gesetzten Konstraste aus, die standardmaeßig fuer
# Faktoren in der Regression verwendet werden
contrasts(newDat$Education) # kann auch ueberschrieben werden, um neue Kontraste zu setzen

m1 <- lm(Happiness.in.life ~ Education, newDat)
summary(m1)

# Unstandardisierte Regressionkoeffizienten entsprechen den Mittelwert- 
# unterschieden der Auspraegung zur Basiskategorie
describeBy(newDat$Happiness.in.life, newDat$Education)

3.34-3.76 # Mittelwertunterschiede zw. primary und master

# mit relevel(var, base-Kategorie) ist es moeglich die Base-Kategorie fuer den 
# Vergleich umzustellen
newDat$Education <- relevel(newDat$Education, "masters degree")
newDat$Education <- relevel(newDat$Education, "primary school")

# Auch andere Kontraste sind moeglich:
contrasts(newDat$Education) <- contr.sum(4)
contrasts(newDat$Education)

# - Helmert 
# Ein orthagonaler Kontrast, der eine Gruppe stets mit dem Mittelwert der restlichen
# Gruppen vergleicht
contrasts(newDat$Education) <- contr.helmert(4)
contrasts(newDat$Education)


# Orthogonale Kontraste
contrasts(newDat$Education) <- cbind(c(-3, 1, 1 ,1), c(0, -2, 1, 1), c(0, 0 , -1 ,1 ))
contrasts(newDat$Education)

m1 <- lm(Happiness.in.life ~ Education, newDat)
summary(m1)
# Ergebnis zeigt, dass erste Gruppe sich sig. von den anderen unterscheidet.
# Aber sich die anderen nicht sig. voneinander unterscheiden p > .05

# collage degree sig. glueklicher als die restlichen Gruppen
describeBy(newDat$Happiness.in.life, newDat$Education)

mean(c(3.71, 3.76, 3.81, 3.34)) # Intercept entspricht dem Grand mean

1/4*(mean(c(3.71, 3.76, 3.81)) - 3.34) # b1 = 1/4 der durchschnittlichen Abweichung von der Basisgruppe
1/3*(mean(c(3.71, 3.81)) - 3.76) # b2 = 1/3 der durchschnittlichen Abweichung von Master
1/2*(3.71- 3.81) # b2 = 1/2 Mittelwertabweichung der letzten Kategorien

# Das teilen durch die Anzahl der Gruppen kontrolliert die family-wise Error-rate


# stellt urspruengliche Kontraste wieder her
contrasts(newDat$Education) <- contr.treatment(4, base = 1)
contrasts(newDat$Education)


# Bootsprapped Regression

# Eigenes Boostrapping mit for-Funktion
sample_coef_intercept <- NULL
sample_coef_x1 <- NULL

for (i in 1:1000) {
  #Creating a resampled dataset from the sample data
  sample_d = newDat[sample(1:nrow(newDat), nrow(newDat), replace = TRUE), ]
  
  #Running the regression on these data
  model_bootstrap <- lm(Happiness.in.life ~ Education, data = sample_d)
  
  #Saving the coefficients
  sample_coef_intercept <-
    c(sample_coef_intercept, model_bootstrap$coefficients[1])
  
  sample_coef_x1 <- rbind(sample_coef_x1, coef(model_bootstrap))
}
sample_coef_x1

# Bootstrapp mit Boot() aus car
dat2_na <- na.omit(dat2[c("stflife", "trstplc", "trstplt")])
# Benoetigt einen Datensatz ohne fehlende Werte
m2 <- lm(stflife~trstplc + trstplt, dat2_na)
library(car)
m_b <- car::Boot(m2_b, f = coef, 2000) 
# f = conf() gibt Funktion an, die relevante stat. Kennwerte enthaelt
summary(m_b) # Original enthalet die
confint(m_b)


## Bootsprapping mit boot()-Funktion
# Bootstrapped Korrelations-Koeffizienten

# Benoetigt eine Funktion, die das boot-sample erstellt
boot_function <- function(data, idx){
  df <- data[idx,]
  cor(df$trstplc, df$stflife, use="complete.obs", method="pearson")
}

bootstrap <- boot(dat2, boot_function, R=1000)
boot.ci(bootstrap, type="perc")

## Bootstrapped Regression (bei verletzter Normalverteilung)
boot_function <- function(data, idx){
  df <- data[idx,]
  fit <- lm(stflife ~ trstplc, data = df) # Klappt nur, wenn Formel hier spezifiziert wird 9.9
  return(coef(fit))
}

names(newDat)
library(boot)  
bootResults <- boot::boot(dat2_na, boot_function, R = 2000)
bootResults
boot.ci(bootResults, type="bca", conf = 0.95, index = 2, L =empinf(bootResults, index=1L, type="jack"))
# Ergaenzung mit L = empinf nur noetig, wenn es ohne nicht funktioniert


boot_function <- function(data, idx){
  df <- data[idx,]
  fit <- lm(Happiness.in.life ~ Education, data = df)
  return(coef(fit))
}

library(boot)  
bootResults <- boot::boot(newDat, boot_function, R = 2000)
bootResults
boot.ci(bootResults, type="bca", index = 1) # Bootstrap Intervall fuer Intercept (index = 1)
boot.ci(bootResults, type="bca", index = 2) # Bootstrap fuer ersten Koeffizienten 


## Moderation
names(newDat)

newDat$Self.criticism <- as.numeric(scale(newDat$Self.criticism, center = T, scale = F))
newDat$Loneliness_c <- as.numeric(scale(newDat$Loneliness, center = T, scale = F))


m1 <- lm(Happiness.in.life~ Self.criticism*Loneliness_c, newDat)
summary(m1)
# Es gibt eine singifkante Interaktionseffekt fuer den Einfluss von Selbstkritik 
# und Einsamkeit auf die Lebenszufriedenheit.

library(interactions)
interact_plot(m1, pred = Self.criticism, modx = Loneliness_c)
# Bei geringer Einfsamkeit weist Selbstkritik einen positiven Effekt auf das 
# Lebensgleuck auf, jedoch liegt dieser Effekt außerhalb des sinnvollen Wertebereichs,
# erst ab Loneliness_c < 3 signfikant, Werte bis -1.88 moglich.
# Bei steigender Einsamkeit wird dieser Effekt jedoch signifikant negavti negativ
# ab Loneliness_c > 0.23

johnson_neyman(m1, pred = Self.criticism, modx = Loneliness_c, 
               alpha = .05, sig.color = "blue", 
               insig.color = "grey") 
summary(newDat$Loneliness_c)

interact_plot(m1, pred = Loneliness_c, modx = Self.criticism)
# Der negative Effekt von Einsamkeit auf Lebensglueck wird staerker bei steigender
# Selbstkritik.


## x nicht-lineare Regression :D

# evtl. quadratisch
ggplot(newDat, aes(x = Empathy, y = Children)) +
  geom_jitter() +
  geom_smooth(method = "loess") +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), col = "green", lty = 2)

# Durchfuehren einer quadratischen Regression
m_q <- lm(Empathy ~ Children + I(Children^2), newDat)
summary(m_q)
# Quadratischer Effekt ist nicht signifikant >> evtl. zu klein


# wenn a (b2 aus b2*x^2 in Regression) < 0, dann geht die Kurve nach unten

# evtl kubisch (mit x^3)
ggplot(newDat, aes(x = Spending.on.looks, y = Happiness.in.life)) +
  geom_jitter() +
  geom_smooth(method = "loess") +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2) + I(x^3), col = "red", lty = 2)

m_k <- lm(Happiness.in.life ~ Spending.on.looks + I(Spending.on.looks^2) + I(Spending.on.looks^3), newDat)
summary(m_k)

# Signfikanter kubischer Effekt... was macht man damit?


# evtl. mit x^4
ggplot(newDat, aes(x = Finances, y = Happiness.in.life)) +
  geom_jitter() +
  geom_smooth(method = "loess") +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2) + I(x^3) + I(x^4), col ="purple", lty =2)

m4 <- lm(Happiness.in.life ~ Finances + I(Finances^2)  + I(Finances^3)  + I(Finances^4), newDat)



## x logistische Regression
# verwendet die Funktion glm(generalized linear model), da es eine 
# Verallgemeinerung des allgemeinen linearen modells ist
newDat$Village...town <- factor(newDat$Village...town, levels=c("village", "city"))
names(dat)

m1 <- glm(Village...town~Finances + House...block.of.flats, newDat, family = binomial)
summary(m1)

# Die Wahrscheinlichkeit in der Stadt zu leben sinkt mit steigendem Gehalt und 
# wenn man in einem Haus lebt p jeweils < .05.

# AIC sollte moeglichst klein sein

# Number of Fisher scoring, zeigt an wie viele Iterationen benoetigt wurden, um
# die Modellguete zu schaetzen (sollte < 25 sein).

# Der odds-Ratio laesst sich mithilfe der Koeffizienten des Modells berechnen
exp(m1$coefficients)
# da es sich hier um einen negativen Effekt handelt, sollten diese invertiert werden
# fuer die Interpretation
1/exp(m1$coefficients)

# Wenn eine Person in einem House wohnt, ist es 23mal unwahrscheinlicher, dass 
# sie in in der Stadt wohnt, als wenn sie in einem Wohnblock wohnt.

# Bei einem Anstieg der Finanzen sinkt die Wahrscheinlichkeit in der Stadt zu
# wohnen um ein 1.18-fache.




### VIII Verfahren fuer die Testkonstruktion
# x Explorative Faktorenanalyse

# a) Zunaechst wird geprueft, ob die Variablen ueberhaupt miteinander korrelieren
pairs.panels(newDat[c("Flying", "Storm", "Darkness", "Heights",
                      "Spiders", "Snakes", "Rats")])

library(Hmisc)
rcorr(as.matrix(newDat[c("Flying", "Storm", "Darkness", "Heights",
                         "Spiders", "Snakes", "Rats")]), type = "pearson")


# Bartell-Test
# prueft, ob die Korrelationen zwischen den Variablen = 0 sind
# wenn p< .05 deutet das darauf hin, dass die Faktorenanalyse moeglich ist
# >> Die Korrelationen sind ungleich 0
cortest.bartlett(newDat[c("Flying", "Storm", "Darkness", "Heights",
                          "Spiders", "Snakes", "Rats")])

# KMO - Kaiser-Mayer-Olkin-Kriterium
# Maß, dass die Summe der quadrierten Korrelationen in Relation setzt zu der
# Summe der quadrierten Korrelationen und der Summe der quadrierten verbleibenden
# partiellen Korrelationen (verbleibender linearer Zusammenhang zwischen i und j 
# nach Kontrolle der uebrigen Variablen)

# Interpretation:
# ab < .6 akzeptabel; ab < .7 gut; ab < .08 sehr gut
KMO(newDat[c("Flying", "Storm", "Darkness", "Heights",
             "Spiders", "Snakes", "Rats")])
# In dem Fall .76 >> also geeignet.
# "MSA for each item" nicht besonders auffaellig (kein besonders niedriger Wert
# dabei) >> allte Items koennen beibehalten werden



# b) Anzahl der Faktoren festlegen
# Kaiser-Kriterium (d. h., alle Faktoren mit einem Eigenwert > 1 werden extrahiert) 
pca1 <- principal(newDat[c("Flying", "Storm", "Darkness", "Heights",
                           "Spiders", "Snakes", "Rats")]) # aus psych

pca1$values # Gibt Eigenwerte aus. Wuerde darauf hindeuten 2 Faktoren zu extrahieren
# Eigenwert = Summe d. quadrierten Faktorladungen

# Scree-Test/ Elbow-Kriterium (d. h., Interpretation des Eigenwertverlaufs)
VSS.scree(newDat[c("Flying", "Storm", "Darkness", "Heights",
                   "Spiders", "Snakes", "Rats")])

# Starke Abflachung ab dem dritten Faktor, spricht dafuer, dass ab dem dritten
# die Erklaerkraft der Faktoren gering ist. Also werden zwei beibehalten.


# Bei der Parallelanalyse werden unsere Eigenwerte mit denen vergleichen, die man
# bei Zufallsdaten erwarten wuerde
# >> Es werden nur Faktoren Extrahiert, deren Eigenwerte ueber den zufaelligen liegen
fa.parallel(newDat[c("Flying", "Storm", "Darkness", "Heights",
                     "Spiders", "Snakes", "Rats")])

VSS(newDat[c("Flying", "Storm", "Darkness", "Heights",
             "Spiders", "Snakes", "Rats")])

# Verschiedene Methoden
# https://personality-project.org/r/book/Chapter6.pdf
# - So lange extrahieren bis wie der Chisq-Wert der Residuenmatrix (eChisq) nicht
#   signifikant ist (Haengt aber von der Stichprobengroesse ab)
# - VSS (very simple structure) ... ist nicht so einfach > hoechster
#   Wert in Abhaengigkeit von der Komplexitaet optimal
# - map: optimale Faktorenloesung bei geringstem Wert
# - RMSEA sollte moeglichst klein sein

# Mit der BassAckward-Methode lassen sich relativ schnell Faktorloesungen
# fuer eine unterschiedliche Anzahl von Faktoren praesentieren
bassAckward(newDat[c("Flying", "Storm", "Darkness", "Heights",
                     "Spiders", "Snakes", "Rats")], n = 2, rotate = "oblimin")



# c) Durchfuehren der Faktorenanalyse
# Hier muss die Entscheidung getroffen werden, welches Extraktionsverfahren 
# gewaehlt wird z.B. Hauptachsenanalyse oder Maximum Likelihood Analyse 
# (siehe Eid et al. 2017)
library(GPArotation)

# Hauptkomponentenanalyse
# (deskriptives Verfahren, das versucht gesamte Varianz mit den Komponenten zu 
# erklaeren)
# Die Faktoranalyse ml und pfa hingegen versuchen nur die beob. Korrelation unter
# den Variablen auf uebergeordnete Faktoren zurueckzufuehren
pca1 <- principal(newDat[c("Flying", "Storm", "Darkness", "Heights",
                           "Spiders", "Snakes", "Rats")],
                  nfactors=2, rotate="oblimin")

pca1
# Es enstehen zwei Faktoren: 1. Tierphobien und 2. Situative- und Umwelt-Phobien
# Items laden eindeutig auf einzelne Faktoren (Faktorladung > .4)


# h2 (Komunalitaet) = Anteil der Varianz d. durch die Faktoren erklaert wird
# u2 (Uniqueness)   = Anteil d. Varianz d. unerklaert bleibt/ verloren geht
# com (complexity)  = Anzahl an Faktoren, die benoetigt werden, um diese Var zu
#                     erklaeren >> sollte nahe 1 sein


# Auch hier: Eindeutige Fakotrenladung > .4 ideal
# SS Loadings      = Eigenwerte
# Proportional Var = proz. Anteil der durch den Faktor erklaerten Gesamtvarianz
# cumulative Var   = Addiert Prozentanteile auf
# Proportion explained = Prozentanteil, den Faktor zur Erklaerung der erklaerten 
#                        Var beitraegt (.24/.47 = 51%)

# RSME gibt eine Einschaetzung ueber die unerklaerte Varianz und sollte unter .1 liegen
# >> in dem Fall groeßer als .1

# Guetekriterien der konf. Faktorenanalyse siehe unten

# Maximum Likelihood Analyse
# (Inferenzstatistische Verfahren)
# Wenn diskrete Variablen vorliegen (z.B. Likert-Skalen) dann kann die
# Faktorenanalyse auch auf Basis der polychorischen Korellation durchgefuert
# werden (cor = "poly") >> dann laut Luhmann 2020 sinnvoll

# Annahmen: 
#- multivariaite normalverteilung der analysierten Variablen 
#- Beobachtungen sind unabhängig voneinander 
#- Modell ist korrekt spezifiziert, d. h. speigelt wahre Kovarianzstruktur in Pop. wieder
#- die Stichprobe ist hinreichend 

ml1 <- fa(newDat[c("Flying", "Storm", "Darkness", "Heights",
                   "Spiders", "Snakes", "Rats")], nfactors = 2, fm = "ml", 
          rotate = "oblimin", cor = "poly")
print(ml1, digits=2, cut = .2, sort = T)

# Nachfolgende Tabelle enthaelt Korrelationen der Faktoren untereinander
# Und schließlich einige statistische Kennwerte, die nicht erklaert werden...

# Hauptachsenanalyse (PFA)
# (Inferenzstatistische Verfahren)
pfa1 <- fa(newDat[c("Flying", "Storm", "Darkness", "Heights",
                    "Spiders", "Snakes", "Rats")], nfactors = 2, fm = "pa", 
           rotate = "oblimin", cor = "poly")
print(pfa1, digits=2, cut = .3, sort = T)



# d) Erstellen und Benennen der Faktoren
newDat$fear_critters <- rowMeans(newDat[c("Spiders", "Snakes", "Rats")])
newDat$fear_environment <- rowMeans(newDat[c("Flying", "Storm", "Darkness", "Heights")])

psych::describe(newDat$fear_environment, IQR = T)


# Weitere Verfahren
# - hierarchische explorative Faktorenanalyse (nimmt an, dass es Faktoren hoeherer
#   Ordnung gibt, die die Varianz unter den Faktoren erklaren)
# - Bifaktor-Faktorenanalyse (nimmt an, dass es einen Generalfaktor gibt, auf den
#   einige Faktoren laden und weitere Faktoren, die die Beziehung der Items erklaren,
#   die nicht auf den Generalfaktor zurueckzufuehren sind)



## x Lineare Strukturgleichungsmodelle

# werden in R mit dem Paket lavaan berechnet
# install.packages("lavaan")
library(lavaan)

# a) Eingangsbeispiel: Regression mit lavaan
gleichung <- 'Happiness.in.life ~ Number.of.friends + Unpopularity'
m1 <- sem(gleichung, newDat)
summary(m1)

# Beide Effekte signifikant + enspricht dem Output einer Regression mit lm()


# b) Pfadmodell mit Mediatorvariable
# Number.of.friends als Mediator, der durch Unbeliebtheit beeinflusst wird,
# und schliesslich einen Effekt auf die Lebenszufriedenheit hat

gleichung <- 'Number.of.friends ~ Unpopularity
              Happiness.in.life ~ Number.of.friends + Unpopularity'

m1 <- sem(gleichung, newDat)
summary(m1)
# Interpretation der Parameter:
# Das Modell enthaelt 5 Paramete, die mit der Maximum Likelihood (ML) Methode 
# geschaetzt wurden, wozu eine Iteration benoetigt wurd  

# von 994 Faellen konnten 987 verwendet werden, da diese Werte fuer die betrachteten
# Variablen enthielten

# Das Modell gibt folgende Effekte aus:
# - Effekt der UV auf Mediator (a): b = -0.069, p < .05
# - Effekt des Mediators auf AV (b): b = 0.244, p < .001
# - (direkter) Effekt der UV auf AV (c'): b = -0.052, p < .05

# Um den indirkten Effekt genau zu bestimmen, muss die Gleichung jedoch angepasst
# werden:

gleichung <- 'Number.of.friends ~ a*Unpopularity
              Happiness.in.life ~ b*Number.of.friends + c*Unpopularity
              indirekt := a * b 
              total := c + (a * b)'
m1 <- sem(gleichung, newDat)
summary(m1)

# Die ersten Zeilen enthalten die gleichen Zeilen wie zuvor, geben nun jedoch
# den Modellparametern die Namen (a, b und c)

# Operatoren in Modellen
# =~ Definition einer latenten Variable, die durch nachfolgende Items gemessen wird
# ~  Regression (wird vorhergesagt durch)
# ~~ Kovarianz (korelliert mit) z.B. F1 ~~ F2
# ~~ (Residual-) Varianz, Kovarianz einer Var mit sich selbst z.B. F1 ~~ F1
# := Definition eines neuen Parameters
# ~1 Achsenabschnitt

# Es Gibt verschiedene Verfahren einen indirekten Effekt auf Signifikanz zu
# pruefen (Meist werden asym. Konfidenzintervalle mit Bootstrapping empfohlen)

m1 <- sem(gleichung, newDat, se = "bootstrap") 
# Modell wird nun 1000 mal geschaetzt, weshalb dide Ausfuerhung etwas laenger dauert
summary(m1)

# Die Konfidenzintervalle fuer den indirekten Effekt

parameterEstimates(m1, ci = TRUE, 
                   boot.ci.type = "bca.simple") 
# Wenn 0 nicht enthalten ist, deutet das auf einen signifikanten Effekt hin



# c) Konfirmatorische Faktorenanalyse
# Wird verwendet, um die Guete eines Messmodells zu ueberpruefen
gleichung <- 'fear_critters =~ Spiders + Snakes + Rats
              fear_environment =~ Flying + Storm + Darkness + Heights
              fear_environment ~~ fear_critters'

m1 <- cfa(gleichung, newDat)
summary(m1, fit = T)

# Model Test User Model (Chi2-Anpassungstest):
# Drueckt aus wie gut das Modell auf die Daten passt
# >> H0: Beobachtete Varianz-Kovarianz-Matrix ist gleich der vom Modell aufgestellten
# >> Signfikanz spricht dafuer, dass das Modell nicht so gut zu den Daten passt p < .001

# Model Test fuer Baseline Model (CHi2)
# Klaert, ob das Modell besser ist, als das restriktivste (Ladungskoeff. = 1,
# Varianzen der Faktoren = 0, Korrelation unter Faktoren = 0)

# Darauf folgen einige Maße der Modellguete (siehe Eid et al. 2017)
# - RMSR kann nur in Abhaenigigkeit zur Varianz eingeschaetzt werden
#   >> DER standardisierte Wert davon sollte gegen 0 gehen. (Werte > .08 deuten auf
#      geringe Passung der Daten hin
# - RMSEA < .05 (manchmal auch < .1 akzeptabel)


# Diese koennen auch mit fitmeasures(m1) betrachtet werden
# Außerdem moeglich Modifikationsindizes mit modindices(m1) anzufordern


# Am Ende werden Ladungskoeffizienten und Residualvarianzen ausgegeben
# Ladung der ersten Variable wird bei lavaan auf 1 fixiert (um d. Modell zu fixieren
# und die latente Var. zu skalieren)


# Modellvergleiche
# Likelihood-Ratio-Vergleiche bei geschachtelten Modellen moeglich
# dafuer wird die Funktion anova(m1, m2) verwendet >> sig deutet darauf hin, 
# dass das komplexere Modell besser geeignet ist


# Kombination von Mess- und Strukturmodellen
# Es ist auch moeglich ein Strukturmodell, dass den Einfluss von latenten Variablen
# untersucht, mit Messmodellen fuer die latenten Variablen zu kombinieren

gleichung <- 'fear_critters =~ Spiders + Snakes + Rats
              Pets ~ fear_critters + Unpopularity'
m1 <- sem(gleichung, newDat)
summary(m1, fit = T)


## Bei komplexen Modellen sollten diese auch mit Pfeildiagrammen visualisiert werden
# install.packages("lavaanPlot")
# install.packages("semPlot")
library(semPlot)
library(lavaanPlot)


semPaths(m1, whatLabels = "est", layout = "spring", 
         layoutSplit = TRUE, rotation = 2)

# Geht auf jeden Fall schoener... mit Netzwerkanalyse skript

# Zukunft:
# blavaan (Merkle & Rosseel, 2018) für Bayesianische Strukturgleichungsmodelle 
# semTools (Jorgensen et al., 2019) für Funktionen zur Prüfung von Messinvarianz und Poweranalysen



## Mehrebenenanalysen
# immer das Verfahren, wenn man es mit hierarchisch strukturierten Gruppen zu tun hat.
# Dabei lassen sich Faelle immer genau einer uebergeordneten Gruppe zuordnen
# z.B. Schueler (Ebene 1), Klassen (Ebene 2)
# z.B. Beschaeftigte (Ebene 1), Teams (Ebene 2), Abteilungen (Ebene 3)
# z.B. auch Laengsschnittdaten: Messzeitpunkt (Ebene 1), Personen (Ebene 2)

## >> Betrachtung ausgesetzt, da es gerade nicht so relevant erscheint


