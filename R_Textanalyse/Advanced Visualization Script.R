##########################################################
## MA Aufbaukurs Datenanalyse mit R
## Dozent: Manuel Kulzer (MA)
## Sitzung IV Datenvisulisierung - Begleitendes Skript 
## 17.03.2022

# GGf. Muss das Arbeitsverzeichnis festgelegt werden, damit die Dateien geladen
# werden koennen.
# setwd("C:/Users/mkulzer/Desktop/MA Aufbaukurs Datenanalyse/R")
getwd()

# Installation der benoetigten Pakete
if(!require("haven")){install.packages("haven")}
library(haven)

if(!require("ggplot2")){install.packages("ggplot2")}
library(ggplot2)

if(!require("naniar")){install.packages("naniar")}
library(naniar)

# Einlesen der Datensaetze
dat <- read.csv("mediaUsage.csv", header=T, stringsAsFactors = T)
dat <- replace_with_na_all(dat, condition=~.x==-99)
dat[dat$age==222,]$age <- 22

dat2 <- read_sav("ESS7DE.sav")


# 0 Einfuehrung in ggplot

# ggplot() erzeugt Grafiken mithilfe von Ebenen:
# Bestandsteile:
# - Datensatz (dat) 
#   Legt die zu visualisierenden Daten fest
# - Grafische Elemente Legen fest, welche Form der 
#   Visualisierung verwendet wird geoms oder stat_functions 
#   Skalen, Beschriftungen und Legenden
# - Ästhetische Elemente (aes())
#   Legt grafische Parameter fest (z. B. Farbe, Transparenz, 
#   Schriftgröße etc.)(bis auf Kennzeichnung der Achsen optional)

ggplot(dat, aes(prefMed))
# Erzeugt beispielsweise ein leeres Koordinatensystem

# I Univariate Analyse
# Mit dem Hinzufuegen von Geoms werden grafische Darstellung
# in den Koordinatensystemen ergaenzt

# a) Balkendiagramm (geom_bar)
ggplot(dat, aes(prefMed)) + 
  geom_bar() 

# b) Boxplots (geom_boxplot)
# x bzw y bei der Angabe der Achsen bestimmen die Ausrichtung
# des Boxplots.
ggplot(dat, aes(x=soMedTime)) + 
  geom_boxplot() 

ggplot(dat, aes(y=soMedTime)) + 
  geom_boxplot()

# c) Histogramme (geom_hist)
ggplot(dat, aes(x=soMedTime)) + 
  geom_histogram()

# binwidth = 10 bestimmt die Groeße der Gruppen, in denen die 
# Variable zusammengefasst wird (ein Balken umfasst 10 Minuten)
ggplot(dat, aes(x=soMedTime)) + 
  geom_histogram(binwidth=10) 

# aes(y = ..density..)) wandelt die Y-Achse von absoluten 
# Haeufigkeiten in Dichte um

ggplot(dat, aes(x=soMedTime)) + 
  geom_histogram(aes(y=..density..))+
  theme_grey(base_size=13)


# II Bivariate Visualisierung
# Meistens interessiert man sich nicht nur für ein einziges, 
# sondern gleichzeitig für zwei oder mehrere Merkmale und 
# ihr Verhaeltnis zueinander.

# Um eine bivariate Visualisierung zu erstellen, muessen
# auch immer zwei Variablen in ggplot angegeben werden.
# - Entweder zur Bestimmung der x- und y-Achse 
# - Oder zum Einfaerben Visualisierungselemente

# a) gestapeltes Balkendiagramm
ggplot(dat, aes(x=prefMed, fill=student))+geom_bar()

# position ="dodge" laesst die Balken nebeneinander erscheinen
ggplot(dat, aes(x=prefMed, fill=student))+geom_bar(position="dodge")

# b) boxplots nach Gruppen
ggplot(dat, aes(student, soMedTime)) + 
  geom_boxplot() 

# Um die Darstellung umzudrehen, muss coord_flip() verwendet werden
ggplot(dat, aes(student, 
                soMedTime)) + 
  geom_boxplot() + coord_flip()

# Eine Alternative ist facet_wrap
# Es zerlegt den Datensatz in Subsets (students und non-students) 
# und erstellt die gleiche Grafik für die Teildatensaetze
ggplot(dat, aes(y=soMedTime)) +geom_boxplot() + facet_wrap(~student)

# c) Streudiagramme (geom_point)
ggplot(dat2, aes(agea, inwtm)) + geom_point()

# Im Gegensatz zu geom_point() werden die Daten mit geom_jitter() 
# minimal, zufällig variiert, damit sich die Punkte besser 
# voneinander abheben 
ggplot(dat2, aes(agea, inwtm)) + geom_jitter()

## Zum Interpretieren
ggplot(dat, aes(age, soMedTime)) + geom_jitter() + 
  ylab("Social Media Nutzung [min]") +xlab("Alter")

ggplot(dat, aes(age,tvTime)) + geom_jitter() + 
  ylab("Fernsehnutzung [min]") +xlab("Alter")


# III Optionale Grafikelemente in ggplot

# a) Basiselemente
# Beispiel Histogramm
ggplot(dat, aes(x=soMedTime))+ 
  geom_histogram(fill="Royalblue", colour="Black", size = 1)

# fill bestimmt die Fuellfarbe
# colour bestimmt die Farbe der Formgrenzen
# size bestimmt die Breite der Formgrenzen (in mm)

# Als Argument für die Farben können die Standardbezeichnung von 
# Base-R ("Royalblue", "Black" etc.) oder Hexcodes ("#FFFFFF", 
# "#fccf03") verwendet werden.

# Beispiel Scatterplot

ggplot(dat2, aes(agea, inwtm)) + geom_point(alpha=.3, size=2)
ggplot(dat2, aes(agea, inwtm)) + geom_point(shape=12, size=4)
# alpha = x bestimmt die Transparenz der Datenpunkte (x, zwischen 0 und 1)
# size = x bestimmt die Größe der Datenpunkte (x in mm)
# shape = x bestimmt die Form der Datenpunkte (1-25)

# Farben nach Gruppen
# Ohne Farbeinstellung
ggplot(dat, aes(prefMed, soMedTime, fill=prefMed)) + 
  geom_boxplot()

# mit Farbpalette
ggplot(dat, aes(prefMed, soMedTime, fill=prefMed)) + 
  geom_boxplot() + scale_fill_brewer(palette="Blues") 

# mit selbstausgewaehlten Farben
ggplot(dat, aes(prefMed, soMedTime, fill=prefMed)) + 
geom_boxplot() + scale_fill_manual(values=c("Facebook"="#4267B2", "Instagram"="#bc2a8d", 
"Snapchat"="#FFFC00", "Twitter"="#1DA1F2", "Whatsapp"="#25D366"))

# Beispiel kontinuierliche Variable
ggplot(dat, aes(age, soMedTime, colour=tvTime)) + 
  geom_point(size=3) + scale_fill_distiller(palette="Reds", aesthetics = "colour")


# b) Achsen und Beschriftungen
ggplot(dat, aes(age, soMedTime)) +  geom_point(size=2) + 
  ylab("Social Media Nutzung [min]") + 
  xlab("Alter der Versuchspersonen [Jahren]")+
  ggtitle("Streudiagramm", "Zusammenhang von Alter und Social Media Nutzung")

# xlab("title") und ylab("title") fuegt Beschriftungen der - bzw. 
# Y-Achse hinzu
# ggtitle("title", "subtitle") fuegt einen Titel hinzu

ggplot(dat, aes(age, soMedTime)) +  geom_point(size=2) + 
  ylim(0,600) +  xlim(0, 50)

# xlim(start, end) und ylim(start, end) definieren den abgebildeten
# Bereich der Y- bzw. Y-Achse

# c) Trendlinien
# Histogram mit Normalverteilung
ggplot(dat, aes(x=soMedTime))+ geom_histogram(aes(y=..density..)) + 
  ylab("Dichte") + xlab("Social Media Nutzung [min]")+ 
  stat_function(fun=dnorm, args=list(mean(dat$soMedTime, na.rm=T), sd(dat$soMedTime, na.rm=T)), colour="Blue", size=1)

# Regressionsgeraden
ggplot(dat, aes(age, soMedTime)) +  geom_point(size=2) + 
  ylab("Social Media Nutzung [min]") + 
  xlab("Alter der Versuchspersonen [Jahren]")+
  geom_smooth(method="lm", se=F)

# d) Themen
ggplot(dat, aes(age, soMedTime)) +  geom_point(size=2) + 
  ylab("Social Media Nutzung [min]") + 
  xlab("Alter der Versuchspersonen [Jahren]")+
  geom_smooth(method="lm", se=F) + theme_bw()

ggplot(dat, aes(age, soMedTime)) +  geom_point(size=2) + 
  ylab("Social Media Nutzung [min]") + 
  xlab("Alter der Versuchspersonen [Jahren]")+
  geom_smooth(method="lm", se=F) + theme_dark()



#### Zusatz
ggplot(dat, aes(prefMed, soMedTime)) +  stat_summary(fun=mean, geom="point")+
  stat_summary(fun.data=mean_cl_normal, geom="errorbar", width=.2)

m1 <- aov(soMedTime~prefMed, dat)

summary(m1)






# barplot
ggplot(dat, aes(x=eduade1)) + geom_bar() 

# boxplot
ggplot(dat, aes(x=lrscale)) + geom_boxplot()
summary(dat$lrscale)


# Simple histogram
ggplot(dat, aes(x=agea)) + 
  geom_histogram(binwidth=5, col="Black") 

# Histogram with normal curve
ggplot(dat, aes(x=agea)) + 
  geom_histogram(aes(y= ..density..), col="Black") +
  stat_function(fun=dnorm, colour ="red", 
                args=list(mean=mean(dat$agea, na.rm=T), 
                          sd=sd(dat$agea, na.rm=T)))

# Bivariate
View(dat)

# Boxplots
ggplot(dat, aes(y=lrscale)) + geom_boxplot(fill="Royalblue") + facet_wrap(~gndr)

ggplot(dat, aes(y=lrscale)) + geom_boxplot(fill="Royalblue") + facet_wrap(~gndr)

ggplot(dat, aes(x=as.factor(gndr),y=lrscale, fill=as.factor(gndr))) + geom_boxplot()

ggplot(dat, aes(x=as.factor(gndr),y=lrscale, colour=as.factor(gndr))) + geom_boxplot()

# 

ggplot(dat, aes(x=tvtot, y=tvpol))+geom_point()+
  geom_smooth(method=lm)
ggplot(dat, aes(x=tvtot, y=tvpol))+geom_jitter()+
  geom_smooth(method=lm)


ggplot(dat, aes(x=tvtot, y=tvpol))+geom_jitter()+
  geom_smooth(method=lm)

ggplot(dat, aes(x=tvtot, y=tvpol))+geom_jitter(aes(colour="blue"))+
  geom_smooth(method=lm)




names(dat)
?dnorm

qqplot(dat, aes(dat$agea))+ geom_qq()
psych::describe(data$neuro)

rnorm(data$neuro, mean(data$neuro), sd(data$neuro))
?dnorm
?curve
densityPlot(data$neuro, freq=F)
?hist
# QQ Plot for normality testing
qplot(sample=dat$agea, stat="qq")
qplot(sample=rnorm(1000, 10, 2), stat="qq")
summary(dat$agea)
psych::describe(dat$agea)
boxplot(dat$lrscale)

names(data)
m1 <- lm(horiPriv~neuro, data)
summary(m1)


# Text hinzufügen
ggplot(dat, aes(prefMed)) + 
  geom_bar() + 
  geom_text(aes(y=..count..+2, label=..count..), stat="count")