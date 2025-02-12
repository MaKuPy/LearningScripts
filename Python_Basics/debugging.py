# Debugging
# ist das Finden und Verbessern von Fehlern im Code
# Click Debugging > Show Python Debugger (use Python current File)

# Insert a break point with FN + F9
# FN + F5 runs the programm up to this point
# FN + F10 to execute 1 Statement after at a time

# FN + F11 lets you check the current function (on the line you are at)
# >> left side shows arguments that are meaningful in the function (1, 2, 3)
# >> total is defined as 1
# >> number in the for loop is set to 1
# ! loops jumps to end after first iteration >> not completed

# shows that indentation needs to be fixed
# than the for loop is executed in order

# close debugger with FN + F5

def multiply(*numbers):
    total = 1
    for number in numbers:
        total *= number
        return total

# e.g Falsches Einrücken des return statements


print("Start")
print(multiply(1, 2, 3))  # sollte 6 ergeben
