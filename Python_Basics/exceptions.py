# Kapitel 6: Exceptions

# Fehler im Programm, führen ohne das Einbauen von Fehlerkontrollen doft dazu, dass
# das Programm abbricht . Mit Fehlerkontrolle kann stattdessen eine Fehlermeldung
# ausgegeben werden.
# >> Fehler, die ein Programm zum Abbrechen bringen werden Exception genannt

# Häufige Fehlerquellen
# - Programmierfehler
# - Fehlerhafte Eingaben der Nutzer:innen
# - Fehlende Objekte oder Dateien etc.

from timeit import timeit
numbers = [1, 2]
# print(numbers[2])
# der Versuch, ein Item außerhalb der Indexrange zu auszuwählen führt zu einem Error

# age = int(input("Age: ")) führt zu einem valueError, wenn der Nutzer einen Buchstaben eingibt


# X Mit Exceptions umgehen
try:
    age = int(input("Age: "))
except ValueError as ex:
    print("You didnt enter a valid age.")
    print(ex)
    print(type(ex))
else:  # wird ausgeführt, wenn es keinen Error gab
    print("No exceptions were thrown.")

# as ex und print(ex)/print(type(ex)) kann weggelassen werden >> Demonstriert nur,
# dass man die ursprüngliche Fehlermeldung weiterverwenden kann


# X Mit weiteren Fehlermedlungen umgehen
# ergänzt ZeroDivisionError

try:
    age = int(input("Age: "))
    xfactor = 10/age
except ZeroDivisionError:
    print("You didnt enter a valid age.")
except ValueError as ex:
    print("You didnt enter a valid age.")
else:  # wird ausgeführt, wenn es keinen Error gab
    print("No exceptions were thrown.")

# Dieser Code kann folgendermaßen verkürzt werden:
# try:
#     age = int(input("Age: "))
#     xfactor = 10/age
# except (ZeroDivisionError, ValueError):
#     print("You didnt enter a valid age.")
# else:  # wird ausgeführt, wenn es keinen Error gab
#     print("No exceptions were thrown.")


# X Cleaning Up
# Manchmal werden in Programmen Dateien geöffnet, die am Ende auch wieder geschlossen
# werden sollten, damit andere Programme darauf zugreifen können.

# try:
#     file = open("app.py")                           # öffnet ein Programm, das mit file.close() geschlossen werden muss
#     age = int(input("Age: "))
#     xfactor = 10/age
# except (ZeroDivisionError, ValueError):
#     print("You didnt enter a valid age.")
# else:  # wird ausgeführt, wenn es keinen Error gab
#     print("No exceptions were thrown.")
# finally:
#    file.close()

# >> finally: wird immer am Ende des try-Blocks ausgeführt, egal, ob ein Error
# aufgetaucht ist oder nicht >> so können externe Ressourcen sicher geschlossen werden

# (Im Codeblock oben würde file.close() nicht ausgeführt werden, wenn der Code
# zu einem Fehler führt, ohne finally, müsste file.close() also bei except und
# else wiederholt werden)


# X The with-Statement
# Eine Alternative zu finally ist das with statement

# with open("app.py") as file:
#   Code, in dem file genutzt werden kann
# >> schließt Datei danach (file.close()) nicht notwendig

# jedes Objekt, dass eine __exit__ und __enter__ magic-Method hat, kann mit
# dem with-Statement verwendet werden

# Es is möglich mehrere Dateien mit with zu öffnen
# with open("app.py") as file, open("text.txt") as text:
#   Code, in dem file und text genutzt werden kann
# >> schließt Datei danach (file.close()/ text.close()) nicht notwendig

 # X Raising Exceptions
 # Google python3 built-in exceptions, zeigt alle Exceptions, die es bereits in Python gibt
 # https://docs.python.org/3/library/exceptions.html

def calculate_xfactor(age2):
    if age2 <= 0:
        raise ValueError("Age cannot be zero or less")
    return 10/age


# mit einem try statement kann auf die neue Exception getestet werden
try:
    calculate_xfactor(0)
except ValueError as error:
    print(error)

# Raising exceptions ist nicht sehr effizient uns sollte eher vermieden werden

# X Die Kosten von Exceptions

# from timeit import timeit
# timeit erlaubt mir, die rechenzeit einer codezeite zu bestimmen

code1 = """
def calculate_xfactor(age2):
    if age2 <= 0:
        raise ValueError("Age cannot be zero or less")
    return 10/age


# mit einem try statement kann auf die neue Exception getestet werden
try:
    calculate_xfactor(0)
except ValueError as error:
    print(error)
"""
code2 = """
def calculate_xfactor(age2):
    if age2 <= 0:
        raise ValueError("Age cannot be zero or less")
    return 10/age


# mit einem try statement kann auf die neue Exception getestet werden
try:
    calculate_xfactor(0)
except ValueError as error:
    pass
"""
code3 = """
def calculate_xfactor(age2):
    if age2 <= 0:
        return None
    return 10/age


# mit einem try statement kann auf die neue Exception getestet werden
xfactor = calculate_xfactor(0)
if xfactor == None:
    pass
"""


# gibt Prozessorzeit nach 10.000 Ausführungen
print("first code:", timeit(code1, number=10000))
print("second code:", timeit(code2, number=10000))
print("third code:", timeit(code3, number=10000))

# Zeigt, dass das ausgeben der Fehlermeldung, den Prozess enorm verlangsamt
# ebenso das erste Beispiel, bei dem eine Fehlermeldung geraised und überprüft wird
# >> der letzte Code mit return None ist am schnellsten
