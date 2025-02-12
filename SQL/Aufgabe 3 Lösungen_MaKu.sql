-- Aufgabe 1:  
-- Führen Sie die beiden Kommandos 
SELECT count(*) FROM Artists WHERE ArtistId < 100;
SELECT count(*) FROM Performs WHERE ArtistId < 100;

select * 
from   
Artists a, Performs p 
where  a.ArtistId < 100 and 
p.ArtistId < 100;
-- Prüfen Sie Ihre Antwort durch Ausführung des Kommandos nach. 

-- Es sollten 24180 Zeilen ausgegeben werden, da alle Kennwerte aus der ArtistTabelle mit ArtistId < 100 (62) angegeben werden
-- sowie alle Zeilen aus der performs Tabelle mit Id < 100 (390) 
-- Ohne sinnvollen merge werden die Zeilen aus der Zweiten Tabelle für jede Zeile aus der ersten gedoppel... >> 390 * 62 = 452

-- Aufgabe 2: 
-- Geben Sie für die sechs Fragestellungen von Aufgabe 3 von Übungsblatt 2 jeweils eine Lösung mit SQL an. 
-- Quick Solutions
-- a
SELECT Name, BeginYear FROM Artists WHERE BeginYear BETWEEN 1980 AND 1985;
-- b
SELECT Name, Gender, Location FROM Artists WHERE Gender = "Male" AND (Location = "France" OR Location = "Germany");
-- c
SELECT s.Name FROM Songs s INNER JOIN includes i ON s.SongId = i.SongId WHERE i.MediumId  = 90;
-- d
SELECT a.Name, a.BeginYear, a.EndYear FROM Artists a 
INNER JOIN performs p ON a.ArtistId = p.ArtistId 
INNER JOIN Songs s ON s.SongId = p.SongId
WHERE s.Name = "Never Been Rocked Enough";
-- e
SELECT a.Name, r.Name as RecordName FROM Artists a LEFT JOIN Records r ON a.ArtistId = r.ArtistId;
-- f
SELECT Name FROM Songs
INTERSECT
SELECT NAME FROM Artists;


-- Aufgabe 3: 
-- Formulieren Sie für folgende Anfragen an die Musikdatenbank jeweils ein SQL-Kommando. 

-- 1. Erzeugen Sie eine Übersicht über alle weiblichen Künstler, wobei nur Name und Geburtsort ausgegeben werden sollen. Die Ausgabe 
--    soll aufsteigend nach dem Namen sortiert erfolgen. 
SELECT Name, Location FROM Artists WHERE Gender = "Female" ORDER BY Name;

-- 2. Es soll eine Liste mit allen Musikstücken erzeugt werden, bei denen eine Bemerkung, aber keine Länge angegeben ist.
SELECT * FROM Songs WHERE Songs.Length IS NULL AND Note IS NOT "";
  
-- 3. Welche Musikverlage enthalten in ihrem Namen irgendwo die Zeichenfolge Record oder Music (auch beides) 
--    und sind in den USA (United States) angesiedelt? 
SELECT * FROM Labels WHERE (Name LIKE "%Records%" OR Name Like "%Music%") AND Location = "United States";

-- 4. Geben Sie die Namen der Alben einschließlich Erscheinungsjahr und Track-Anzahl der ersten CD so aus, dass die Ausgabe aufsteigend nach
--    dem Erscheinungsjahr und innerhalb des Erscheinungsjahrs aufsteigend nach der Track-Anzahl geordnet ist. 
SELECT r.Name, r.Year, COUNT(i.SongID) as NumberOfSongs FROM RECORDS r 
INNER JOIN includes i ON r.MediumId = i.MediumId 
GROUP BY r.Name, r.Year, i.MediumId
ORDER BY r.Year, NumberOfSongs;  

-- 5. Erstellen Sie eine Liste, die für die männlichen Künstler, bei denen ein Geburts- und ein Sterbejahr angegeben ist, das Alter ausweist
--   (gehen Sie davon aus, dass die Person ihren Geburtstag im Sterbejahr noch erlebt hat). 
--    Geben Sie den Namen und eine Spalte mit einer passenden Bezeichnung für das Alter aus und ordnen Sie die Ausgabe aufsteigend nach dem Alter. 
SELECT Name, (EndYear - BeginYear) AS Age FROM Artists 
WHERE GENDER = 'Male' AND EndYear IS NOT NULL and BeginYear IS NOT NULL 
ORDER BY Age ASC;

-- 6. Geben Sie für alle Musikstücke, die zwischen zwei und vier Minuten lang sind, in einer Spalte Dauer jeweils die Länge in der Einheit
--    Minuten (Dezimalzahl) an. Anzugeben sind neben der Länge SongId und Name. 
--    Hinweis: (Length+0.0) erzeugt einen Floating-Point-Wert für Length.  
SELECT Length/60000.0 AS LengthInMin, Name  FROM Songs WHERE Songs.Length IS NOT NULL AND LengthInMin BETWEEN 2.0 AND 4.0
ORDER BY LengthInMin DESC;


-- 7. Wie viele Alben wurden seit dem Jahr 2000 veröffentlicht und wie viele Tracks enthalten diese insgesamt und im Durchschnitt auf der ersten CD? 
SELECT COUNT(DISTINCT RecordId) NuOfRecords, SUM(TrackCount) as TotalTracks, AVG(TrackCount) as AvgTracksCD FROM Records WHERE Year > 2000 AND DiscNumber = 1;

-- 8. Wie viele Alben haben die Verlage Pickwick Records und Brown Records insgesamt verlegt? 
SELECT l.Name, COUNT(r.RecordId) as NumOfRecords FROM Labels l INNER JOIN releases r ON l.LabelId = r.LabelId WHERE l.Name = 'Pickwick Records' OR l.Name = 'Brown Records' GROUP BY l.Name;

-- 9. Wie viele CDs enthalten eine Version des Titels Tears in Heaven, die eine Spieldauer von mehr als vier Minuten besitzt? 
SELECT COUNT(DISTINCT i.MediumId) as NumOfRecords FROM includes i INNER JOIN Songs s On i.SongId = s.SongId Where s.Name = 'Tears in Heaven' AND s.Length/60000 > 4;
-- Es gibt 5 CDs die diesen Anforderungen entsprechen

-- 10. Welche Stücke (Namen der Titel ausgeben) hat Michael Brecker aufgeführt?  
SELECT s.Name FROM Songs s 
INNER JOIN performs p ON s.SongId = p.SongId
INNER JOIN Artists a ON p.ArtistId = a.ArtistId
WHERE a.Name = 'Michael Brecker';


-- 11. Welche Instrumente spielt Michael Brecker in dem Stück Security auf der CD mit der Medium-ID 90?   
SELECT p.Description, s.Name, a.Name, i.MediumId From performs p
INNER JOIN Artists a ON p.ArtistId = a.ArtistId
INNER JOIN Songs s ON p.SongId = s.SongId
INNER JOIN includes i ON p.SongId = i.SongId
WHERE i.MediumID= 90 AND s.Name = 'Security' AND a.Name = 'Michael Brecker';


-- Aufgabe 4:  
-- 1. Erzeugen Sie mittels CREATE TABLE eine Tabelle Mitarbeiter1 mit den Spalten P_Nr (int, NOT NULL),   Name (varchar(30), NOT NULL) 
--    und Vorg (int, NOT NULL), wobei die Spalte P_Nr Primärschlüssel sein soll.  In der Spalte Vorg soll die P_Nr des unmittelbaren 
--    Vorgesetzten des Mitarbeiters eingetragen werden. 
CREATE TABLE Mitarbeiter1 ("P_Nr" INT NOT NULL, "Name" VARCHAR(30) NOT NULL, "Vorg" INT NOT NULL, PRIMARY KEY ("P_Nr"));

-- 2. Fügen Sie mittels INSERT folgende sieben Datensätze ein:  
--    (3,Mueller,1), (2,Meyer,1), (1,Adenauer,1), (4,Schmidt,2), (5,Schmitt,1), (6,Gruen,4), (7,Gelb,2). 
INSERT INTO Mitarbeiter1(P_Nr, Name, Vorg) VALUES (3,'Mueller',1), (2,'Meyer',1), (1,'Adenauer',1), (4,'Schmidt',2), (5,'Schmitt',1), (6, 'Gruen', 4), (7, 'Gelb', 2);

-- 3. Erzeugen Sie mittels eines SQL-Kommandos eine Liste, die für jede P_Nr den Namen des unmittelbaren Vorgesetzten ausgibt. 
SELECT m.P_Nr, v.Name FROM Mitarbeiter1 m Left JOIN Mitarbeiter1 v ON m.Vorg = v.P_Nr;
 
 
-- 4. Verwenden Sie ein UPDATE-Kommando, um alle in der Tabelle vorkommenden Personalnummern um 10 zu erhöhen.
UPDATE Mitarbeiter1 SET P_NR = P_Nr+10, Vorg = Vorg+10;
SELECT * FROM Mitarbeiter1;
  
-- 5. Legen Sie eine Tabelle Mitarbeiter2 gemäß dem gleichen Schema wie Mitarbeiter1 an. Informieren Sie sich über das Kommando INSERT 
--    INTO … SELECT und fügen Sie damit alle Einträge von Mitarbeiter1 ein. 
--    Löschen Sie alle Datensätze mit einer P_Nr größer als 14 aus Mitarbeiter2 und fügen Sie (18,Blau,11) ein. 
CREATE TABLE Mitarbeiter2 ("P_Nr" INT NOT NULL, "Name" VARCHAR(30) NOT NULL, "Vorg" INT NOT NULL, PRIMARY KEY ("P_Nr"));
INSERT INTO Mitarbeiter2
SELECT * FROM Mitarbeiter1;

DELETE FROM Mitarbeiter2 WHERE P_Nr > 14;
INSERT INTO Mitarbeiter2 VALUES (18, 'Blau', 11);


--6. Vereinigen Sie die beiden Tabellen für eine Ausgabe mittels UNION. Informieren Sie sich, welche beiden grundsätzlichen Möglichkeiten es 
--   zur Behandlung vorhandener und entstehender Duplikate bei UNION gibt und probieren Sie beide Möglichkeiten aus.  

-- Mit Duplikate
SELECT * FROM Mitarbeiter1
UNION ALL
SELECT * FROM Mitarbeiter2;


-- Ohne Duplikate
SELECT * FROM Mitarbeiter1
UNION
SELECT * FROM Mitarbeiter2;


-- Nur gemeinsame Einträge
SELECT * FROM Mitarbeiter1
INTERSECT
SELECT * FROM Mitarbeiter2;

