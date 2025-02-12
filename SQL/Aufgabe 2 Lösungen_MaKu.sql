/*Aufgabe 3:
1. Namen aller Gruppen, die im Zeitraum 1980-1985 gegründet wurden */
SELECT Name FROM Artists WHERE BeginYear >1979 AND BeginYear < 1986;

-- 2. Welche männlichen Künstler sind in Deutschland (Germany) oder Frankreich (France) geboren? Auszugeben sind Name und Geburtsland. 
SELECT Name, Location FROM Artists WHERE Gender = "Male" AND (Location = "France" OR Location = "Germany" );


-- 3. Geben Sie die Namen der Titel aus, die sich auf der CD mit der Medium-ID 90 befinden. Formulieren Sie zwei Lösungen: eine ohne und eine mit Verwendung des Join-Operators ⨝.  
SELECT SongId FROM includes WHERE MediumId == 90;
SELECT Name FROM Songs WHERE SongId BETWEEN 1167774820 AND 1164831;

SELECT Songs.Name FROM Songs INNER JOIN includes on Songs.SongId = includes.SongId WHERE includes.MediumId = 90;

-- 4. Welche Künstler haben einen Titel mit der Bezeichnung Never Been Rocked Enough aufgeführt? Geben Sie die Namen sowie die Angaben zu Geburts – und Sterbejahr 
--    (bzw. Gründungs- und Auflösungsjahr) an. Formulieren  Sie zwei Lösungen: eine ohne und eine mit Verwendung eines Join-Operators ⨝.  
--- performs enthält artisid und SongId

SELECT Name, SongId FROM Songs WHERE Name LIKE "Never Been Rocked Enough";
SELECT ArtistId FROM performs WHERE SongId = 207886;
SELECT Name, BeginYear, EndYear FROM Artists WHERE ArtistId = 17;

SELECT a.Name, a.BeginYear, a.EndYear From Artists a INNER JOIN performs p on a.ArtistId = p.ArtistId INNER JOIN songs s on p.SongId = s.SongId WHERE s.Name = "Never Been Rocked Enough";

-- 5. Geben Sie zu allen Künstlernamen die Namen der Alben aus, die der Künstler veröffentlicht hat. Falls für einen Künstler kein Album
--    angegeben ist, so soll nur der Name des Künstlers ausgegeben werden. 
SELECT a.Name, r.Name as Recordname, r.Year FROM Artists a LEFT JOIN Records r on r.ArtistId = a.ArtistId;

-- Test Albums auszählen
SELECT a.Name, COUNT(r.Name) as RecordName FROM Artists a 
INNER JOIN Records r on r.ArtistId = a.ArtistId 
GROUP BY a.Name ORDER 
BY COUNT(r.Name) DESC;


-- 6. Geben Sie die Namen der Künstler aus, die namensgleich mit irgendeinem Songtitel sind (sie müssen diesen Song nicht selbst 
--    aufgeführt haben). Formulieren Sie zwei Lösungen: eine ohne und eine mit Verwendung einer Mengenoperation.
SELECT Name FROM Artists
INTERSECT
SELECT Name FROM Songs;

SELECT a.Name, s.Name FROM Artists a, Songs s WHERE a.Name = s.Name;

