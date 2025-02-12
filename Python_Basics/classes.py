# Kapitel 8 - Klassen
# Klasse: Vorlage, mit der neuer Objekte erstellt werden (e.g. Human)
# Objekt: ein spezifisches Objekt einer Klasse (e.g. John, Marry, Lorey)
# >> Klassen geben die Attribute (Eigenschaften, e.g. Haarfarbe, Augenfarbe etc.)
#   und Methoden eines Objekts vor (.gehen(), .essen(), .trinken() etc.)


# Viele Objekte in Python haben klassenspezifische Methoden, die darauf angewandt
# werden können, e.g.
numbers = [12, 22]
numbers.append(34)
print(numbers)

# Die Definition eigener Klassen schafft neue Objekte mit eigenen klassenspezifischen
# Methoden, e.g.
# shopping_cart-Klasse mit shopping_cart.add(), shopping_cart.remove(), shopping_cart.total()
# point-Klasse mit point.draw(), point.move(), point.get_distance() etc.


# X Creating classes
# Die Definition einer neuen Klasse erfolgt durch:
# class Name(parameter):        # per Konvention sind Klassennamen Pascal konnotiert
#    def methods(self):         # jede Methode braucht mindestens einen self Argument
#        code
#     .....

class Point:
    def draw(self):
        print("draw")


# Definition eines neuen Objekts der Klasse point
point = Point()
point.draw()  # point steht die draw-Methode zur Verfügung, ebenso wie einige vererbte Funktionen, wie __dir__

print(isinstance(point, Point))  # überprüft Typ eines Objekts


# X Constructors
# Das Point-Objekt soll nun eine X, und Y Koordinate haben
class Point:
    default_colour = "red"  # Klassenattribut (siehe nächster Unterpunkt)

    def __init__(self, x, y):  # Dies ist eine Constructor Funktion
        self.x = x             # Sind Attribute des Objekts Point
        self.y = y

    def draw(self):
        print(f"Point ({self.x}, {self.y})")


point = Point(1, 2)
print(point.x)  # jetut kann das Attribut mit einem . aufgerufen werden
point.draw()


# X Klassen vs. Instance-Attribute
# Instance-Attribute können über unterschiedliche Objekte einer Klasse verschieden sein
point.z = 10  # Es können weitere Instance-Attribute hinzugefügt werden
another = Point(10, 5)
another.draw()  # x + y unterscheiden sich von dem Objekt point

# Klassen-Attribute sind gleich über alle Objekte hinweg
# Sie werden auf dem Klassenlevel definiert (vor __init__) und sind über alle Objekte der Klasse gleich
print(point.default_colour)
print(another.default_colour)
print(Point.default_colour)  # kann auch über Klasse aufgerufen werden

# kann über die Klasse für alle Objekte verändert werden verändert werden
Point.default_colour = "yellow"
print(another.default_colour)


# Klassen vs. Instance-Methoden
# Wie bei den Attributen, können Methoden auf Klassen oder Instance-Level definiert werden

# - Instance-Methoden, wie draw, brauchen ein spezifisches Objekt der Klasse Point,
#   um ausgeführt  zu werden
# - Klassen-Methoden können auf Klassenlevel aufgerufen werden, wie z.B.
#   sog. Factory-Methoden, die das schnelle Erstellen eines Klassenobjekts erlauben

class Point:
    default_colour = "red"  # Klassenattribut (siehe nächster Unterpunkt)

    def __init__(self, x, y):  # Dies ist eine Constructor Funktion
        self.x = x             # Sind Attribute des Objekts Point
        self.y = y

    @classmethod        # ist ein decorator, der verwendent wird, um eine Klasse zu erstellen
    def zero(cls):      # cls ist das self für Klassenmethoden
        # cls(0,0) = Point(0,0), python automatically passes a reference to Point-Klass
        return cls(0, 0)

    def __str__(self):
        return f"(x:{self.x}, y:{self.y})"

    def draw(self):
        print(f"Point ({self.x}, {self.y})")


point = Point.zero()
point.draw()


# X Magic methods, sind methoden mit __ am Ende und Anfang der Methode
# Magic Methoden werden nicht manuell aufgerufen, sondern automatisch von Python
# e.g. __init__ wird automatisch aufgerufen, wenn ein Objekt erstellt wird

# google Python 3 magic methods, __str__ defiert, wie ein Objekt in ein string umgewandelt wird + print()-Ergebnis
# https://rszalski.github.io/magicmethods/

# print() gibt bei Default den Speicherplatz + Objektname zurück >> mit einer
# __str__ bei der Klassendefinition, kann der Output angepasst werden (siehe oben)
print(point)
other = Point.zero()
print(point == other)  # False, da by default der Speicherort verglichen wird
# >> dafür müssen Vergleichs-Magic-methods definiert werden


class Point:
    default_colour = "red"  # Klassenattribut (siehe nächster Unterpunkt)

    def __init__(self, x, y):  # Dies ist eine Constructor Funktion
        self.x = x             # Sind Attribute des Objekts Point
        self.y = y

    @classmethod        # ist ein decorator, der verwendent wird, um eine Klasse zu erstellen
    def zero(cls):      # cls ist das self für Klassenmethoden
        # cls(0,0) = Point(0,0), python automatically passes a reference to Point-Klass
        return cls(0, 0)

    def __str__(self):
        return f"(x:{self.x}, y:{self.y})"

    def __eq__(self, other):  # Methode, die bestimmt, wie == Vergleiche durchgeführt werden
        return self.x == other.x and self.y == other.y

    def __gt__(self, other):  # für > Vergleiche
        return self.x > other.x and self.y > other.y

    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)

    def draw(self):
        print(f"Point ({self.x}, {self.y})")


point = Point.zero()
other = Point(10, 1)
print(f"{str(point)} und {str(other)} sind gleich?: {point == other}")
print(other > point)
# Obwohl nur > definiert wurde, kann Python automatisch < interpretieren
print(point < other)
# >= und <= müssen noch definiert werden
point2 = other + other

# X Mathematische Operationen mit Klassen
# um mathematische Operationen mit einer Klasse durchzuführen, müssen die
# dazugehörigen magic-methods definiert werden, eg. __add__, _sub__, __mul__ etc.

# Definition erfolgt oben
point2 = other + other
print(point2)
