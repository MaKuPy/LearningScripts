# Kapitel 8 - Klassen >> Forsetzung
# Komplexere Inhalte zum Umgang mit Klassen

# X Making Custom Container
# Bisher haben wir den Umgang mit gängigen Datenstrukturen/Container-Types gelernt
# aber manchmal ist es auch sinnvoll eine eigene Container zu definieren

# z.B. tagcloud, die eine Reihe von Tags managed

from collections import namedtuple
from abc import ABC, abstractmethod


class TagCloud:
    def __init__(self):
        self.__tags = {}   # das tags-attribut wird als dictionairy definiert

    def add(self, tag):
        # sucht nach tag in tags und ordnet den Wert 0 zu, wenn nicht enthalten
        self.__tags[tag.lower()] = self.__tags.get(tag.lower(), 0) + 1

    # um die Anzahl eines tags mit cloud["tagname"] auszulesen:
    def __getitem__(self, tag):
        return self.__tags.get(tag.lower(), 0)

    # um mit cloud["tagname"] = 10, den Wert eines Attributes verändern zu können
    # muss __setitem__(self, key, value) definiert werden.
    def __setitem__(self, tag, count):
        self.__tags[tag.lower()] = count

    # um len() anwenden zu können
    def __len__(self):
        return len(self.__tags)

    # um das Element iterable zu machen
    def __iter__(self):
        return iter(self.__tags)  # gives one item at a time in for-loop


cloud = TagCloud()

# >> diese TagCloud Klasse, soll etwas schlauer sein als ein gewöhnliches Dictionairy
# >> z.B. case-sensitivity herausfildern (deswegen wird .lower() gesetzt)

cloud.add("Python")
cloud.add("python")
cloud.add("python")
print(cloud["python"])

# mit __setitem__ können Einträge einfach ergänzt werden
cloud["python"] = 10
cloud["java"] = 4  # voher: cloud.tags["CSS"] = 5
print(cloud["java"])


# X Private members
# Dies sind Klassen-Attribute, die von außen nicht verändert werden können
# >> in Python nur schwerer zugänglich statt gar nicht zugänglich

# Problem mit der Klasse
print(cloud["python"])  # funktioniert
# print(cloud.tags["Python"]) # führt zu einer Fehlermeldung, da dies nicht im
# underline dictionairy enthalten ist (nur __get__ löst das Problem mit casesesitivity!)
# >> um dies zu vermeiden, sollte das attribut cloud.tags nicht aufgerufen werden können
# >> dazu muss ein __ vor dem Attributname ergänzt werden >> macht Zugang schwerer möglich

print(cloud.__dict__)  # zeigt alle Attribute einer Klasse
# print(cloud._TagCloud__tags)


# X Properties
# Manchmal gibt es besondere Anforderungen an die Attribute einer Klasse
# z.B. sollte der Preis eines Produktes nie kleiner Null sein
# >> bei einer einfachen Definition der Klasse ist dies jedoch möglich

# z.B.
# class Product:
#     def __init__(self, price):
#         self.price = price

# product1 = Product(-10)
# print(product1.price)

# Um dies zu verhindern wird das Attribut privat gesetzt und eine Funktion festgelegt, mit der
# der Preis verändert werden kann

class Product:
    def __init__(self, price):
        self.set_price(price)

    def get_price(self):
        return self.__price

    def set_price(self, value):
        if value < 0:
            raise ValueError("Price cannot be negative")
        else:
            self.__price = value

    def __str__(self):
        return f"{self.__price}"


try:
    product1 = Product(-10)  # raises ValueError
except ValueError as error:
    print(error)
    print("Error continue")

product1 = Product(10)

# The code above is considered unpythonic >> simple implementation, that doesn't
# use Pythons features to its fullest potential
# >> Problem ist, dass so auf das Preis-Attribut nicht zugegriffen werden kann

# Lösung: properties


class Product2:
    def __init__(self, price):
        self.set_price(price)

    def get_price(self):
        return self.__price

    def set_price(self, value):
        if value < 0:
            raise ValueError("Price cannot be negative")
        else:
            self.__price = value

    # Funktionen werden nur mit Namen bezeichnet
    price = property(get_price, set_price)

    def __str__(self):
        return f"{self.__price}"


# Nun kann der Preis einfach mit .preis festglegt und verändert werden
# >> Dabei werden die Anforderung an das Attribut berücksichtigt
product1 = Product2(22)
print(product1.price)
# product1.price = -10 # löst Value Error aus


# Zugriff auf .set_preis() und . get_price() macht Code etwas noisy
# >> da nun alles mit .preis geregelt werden kann, könnten diese FUnktionen
# privat gestellt werden __set_price() und __get_price() oben

# Besser ist die verwendung von Decoraters

class Product3:
    def __init__(self, price):
        # self.set_price(price) >> set_price() no longer exists
        self.price = price

    @property
    def price(self):  # erstellt ein Poperty-Objekt mit dem Namen price
        return self.__price

    @price.setter
    def price(self, value):  # legt den Setter des property Objekts fest
        if value < 0:
            raise ValueError("Price cannot be negative")
        else:
            self.__price = value

    # price = property(get_price, set_price)  # wird nicht mehr benötigt

    def __str__(self):
        return f"{self.__price}"


product1 = Product3(17)
print(product1)


# X Inheritance
# Wenn man viel mit Klassen arbeiten, merkt man, dass es einige Klassen gibt, die
# gewisse Funktionen gemein haben.
# Vererbung Identifiziert Funktionen, die zwei Klassen gemeinsam haben, und
# vererbt diese an eine der Klassen

# z.B. Säugetiere und Fische können beide Essen, bewegen sich unterschiedlich fort

# class Mammal:
#     def eat(self): # jedes Säugetier kann essen
#         print("eat")

#     def walk(self):
#         print("walk")

# class Fish:
#     def eat(self): # jeder Fisch kann essen
#         print("eat")

#     def swim(self):
#         print("swim")

# Diese Wiederholung der Funktion eat() führt zu Wartungsproblemen, da Anpassung
# stehts an beiden Stellen durchgeführt werden müssen
# General Rule: DRY: DONT REPEAT YOURSELF
# >> kann mit inheritance gelöst werden

class Animal:
    def __init__(self):
        self.age = 1  # setzt Alter auf default 1

    def eat(self):
        print("eat")

# Animal: Parent/Base Class;
# Mammal: Child/ Sub Class


class Mammal(Animal):  # = Inhertance von Animal Klasse
    def walk(self):
        print("walk")


class Fisch(Animal):  # = Inheritance von Animal Klasse
    def swim(self):
        print("swim")


m = Mammal()
m.eat()  # von Animal-Klasse vererbt
print(m.age)
m.age = 100
print(m.age)

m.walk()  # Einzigartig für Subklasse


# X Die Objekt-Klasse
print(isinstance(m, Mammal))  # True
print(isinstance(m, Animal))  # Auch True, da Mammal von Animal erbt
# Auch True, da jede Klasse von der objekt-Klasse abstammt
print(isinstance(m, object))

o = object()
# o. zeigt alle Methoden der objekt Classe

# gibt True, da Mammal indirekt von Objekt-Klasse abstammt
print(issubclass(Mammal, object))


# X Method Overriding
# Wenn nun im Mammal ein Gewichts-Attribut ergänzt werden soll und die
# __init__ Methode auf Subclass Level definiert wird, überschreibt diese die
# __init__ Methode auf Baseclass level

# class Mammal2(Animal):  # = Inhertance von Animal Klasse
#     def __init__(self):
#         self.weight = 100  # setzt Gewicht auf 100; ALter wird nicht definiert

#     def walk(self):
#         print("walk")


# m = Mammal2()
# print(m.age) >> Fehlermeldung, da der Constuctor in Mammal 2, den ersten überschreibt


class Mammal2(Animal):  # = Inhertance von Animal Klasse
    def __init__(self):
        super().__init__()  # ruft nun zunächst den Constructor in Baseclass auf
        self.weight = 100  # setzt Gewicht auf 100; ALter wird nicht definiert

    def walk(self):
        print("walk")


m = Mammal2()
print(m.age, m.weight)  # so werden ALter und Age festgelegt


# X Multi-Level Inheritance
# Zu häufige Verwendung von Inheritance kann:
# - die Struktur zu komplex machen, um sie zu verstehen (nicht mehr funktional)
#   >> Angestellter - Person - Lebewesen - Ding etc.
# - fördert inheritance Abuse, bei dem Objekten Funktionen weitervererbt werden
#   die sie nicht nutzen können sollten

# Deswegen sollte auf max. 2 - 3 Leveln vererbt werden


# X Multiple Inheritance
# In Python kann eine Klasse mehrere Basisclassen haben, was ebenfalls ein
# großes Potenzial für Fehler aufweist (wenn die Klassen gemeinsame Funktionen haben)
# e.g.

class Employee:
    def greet(self):
        print("Exmployee greet")


class Person:
    def greet(self):
        print("Person greet")


class Manager(Employee, Person):
    pass


manager = Manager()
manager.greet()  # gibt Employee greet, da die Employee Klasse zuerst vererbt wird

# Reihenfolge der Verarbeitung: 1 Python kontrolliert, ob Manager .greet() hat
# 2. Py kontrolliert die erste Base-Klasse (Employee) nach .greet() + führt diese aus
# 3. wenn weder Manager noch 1. BaseKlasse die gewünschte FUnktion hat, wird die zweite
#    Base-Klasse danach durchsucht

# >> Reihenfolge bei multiple Inherantce ist wichtig! Veränderung der Reihenfolge
#    (aus welchem Grund auch immer) können zu Problemen führen


# X Gutes Beispiel für Inheritance
class InvalidOperationError(Exception):
    pass

# Steam ist ein Objekt, das einen Datenfluss einließt
# Basis ist gleich - offener Datenfluss wird gelesen, dann wird Datenfluss gestoppt
# Art, ob WebStream oder FileStream ist verschieden


# class Stream:
#     def __init__(self):
#         self.opened = False

#     def open(self):
#         if self.opened:
#             raise InvalidOperationError("Stream is already open")
#         self.opened = True

#     def close(self):
#         if not self.opened:
#             raise InvalidOperationError("Stream is already closed")
#         self.opened = False


# class FileStream(Stream):
#     def read(self):
#         print("reading data from file")


# class WebStream(Stream):
#     def read(self):
#         print("reading data from web")


# X Abstract Base Classes (ABC)
# Ein Problem an dem Beispiel oben ist, dass ein Objekt mit der Stream-Klasse
# erstellt und geöffnet/-schlossen werden kann >> ein Stream existiert jedoch nur
# in den Subclassen als FileStream oder WebStream
# >> Die Stream-Klasse ist abstrakt, weshalb Stream in eine abstrakte Klasse umgewandelt wird
# >> Außerdem sollte bei zukünftigen Stream-Subklassen ebenfalls eine read() Funktion
#    mit dem Namen read() implementiert werden


# from abc import ABC, abstractmethod

class Stream(ABC):  # Stream erbt nun von ABC (Abstract Base Class)
    def __init__(self):
        self.opened = False

    def open(self):
        if self.opened:
            raise InvalidOperationError("Stream is already open")
        self.opened = True

    def close(self):
        if not self.opened:
            raise InvalidOperationError("Stream is already closed")
        self.opened = False

    # Damit kann kein Stream()-Objekt mehr erstellt werden
    @abstractmethod  # mit dem Decorater wird d. Objekt als abstrakte Klasse verstanden
    def read(self):
        pass


class FileStream(Stream):
    def read(self):
        print("reading data from file")


class WebStream(Stream):
    def read(self):
        print("reading data from web")

# Neue Klasse MemoryStream() ist nur dann nicht abstrakt,
# wenn die read Funktion definiert wurde


class MemoryStream(Stream):
    #    def read(self):
    #        pass
    pass


# stream = Stream() # Fehlermeldung, da Stream eine abstrakte Klasse
# stream = MemoryStream()
# print(stream.opened)


# X Polymorphism

class UIControl(ABC):
    @abstractmethod
    def draw(self):
        pass


class DropDownList(UIControl):
    def draw(self):
        print("DropDownList")  # vereinfachtes print-Statement
        # Könnte komplexere Visualisierungform enthalten


class TextBox(UIControl):
    def draw(self):
        print("TextBox")

# Definiere eine draw Fuktion, die controll-Objekte nimmt und die .draw Methode aufruft
# >> auf diese Weise kann ein gesamtes Interface ausgegeben werden :)


def draw(controls):
    for control in controls:
        control.draw()


ddl = DropDownList()
textbox = TextBox()

draw([ddl, textbox])
# Dies ist ein Beispiel von Polymorphism (Poly = Many; morph = forms)
# >> Die Funktion draw nimmt viele verschiedene Objekte (controlls), die
#    mit dieser einzelnen Funktion verarbeitet werden


# X Extending built-in types
# auch built-in types wie strings, integers, floats etc. können vererbt und erweitert werden

class Text(str):
    def duplicate(self):
        return self + self


class TrackableList(list):
    def append(self, list_object):  # append soll überschrieben werden + eine Nachricht drucken
        print("Append called")
        super().append(list_object)  # ruft append-Methode von Listen auf


# X Data Classes
# Manche Klassen, die nur Daten enthalten können einfach als namedtuples
# definiert werden. e.g. Point-Class

# from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])
# Point-Objekte sind nun ein named tuple, mit key-argumenten x und y
point1 = Point(x=3, y=3)
point2 = Point(x=2, y=2)

# Named tuple kommen bereits mit vorgefertigten Funktionen,__str__, ==, > muss nicht
# seperat definiert werden
print(point1)
print(point1 > point2)
# auch auf die Attribute kann zugegriffen werden
print(point1.x)
# aber sie können nicht verändert werden, da tuple
# point1.x = 10 gibt Fehlermeldung
