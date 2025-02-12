# Kapitel 10: Technischer Umgang mit Paketen in Python

# import requests

# X Pypi - Python package index

# Nicht alle Probleme in Python lassen sich mit den Funktionen der Standardbibliothek
# lösen. Manchmal müssen externe Pakete installiert werden
# >> https://pypi.org/   # ist ein Repository von unzähligen Pakten für nahezu jede Anwendung
# >> e.g. suche nach Pdf, um Funktionen zu finden, die pdfs handeln

# Nicht alle Funktionen sind buggfrei und manchmal muss man etwas suchen, um die richtige
# Anwendung zu finden
# >> Google oder ChatGPT nach dem besten Paket fragen


# X Pip
# pip install name in Terminal ausführen, um ein Paket zu installieren
# e.g. pip install request

# pip list im Terminal ausführen, gibt Liste der installierten Pakete
# requests 2.32.3; 2 = major Update, 32 = Minor updates, 3 = bugfixes

# unter pypi.org kann nach requests gesucht werden
# >> https://pypi.org/project/requests/ # >> veröffentlichte Historie zeigt früh. Versionen

# pip install requests==2.9.0 # installiert die Version 2.9.0
# pip install requests==2.9.* # installiert die letzte Version, die mit 2.9 kompatible ist


# pip uninstall requests deinstalliert das Paket requests

# Nach dem installieren kann das Paket verwendet werden
# import requests
# https://requests.readthedocs.io/en/latest/ # beschreibt Funktion des Pakets

# response = requests.get("https://requests.readthedocs.io/en/latest/")
# print(response) # Respose = 200 entspricht einem erfolgreichen aufrug


# X Virtual Environment
# eine vituelle Umgebung ist eine geschlossene Umgebung zum Programmieren, die
# sich von dem Standard unterscheidet. >> So können beispielsweise zwei unterschiedliche
# Versionen von Paketen installiert und getestet werden

# $env\bin\activate.bat auf Windows, um die virtuelle Umgebung zu starten (öffnet sich im Terminal)
# Dort kann eine frühere Version von requests installiert werden >> mit pip

# run deactivate im Terminal, um die virtuelle Umgebung zu schließen


# X Pipenv
# erlaubt die Kombination von pip Argumenten mit virtuellen Umgebungen
# pip install pipenv im Terminal verwenden

# nun kann ein Paket direkt in eine virutelle Umgebung installiert werdne
# pipenv install requests  # im Terminal verwenden
# Installiert das Paket in eine virtuelle Umgebung
# + erstelllt Pipfile (managed dependencies) und pipfile.lock (json file, dass die
# Exakte Version der Dependencies enthält) im Directory

# pipenv -- venv # im Terminal gibt den Pfad zur virtuellen Umgebung zurück

# pipenv shell # in Terminal aktiviert die virutelle Umgebung

# dort kann das Programm gestartet werden und das Paket darin wird verwendet

# exit  # im Terminal schließt die virtuelle Umgebung


# X Virtual environment in VS Code
# Der Code Runner (Str + Alt + N) verarbeitet das Programm automatisch in der
# globalen Umgebung
# >> um die virtuelle Umgebung zu verwenden, muss der Pfad des Python Interpreters
#    aus der virtuelle Umgebung angegeben werden
# pipenv -- venv # gibt Pfad der virtuellen Umgebung >> suche Python >> kopiere Pfad

# >> Muss in Settings angepasst werden... Siehe Video ziemlich meh


# X Pipfile >> siehe Video
# ziemlich cool, damit kann das Projekt auf einen anderen Rechner übertragen werden
# mit pipenv install werden dann alle dependencies aus der pipfile datei
# genauso installiert, wie sie für die Anwendung benötigt werden

# pipenv install --ignore-pipfile # verwendet die pipfile.lock Datei und reproduziert
# die Bedingungen, die beim Schreiben der Datei vorlagen


# X Manageing Dependencies
# $pipenv graph # im Terminal gibt alle Dependencies der Pakete aus

# e.g. das installiserte Paket requests benötigt certifi, chardet, idna, urllib3

# $pipenv update --outdated # im Terminal # updated alle Pakete
# $pipenv update requests # updatet requests


# X Pakete veröffentlichen
# Erstelle einen Account auf pypi.org

# Es werden 3 Tools benötigt
# pip install setuptools wheel twine

# erstelle ein neues directory und öffne VS Code
# >> Best Practice: in dem Ordner ein top_lvl Ordner mit dem Namen des Pakets
#    darin ein __init__.py File, README.md LICENSE evtl. weitere Ordner mit Daten,
#    tests etc.
# >> In dem Ordner könnten jetzt unterschiedeliche Module programmiert werden

# erstelle eine Datei setup.py im Projekt-Directory, mit folgendem Code

# import setuptools

# setuptools.setup(
#    name="workpdf", # Name des Pakets
#    version="1.0" # Versionsnummer
#    long_description=PATH("README.md"),read_text(), # Beschreibung aus README Datei
#    packages="setuptools.find_packages(exclude=["tests", "data"]) # Ordner in # werden ignoriert
# )

# Im READMEmd. wird die Beschreibugn auf pypi. geschrieben
# In LICENSE (https://choosealicense.com/) # gibt Templates, die reinkopiert werden können


# Um es zu veröffentlichen
# $python setup.py sdist bidst_wheel >> generiert 2 Ordner (built und dist) for
# built und source distribution

# $twine upload dist/* # Läd alle Dateien im dist Ordner hoch >> braucht Username und Passwort


# X docstrings
# Docstrings verwendet """ nach der Definition einer Funktion, Klasse etc, um zu
# beschreiben, was die Funktion des Codes ist

# Kommentare werden hingegen verwenden, um zu beschreiben, warum etwas auf eine gewisse Art
# geschrieben wurde

# X Header:
# für kurze Erklärungen
""" One line description."""

# für längere Erklärungen
# """ Short description.

#     Detaillierte Erklärung
# """


# X Funktionen
def convert(path):
    """ 
    Convert the given pdf to text.

    ... optionale Erklärung

    Parameters:
    path (str): The path to a PDF file.
    ... weitere Parameter

    Returns:
    str: The content of PDF file as text 
    """
    print(path)
    print("convert pdf to text")


# X Klassen
class Converter:
    """ A simple converter for converting PDFs to text. """
    print("something")

# X Pydoc
# $pydoc math # im Terminal soll die Dokumentation des Math Modules wiedergeben
