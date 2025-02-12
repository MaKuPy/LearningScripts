# Kapitel 9: Python Standard Library - Teil 1

# Python enthält viele Bibliotheken (wie R Package), die spezifische Funktionalitäten
# für die unterschiedlichsten Aufgaben enthalten

# >> hier werden einige Standard Bibliotheken ausgetestet
from datetime import datetime, timedelta
import sqlite3
import json
import csv
from zipfile import ZipFile
from pathlib import Path
import time
# import shutil

# X pathlib Bibliothek
# https://docs.python.org/3/library/pathlib.html >> Übersicht über Funktionen
# from pathlib import Path

# Das Path-Objekt der pathlib library erlaubt das erstellen von Dateipfaden als Objekt
Path()  # der aktuelle Pfad

# Pfad aus der Struktur des aktuellen Directories
path = Path("ecommerce\\__init__.py")

# Andere Pfade festlegen
Path("C:\\Users\\Manue\\Desktop\\Textanalysis")
# Doppel \, da \ = Escape_Charakter

Path(r"C:\Users\Manue\Desktop\Textanalysis")
# oder raw string, der keine Escape_charakter zählt

# Möglich Pfade zu kombinieren
# Path() / "ecommerce"  # wählt ecommerce Ordner aus

print(Path.home())  # return home directory

print(path.exists())  # Kontrolliert, ob Pfad existiert
print(path.is_file())  # Gibt True, wenn Pfad auf eine Datei zeigt
print(path.is_dir())  # GIbt True, wenn Pfad auf das Directory zeigt

print(path.name)  # Gibt vollen Dateiname
print(path.stem)  # Gibt nur den Namen
print(path.suffix)  # Gibt Suffix der Datei
print(path.parent)  # Gibt den Ordner der Datei

print(path.absolute())  # GIbt den kompletten Dateipfad

# erstellt einen neuen Pfad, mit anderer Datei
path = path.with_name("file.txt")
print(path)  # die Datei sollte dann jedoch auch existieren


# X Mit Verzeichnissen (directories) arbeiten
path = Path("ecommerce2")
print(path.exists())  # Kontrolliert, ob Pfad existiert
# path.mkdir() # erstellt ein neues directory (Ordner :))
# print(path.exists())
# path.rmdir()  # entfernt das directory
# print(path.exists())
# path.rename("") # gibt neuen Namen

# Gibt eine Liste von Dateien und Orndern in dem Pfad als Generator-Objekt
print(path.iterdir())
# >> Generator ist effizienter als eine Liste, wenn 1000 files enthalten sind

path = Path("ecommerce")

for p in path.iterdir():
    print(p)

# Dateien im DIrectory können mit Listcomprehension zu einer Liste konvertiert werden

paths = [p for p in path.iterdir()]
print(paths)

# Pfade können auch gefiltert werden
paths = [p for p in path.iterdir() if p.is_dir()]
print(paths)  # gibt nur Ordner aus

# mit dieser Methode kann man jedoch nicht nach Worten suchen.
# >> Dafür gibt es die path.glob() Methode
path.glob("*.*")  # erstellt ein generator Objekt
# *.* bedeutet alle Dateien
# *.py beudetet alle .py Dateien
# alternativ kann auch ein Name verwednet werden
for p in path.glob("*.py"):
    print(p)

# um in allen subordnern zu suchen kann path.glob("**/*.py") verwendet werden
# oder rglob("*.py")

# X Mit Dateien arbeiten
path = Path("ecommerce\\__init__.py")
# path.unlink() # schließt die Verbindung zu dem Pfad/entfernt Datei evtl.
print(path.stat())

# st_size = size of file in bytes;
# st_atime = last access time
# st_mtime = last modification time
# st_ctime = creation time

# Zeit wird in Sekunden nach EPIC (Start time for Computers) gemessen
# >> um dies in lesbare Zeit zu ändern:
# from time import ctime
print(time.ctime(path.stat().st_ctime))

# Dateienn einlesen
# path.read_bytes() # liest Datei als byte.File
# path.read_text() # liest Datei als txt.File

# Alternative mit open(filename, mode)
# with open("__init__.py", "r") as file:
#     pass
# >> Best Practice: Datei mit with öffenen, damit sie automatisch geschlossen wird

# path.read_text() ist etwas einfacher


# Dateien schreiben
# path.write_bytes("Name")
# path.write_text("Name")
# >> erstellt eine Datei mit Namen und Typ Bytes/Text


# # Datein kopieren ist etwas schwierig
source = Path("ecommerce\\__init__.py")
target = Path() / "__init__.py"

# target.write_text(source.read_text()) # kopiert dei Datei in den Zielpfad

# X shutil
# Ermöglicht einfacheren Umgang mit Dateien
# import shutil
# shutil.copy(source, target)
# >> kopiert die Datei in den Zielpfad


# zipfiles Modul
# from zipfile import ZipFile
# w für write, wenn eine Datei geschrieben werden soll
zip_file = ZipFile("files.zip", "w")  # schreibt das zip-File, files.zip

for path in Path("ecommerce").rglob("*.*"):
    zip_file.write(path)
# >> schreibt alle Dateien im ecommerce-Ordner in die zip-Datei
zip_file.close()

# Besser mit with arbeiten >> Damit die Datei auf jeden Fall wieder geschlossen wird
# with ZipFile("files.zip", "w") as zip_file:
#     for path in Path("ecommerce").rglob("*.*"):
#         zip_file.write(path)

# Zip-file lesen
with ZipFile("files.zip") as zip_files:
    print(zip_file.namelist())
    info = zip_file.getinfo("ecommerce/sales.py")
    print(info.file_size)
#   zip_file.extractall("extract") extrahiert alle Dateien in einen neuen Ordner extract

# Um alle Dateien aus dem zip-File auszulesen


# X mit csv-Dateien arbeiten
# csv = Tabellen, die im csv format gespeichert sind

# csv-Dateien schreiben
with open("data.csv", "w", newline='') as file:  # schriebt eine csv-Datei
    # erstellt einen csv.Writer, mit dem die Tabelle gefüllt werden kann
    writer = csv.writer(file)  # erstes arg ist eine .csv Datei
    # schreibt Kopfzeile
    writer.writerow(["transaction_id", "product_id", "price"])
    writer.writerow([1000, 1, 5])
    writer.writerow([1001, 2, 15])

# csv-Dateien lesen
with open("data.csv") as file:
    reader = csv.reader(file)
    # print(list(reader)) # gibt Reihen als Liste in Listen aus
    for row in reader:
        # funktioniert nur, wenn print() ausge-# ist, da ein inter index in csv.
        # mitläuft, der nach print am Ende der Datei ist
        print(row)

# >> wichtig, zahlen werden automatisch als strings gespeichert


# X JSON Datein in Python
# JSON = Java Script Object Notation
# Viele Websites, wie Facebook, Youtube, Twitter geben ihre Daten im JSON Format aus

# import json
movies = [
    {"id": 1, "title": "Terminator", "year": 1989},
    {"id": 2, "title": "Kindergarten Cop", "year": 1993}
]

# mit json.dumps()
# wandelt Datein in das json-Format um
data = json.dumps(movies)
print(data)

# JSON Dateien schreiben
# Dieses Objekt kann als Datei geschrieben werden
Path("movies.json").write_text(data)

# JSON Dateien lesen
data = Path("movies.json").read_text()
print(data)  # sieht aus wie eine Liste, ist es aber nicht

movies = json.loads(data)  # wandelt txt in eine liste mit Dictionären um
print(movies[0])  # kann ganz normal verwendet werden


# X SQLite in Python
# SQLite ist eine einfache Form von Datenbanken, die bei einfachen Applikation
# verwendet werden, wie z.B. bei Smartphones und Tabletts
# import sqlite3

# Laden der movies Datei
movies = json.loads(Path("movies.json").read_text())

# conn = sqlite3.connect("db.sqlite3") # erstellt eine connect-Objet in Python
# + eine Datei im Ordner, wenn diese noch nicht existiert

# Inhalte in Datenbank schreiben
# with sqlite3.connect("db.sqlite3") as conn:
#     # Datenbanken werden verwendet, um Dateien reinzuspeichern oder auszulesen
#     # >> nutzt SQL-Commands (nachlesen)
#     command = "INSERT INTO Movies VALUES(?, ?, ?)"  # erstellt 3 leere Spalten
#     for movie in movies:
#         conn.execute(command, tuple(movie.values()))  # tuple benötigt
#     conn.commit()  # schreibt Änderungen in die Datenbank, wenn Movies Tabelle (siehe command) existiert

# um zu schauen, was eingespeichert wird
for movie in movies:
    print(tuple(movie.values()))


# db browser for sqlite >> Google
# Dort kann ein Programm heruntergeladen werden, mit denen SQLite Datenbanken betrachtet werden können
# https://sqlitebrowser.org/

# In dem Browser die Datenbank db.sqlite3 öffnen
# Diese enthält ursprünglich keine Tabellen...
# >> Neue Tabelle ergänzen >> Name Movies
# >> 3 Felder hinzufügen: Id (integer, pk [ist ein unique identifier > primary key]),
#    Title (text), Year (integer)
# - Wenn man Not ankreuzt, bedeutet es, dass das Feld mit Daten gefüllt sein muss

# Abschließen mit "write changes"

# nun hat der Code oben keinen Error > im sqlite Browser unter Movies > Daten durchsuchen > erscheinen nun die DB-Einträge


# SQLite Datenbanken lesen
with sqlite3.connect("db.sqlite3") as conn:
    command = "SELECT * FROM Movies"  # zum Lesen wird ein SELECT Command benötigt
    cursor = conn.execute(command)  # Ergebnis: cursor ist iterable
    # for row in cursor: # hat ebenfalls einen Index der bis zum Ende durchläuft >> deswegen ausge-#
    #     print(row)  # wird als tuple ausgegeben
    movies = cursor.fetchall()  # gibt eine Liste von Tuplen
    print(movies)


# X time Module
# 2 Module um mit Zeit in Python umzugehen time (timestamp) und datetime (datetime objekte)
print(time.time())  # gibt aktuelle Zeit
# wandelt aktuelle Zeit in ein lesbares Format um
print(time.ctime(time.time()))


def send_emails():
    for i in range(1000000):
        pass


# Zeitdifferenzen mit der Maschinenzeit berechnen
start = time.time()
send_emails()
end = time.time()

duration = end - start
print(duration)  # gibt Zeit, die benötigt wurde, um den Code auszuführen


# X datetime Modul - datetime-Klasse
# Das datetime enthält die datetime-Klasse, mit der Daten gespeichert werden können
# from datetime import datetime
dt = datetime(2024, 6, 12)  # Stunden, Minuten, Sekunden sind optional
print(dt)
dt = datetime.now()  # Sspeichert aktuelle Zeit
print(dt)

# datetime.strptime()  # Dazu da ein Datetime-String zu parsen/konvertieren
# >> sinnvoll wenn man user-imput bekommt oder Datum von einer Datei list

# erstes Arg = input, zweites Arg = Datum-Format
dt = datetime.strptime("2023/01/01", "%Y/%m/%d")
# Abkürzungen in docs (unten): https://docs.python.org/3/library/datetime.html
print(dt)

# konvertiert das Objekt von einem timestamp
print(datetime.fromtimestamp(time.time()))

# Einelne Komponente aus dem Dateformat können ausgewählt werden
print(f"{dt.year}/ {dt.month}")
# datetime_Objekt zu formatiertem String konvertieren
print(datetime.strftime(dt, "%y/%m/%d"))  # auch als methode möglich
# Formatstring bestimmt Output


# X datetime Modul - timedelta Klasse
# timedelta-Objekte erfassen Zeitperioden

dt1 = datetime(2024, 6, 11)
dt2 = datetime.now()
duration = dt2 - dt1
print(duration)
print("days", duration.days)
print("seconds", duration.seconds)  # entspricht dem Rest (Stunden)
print(duration.total_seconds())  # Gesamtzeit in Sekunden

# Möglich timedelta-Objekte zu datetime-Objekten dazuzuaddieren
print(dt1 + timedelta(days=1))
