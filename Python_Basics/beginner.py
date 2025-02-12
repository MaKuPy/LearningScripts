

# Aufgaben aus
# Programming mit Mosh
# https://members.codewithmosh.com/courses/python-programming-course-beginners-1/lectures/6781572


import math
print("Hello world")


# Extensions Python, pylint und .Run machen das Programmieren einfacher

# Linting shows problems with your code in a read underline
# MIt der Maus draufgehen, gibt Tipps, wie das PRoblem zu loesen ist
# Ctrl + Shift + M

# Formatierungsstil - PEP8
# Styleguide für Codeformate
# https://peps.python.org/pep-0008/

# Ctrl + Shift + P offnet comand line
# nach format suchen > format document auswählen, formattiert den Code automatisch nach PEP8

# Für .run muss Python in PATH installiert werden
# Dann kann der Code einfach mit STR + ALT + N ausgeführt werden


# Variables
# nutze drei """ für Textblöcke
# \ ist ein escape Zeichen, dass den nächsten Character überspringt
# so können " oder # oder \ in einen String aufgenommen werden
# \n steht für eine neue Zeile

# X Strings
absatz = """ Hallo \"John\"
Das ist ein Absatz

Danke :)"""
print(len(absatz))  # absatz hat 40 zeichen


# String-Methoden
# Methoden werden mit einem . hinter dem Objekt-Namen aufgerufen
headline = "  programmier kurs"

print(headline.capitalize())  # macht den ersten Buchstaben groß
print(headline.title())  # macht die Anfangsbuchstaben groß
print(headline.upper())  # macht alle Buchstaben groß

print(headline.strip())  # entfernt whitespace am Anfang und Ende
# .rstrip entfernt whitespace am Ende (right)
# .lstrip entfernt whitespace am Anfang (left)

print(headline.find("pro"))  # Gibt Index des gesuchten Patterns
print(headline.replace("r", "i"))  # Ersetzt Zeichen

# wichtig ist, dass dabei das ursprüngliche Objekt nicht verändert wird
print(headline)

print("pro" in headline)


# X numbers

x = 1  # integer
y = 1.99  # float
z = 1 + 2j  # complex number

# Math-Operations
# +, -, /, *
# // ganzzahlige Division
# % Modulo (Rest nach ganzzahliger Division)
# ** Potenz

# number functions
round(1.99)  # rundet die Zahl auf 2
print(abs(-2.5))  # gibt den absoluten Wert

# Für komplexere mathematische Operationen wird das math-Modul benötigt


# https://docs.python.org/3/library/math.html
# zeigt alle möglichen Funktionen im Math-Modul
math.ceil(2.2)  # rundet auf

print(math.cos(10))


x = int(input("x: "))
y = x + 2
print(y)
