#############################################################
# Task: GitHub Tutorials (Niekler & Wiedemann)
# https://tm4ss.github.io/docs/index.html
#
# Basics of Textmining

# Tutorial 1: Web Crawling and Scraping
# I Vorbereitung
# a) Installiere phantomJS via webdriver
#install.packages("webdriver")
library(webdriver)
install_phantomjs()

# b) Start an instance of phantomJS
pjs_instance <- run_phantomjs()
pjs_session <- Session$new(port=pjs_instance$port)


# II Crawling a single webpage
url <- "https://www.theguardian.com/world/2017/jun/26/angela-merkel-and-donald-trump-head-for-clash-at-g20-summit"
library(rvest) # for scraping

# a) Dynamic Wegpages
# Lade die Website in einer phantomJS Session
pjs_session$go(url)

# Speichere den Source Code der Website in einem neuen Object
rendered_source <- pjs_session$getSource() # Enthaelt den Source Code

# Wandel den Source Code in eine html-Datei um (Parsing)
# Code kann mit
html_doc <- read_html(rendered_source) 
View(html_doc)

# Alternativ kann auch einfach mit read_html der ungerenderte Source Code 
# heruntergelanden werden
html_doc2 <- read_html(url)

# b) Inhalte von einer Webseite scrapen

# Original:
# title_xpath <- "//h1[contains(@class, 'content_headline')]" 
# geht leider nicht mehr, da die Klasse randomisiert wurde

# "//h1[contains(@class, 'content_headline')]" drueckt aus, dass Überschriften 
# der ersten Ordnung (h1) im ganzen Document (//) gesucht werden sollen, auf die die
# Kondition ([...]) Klassenattribute (@class) == 'content_headline' passt

# Alternative
title_xpath <- "//h1[contains(@class, 'dcr-d5iddn')]"
# oder alternativ einfach @class weglassen
# title_xpath <- "//h1"
title_text <- html_doc %>%
  html_node(xpath = title_xpath) %>%
  html_text(trim = T)

# Ausgabe des Ergebnisses
cat(title_text)

# Etwas Uebung zum Extrahieren von Ueberschriften mit dem Tagesschau Text
url2 <- "https://www.tagesschau.de/inland/gesellschaft/kita-platz-rechtsanspruch-100.html"

# Lade die Website in einer phantomJS Session
pjs_session$go(url2)

# Speichere den Source Code der Website in einem neuen Object
rendered_source2 <- pjs_session$getSource() # Enthaelt den Source Code

# Wandel den Source Code in eine html-Datei um (Parsing)
# Code kann mit
html_doc2 <- read_html(rendered_source2) 
html_doc2["body"]
title_text2 <- html_doc2 %>%
  html_nodes(xpath = "//h1/span") %>%
  html_text(trim = T) %>%
  paste0(collapse = "\n")

cat(title_text2)

# Teilueberschrift extrahieren
title_text3 <- html_doc2 %>%
  html_node(xpath = "//h1/span[contains(@class, 'seitenkopf__topline')]") %>%
  html_text(trim = T) 

cat(title_text3)

# Alle h2 extrahieren
headline_object <- html_doc2 %>%
  html_nodes(xpath = "//h2") %>% html_text(trim = T) %>% paste0(collapse = "\n")

cat(headline_object)
headline_vector <- strsplit(headline_object, "\n")

# Artikel Intro
# intro_path <- "//div[contains(@class, 'content__standfirst')] //p"
# funktioniert nicht da Klassen verschluesselt wurden, daher:
intro_xpath <- "//div/p"
intro_text <- html_doc %>%
  html_node(xpath = intro_xpath) %>%
  html_text(trim = T)

cat(intro_text)

# Uebung mit Tagesschau-Text
intro_text2 <- html_doc2 %>%
  html_node(xpath="//div//p[contains(@class, 'textabsatz columns twelve  m-ten  m-offset-one l-eight l-offset-two')]") %>%
  html_text(trim=T)

cat(intro_text2)


# Artikel-Text
# body_xpath <- "//div[contains(@class, 'content_article_body')] //p"
# funktioniert nicht da Klassen verschluesselt wurden, daher:
body_xpath <- "//div//p"
body_text <- html_doc %>%
  html_nodes(xpath = body_xpath) %>%
  html_text(trim = T) %>%
  paste0(collapse = "\n")

cat(body_text)

# Uebung - Tagesschau
body_text2 <- html_doc2 %>%
  html_nodes(xpath = "//div//p[contains(@class, 'textabsatz m-ten m-offset-one l-eight l-offset-two columns twelve')]") %>%
  html_text(trim = T) %>% paste0(collapse="\n")

cat(body_text2)
body_vector <- strsplit(body_text2, "\n") # 17 Textabschnitte

# Artikel Datum
date_xpath <- "//div//summary[contains(@class, 'dcr-1ybxn6r')]"
date_object <- html_doc %>%
  html_node(xpath = date_xpath) %>% html_text(trim=T)

date_object <- sub("Mon", "Mo", date_object)
date <- strptime(date_object, "%a %d %B %Y %H.%M", tz = "Europe/Berlin")

# Uebung - Tagesschau
date_object2 <- html_doc2 %>% 
  html_nodes(xpath = "//div//p[contains(@class, 'metatextline')]") %>%
  html_text(trim = T)

cat(date_object2) # geht nicht richtig, da nicht als Datum hinterlegt
date_object2 <- substr(date_object2, 8, 23) %>% strptime("%d.%M.%Y %R",
                                                         tz = "Europe/Berlin")

# Guardian Text
# Test fuer Verstaendnis: alle h2 extrahieren
headlines <- html_doc %>%
  html_nodes(xpath = "//h2") %>%
  html_text(trim = T) %>%
  paste0(collapse = "\n")

cat(headlines)

# Test fuer Verstaendnis: alle h3 extrahieren
headlines <- html_doc %>%
  html_nodes(xpath = "//h3") %>%
  html_text(trim = T) %>%
  paste0(collapse = "\n")


# Test fuer Verstaendnis: Alle mit Links gekennzeichneten Begriffe im Artikel
headlines <- html_doc %>%
  html_nodes(xpath = "//div //p //a") %>%
  html_text(trim = T) %>%
  paste0(collapse = "\n")

cat(headlines)


# c) Following Links

# 1) Die Seite herunterladen, die das Suchergebnis enthaelt
url <- "https://www.theguardian.com/world/angela-merkel"

pjs_session$go(url)
rendered_source3 <- pjs_session$getSource()
html_overview <- read_html(rendered_source3)



# 2) alle Links herunterladen, die auf der Seite aufgefuehrt werde
# Laedt alle a-Elemente in einem bestimmten Abschnitt (div mit fc-item-container)
# herunter, bzw. das href-Attribut davon

# a) Erstellt eine Liste der Links auf der Seite

links <- html_overview %>% 
  html_nodes(xpath="//div[contains(@class, 'fc-item__container')]/a") %>%
  html_attr(name="href") %>%
  paste0(collapse = "\n")

cat(links)

# b) Links aus mehreren Subpages scrapen

# Aber dadurch werden nur die Links auf der ersten Seite und nicht die auf 
# den Subseiten (2, 3, 4 etc.) gescraped

# Dafuer muss ueber eine Liste von URLs, die die unterschiedlichen Seiten enthalten,
# mit einem for-loop iterated werden

# Erstellen der Liste
page_urls <- paste0("https://www.theguardian.com/world/angela-merkel?page=", 1:5)
page_urls # enthaelt die Links zu den Seiten

# Wiederholen des Scraping-Processes und Zusammenfuehren der Links in eine Liste


all_links <- NULL
for(url in page_urls){
  # Download der einzelnen Uebersicht-Seite
  pjs_session$go(url)
  rendered_source <- pjs_session$getSource()
  html_doc <- read_html(rendered_source)
  
  # Scraping der Links
  links <- html_doc %>%
  html_nodes(xpath = "//div [contains(@class,'fc-item__container')]/a") %>%
  html_attr(name="href")

  # Kombinieren in eine Liste
  all_links <- c(all_links, links)
}
all_links


# c) Funktionen fur das Extrahieren der zentralen Informationen schreiben 
#    (spart wiederholende Zeilen von Code)

scrape_article <- function(url) {
  # Seite herunterladen
  pjs_session$go(url)
  rendered_source <- pjs_session$getSource()
  html_doc <- read_html(rendered_source)
  
  # Titel Scrapen
  title <- html_doc %>%
    html_node(xpath = "//h1") %>%
    html_text(trim = T)
  
  intro <- html_doc %>%
    html_node(xpath = "//div[@data-gu-name='standfirst']//p")%>%
    html_text(trim=T)
  
  
  # Textkörper Scrapen
  body <- html_doc %>%
    html_nodes(xpath="//div//p") %>%
    html_text(trim = T) %>%
    paste0(collapse ="\n")
  
  # Zeit
  # mit Catch falls es keine Zeit im Artikel gibt
  time <- html_doc %>%
    html_node(xpath = "//time") %>%
    html_attr(name = "datetime")
  date <- tryCatch(
    as.Date(time), error = function(e) {cat("Error")
      return(NA)}
    )
  
  # In Dataframe zusammenfuegen
  article <- data.frame(
    url = url,
    title = title,
    intro = intro,
    body = body,
    time = date
  )
 
   return(article)
}

# Test mit einem Artikel
url <- "https://www.theguardian.com/world/2021/sep/07/merkel-urges-germans-back-party-choice-successor-armin-laschet"
text1 <- scrape_article(all_links[50])
# funktioniert


# Debugging, 
# da Fehler bei ganzer Funktion


instance <- run_phantomjs()
jps_session <- Session$new(port=instance$port)

jps_session$go(all_links[50])
scraped <- jps_session$getSource()
html_doc <- read_html(scraped)


date <- html_node(html_doc, xpath = "//time") %>% html_attr(name="datetime") 
date <- tryCatch(as.Date(date), error = function(e) {cat("Error")
                                                      return(as.character(date))})

# funktioniert


# Alle Links aus der Uebersichtsseite herunterladen
all_articles <- data.frame()

for(i in 1:length(all_links)){
  cat("Downloading", i, "from", length(all_links), "URL:", all_links[i], "\n")
  
  # scrapen der seite
  article <- scrape_article(all_links[i])
  all_articles <- rbind(all_articles, article)
}

View(all_articles)
library(tidyverse)

# Funktioniert evtl noch nicht

# d) Speichern des Datensatzes
write_csv2(all_articles, "guardian_merkel.csv")


getwd()
# Uebung mit der Startseite der Tagesschau

library(webdriver)
instance <- run_phantomjs()
pjs_session <- Session$new(port=instance$port)


pjs_session$go("https://www.tagesschau.de/")
rendered_source <- pjs_session$getSource()
html_page <- read_html(rendered_source)

links <- html_page %>%
  html_nodes(xpath = "//div//a[contains(@class, 'teaser__link')]") %>%
  html_attr(name="href")


links_comp <- paste0("https://www.tagesschau.de", links[-grep("https", links)])
all_links <- c(links[grep("https", links)], links_comp)

all_articles <- NULL

scrape_article <- function(url) {
  # Seite herunterladen
  pjs_session$go(url)
  rendered_source <- pjs_session$getSource()
  html_doc <- read_html(rendered_source)
  
  # Titel Scrapen
  title <- html_doc %>%
    html_nodes(xpath = "//h1") %>%
    html_text(trim = T) %>%
    paste0(collapse="\n")
  
  intro <- html_doc %>%
    html_node(xpath = "//div//p//strong")%>%
    html_text(trim=T)
  
  
  # Textkörper Scrapen
  body <- html_doc %>%
    html_nodes(xpath="//div//p[contains(@class, 'textabsatz m-ten m-offset-one l-eight l-offset-two columns twelve')]") %>%
    html_text(trim = T) %>%
    paste0(collapse ="\n")
  
  # Zeit
  # mit Catch falls es keine Zeit im Artikel gibt
  time <- html_doc %>%
    html_node(xpath = "//div//p[contains(@class, 'metatextline')]") %>%
    html_text(trim=T)

  # In Dataframe zusammenfuegen
  article <- data.frame(
    url = url,
    title = title,
    intro = intro,
    body = body,
    time = time
  )
  
  return(article)
}

# Test mit einem einzelnen Artikel
# Funktioniert, Ueberschrift etwas clunky (erscheint mit \n)
pjs_session$go(all_links[10])
pjs_session$go(all_links[10])
rendered_source <- pjs_session$getSource()
html_doc <- read_html(rendered_source)

text <- scrape_article(all_links[10])

# Scrapen der gesamten Uebersicht Seite

all_articles <- NULL

for(i in 1:length(all_links)){
  cat("Download", i, "from", length(all_links), "URL", all_links[i])
  article <- scrape_article(all_links[i])
  all_articles <- rbind(all_articles, article)
}

# Speichern des Datensatzes
write_csv2(all_articles, "tagesschau_start_03.08.2023.csv")

View(all_articles)
  
 # Corpora des Guardians von Github fuer spaeter
 library(quanteda.corpora)
 corp_news <- download("data_corpus_guardian")
