# Kapitel 5: Datenstrukturen wie Listen

from collections import deque  # für unten
from array import array  # für unten 288

# X Listen werden mit [] definiert
letters = ["a", "b", "c"]
matrix = [[0, 1], [2, 3]]
print(matrix)

# creating a list with 5 zeros
zeros = [0] * 5

# X Listen komibinieren
print(zeros + letters)

# die list() Funktion erstellt eine Liste aus einem iterable Objekt
reihe = list(range(21))  # Zahlen von 0 bis 20
print(reihe)
print(len(reihe))  # gibt länge der Liste
print(reihe[::2])  # wählt jedes zweite Element der Liste aus = gerade Zahlen
print(reihe[::-1])  # Gibt Liste in umgekehrter Reihenfolge aus


# X Indexing
# mit [] können einzelne Elemente einer Liste aufgerunden und verändert werden
print(letters[1])  # = zweiter Index "b"
letters[1] = "B"  # verändert Listenelement
print(letters)

#
# X list unpacking

# first = letters[0]
# second = letters[1]
# third = letters[2]

# alternative mit List-unpacking
first, second, third = letters

print(first, second, third)

# ein Teil der Werte kann in eine Restliste gesteckt werden
# siehe mit reihe
first2, second2, *other = reihe
print(first2, second2, other)


# X Looping over Lists
# Listen sind iterable in for-Schleifen verwendet werden
for letter in letters:
    print(letter.upper())

# Liste + Index mit enumerate (erstellt einen tuple)
for letter in enumerate(letters):
    print(letter)

# Es ist möglich den Index direkt zu entpacken
# # statt:
# for letter in enumerate(letters):
#     print(letter[0], letter[1])
# schreib:

for index, letter in enumerate(letters):
    print(index, letter)


# X Hinzufügen und entfernen von items
# Hinzufügen - die append-method
letters.append("d")
print(letters)

# Hinzufügen an Position - die insert-method
letters.insert(0, "_")  # fügt _ an Anfag der Liste hinzu
print(letters)

# Entfernen d. letzten Position - die pop-method
letters.pop()
print(letters)

# Entfernen einer bestimmten Position - mit pop
letters.pop(1)
print(letters)  # Entfernt Index 1

# Entferne ein bestimmtes Objekt (erstes in Liste) - mit remove
letters = ["a", "b", "b", "b", "c"]
# zählt abs. Häufigkeit aus
print(f"Es sind {letters.count("b")} b in der Liste")
letters.remove("b")
print(letters)

# Entfernen (einer  Reihe) von Objekten mit del
del letters[0:2]  # löscht erste beiden Elemente
print(letters)

# Entferne alle Elemente
letters.clear()


#
# Elemente in einer Liste finden - mit .index Method
names = ["John", "Berry", "Monica", "Elouise"]

print(names.index("John"))  # gibt 0 zurück = Index von "John"

# Da names.index() eine Fehlermeldung zurückgibt, wenn das Objekt nicht in der
# Liste enthalten ist, sollte mit in zunächst überprüft werden, ob es das Objekt gibt

if "John" in names:
    print(names.index("John"))
else:
    print("Item not in List")

# X Sortieren von Listen
# die Methode sort

# Da Listen mutable Objekte sind, verändert die Methode sort()
# das ursprüngliche Objekt
names.sort()
print(names)

# Um die Liste nicht zu verändern sollte die Funktion sorted verwendet werden
names = ["John", "Berry", "Monica", "Elouise"]
print(sorted(names))

names.sort(reverse=True)  # sortiert aufsteigend
print(names)

# Bei strings, die immutable sind, ist das nicht der Fall
name = "John"
name.upper()
print(name, name.upper())  # das Objekt wird nicht in JOHN verwandelt

# Wie geht man mit einer Liste von Tupeln um
items = [("Product 1", 10),
         ("Product 2", 9),
         ("Product 3", 12)]
# item.sort() weiß nicht wonach sortiert wird

# >> deswegen wird eine Funktion benötigt, die bestimmt wie die Liste angeordnet sein soll


def sort_item(tuple_liste):
    return tuple_liste[1]  # wählt zweites Argument (Preis) aus


# sortiert nun nach Preis, den die sort_item Funktion auswählt
items.sort(key=sort_item)
print(items)


# X lambda Funktionen (lambda parameters: function)
items.sort(key=lambda item: item[1])  # nutzt eine lambda Funktion
print(items)

# >> lambda Funktionen sollten immer verwendet werden, wenn eine FUnktion nur einmal aufgerufen wird


# Preise aus der items Liste extrahieren
prices = []
for item in items:
    prices.append(item[1])

print(prices)
# Alternativ kann die map() Funktion verwendet werden
# Die Map Funktion wendet eine lambda Funktion auf jedes Item einers itterables an
# >> Das Ergebnis ist selbst iterable und kann mit einem for - loop oder als Liste ausgelesen werden
prices = map(lambda item: item[1], items)
print(prices, "as list", list(prices))


# X filtering a list
# Um eine Liste zu erhalten, die nur noch Produkte mit Preisen >= 10 enthält,
# könnte man in einem for-loop prüfen, ob der Preis eines Products > 10 ist und dann
# das Element einer Liste hinzufügen

# Die filter-Funktion bietet eine schnellere Lösung
prices_filtered = filter(lambda item: item[1] >= 10, items)
# Das Ergebnis ist ein filter-Objekt, das in eine Liste konvertiert werden kann
print(prices_filtered, list(prices_filtered))


# X list comprehension
# ermöglichen einen vielseiten Umgang mit Listen  >> kürzerer, besser lesbarer Code
# z.B. extrahiert Preise aus tupples
prices = [item[1] for item in items]

# filtern von Preisen
prices = [item for item in items if item[1] >= 10]


# X Die zip Funktion
# kombiniert 2 oder mehr Listen zu einer Liste mit Tupples, die die Elemente miteinander kombiniert
list1 = [1, 2, 3]
list2 = [10, 12, 15]

print(zip(list1, list2), list(zip(list1, list2)))

print(list(zip("abc", list1, list2)))


# X Stack Datastrukturen
# Stacks sind Listen mit LIFO Verhalten (Last in first out)
# Das zuletzt reingegebene Element ist das Erste, das wieder rauskommt
# e.g. Browser speichert Websites als LIFO)

# Der Browser speichert Websiten (Adresse) als Stack, um zurück navigieren zu können
browsing_session = []
browsing_session.append("Website1")
browsing_session.append("Website2")
browsing_session.append("Website3")

print(browsing_session)

# Person drückt "back" Button
browsing_session.pop()

if not [browsing_session]:  # Siehe Line 221
    print(browsing_session)

# Navigiert auf die Website davor, wird mit Index -1 aufgerufen
print("redirect", browsing_session[-1])

# Dann müsste der back-Button deaktiviert werden, wenn die Liste leer ist
# da [] ein falsy Wert ist, ist not [] = True. Also:
if not browsing_session:
    print("back disabled")


# X Queue - Datenstruktur
# Ques sind Listen mit FIFO verhalten (First in First out)
# Das erste Element der Liste kommt als erstes wieder raus
# e.g.

# Das Verhalten könnte mit einer Liste reproduziert werden:
# [1, 2, 3], das erste Element wird entfernt list.pop(0) und alle anderen Items rücken nach
# >> führt zu performance Problemen, weshalb ein deque-Objekt hilfreich ist

# from collections import deque
queue = deque([])  # erstellt ein deque Objekt

# Dieses hat die append-Method
queue.append(1)
queue.append(2)
queue.append(3)

# Um das erste Element zu entfernen wird popleft verwendet (unique to deque)
queue.popleft()
print(queue)


# X Tuples
# sind nicht-modifizierbare Listen (nur lesbar)

point = (1, 2)  # () kann man auch weglassen
print(type(point), point)

# Tuple können auch mit + und * erstellt werden
point += (2, 3)
print(point)

# mit der tuple() Funktion können Iterables zu tuples konvertiert werden
# Items können mit Indexen aufgerufen werden
# Unpacking und in-Überprüfungen e.g. 1 in point sind möglich

# Elemente in tuplen können nicht verändert werden
# point[0] = 10 # gibt eine Fehlermeldung


# X Tauschen Variablen
x = 10
y = 12

# klassische Lösung
# z = x
# x = y
# y = z

# in Python:
# rechts wird ein Tuple definiert, der auf der linken Seite unpackt wird
# deswegen ist es in Python möglich Variablen auf diese Art zu tauschen und
# auch mehrere Variablen gleichzeitig zu definieren

x, y = y, x
print(x, y)


# X Arrays (sind typed, enthalten einen Typ von Objekten)
# Arrays sind effizienter als Listen (weniger Speicher, schnellere Verarbeitung etc.)
# >> Effekt nur bei vielen Listenelementen sichtbar ~10.000 oder mehr

# from array import array

# ein Array wird mit der Funktion array() erstellt
# Diese nimmt als erstes einen typecode, z.B. "i" für ganzzahlige Werte
# # (siehe https://www.w3resource.com/python/library/python_array_module.php)
numbers = array("i", [12, 15, 19, 25])

# Arrays sind indexiert und Einzelne können mit [index] aufgerufen werden
# Arrays haben viele Methoden, wie z.B. append, insert, pop, remove (siehe Listen)
print(numbers)

# array[0] = "Hello" # würde zu einer Fehlermeldung führen, da der type im Array kein String ist


# X Sets
# Listen ohne Duplikate, die in einer unsortierten Reihenfolge existieren (kein Index)
numbers = [1, 1, 2, 3, 4, 1]
first = set(numbers)
print(first)  # entfernt die vielfachen 1

# sets können mit {} erstellt werden
second = {1, 4}

# Methoden von sets
second.add(5)
# second.remove(1)
print(second, len(second))

# Schnittmengen können überprüft werden
# | entspricht dem oder (or)
print(first | second)

# & entspricht dem exklusiven AND
print(first & second)

# Items, die nur im ersten Set enthalten sind
print(first - second)

# Items, die nur in einem der beiden enthalten sind
print(first ^ second)

# >> da Sets nicht indexiert sind second[0] = ERROR, werden Schnittmengen oder
#    in Operatoren häufiger beim Umgang mit sets verwendet


# X Dictionairy
# Sammlung von key : value Paaren
# e.g. Telefonbuch Name : Telefonnummer

# Dictionairies werden mit {key: value} erstellt
# key-Argumente müssen immutable sein > Häufig strings
phone_book = {"name1": 826, "name2": 562}

# Alternative dict() Funktion - ohne ""
phone_book = dict(name1=826, name2=562)  # Pylinter schlägt COde oben vor

# Items in Dictionären können nicht via Index auferufen werden, sondern nur über
# den Key, e.g.
print(phone_book["name1"])

# Ergänzungen sind möglich
phone_book["name3"] = 194
print(phone_book)

# Wenn ein key nicht Dictionairy enthalten ist, kommt es zu einer Fehlermehldung
# phone_book["a"]  # KeyError

# Kann mit if umgangen werden
if "a" in phone_book:
    print(phone_book["a"])

# Alternativ mit .get() Method umgehen - fehlender Key = None
print(phone_book.get("a"))
print(phone_book.get("a", 0))  # Kann ein Defaultwert benennen

# Items werden mit del entfernt
del phone_book["name1"]  # entfernt key-value pair mit key "name1"

# Loopen über dictionairys, gibt key aus
for key in phone_book:
    print(key, phone_book[key])

# Loopen über dictionairy.items() ergibt tuple, die unpackt werden können
for key, value in phone_book.items():
    print(key, value)


# X Dictionairy Comprehension

# Recap - List Comprehension
# list = [Expression for item in iterable] >> mit {} statt [] erstellt ein set
values = [x * 2 for x in range(5)]
print(values)

# Dictionairy Comprehension
values = {x: x * 2 for x in range(5)}
print(values)


# X Generator Objects
# statt einem tuple wird bei Comprehension mit () ein Generator-Objekt erstellt
# Diese sind iterable und geben in jedem Schritt ein anderes Objekt heraus
# len(generator) ist nicht möglich, da nicht alle Einzelitems in dem Objekt gespeichert wurden


# >> Generator Objekte sind sinnvoll, wenn mit riesigen Mengen von systematischen
# Listen gearbeitet wird (e.g. ganze Zahlen)
values = (x*2 for x in range(5))
print(values)  # Werte können mit * unpacked werden


# X Der unpacking-Operator *
print(*numbers)  # mit * wird die Liste entpackt

# statt
numbers = list(range(5))

# kann man folgendes schreiben
numbers = [*range(5)]


# XX Exercise
# find the most repeated charater in the text
sentence = "This is a common interview question"

letters = list(sentence.lower())
sentence_let = set(sentence)


letter_count = {letter: 0 for letter in sorted(letters)}
print(letter_count)

for letter in letters:
    letter_count[letter] += 1

del letter_count[" "]

# Alternative
char_frequency = {}
for char in sentence:
    if char in char_frequency:
        char_frequency[char] += 1
    else:
        char_frequency[char] = 1
print(char_frequency)

compare = 0
for letter, count in letter_count.items():
    if count > compare:
        compare = count
        highest = letter

print(highest)

# alternative für highest
print(sorted(letter_count.items(), key=lambda kv: kv[1], reverse=True))
