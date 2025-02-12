#############################################################
# CSS-Arbeitskreis Mannheim
# - Institut für Medien- und Kommunikationswissenschaften
# 
# Netzwerkanalyse (Katya Ognyanova)
# https://kateto.net/network-visualization
#
# Basics - Netzwerkanalyse

# Mit Hilfe von Nodes (Knotenpunkten) und Edges (Verbindungen) kann ein Netzwerkgraph
# erstellt werden, der die Vernuepfung von Elementen auf unterschiedlichste Weise
# visualisiert (z.B. Freundschaften, Handelsbeziehungen oder Prozesse wie die 
# Verbreitung von Informationen) werden.

# Netzwerkgraphen visualisieren Informationen auf unterschiedlichen Ebenen
# - Groeße, Form, Farbe der Nodes und Edges (3 x 2 Dimensionen)
# - Pfeilrichtung
# - Position der Nodes

# Werden zu unterschiedlichen Zwecken eingesetzt
# - wichtige Knotenpunkte identifizieren
# - Staerke von Kontakten determinieren 
# - Strukturen erkennen 
# - Gruppierungen und deren Verbindungen markieren
# - Diffusion/ Streuung durch ein Netzwerk verfolgen
# - Entwicklung von Netzwerken nachzeichnen

# Regeln beim Erstellen von Netzwerkgraphen
# 1 Minimale Ueberschneidung von von Edges
# 2 Gleichlange Edges
# 3 Ueberlappen von Strukturen vermeiden
# 4 Symmetrischer Aufbau


# Benoetigte Pakete
# install.packages("igraph") 
# install.packages("network") 
# install.packages("sna")
# install.packages("ggraph")
# install.packages("visNetwork")
# install.packages("threejs")
# install.packages("networkD3")
# install.packages("ndtv")

# Farben in R
# Koennen durch Namen, Hex-Codes oder RGB aufgerufen werden
colors() # gibt eine Liste der Farbnamen in R
colors()[grep("blue", colors())] # mit grep koennen auch bestimmte Farben gewaehlt werden

plot(x = 1:10, y = rep(5,10), pch = 19, cex = 3, col = "dark red")
points(x = 1:10, y = rep(6, 10), pch = 19, cex = 3, col = "557799")
points(x = 1:10, y = rep(4, 10), pch = 19, cex = 3, col = rgb(.25, .5, .3))
points(x = 1:10, y = rep(3,10), pch = 19, cex = 3, col ="royalblue")

# Transparenz kann mit dem Parameter alpha eingestellt werden
plot(x=1:5, y=rep(5,5), pch=19, cex=12, col=rgb(.25, .5, .3, alpha=.5), xlim=c(0,6)) 

# Fuer Hexcodes muss evtl die Funktion adjustcolor aus grDevices verwendet werden
par(bg="gray40") # Hintergrundfarbe mit par anpassen
col.tr <- grDevices::adjustcolor("557799", alpha=0.7)
plot(x=1:5, y=rep(5,5), pch=19, cex=12, col=col.tr, xlim=c(0,6)) 

# Farbpaletten
# Build-in Farbpaletten
pl1 <- heat.colors(6, alpha = .7)
pl2 <- rainbow(6, alpha = .7)

plot(x = 1:10, y = rep(5, 10), pch = 19, cex = 5, col = pl1)
points(x = 1:10, y = rep(3,10), pch = 19, cex = 5, col = pl2)

# Eigene Paleten mit colorRampPalette
palf <- colorRampPalette(c("gray20", "royalblue"))
plot(1:10, 1:10, pch = 18, cex = 4 , col =palf(10))


## 3 Datenformate, Groeße und Vorbereitung
# Zwei Beispieldatensaetze: 
# 1 Netzwerk aus Hyperlinks und Mentions von Quellen
# 2 Links zwischen Medieangeboten und Nutzer:innen 

# 3.1 edgelist
# Typ 1: Informatioen zu Datenpunkten (nodes) und Verbindungen (links)
nodes <- read.csv("Data files/Dataset1-Media-Example-NODES.csv", header=T, as.is=T)
links <- read.csv("Data files/Dataset1-Media-Example-EDGES.csv", header=T, as.is=T)

head(nodes) 
# Nodes idenfiziert mit einer ID, die auch in from und to bei links verwendet wird
# Name (media), Medientyp (num. mit label), Zuschauergroeße

head(links) # Von und zu Verbindung, Typ, Gewichtung [Frequenz?]

# 3.2 Netzwerkgraph (igraph-Object) erstellen 
library('igraph')
net <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 
net

# Die ersten 4 Buchstaben repraesentieren Eigenschaften des igraph-objektes
# D (Directed), N (Named nodes), W (Weighted Edges), - (statt B fuer bipartit nodes)

# Die Zahlen danach stehen fuer die Anzahl an Nodes und Edges
# Er enthaelt 17 Nodes und 49 Edges

# bei attr. sind die Typen von weiteren Informationen festgehalten und bestimmt:
# - (v) = node/vertice level, (e) = edge level, g = graph level

# Edges und Nodes koennen mit E(net) bzw. V(net) aufgrufen werden 
E(net)       # Edges im dem "net" Objekt
V(net)       # Nodes in dem "net" object

# Auswahl von Attributen erfolgt mit $name
E(net)$type  # Edge-Attribute "type"
V(net)$media # Node-Attribute "media"

# Es koennen auch logische Operatoren verwendet werden, um Nodes mit gewissen 
# Eigenschaften auszuwaehlen
# (gibt eine Sequenz von Nodes bzw. edges aus)
V(net)[media=="BBC"]
E(net)[type=="mention"]

# Auch moeglich das Netzwerk mit [] zu erkunden :
net[1,] # aber was sagt das aus?
net[5,]

# Es ist auch einfach eine Edgelist oder eine Matrix von einem igraph zu extrahieren
# Als Edgelist oder adjecency matrix:
as_edgelist(net, names=T)
as_adjacency_matrix(net, attr="weight")

# Als data frame
as_data_frame(net, what="edges")
as_data_frame(net, what="vertices")

# Netzwerkgraphen ausgeben lassen
plot(net)

net <- simplify(net, remove.multiple = F, remove.loops = T) 
plot(net, edge.arrow.size=.4,vertex.label=NA)
# par(mar=c(5.1, 4.1, 4.1, 2.1)) # Default margins are a lot for network graphs
# par(mar=c(0.1, 0.1, 0.1, 0.1))


# 3.3 Dataset 2
# Einlesen der Datensaetze
nodes2 <- read.csv("Data files/Dataset2-Media-User-Example-NODES.csv", header=T, as.is=T)
links2 <- read.csv("Data files/Dataset2-Media-User-Example-EDGES.csv", header=T, row.names=1)

# Anderes Format
head(nodes2) # Enthaelt weitere Informationen fuer Medien aber nicht fuer Nutzer
head(links2) # Adjacency Matrix (Nuter:innen > Media Outletts)

links2 <- as.matrix(links2)
dim(links2) # 10 Media Outletts, 20 Nutzer:innen
dim(nodes2)

# Erstellt Graph von Adjacency Matrix
net2 <- graph_from_incidence_matrix(links2)
table(V(net2)$type)
net2 # Undirected, Named, - (not weighted), Bipartit Graph with 30 Nodes 
     # and 31 Edges 

# Simple Visualisierung
net2 <- simplify(net2, remove.multiple = F, remove.loops = T) 
plot(net2)     
V(net2)$shape <- c("circle", "square")[as.numeric(V(net2)$type)+1]
c("circle", "square")[2]

## 4. Netzwerke mit igraph visualisieren
# Netzwerke haben eine Vielzahl von Parametern, die angepasst werden koennen
# - Nodeoptionen (beginnen mit vertex.)
# - Edgeoptionen (beginnen mit edge.)

# ?igraph.plotting gibt eine Liste von Moeglichkeiten aus

# Parameter koennen auf zwei Arten festgelegt werden
# a) in der plot-funktion

plot(net, edge.arrow.size = 0.1, edge.curved = .2)

# So koennte z.B. auch die Farbe der Edges und Nodes festgeegt und der Name 
# der Nodes durch die Bezeichnungen ersetzt werden 
plot(net, edge.arrow.size=.2, edge.color="orange",
     vertex.color="orange", vertex.frame.color="#000000",
     vertex.label=V(net)$media, vertex.label.color="black")

# b) die zweite Moeglichkeit ein Attribut festzulegen, ist das hinzufuegen
#    zu dem igraph-objekt
net
V(net)$color <- c("gray50", "tomato", "gold")[V(net)$media.type]

# Anzahl an Links berechnen und Groeße der Nodes darauf festlegen
V(net)$size <- degree(net, mode="all")*3 # *3 um Sichtbarkeit zu gewaehrleisten
# Alternativ kann die Zahl der Zuschauer verwendet werden
V(net)$size <- V(net)$audience.size*0.6

# Labels aus
V(net)$label <- NA

# Groeße der Edges nach Gewichtung
E(net)$width <- E(net)$weight/6
# Pfeilgroeße
E(net)$arrow.size <- 0.2

# Einfaerben der Edges
E(net)$color <- "gray80" # gesamte Edges
E(net)$edge.color <- "gray80" # Verbindung

# Das Layout des Netzwerks kann ebenfalls festgelegt werden
graph_attr(net, "layout") <- layout_with_lgl
plot(net) 


# Trotzdem koenenn die fesgelegten Objekt-Attribute mit localen Attributen 
# in der plot() Funktion ueberschrieben werden
plot(net, edge.color="orange", vertex.color="gray")


# Es hilft außerdem eine Legende hinzuzufuegen
plot(net) 
par(mar=c(1,1,1,1)) # hilft die margins anzupassen...
legend(x="bottomleft", c("Newspaper","Television", "Online News"), pch=21,
       col="#777777", pt.bg = c("gray50", "tomato", "gold"), pt.cex=2, cex=.8, bty="n", ncol=1)
par(mar=c(5,4,4,2))


# Manchmal, besondern in semantischen Netzwerken, sollen nur Namen mit edges
# dargestellt werden
# - Shape auf "none" setzen, Label auf die Bezeichnung setzen!
plot(net, vertex.shape="none", vertex.label=V(net)$media, 
     vertex.label.font=2, vertex.label.color="gray20",
     vertex.label.cex=.7, edge.color="gray65")

# Auch moeglich die Edges nach dem Typ des Anfangsnodes einzufaerben
# Die Funktion ends gibt Anfangs- und Endnode der in es bezeichneten Variable 
# zurueck
edge.start <- ends(net, es=E(net), names=F)[,1]
edge.col <- V(net)$color[edge.start]
plot(net, edge.color = edge.col, edge.curved=.01)

########################
## 4.2 Netzwerk Layouts
########################

# Netzwerk Layouts sind simple oder komplexere Algorithmen, die Koordinaten
# fuer jeden Node generieren

# Um die Funktionsweise der Layout Algorithmen zu veranschaulichen wird 
# ein Graph mit 100-Nodes generiert
net.bg <- sample_pa(120) # einfaches Netzwerk auf Basis des Barabasi-Albert Modells

# Festlegen v. aestetischen Parametern
V(net.bg)$size <- 8
V(net.bg)$frame.color <- "white"
V(net.bg)$color <- "orange"
V(net.bg)$label <- "" 
E(net.bg)$arrow.mode <- 0
plot(net.bg)

# Zufaelliges Layout
plot(net.bg, layout=layout_randomly) # nicht gut

# Nodekoordinaten koennen auch vorab berechnet werden
l <- layout_in_circle(net.bg)
plot(net.bg, layout=l)

# Oder sie koennen selbst generiert werden
l <- cbind(1:vcount(net.bg), c(1, vcount(net.bg):2))
# 1 bis 120, 1, 120 bis 2
plot(net.bg, layout=l)


# 3D-Kugel Layout
l <- layout_on_sphere(net.bg)
palf <- colorRampPalette(c("orange", "orange3"))
plot(net.bg, layout=l, vertex.color = palf(10)[round((l[,3]*(-1)+1)/2*10,1)])

# Fruchterman-Reingold 
# Einer der meistgenutzen, force-directed Algorithmen
# Force-Directed Layouts versuchen einen Graph zu erstellen, bei dem 
# Edges gleich lang sind und sich so wenig wie moeglich kreuzen

# Der Graph wird als physikalisches System behandelt, bei dem die Nodes
# eine elektrische Ladung erhalten und sich gegenseitig abstoßen,
# wenn sie einander zu nahe kommen
# Ergebnis: Nodes sind gleichmaeßig verteilt, solche, die mehr 
#           Verbindungen aufweisen liegen auch naeher beeinander
# Nachteilt: Langsamer Algorithmus, der sehr lange braucht

l <- layout_with_fr(net.bg)
plot(net.bg, layout=l)

# l <- layout_with_fr(net.bg, niter = 50)
# niter erlaubt es einem die Anzahl an Iterationen, die fuer das Modell 
# verwendet werden runterzustellen > kuerzere Rechenzeit, evtl schlechteres Ergebnis

# Und man kann Gewichtungen festlegen, die Anziehungskraefte zwischen den Nodes
# bestimmen

# ws  <-  c(1, rep(100, ecount(net.bg)-1)) # 1 Node weniger Starke Anziehung
# lw <- layout_with_fr(net.bg, weights=ws)
# plot(net.bg, layout=lw) 

# Fruchtermann Reingold fuehrt zu unterschiedlichen Ergebnisse ueber 
# unterschiedliche Iterationen
par(mfrow=c(2,2), mar=c(0,0,0,0))   # plot four figures - 2 rows, 2 columns
plot(net.bg, layout=layout_with_fr)
plot(net.bg, layout=layout_with_fr)
# Da Speichern des Layouts in l, fuehrt jedoch dazu, dass immer wieder der
# gleiche Plot visualisiert werden kann
plot(net.bg, layout=l)
plot(net.bg, layout=l)

dev.off()

l <- layout_with_fr(net.bg)
l <- norm_coords(l, ymin=-1, ymax=1, xmin=-1, xmax=1)

par(mfrow=c(2,2), mar=c(0,0,0,0))
plot(net.bg, rescale=F, layout=l*0.4)
plot(net.bg, rescale=F, layout=l*0.6)
plot(net.bg, rescale=F, layout=l*0.8)
plot(net.bg, rescale=F, layout=l*1.0)


# 4.3 Netzwerk Asppekte highlighten
# eine Moeglichkeit, cutoff-values (schwächste Verbindungen rauslöschen)

hist(links$weight)
mean(links$weight)
sd(links$weight)

# Hier einfach der Mittelwert
# Aber in Literatur gibt es mehr hinweise, welchen Wert man verwenden sollte
cut.off <- mean(links$weight) 
net.sp <- delete_edges(net, E(net)[weight<cut.off])
plot(net.sp, layout=layout_with_kk)


# Clusterfinding Algorithmus
par(mfrow=c(1,2))

# Community detection (by optimizing modularity over partitions):
clp <- cluster_optimal(net)
class(clp)

?cluster_optimal # gibt unten andere Algorithmen an
# Optimal macht alle moeglichen Clsuter und nehmt den mit max. Modularität 
# (Verhältnis der Verknüpfung innnerhalb der über Verhältnis mit Clustern 
# außerhalb) >> max. Verbindungen nach innen und min. Verbindung nach außen

# Sehr viel Rechenleistung (nicht mehr als 50 vertices)

# Andere Algorithmen ausgeben lassen und mit print(modularity(cc))
# Modularität ausgeben
# fast and greedy hat bei Rainer besser funktioniert

## Begriff Community verwenden!!
# Cluster haben ueberhaupt keine Verbindungen miteinander
# Communities schon!
# Community detection returns an object of class "communities" 
# which igraph knows how to plot: 
plot(clp, net)

# We can also plot the communities without relying on their built-in plot:
V(net)$community <- clp$membership
colrs <- adjustcolor( c("gray50", "tomato", "gold", "yellowgreen"), alpha=.6)

# Einfaerben nach Community
# Viele andere Moeglichkeiten das zu plotten
plot(net, vertex.color=colrs[V(net)$community])

