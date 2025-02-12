########################################
## BA Statistik und Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Hausaufgabe IV Deskriptive Statistik - Loesungen 
## 22.03.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die 
# Dateien geladen werden koennen.
setwd("C:/Users/mkulzer/Desktop/BA Statistik und Datenanalyse mit R/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("questionr")){install.packages("questionr")}
library(questionr)

if(!require("psych")){install.packages("psych")}
library(psych)


# Aufgabe 1
# Lest die Datei ESS7DE.sav ein und beschreibt den Datensatz:
dat <- read_sav("ESS7DE.sav")

# A) Beschreibt die Stichprobe: Wie viele M‰nner und Frauen sind
#    befragt worden (gndr)? Was sind Mittelwert, Standardabweichung 
#    und Median des Alters (agea)? Welcher Bildungsgrad kommt am 
#    haeufigsten vor (eduade1)? (Mit Antwortsaetzen)

print_labels(dat$gndr) # Label zeigen, dass 1 = Male; 2 = Female
table(dat$gndr, useNA="always")
# 1545 Personen im Datensatz haben das Geschlecht maennlich ausgewaehlt
# und 1500 Personen das Geschlecht weiblich. Keine Person hat sich bei
# der Angabe des Geschlechts enthalten.

questionr::freq(dat$gndr) 
# In der Loesung mit questionr werden die Label sofort angegeben


# Das durchschnittliche Alter der Stichprobe liegt bei einem Mittelwert 
# von M = 49.9 (SD = 18.39). Der Median ist 51.

# Alternativ, koennen die Werte auch einzeln angegeben werden:
mean(dat$agea, na.rm=T) # wichtig: na.rm=T mitangeben!
sd(dat$agea, na.rm=T)
median(dat$agea, na.rm=T)

# Modus: Bildungsstand
print_labels(dat$eduade1)
# 0 = Grundschule nicht beendet
# 1 = Grundschule beendet, keinen weiterf. Abschluss
# 2 = Volks-/Hauptschule mit Abschluss (8. oder 9. Klasse)
# 3 = Mittlere Reife/ Realschulabschluss
# 4 = Fachhochschulreife
# 5 = Abitur

table(dat$eduade1) 
# Mittlere Reife ist mit 1043 Personen am haeufigsten in der Stichprobe
# vertreten.

# In dem Fall ist questionr aufgrund der langen Labelbezeichnung 
# sehr unuebersichtlich
questionr::freq(dat$eduade1)


# B) Welche Maﬂe der zentralen Tendenz und Streuung sind f¸r die 
#    Variablen Interviewdauer (inwtm) und politische Fernsehnutzung 
#    (tvpol) am besten geeignet? Begruendet Eure Antwort (Antwortsatz) 
#    und gebt die resultierenden Werte an.

dat$inwtm 
# Bei der Interviewdauer, hadelt es sich um eine metrische (ratioskalierte)
# Variable, daher sollte der Mittelwert und die Standardabweichung 
# angegeben werden
psych::describe(dat$inwtm)
# Die durchschnittliche Interviewdauer betraegt 70.61 Minuten (SD = 23.59).

# Wenn man sich die absoluten Haeufigkeiten ausgeben laesst wird deutlich,
# dass bei der Interviewdauer ein Ausreiﬂer enhalten ist. 
table(dat$inwtm) # 462 hebt sich deutlich von den anderen Werten ab.
# Deswegen koennte man auch argumentieren, dass der Median angegeben 
# werden sollte.

print_labels(dat$tvpol)
# Aus den Labels der Variable fuer politische Fernsehnutzung geht ein 
# ordinales Skalenniveau hervor (besonders gut erkennbar an der 
# Auffangkategorie "More than 3 hours"). Deshalb sollte hier der Median
# und der Quartilsabstand bzw. die Spannweite angegeben werden.
summary(dat$tvpol)
# Der Median der Fernsehnutzung liegt bei 2, was einer Nutzungsdauer 
# zwischen einer halben und einer Stunde entspricht. Der Interquartilsabstand
# ergibt sich aus dem unteren Quartil (1 = weniger als eine halbe Stunde) und 
# dem oberen Quartil (2 = eine halbe Stunde bis eine Stunde) und ist 
# daher eins. 50% der Faelle liegen in diesem Bereich.

# Optional: Betrachtet die deskriptiven Kennwerte (z. B. Schiefe) der 
# Variable Lebenszufriedenheit (stflife) und gebt auf Basis dessen eine 
# Einschaetzung ¸ber das Aussehen der H‰ufigkeitsverteilung der 
# Variable ab.
describe(dat$stflife)

# Die Schiefe von -1.15 zeigt an, dass es sich um eine rechtssteile 
# (Die Merkmalsauspraegungen im rechten Bereich der Skala wurden haeufig 
# gewaehlt, sodass sich ein steiler Abfall nach dem Hoehepunkt ergibt) 
# und linksschiefe (die Merkmale im linken Bereich wurden vergleichsweise
# wenig gewaehlt, sodass ich ein schwacher Anstieg zum Hoehepunkt ergibt)
# Verteilung handelt.
# (Die Kurtosis > 0 gibt auﬂerdem an, dass die Verteilung eher spitz ist,
# also einen Hoehepunkt hat, der sich visuell deutlich von den restlichen 
# Werten abhebt) 

table(dat$stflife)
# Aus der Haeufigkeitstabelle geht hervor, dass der Hochpunkt bei 8 liegt.
# der Mittelwert liegt links davon bei M = 7.42.

