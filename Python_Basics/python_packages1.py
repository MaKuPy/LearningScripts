# Kapitel 11: Interessante Pakete in Python

# Dieses Kpaitel umfasst:
# - Arbeiten mit ExcelSheets
# - Arbeiten mit PDFs
# - Senden von Texten
# - Automate Browsers
# - Web Scraping etc.

# >> nur Basics der Pakete

# X Was sind APIs
# Viele Websiten machen Ihre Daten über APIs verfügbar
# Sog. Application Programming Interfaces, die im Internet öffentlich aufgerufen werden können

# Beispiel Yelp - Fusion
# https://fusion.yelp.com # ist die REST (Represenational State Transfer) API for Yelp
# >> Documentation Link >> Endpoints for various businesses

# e.g. YELP hat eine API, um nach Unternehmen zu suchen
# https://docs.developer.yelp.com/reference/v3_business_search
# >> Business_Search findet Unternehmen via Keywords, Location, Category und Preis
# >> Phone_search findet Unternehmen via Telefonnummer etc.
# >> Reviews oder Inforamtionen über ein Unternehmen können ebenfalls gefunden werden

# API über https://api.yelp.com/v3/businesses/search verfügbar

# Es gibt auch weitere Endpoints, wie Events oder Reviews

# In Yelp muss ein Account erstellt werden, um API Calls machen zu dürfen
# Die folgende App wurde mit einem Probeaccount geplant
# >> Dadurch bekommt man eine ClientID und einen API Key (wie ein PW, das die Calls zurückführen kann)
# >> wird in YelpPy weitergeplant


# X Sending Messages - with twilio API
# Man muss einen neuen Account erstellen und eine virutelle Nummer generieren
# KYUL462UHECZGUXAQB1Z77EN
# >> See PyText Ordner


# X Web Scraping
# e.g. Programm, dass die neusten Fragen von StackOverflow läd
# >> See PyCrawler


# X Browser Automation
# als ein Testengineer einer Website, müssen viele Webaktionen manuell getestet werden (e.g. Click Button, Links,
# Formulare ausfüllen, Funktionen testen etc.) >> Selenium erlaubt Browser Automation
# Beispiel: Login to Git-Hub > Fülle das Formular aus > Klicke auf Avater > Prüfe, ob der Name angezeigt wird


# X Mit PDFs arbeiten
# die meisten Pakete, die mit PDF arbeiten, sind instabil oder schlecht dokumentiert
# >> In dem Kurs wird pdpdf2 behandelt >> siehe PyPDF


# X Mit Excel arbeiten
# siehe PyExcel

# X Numpy
# siehe PyNumbers


# X Webapplikations mit Django
# >> siehe vidly Ordner

# Mit Djago können schnelle, sichere, skalierbare Webapplikationen erstellt werden
# e.g. youtube, instagram, dropbox laufen über Django

# Ein Projekt wird am einfachsten über die commandline erstellt
# mkdir vidly # erstellt Ordner
# cd vidly # geht zum Ordner

# pipenv install django
# pipenv shell# in neuer Version

# django-admin startproject vidly .
# code . # öffnet vs code mit vorgefertigten Dateien

# - manage.py: ist für administrative Funktionen :) >> damit wird der webserver gestartet
# - vidlyOrdner: mit __init__.py (paket), settings.py (various config-setting),
#   urls.py (url endpoints), wsgi.py (webserver gateway interface) >> represent standard interface betweens
#   apps written in python and webservers

# Django Projekte können eine Vielzahl von Apps enthalten, die einen Teil der Anwendung definieren
# e.g. Amazon hat Bereiche, wie Shipping, Customer Service, Ordering etc. >> können in anderen Websites verwendet werden

# python manage.py startapp movies >> erstellt eine neue movies app
# Erstellt einen Ordner mit:
# __init__.py
# admin.py # definiert den Bereich für das managen von Filmen
# apps.py # Konfiguration Settings für die App
# model.py # Klasse in der Domain der App
# tests.py # Schreibt aumatische Tests
# views.py # Schreibt View Funktion >> was der Server bei einem request zurückspielt (e.g. html-Datei)

# MVC-Architekture
# Model-View-Controller

# Django nutzt MVT Muster
# Model-Template-View

# X View Funktionen
# in views.py werden Funktionen erstellt, die bestimmen, was an den Nutzer nach einem http-Request
# zurückgespielt wird >> müssen immer eine HttpResponse returnen (from django.http import HttpResponse)
# e.g def index(request):
#        return HttpResponse("Hello") # alternativ kann auch ein html doc mitgegeben werden

# >> anschließend müssen die view-Funktionen zu links gemappt werden
# dafür wird ein neues Skript urls.py erstellt und url patterns als django.path-objekte definiert

# urlpatterns = [
#   path('', views.index, name="index")  # mappt die index-ViewFunktion zu der Startseite ''
# ]
# >> Dies ist eine url-Konfiguration

# Um das urlpattern in der Hauptfunktion von vidly zu integireren, muss der Pfad ebenfalls in urls.py
# von vidly gemappt werden

# include muss erst von django.urls importiert werden
# urlpattern = [
#     path('admin/', admin.site.urls)
#     path('movies/', include('movies.urls'))  # muss ergänzt werden
# ]

# nun wird für jede Seite, die mit /movies beginnt, die view-Funktion im movies-Modul ausgeführt
# e.g. die startseite (nur /movies), gibt den output aus index()


# X Models
# in Models werden Klassen definiert, die für Datenbanken relevant sein können
# Dabei ist das Modul models aus django.db hilfreich, das die Model-Klasse enthält, die viele Datenbank-Funktionen aufweist
# e.g models.save speichert einen Wert in der Datenbank >> Das wird database abstraction api genannt
# - Definierte Klassen sollten dann von Model abgeleitet werden
# - Inhalte sollten als Felder gesetzt werden model.CharField(max_length=255) setzt z.B. ein Stringfeld
# >> max_length wird gesetzt, um Sicherheitslücken zu schließen
# - IntegerField() für Zahlen, FloatField() für Dezimalzahlen und mit ForeignKey(Klasse, on_delete) kann ein
#   Verweis auf eine bestehende Klasse gemacht werden

# >> Anschließend müssen die Models mit der Datenbank synchronisiert werden


# X Website-Datenbanken
# django erstellt bereits mit start des Projekts eine sqlite3 Datenbank, die für einfache Apps geeignet ist
# Für größere Projekte würde eher eine Datenbank wie MySQL, SQL_Server, Oracle etx verwendet werden, die
# 1000-1000000 Einträge fassen können und zudem Sicherheitsfeatures bietet

# Normalerweise müsste diee Datenbank im sqlite3 Browser geöffnet werden und die relevanten Tabellen mit
# Feldern erstellt werden >> django vergleicht die Datenbank automatisch mit dem modules-Code und erstellt
# die benötigt Tabellen und Felder in der Datenbank, es erstellen eine migration.py Datei, die die Module mit
# der Datenbank synchronisiert
# >> dazu wird python manage.py makemigrations ausgeführt

# Damit die Module von dem Programm erkannt werden, müssen diese zunächst registriert werden
# unter settings.py, die die Konfigurationseinstellungen der Applikation enthält (wie INSTALLED_APPS)
# >> INSTALLED_APPS enthält einige Standard-Module, die in Django automatisch angelegt sind:
# - admin für das admin-Backend
# - auth für ein authentification Framework (Managed Erlaubnis zum Ausführen bestimmter Tasks)
# - contenttypes für generic relationships between model-Klasses
# - session ein Framework, um kurzzeitige Nutzerinformationen zu speichern
# - messages ein Framework, das Nachrichten an den Nutzer kommuniziert
# - staticfiles managed Dateien, wie Audio oder Image-Dateien

# >> dort muss die movies-App registriert werden
# Dafür wird von dem Modul movies, die Datei app mit der MoviesConfig Klasse bennant
# >> "movies.app.MoviesConfig" in settings.py unter INSTALLED_APPS ergänzt
# >> mit python manage.py makemigrations erstellt die migrations Datei, der Code für die Anpassung
#    der Datenbank enthält oOo
# >> mit python manage.py migrate werden diese Anpassungen der Datenbank umgesetzt

# Die Datenbank enthält nun alle relevanten Tabellen (sowohl solche, die von Default Apps verwendet werden,
# als auch die, die von den Modulen definiert werden)

# mit python manage.py sqlmigrate movies 0001 (Modulname Migratename) im Terminal wird der SQL Code ausgegeben,
# mit dem die Datenbank geupdaeted wird


# X Admin Area (Backend)
# - ein Bereich, der von Admins verwendet werden kann, um die Datenbank mit Filmen zu füllen
# - by Default gibt es aufgrund der auth.app schon einen Login-Bereich für Admins
#   >> python manage.py runserver >> ergänze /admin/ in der URL
# - Damit der Login funktioniert, muss nun ein superuser angelegt werden
#   im Terminal: python manage.py createsuperuser (Name, Email und Passwort werden abgefrage)
#   (kuro, 1234)
# - Im Admin Bereich können Gruppen und User angelegt und gemanaged werden
#   >> die angelegten Modelle können dort noch nicht gemanaged werden
#   >> dafür muss unter movies im admin-Script Code registriert werden
#      importiere die Klassen und nutze admin.site.register(Klasse)
# - Nun können die Klassen im Admin Panel ergänzt werden >> Die Default Tabelle ist allerdings etwas unübersichtlich

# Admin Bereich customizen
# - Die Anzeige der Datenbank-Einträge im Admin Bereich, wird durch die Standard __str__ M-Method bestimmt
#   >> um den Output zu verändern muss diese also überschrieben werden e.g.
#   def __str__(self):
#       return self.name    # Um Name in Datenbank anzuzeigen
# - um eine Tabelle von Attributen anzuzeigen, muss in admin.py etwas Code ergänzt werden
#   es wird eine Klasse GenreAdmin erstellt, die die Funktionalität von admin.ModelAdmin erbt
#   >> in der Klasse wird die funktion list_display angepasst auf einen Tuple mit Namen der gewünschten
#      Attribute >> final muss auch die GenreAdmin-Klasse registriert werden


# X Datenbank auf Website darstellen
# Dazu muss die view Funktion für movies angepasst werden, die aktuell nur "Hello World ausgibt"
# - from .models import Movie, um die Database abstraction API nutzen zu können, die durch die Inheritence der Klasse nutzbar wird
#   mit Movie.objects.all() # liest alle Elemente aus der Datenbank
#   mit Movie.object.filter(release_year=1984) # kann die Liste gefiltert werden
#   mit Movie.object.get(id=1) # kann ein einzelnes Objekt ausgewählt werden
# >> All diese Methoden transformieren den Code in SQL-Statements, die die gewünschten Inhalte aus der Datenbank ziehen
# >> Alternativ könnten auch direkt SQL Statements geschrieben werden

# Diese Elemente sollten jetzt idealerweise in html-Templates eingefügt werden, damit sie sauber angezeigt werden können
# - dafür wird die render(request, 'template.html', {'name':imported-data}) Funktion von django.shortcuts in Views returned
# - nun muss ein templates-Ordner im Module erstellt werden (da Django by default nach dem Namen sucht)
#   und darin ein html-template für die Seite angelegt werden
#   >> e.g. kann mit table.table>thead>tr>th*3 eine Tabellenkopf mit 3 Spalten angelegt werden
#   >>      tbody>tr>td*4 erstellt eine Zeile 4 Spalten darunter
# - um das Template dynamisch an die Datenbank inhalte anzupassen, kann einfach django html verwendet werden
#   mit {% logic %} können Schleifen in html-Templates integriert werden (siehe Skirpt)
#   mit {{movies.tiltle}} können außerdem variablen, die im Skript importiert wurden (siehe render) aufgerufen werden

# >> Ein Problem von render ist, dass es alle Module durchgeht, die der Reihenfolge nach in app.py angegeben wurden
#    Dafür sollte ein subfolder in templates mit dem namen des Moduls ergänzt werden, darin wird der das hmtl-Template
#    ergänzt und der subfolder name bei render mit 'name/template-Name.html' aufgerufen


# X Adding Bootstrap zur Anwendung
# Bootstrap ist eine beliebtes CSS Framework >> https://getbootstrap.com/
# Unter Dokumentation kann man nachschlagen, wie bootstrap zu einer Anwendung hinzugefügt werden kann
# - Es wird ein Base-Template in templates(movies) erstellt, dass den Base HTML COde von bootstrap inklusive eines
#   Stylesheets enthält: wichtig <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
#   muss ergänzt werden
# - bei body kann alles durch einen django-html-Code ergänzt werden   {% block content %} {% endblock  %}
#   >> nachdem {% extends "movies/base.html" %} oben im html der Seite ergänzt wurde, kann der block mit dem Namen Content
#      einfach im Basis Template eingefügt werden
# - Das Base-Template kann nun durch eine Anpassung des html.-Codes erweitert werden.
#   >> in der Doc von Bootstrap finden sich dafür einige hilfen, e.g kann der COde für eine Navigationbar kopiert werden
#      oder Klassen der Tabellen Funktion hinzugefügt werden, die hovereffekte erlauben, bzw- eine Tabellenbegrenzung einzeichnen

# - Das Base-Template sollte allerdings für alle Seiten und Apps zugänglich sein. Dafür wird ein neuer Ordner in dem
#   directory erstellt mit dem Namen Template und base.html hineingeschoben
#   >> anschließend muss in settings.py unter templates das Directory bei TEMPLATES: unter DIRS mit
#      os.path.join(BASE_DIR, 'templates') ergänzt werden, damit der templates Ordner im Main-DIrectory für den Display durchsucht wird


# X URL Pfade ergänzen
# - Um beispielsweise eine Detailansicht für die Filme zu ergänzen müssen weitere url-Pfade in urls ergänzt werden
#   >> path('<movie_id>', views.detail, name='movies_detail) ergänzt einen Pfad für movies/1, movies/2 etc.
#   >> dann muss die Funktion views.detail erstellt werden
#   >> mit '<int:movie_id>' kann der typ der url Ergänzung spezifiziert werden e.g. auf einen integer Wert

# - Um in der Detailansicht die Informationen zu den einzelnen Filmen anzuzeigen, wird in der views.detail Funktion
#   mit return render(request, 'movies/detail.html', {'movie': movie}) ein neuen html.Template mitgegeben
# - detail.html sollte erstellt werden, oben {extends} von base ergänzt werden und ein content Block definiert werden
#   um die Details in einer liste darzustellen kann dl > (dt + dd) * 3 verwendet werden
#   >> in dt kann nun der Titel eines Listenitems geschrieben werden und in dd mit {{movie.attribute}} der Wert aus der Datenbank gelesen werden

# - Um Pfade abzufangen, die nicht existieren etc /movies/10 sollte in der details-Funktion ein try-Block ergänzt werden
#   der bei einem Movie.DoesNotExist Error eine HTTP404-Exception (standard für nicht existierende Seite) raised
# >> mit der get_object_or_404 Funktion aus dem Paket django.shortcuts kann dieser Code verkürzt werden, indem beim
#    einlesen aus der Datenbank die Funktion ausgerufen wird, dabei muss als erstes Argument die Objektklasse benannt werden


# X URLs verlinken
# - Um Urls in der MovieTabelle dynamisch zu verlinken könnten in dem index.html template um den Inhalt des
#   title <tr>'s ein <a href="url"><> ergänzt werden >> mit "movies/{{movie.id}} wird die url dynamisch in Abhängigkeit
#   von der Film-ID erstellt
# >> das ist allerdings nicht die beste Lösung, da sich die URL in Zukunft ändern kann
# - Besser ist es die URL mit dem Namen zu verlinken, dafür wird das url tag von django html verwendet,
#   http="{% url 'url_name' movie.id %}" # der url_name wird in urls definiert, wichtig auf mitgegebene
#   Werte (movie nicht movies!) achten


# X Creating API's
# In django gibt es zwei wichtige frameworks zum Erstellen von API's djangorestframework und tastypie (in dem
# Projekt verwendet) >> https://django-tastypie.readthedocs.io/en/latest/
# - pipenv install django-tastypie, um das Paket in der virtuellen Umgebung zu installieren
# - mit python manage.py startapp api, um eine neue App für die API zu erstellen
#   >> muss in settings unter INSTALLED_APPS mit 'api.apps.ApiConfig' ergänzt werden
# - nun müssen einige Models ergänzt werden, die bei API's als Ressourcen bezeichnet werden, e.g. restful APIs (Konvention)
# - es wird eine MovieResource-Klasse erstellt, die der tastypie,resources-Klasse MovelResource abgeleitet wird
#   - Darin müssen einige Aspekte der MetaKlasse definiert werden:
#     *queryset = SQL-Statement, dass alle Daten zurückgibt (e.g. Movie.object.get_all())
#     *name = "movies"  # Name der zukünftigen API
# - die API muss in der URL-Struktur von vidly ergänzt werden: path('api/', include(movie_resource.urls))
#   >> dafür wird zunächst die MovieRessoruce Klasse importiert, ein Objekt davon erstellt und die .urls
#      Funktion in include ergänz, was automatisch den Namen der API, die in MovieRessources definiert wurde als URL ergänzt


# X Konfigurieren der Homepage
# Dafür wird im vidly order eine views.py Funktion erstellt, die eine bei einem home(request) ein home.html Dok mitgibt
# Die home.html Datei wird im templates-Order gespeichert und zum Schluss wird in urls der Pfad '' zu views gelinkt.


# X Veröffentlichen einer Website vorbereiten
# Benötigt eine cloud-Platform, wie Heroku (https://www.heroku.com/), GoogleCloud, AWS, Amazon Webservices etc., in
# der die Website hochgeladen wird.
# >> Erstelle einen Account
# >> Lade Heroku CLI (Command Line Interface)
# >> Setup Git, um Versionsupdates etc. durchzuführen

# Überprüfe Versionen im Terminal durch git --version, heroku --version
# >> Fehlermeldung wenn nicht installiert

# Installiere Paket gunicorn, ein server, der für Produktionsumgebung (von NUtzern verwendbar) geeignet ist
# >> Erstelle Procfile im root-Ordner, das von Heroku verwendet wird, um die App zu starten
# >> Darin schreibe web: gunicorn vidly.wsgi (sagt Heroku, dass es sich um einen Webprozess handelt
#    ein gunicorn server zum Start verwendet werden soll und die App mit vidly.wsgi gestartet wird)
# >> Veröffentliche Static Files (e.g. Bilder für Heroku), Dafür wird in settings eine Variable STATIC_ROOT
#    definiert, in der >> danach python manage.py collectstatic im Terminal ausführen, um die files in den Static-ORder zu kopieren
#    >> Für Heroku muss mit pipenv install whitenoise installiert werden >> dann muss whitenoise.middleware.whiteNoiseMIddleware in settings unter MIDDLEWARE sevurity ergänzt werden


# X Die Website veröffentlichen
