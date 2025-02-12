# Kapitel 4 zu Funktionen :)

# Eigene Funktionen sind sinnvoll, um Code, der in einem Programm häufig
# wiederholt wird auszulagern

# Sie werden mit def name(parameter):
#                      Code     erstellt

# z.B. Begrüßungsfunktion
def greet(first_name, last_name):
    print(f"Hi {first_name}, {last_name}!")


greet("Kuro", "Neko")
# Parameter, die so definiert werden müssen in der Funktion benannt werden
# >> Sie sind nicht optional


# 2 Arten von Funktionen in Python
# a) Funktionen, die eine Aufgabe erfüllen, z.B. greet Funktion
# b) FUnktionen, die einen Wert ausgeben, z.B. round

# Greeting Funktion als type b)
def get_greeting(name):
    return f"Hi {name}"


print(get_greeting("Mosh"))
# Grundlegend ist typ b vorzuziehen, da return values flexibler gehandhabt werden können
# bei greet() muss eine Konsole vorhanden sein, in der das Ergebnis geprintet werden kann
# bei get_greeting() kann das Ergebnis in einer Datei gespeichert, als Fenster ausgegeben werden etc.

print(greet("A", "B"))  # returns None by Default, da kein Kennwert benannt wurde


# Default Arguments
# In der Definition von Funktionen können Parameter Default Werte mitgegeben werden
# Dadurch werden Sie optional beim Ausführen der Funktion
# ! Wichtig Optioanle Argumente sollten nur nach Pflicht-Argumenten definiert werden
def increment(number, by=1):
    return number + by


print(increment(6, by=5))
print(increment(5))


# x args
# manchmel wird eine variable Anzahl von Parametern in Funktionen benötigt
def multiply(*numbers):
    print(numbers)


# Das Ergebnis ist ein Tuple, der weiterverwendet werden kann
multiply(3, 2, 5, 7)


def multiply2(*numbers):
    total = 1
    for number in numbers:
        total *= number
    return total


print(multiply2(3, 2, 5, 7))

# Wenn unbestimme zusätzliche Argumente mit ** aufgenommen werden, können diese
# als keyword-Argumente benannt werden >> Es wird ein dictionairy gespeichert


def save_user(**user):
    print(user)


save_user(id=1, name="John", age=22)
# Werte in Dictionairies können mit dict["key"] ausgegeben werden


# Fizz-Buzz-Exercise
# - takes input
# - wenn Teilbar durch 3 return Fizz
# - wenn Teilbar durch 5 return Buzz
# - wenn Teilbar durch 15 return FizzBuzz

def fizzbuzz(input_value):
    if input_value % 3 == 0 and input % 5 == 0:
        return "FizzBuzz"
    if input_value % 3 == 0:
        return "Fizz"
    if input_value % 5 == 0:
        return "Buzz"
    return input


print(fizzbuzz(15))
print(fizzbuzz(5))
print(fizzbuzz(6))
print(fizzbuzz(7))
