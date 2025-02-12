-- Aufgabe 1: 
/*Gegeben seien zwei Tabellen u(s1,s2) und v(s3) mit den Spalten s1 und s2 bzw. s3. u besitze die drei Zeilen (1,4), (2,5), (3,2). v 
besitze die beiden Zeilen b und a.  Bestimmen Sie das Ergebnis nachstehender Anfrage durch Überlegen:  

select v1.s3, v2.s3, sum(s2) as Summe_s2 
from u, v v1, v v2 
where s2 > 3 or v1.s3 = ‘b’ 
group by v1.s3, v2.s3 
having sum(s2) > 10 
order by v1.s3, v2.s3 desc */

-- Lösung auf Papier bearbeitet
-- b b 11
-- b a 11 


-- Aufgabe 2:  
-- Formulieren Sie für die folgenden Anfragen jeweils ein passendes SELECT-Kommando. 
-- 1. Ermitteln Sie, wie viele Verlage pro Örtlichkeit erfasst sind. Die Ausgabe soll nach den Namen der Örtlichkeiten aufsteigend sortiert
--    sein. 
SELECT Location, COUNT(DISTINCT LabelId) as NumOfLabels FROM Labels GROUP BY Location ORDER BY Location ASC;


-- 2. Wie viele Alben wurden in jedem Jahr veröffentlicht (denken Sie daran, dass Alben mehrere Datenträger umfassen können ein Album mit
--    mehreren Datenträgern soll nur einmal gezählt werden)? Ordnen Sie die Ausgabe aufsteigend nach der Jahreszahl. 

SELECT Year, COUNT(DISTINCT RecordID)as NumOfRecords FROM Records Group BY Year ORDER BY Year ASC;

-- 3. Geben Sie für jeden Verlag den Namen und jeweils die Anzahl der Alben aus, die er veröffentlicht hat. Ordnen  Sie die Ausgabe dabei 
--    absteigend nach der Anzahl. 

SELECT l.Name, COUNT(r.RecordId) as NumOfRecords FROM Labels l 
INNER JOIN releases r ON l.LabelId = r.LabelId
GROUP BY l.Name
ORDER BY NumOfRecords DESC;

-- 4. Führen Sie die Anfrage 3 mit folgenden Einschränkungen durch: es sollen nur Verlage aus den USA (United States) ausgegeben werden, die 
--    mindestens 1000 Alben veröffentlicht haben. 
SELECT l.Name, COUNT(r.RecordId) as NumOfRecords FROM Labels l 
INNER JOIN releases r ON l.LabelId = r.LabelId
WHERE l.Location = "United States"
GROUP BY l.Name
HAVING NumOfRecords >= 1000
ORDER BY NumOfRecords DESC;


-- 5. Wie hoch ist jeweils das Durchschnittsalter der weiblichen bzw. männlichen Künstler vom Typ Person, bei denen ein Geburtsjahr und ein 
--    Sterbejahr angegeben ist? Geben Sie neben dem Geschlecht eine Spalte mit der Bezeichnung Alter_AVG für das Durchschnittsalter an.       

SELECT Gender, AVG((EndYear - BeginYear)) as Alter_AVG FROM Artists
WHERE TYPE = "Person" AND EndYear IS NOT NULL AND BeginYear IS NOT NULL AND Gender IS NOT NULL
GROUP BY Gender;


-- 6. Geben Sie für jedes Medium (MediumId) die Spieldauer in Minuten an. 
SELECT i.MediumId, SUM(s.length)/60000 as LengthInMin FROM includes i 
INNER JOIN Songs s On i.SongId = s.SongId
GROUP BY MediumId;


-- 7. Geben Sie für jeden Künstler vom Typ Person aus, wie viele Instrumente er bei der Aufführung eines bestimmten Titels gespielt hat (
--    auch die Stimme soll als Instrument zählen). Es genügt, für Künstler und Titel die ArtistId bzw. die SongId auszugeben.
SELECT ArtistId, SongId, COUNT(DISTINCT Description) From performs
GROUP BY ArtistId, SongId;


-- Aufgabe 3: 
-- Formulieren Sie für die folgenden Anfragen jeweils ein passendes SELECT-Kommando. Geben Sie beim ersten Kommando zwei Lösungen an eine
--  mit einer Unterabfrage, eine unter Verwendung eines Join. 

-- 1. Es sind die Namen der Alben auszugeben, die Joan Baez veröffentlicht hat. 
SELECT r.Name FROM Records r
INNER JOIN Artists a On r.ArtistId = a.ArtistId
WHERE a.Name = 'Joan Baez';

SELECT ArtistId FROM Artists WHERE Name = 'Joan Baez';
SELECT Name FROM Records WHERE ArtistId = 14284;

-- 2. Wie viele Titel besitzen eine Spieldauer, die zwischen 25% und 75% der Länge des längsten Titels beträgt?  
WITH Max_Length AS (
	SELECT MAX(Length) AS max_len FROM Songs
	)
SELECT COUNT(DISTINCT SongId) AS NumOfSongs FROM Songs WHERE Length BETWEEN (SELECT max_len FROM Max_Length)/4 AND (SELECT max_len FROM Max_Length)/4*3;



-- 3. Wie viele Titel auf dem Medium mit der ID 5128 besitzen eine Spieldauer, die länger ist als die durchschnittliche Spieldauer aller 
--    insgesamt erfassten Titel?  

WITH Avg_Length AS (
	SELECT AVG(Length) AS avg_len FROM Songs
	)
SELECT COUNT(DISTINCT s.SongId)AS LongerAvgSongs FROM Songs s 
INNER JOIN includes i ON s.SongId = i.SongId
WHERE i.MediumId = 5128 AND s.Length > (SELECT avg_len FROM Avg_Length);

-- 4. Welche Künstler (Artists) haben nur Alben (Records) in den Jahren (Year) von 1990 bis 1999 veröffentlicht?  Es genügt die Ausgabe der ArtistId. 

SELECT ArtistId FROM Records
GROUP BY ArtistId
HAVING MIN(Year) >= 1990 AND MAX(Year) <= 1999;


-- 5. Welche sind die fünf Künstler (Artists), welche die meisten Alben (Records) im Zeitraum (Year) von 1980 bis 1989 veröffentlicht haben?
--    Es genügt die Ausgabe der ArtistId. 

SELECT ArtistId, COUNT(RecordId) FROM Records
GROUP BY ArtistId
ORDER BY COUNT(RecordId) DESC
LIMIT 5;


-- 6. Welche Alben (Records) beinhalten auf einem Medium (MediumId) mit mehr als 10 Songs (TrackCount) einen Song mit dem Namen 
--    „Time Flies“? Es sollen RecordId und Name des Albums ausgegeben werden. 

SELECT r.RecordId, r.Name FROM Records r
INNER JOIN includes i ON r.MediumId = i.MediumId
INNER JOIN Songs s ON i.SongId = s.SongId
WHERE TrackCount > 10 AND s.Name = "Time Flies";

-- BAAAAA

SELECT MediumId FROM Records WHERE RecordId = 54953;
SELECT SongId FROM includes WHERE MediumId = 54953;	
SELECT Name FROM Songs WHERE SongId BETWEEN 3627936 AND 3627948
