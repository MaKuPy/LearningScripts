# Kapitel 9: Python Standard Library - Teil 2
import subprocess
import sys
from string import Template
import smtplib
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from pathlib import Path
import webbrowser
import random
import string

# X random Modul
# enthält nützliche Funktionen, um Zufallszahlen zu generieren
print(random.randint(1, 100))  # Zufallszahl in range 1-100
print(random.random())  # zufällige float
print(random.sample(range(100), 10))  # zieht 10 Zahlen v. 1-100

pets = ["cat", "dog", "g.pig", "parrot"]
print(random.choice(pets))
# wählt zufällig ein Item aus einem Iterable

print(random.choices("abcdefghijklmnop", k=4))
# wählt k items aus

# um das Ergebnis als ein String auszugeben
print("".join(random.choices("abcdefghijklmnop", k=4)))
# ", ".jpint trennt Werte mit ,
print(", ".join(random.choices("abcdefghijklmnop", k=4)))
print(string.ascii_letters)  # gibt alle ascii_letters

# Passwort Generator
print("".join(random.choices(string.ascii_letters + string.digits, k=10)))

random.shuffle(pets)
print(pets)  # Ändert Reihenfolge der Elemente in Iterable


# X webbrowser Modul - Öffnen von Browsers
# import webbrowser
# webbrowser.open("http://google.com") # öffnet den Browser unter der angegebenen URL


# X - zum Emails senden
# Benötigt Pakete...
# ... um eine Email zu erstellen
# from email.mime.multipart import MIMEMultipart
# from email.mime.text import MIMEText


# >> mime steht für multipurpose internet mail extensions und ist ein Standard, der das
#    format von Emails definiert
# >> Die Klasse MIMEMultipart erlaubt das Versenden von EMails mit txt und html Format

# ... um sich mit einem smtp.server zum Versenden zu verbinden
# import smtplib

message = MIMEMultipart()
message["from"] = "Manuel Kulzer"
message["to"] = "manuel.kulzer@uni-mannheim.de"
message["subject"] = "test"
# In Mimetext wird der Inhalt der Mail mitgegeben
message.attach(MIMEText("Body", "plain"))
# Um ein Bild anzuhängen (muss in binary Format sein)
message.attach(MIMEImage(Path("example.png").read_bytes()))

# Um stattdessen einen html. Text zu versenden muss MIMEText("Ein html.text", "html")
# verwendet werden >> zweites Arg = benennt Format

# Email versenden:
# Zum Senden, wird ein smtpserver verwendet
# smtp = smtplib.SMTP(host="smtp.gmail.com", port=587)
# smtp.close()  # schließt die Verbindung zum smtp.Server

# Besser mit with arbeiten
# with smtplib.SMTP(host="smtp.gmail.com", port=587) as smtp:
#     # Erster Teil des smtp-Kommunikation Protokolls - Greeting
#     smtp.ehlo()  # sagt Hallo zum Server
#     # Öffnet eine sichere Verbindung > nachfolgende Kommunikation ist encrypted
#     smtp.starttls()
#     smtp.login("name", "passwort")
#     smtp.send_message(message)
#     print("Sent...")


# X Templates
# statt den Text in der message.attach(MIMEText("Inhalt")) Funktion zu schreiben
# werden html Templats zum versenden von Emails verwendet
# 1. Erstelle ein Dokument mit .html im Projekt-Ordner (e.g. template . hmtl)
# >> mit ! + Enter wird ein Basis html-Code erstellt

# 2. Template Datei laden
# from string import Template
# Datei als Text laden und zu einem Template konvertieren
template = Template(Path("template.html").read_text())

# 3. Nun können Variablen, die im Template mit $ definiert wurden, variabel ausgetauscht werden
# >> dafür wird die .substitute Methode verwendet, die keyvalue:pairs von
#    dictionairen oder keyword Arguments verwendet
body = template.substitute({"name": "John"})  # return string
print(body)  # zeigt replacement
message.attach(MIMEText(body, "html"))  # setzt den text in message ein

# Um eine Liste von Namen zu ersetzen
# names = ["John", "Mary", "Louis", "Berta"]
# for name in names:
#     print(template.substitute({"name": name}))


# X Command Line Argumetns
# In manchen Programmen könnte es Sinn ergeben, die Command Line Konsoule mit zu verwenden

# import sys
# Gibt Argumente, die im Terminal beim Starten des PRogramms genannt wurden
print(sys.argv)

# >> Kann dazu verwendet werden, um ein Passwort zu speichern oTL


# X Running External Programms
# besonders hilfreich als Teil von automatisierten Prozessen
# Funktioniert nicht, da MaC oTL

# import subprocess
# Damit können andere Programme verwendet werden

# Methoden
# subprocess.run()
# subprocess.call()
# subprocess.check_call()
# subprocess.check_output()
# >> Alles Methoden, die ein Objekt der Popen (P(rocess)-open) Klasse erzeugen
# Bis auf run() jedoch ziemlich veraltet
subprocess.run(["dir"], check=True)  # funktioniert i.wie nicht... tut in MAC
