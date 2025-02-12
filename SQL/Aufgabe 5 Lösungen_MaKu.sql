/* Aufgabe 1:  
In einem Versandhandel werden die einzelnen Bestellpositionen einer Bestellung in einer Relation BPOS mit den Attributen BNr, ANr, BDat, ABez
und Anz erfasst. Dabei steht BNr für die Bestellnummer, ANr für die Artikelnummer, BDat für das Datum der Bestellung, ABez für die 
Artikelbezeichnung und Anz für die Anzahl der in der Bestellposition bestellten Artikel. Dabei können verschiedene Artikelnummern durchaus 
die gleiche Artikelbezeichnung besitzen. Auf der Rückseite befindet sich ein Auszug mit Tupeln der Relation, die die Bestellpositionen zu 
6 Bestellungen darstellen. 
1. Geben Sie alle voll funktionalen Abhängigkeiten sowie fünf nicht voll funktionale Abhängigkeiten an.  */

-- Das Bestelldatum, die Artikelbezeichnung und die Anzahl sind vollfunktional abhänigig von der Bestellnummer und der Artikelnummer
-- >> Sie lassen sich eindeutig über diese Kombination bestimmen

-- Nicht voll funktionale Abhängigkeiten sind:
-- Bestelldatum von Bestellnummer
-- Artikelbezeichnung von ArtikelNr
-- Artikelnummer von Bestellnummer
-- Anzahl von Artikelnummer
-- Anzahl von Artikelbezeichnung


-- 2. Führen Sie für die Relation unter Verwendung der Methoden von Kapitel 5.4 der Vorlesung (keine formale Anwendung des 
--    3NF-Synthese-Algorithmus) eine Zerlegung bis 3NF durch. Dabei genügt es, die Relationen mit zugehörigen Attributen unter Kennzeichnung
--    eines Primärschlüssels anzugeben. 
--    Hinweis: die Relation BPOS besitzt nur einen Kandidatenschlüssel. 

-- BNr, ANr > BDat		... überflüssig Aufgrund von funktionaler Abhänigkeit unten
-- BNr, ANr > ABez		... siehe oben.
-- BNr, ANr > ANr

-- BNr > BDat
-- Anr > ABez

-- >> 3 Datenbanken Artikel(ANr!, ABez), Bestellung(BNr!, BDat), Bestelldisposition(ANr!, BNr!, Anzahl)


-- 3. Inwieweit ist die von Ihnen ermittelte Zerlegung aus Aufgabenteil 2 verlustfrei und abhängigkeitsbewahrend?

-- Der Algorithmus berücksichtigt, dass alle Abhängigkeiten verlustfrei bewahrt werden


/* Aufgabe 2: 
Auf der Rückseite des Aufgabenblattes befindet sich ein Auszug aus einer Relation PROMI, die beschreibt, wie viele Stunden ein Mitarbeiter
einer Firma, der zu einer bestimmten Abteilung gehört, pro Monat für ein Projekt aufwendet. Dabei arbeiten in der Regel mehrere Mitarbeiter
an einem Projekt und ein Mitarbeiter ist meist auch an mehreren Projekten beteiligt.  
Hinweis: Projekte mit unterschiedlichen Nummern sollen stets unterschiedliche Namen besitzen. Beachten Sie dies beim Aufstellen der 
Kandidatenschlüssel im Rahmen der Normalisierung. 

1. Führen Sie für die Relation unter Verwendung der Methoden von Kapitel 5.4 der Vorlesung (keine formale Anwendung des 3NF-Synthese-
   Algorithmus) eine Zerlegung bis 3NF durch. Dabei genügt es, ab 2NF die Relationen mit zugehörigen Attributen unter Kennzeichnung eines
   Primärschlüssels anzugeben. Nur bei 1NF sind zusätzlich die Tupel des Auszugs einzutragen. */

-- Abhängigkeiten
-- PersNr > Name
-- PersNr > AbtNr
-- PersNr > AbtName ... überflüssig, da transivite Abhängigkeit über AbtNr > AbtName
-- AbtNr > AbtName   
-- ProjNr > ProName
-- ProjrNr, PersNr > Zeit

-- 4 Tabellen
-- Personal(PersNr!, Name, AbtNr)
-- Abteilung (AbtNr!, AbtName)
-- Projekt (ProjNr!, Name)
-- Arbeitszeit (PersNr!, ProjNr!, Zeit)

     
-- 2. Was ändert sich am Ergebnis aus „1.“, wenn Sie die Zerlegung bis BCNF durchführen? 

-- Nichts, da alle Attribute mit dem Superkey (PersNr, ProjNr) vernüpft sind


/*Aufgabe 3: 
Der auf der Rückseite des Aufgabenblattes befindliche Auszug aus einer Relation RELI (Rechnungsliste) erfasst die Rechnungshistorie für einen
bestimmten Kunden bei einem Händler. RNr bedeutet die Rechnungsnummer, ANr die vom Händler vergebene Artikelnummer eines Artikels, den er von
mehreren Herstellern beziehen kann; HNr ist die händlerinterne Herstellernummer, Preis der Einzelpreis eines Artikels. 
Hinweis: es kann zwar für einen Tag mehrere Rechnungen geben, aber ein bestimmter Artikel wird an einem Tag höchstens einmal in Rechnung 
gestellt. Geben Sie die möglichen Kandidatenschlüssel für diese Relation an. */	


-- RechnungsNr, ArtikelNr
-- Datun, ArtikelNr, da jeder Artikel nur einmal am Tag in Rechnung gestellt wird


/* Aufgabe 4: 
Erzeugen Sie sich mittels CREATE TABLE Kopien der Tabellen ARTISTS und RECORDS der Musikdatenbank mit den Attributen und Datentypen der 
Originaltabellen (nur Struktur, keine Daten übernehmen!). Legen Sie mittels Constraints dabei Folgendes fest: 
-- 1. Für beide Tabellen werden Primärschlüssel gesetzt. */
-- 2. In ARTISTS ist nur für das Attribut EndYear ein  NULL-Wert erlaubt, in RECORDS darf nur das Attribut Note  NULL sein. 
-- 3. Alle Integer-Werte müssen positiv sein. 
-- 4. Das Attribut Type von ARTISTS darf nur die Werte Group und Person annehmen. 
-- 5. Die Angabe zu EndYear darf nicht vor der Angabe zu BeginYear liegen. 
-- 6. In die Tabelle RECORDS dürfen nur Datensätze mit einer ArtistId eingetragen werden, die in ARTISTS vorhanden ist. 
-- 7. Wenn aus der Tabelle ARTISTS Datensätze gelöscht werden, so müssen auch die zugehörigen Datensätze aus der Tabelle RECORDS entfernt 
--    werden. 


CREATE TABLE Artists (
	ArtistId INT NOT NULL CHECK(ArtistId > 0),
	Name VARCHAR(100) NOT NULL,
	BeginYear INT NOT NULL CHECK(BeginYear > 0),
	EndYear INT CHECK (EndYear >= BeginYear),
	Location VARCHAR(100) NOT NULL,
	Type VARCHAR(10) NOT NULL CHECK (Type IN ('Person', 'Group')),
	Gender VARCHAR(100) NOT NULL,
	PRIMARY KEY(ArtistId));
	
CREATE TABLE Records (
	MediumId INT NOT NULL CHECK (MediumId > 0),
	RecordId INT NOT NULL CHECK (RecordId > 0),
	DiscNumber INT NOT NULL CHECK (DiscNumber > 0),
	Name VARCHAR(100) NOT NULL,
	ArtistId INT NOT NULL CHECK (ArtistId > 0),
	Year INT NOT NULL CHECK (Year > 0),
	Note TEXT,
	TrackCount INT NOT NULL CHECK (TrackCount > 0),
	PRIMARY KEY(MediumId),
	FOREIGN KEY (ArtistId) REFERENCES Artists(ArtistId) ON DELETE CASCADE);
	
	
--- Testen der Constraints
-- Erfolgreiches Einfügen
INSERT INTO Artists (ArtistId, Name, BeginYear, EndYear, Location, Type, Gender) 
VALUES (1, 'Artist 1', 2000, NULL, 'Location A', 'Person', 'Male');

-- Fehlerhafte Constraint
INSERT INTO Artists (ArtistId, Name, BeginYear, EndYear, Location, Type, Gender)
VALUES (3, 'Artist 3', 2000, 1995, 'Location C', 'Person', 'Female');

INSERT INTO Records (MediumId, RecordId, DiscNumber, Name, ArtistId, Year, Note, TrackCount)
VALUES (2, 102, 1, 'Album 2', 99, 2021, 'Another great album', 12);