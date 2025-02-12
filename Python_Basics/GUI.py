# X Benutzeroberflächen mit tkinter
# Um Benutzeroberflächen (GUI) zu programmieren eignet sich für Python-Einsteiger die Bibliothek Tk mit
# dem Schnittstellenmodul tkinter besonders gut
# >> Fortgeschrittenere und komplexere Oberflächen können mit dem Gimptoolkit (Modul: pyGTK); wxWidgets
#    (Modul wxPython) und QT (Modul: PyQt) programmiert werden, sind allerdings schwieriger zu verwenden

# X Eine GUI umfasst
# - Ein Hauptfenster mit allen Elementen der Anwandung
# - Steuerelemente (Widgets) innheralb des Fensters zur Bedienung der Anwendung
# - Eine Endlosschleife, die das Hauptfenster offen lässt

# Einfaches Beispiel
import tkinter
import tkinter.messagebox


# def ende():
#     main.destroy()


# # Hauptfenster
# main = tkinter.Tk()  # Erstellt ein tk-Oberfläche/Hauptfenster

# # Buttom uum schließen
# # wird Hauptfenster zugeordnet, mit Text und Funktion
# b = tkinter.Button(main, text="Ende", command=ende)
# b.pack() # fügt Button dem Hauptfenster hinzu

# # Endlosschleife
# main.mainloop()


# X Apassungsmöglichkeiten bei widgets
# - font
# - height
# - width
# - borderwidth
# - relief (Randart)
# - image (Bild)
# - bg (Hintergrund)
# - fg (Vordergrund)
# - anchor (Ausrichtung)


# main = tkinter.Tk()

# lb1 = tkinter.Label(main, text="Groove",
#                     font="Courier 16 italic", height=2, width=20, borderwidth=5,
#                     relief="groove", bg="#F14589")
# lb1.pack()

# b1 = tkinter.Button(main, text="Ende", command=main.destroy, height=2,
#                     width=20, borderwidth=5, bg="#F14589")
# b1.pack()
# main.mainloop()


# X Einzeilige Textbox
# def quad():
#     eingabe = e.get()  # speichert Ergebnis aus Eingabe-Feld
#     try:
#         zahl = float(eingabe)
#         lb["text"] = f"Ergebnis: {zahl * zahl}"
#     except:
#         lb["text"] = "Bitte eine Zahl eingeben"


# def delete():
#     e.delete(0, 100)
#     lb["text"] = "Ergebnis: "


# main = tkinter.Tk()

# e = tkinter.Entry(main) # mit show="*" wird das Ergebnis verborgen und als * angezeigt
# e.pack()

# btry = tkinter.Button(main, text="quad", command=quad)
# btry.pack()

# lb = tkinter.Label(main, text="Ergebnis: ")
# lb.pack()

# bdel = tkinter.Button(main, text="delete", command=delete)
# bdel.pack()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


# X Mehrzeilige Textbox
# das tkinter.Text Objekt ermöglicht eine mehrzeilige Eingabe

# Post-Funktion
# def post():
#     t.insert("end", "stopp ")  # fügt das Wort stopp hinzu am Ende hinzu

# main = tkinter.Tk()

# # mehrzeiliges Textfeld
# t = tkinter.Text(main, width=70, height=10)
# t.pack()


# bpost = tkinter.Button(main, text="stopp", command=post, bg="#FFFF11")
# bpost.pack()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


# X Listenbox mit einfacher Auswahl
# def xshow():
#     """zeigt listenauswahl an"""
#     # wählt das aktive Listenelement aus
#     lb["text"] = f"Auswahl: {li.get("active")}"


# main = tkinter.Tk()

# # Listenauswahl
# li = tkinter.Listbox(main, height=0)
# li.insert("end", "Hamburg")
# li.insert("end", "Tokyo")
# # möglich einen Positionindex mitzugeben<
# li.insert(0, "Mannheim")
# li.insert("end", "Berlin")
# li.pack()


# li2 = tkinter.Listbox(main, height=0, selectmode="multiple")
# li2.insert("end", "5 star")
# li2.insert("end", "4 star")
# li2.insert("end", "3 star")  # möglich einen Positionindex mitzugeben<
# li2.insert("end", "2 star")
# li2.pack()


# # Auswahl anzeigen
# bshow = tkinter.Button(main, text="show", command=xshow)
# bshow.pack()

# lb = tkinter.Label(main, text="Auswahl")
# lb.pack()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


# X Scroll Widget
# Es kann eine Scrollbar erzeugt werden, die mit dem jeweiligen widget verbunden werden muss
# main = tkinter.Tk()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# # Scrollbar erzeugen
# scr = tkinter.Scrollbar(main, orient="vertical")

# # Liste erstellen und mit Scrollbar verbinden
# li = tkinter.Listbox(main, height=4, yscrollcommand=scr.set)
# scr["command"] = li.yview # ebenfalls notwendig

# # 7 Elemente werden der Liste hinzugefügt
# cities = ["Mannheim", "Berlin", "Tokyo",
#           "Lissabon", "Munich", "Genf", "Würzburg"]
# for city in cities:
#     li.insert("end", city)

# li.pack(side="left")
# scr.pack(side="left", fill="y")


# main.mainloop()


# X Radiobutton zur Auswahl

# main = tkinter.Tk()


# def anzeigen():
#     '''Ändert Farbe des BUttons nach Auswahl und zeigt sie an'''
#     lb["text"] = f"Auswahl: {farbe.get()}"
#     if farbe.get() == "rot":
#         bende["bg"] = "#e61a0b"
#     elif farbe.get() == "gelb":
#         bende["bg"] = "#f5d107"
#     elif farbe.get() == "blau":
#         bende["bg"] = "#3f07f5"
#     else:
#         bende["bg"] = "#FFFFFF"


# Widget Variable
# Widget Variablen müssen entwerder tkinter.StringVar(), tkinter.IntVar() oder tkinter.DoubleVar() sein
# farbe = tkinter.StringVar()
# farbe.set("rot")


# # Gruppe von Radiobuttons
# rb1 = tkinter.Radiobutton(main, text="rot",
#                           variable=farbe, value="rot")
# rb1.pack()

# rb2 = tkinter.Radiobutton(main, text="gelb",
#                           variable=farbe, value="gelb")
# rb2.pack()

# # Die Funktion kann auch direkt ausgeführt werden
# rb3 = tkinter.Radiobutton(main, text="blau",
#                           variable=farbe, value="blau", command=anzeigen)
# rb3.pack()


# bshow = tkinter.Button(main, text="show", command=anzeigen)
# bshow.pack()

# lb = tkinter.Label(main, text="Auswahl:")
# lb.pack()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


# # X Checkboxen
# def anzeigen():
#     '''Zeigt ticks an'''
#     lb["text"] = f"Zimmer {du.get()} {mb.get()}"


# main = tkinter.Tk()

# lb = tkinter.Label(main, text="Zimmer", width=50)
# lb.pack()

# # Checkboxen
# du = tkinter.StringVar()
# du.set("ohne Dusche")
# mb = tkinter.StringVar()
# mb.set("ohne Minibar")

# # Checkbuttoms
# cb1 = tkinter.Checkbutton(main, text="Dusche", variable=du,
#                           onvalue="mit Dusche", offvalue="ohne Dusche", command=anzeigen)
# cb1.pack()

# cb2 = tkinter.Checkbutton(main, text="Minibar", variable=mb,
#                           offvalue="ohne Minibar", onvalue="mit Minibar", command=anzeigen)
# cb2.pack()


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()


# main.mainloop()


# # X Schieberegler
# def anzeigen(self): # braucht self hier :/
#     '''zeigt km/h an'''
#     lb["text"] = f"Geschwindigkeit: {scvwert.get()} km/h"


# main = tkinter.Tk()

# # Anzeigelabel
# lb = tkinter.Label(main, text="Geschwindigkeit: 0 km/h", width=25)
# lb.pack()

# # Schiebereglervariable
# scvwert = tkinter.IntVar()
# scvwert.set(0)

# # Schieberegler
# scv = tkinter.Scale(main, width=20, length=180, orient="vertical",
#                     from_=0, to=300, resolution=5, tickinterval=30, label="km/h", command=anzeigen,
#                     variable=scvwert)
# scv.pack()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


# X Mausergebnisse
# def mlinks(e):
#     lbanz["text"] = "Linke Maustaste"


# def mrechts(e):
#     lbanz["text"] = "Rechte Maustaste"


# def mstrglinks(e):
#     lbanz["text"] = "Strg-Taste und linke Maustaste"


# def maltlinks(e):
#     lbanz["text"] = "Alt-Taste und linke Maustaste"


# def mshiftlinks(e):
#     lbanz["text"] = "Shift-Taste und linke Maustaste"


# def mlinkslos(e):
#     lbanz["text"] = "Linke Maustaste losgelassen"


# def mbetreten(e):
#     lbanz["text"] = "Schaltfläche betreten"


# def mverlassen(e):
#     lbanz["text"] = "Schaltfläche verlassen"


# def mbewegt(e):
#     lbanz["text"] = f"Korrdinaten: x={e.x}, y={e.y}"


# main = tkinter.Tk()
# im = tkinter.PhotoImage(file="fgty.gif")
# lbm = tkinter.Label(main, image=im)

# # Mausereignisse können mit .bin("Name Aktion", Funktion) an ein Widget gebunden werden
# lbm.bind("<Button 1>", mlinks)
# lbm.bind("<Button 3>", mrechts)
# lbm.bind("<Control-Button 1>", mstrglinks)
# lbm.bind("<Alt-Button 1>", maltlinks)
# lbm.bind("<Shift-Button 1>", mshiftlinks)
# lbm.bind("<ButtonRelease 1>", mlinkslos)
# lbm.bind("<Motion>", mbewegt)
# lbm.pack()


# lbanz = tkinter.Label(main, width=35)
# lbanz.pack()


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.bind("<Enter>", mbetreten)
# bende.bind("<Leave>", mverlassen)
# bende.pack()

# main.mainloop()


# X Tastaturereignisse
# Auf ähnliche Weise können auch Tastaturereignesse mit Widgets verbunden werden
# e entspricht den Eignis, das mit bind gebunden wird
# def kev(e):
#     lbanz["text"] = f"Zeichen: {e.char}, Beschreibung; {
#         e.keysym}, Codezahl {e.keycode}"


# main = tkinter.Tk()

# e = tkinter.Entry(main)
# e.bind("<p>", kev)
# e.bind("<+>", kev)
# e.bind("<%>", kev)
# e.bind("<,>", kev)
# e.pack()


# # Hilfslabel
# lbhlp = tkinter.Label(main, text="Taste: p, +, % oder , drücken", width=40)
# lbhlp.pack()
# lbanz = tkinter.Label(main)
# lbanz.pack()


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


#  X Geometrische Anordnung von widgets mit frames
# Frames sind vordefinierte Bereiche, in denen GUI Elemente angeordnet werden können
# main = tkinter.Tk()

# # Frame 1
# fr1 = tkinter.Frame(main, width=200, height=100, relief="sunken", bd=1)
# fr1.pack(side="left")

# b1a = tkinter.Button(fr1, text="Schaltfläche 1a")
# b1a.pack(padx=5, pady=5)  # Abstand nach oben und utnen in pixeln

# b1b = tkinter.Button(fr1, text="Schaltfläche 1b")
# b1b.pack(padx=5, pady=5)  # Abstand nach oben und utnen in pixeln


# # Frame 2
# fr2 = tkinter.Frame(main, width=200, height=100,
#                     relief="sunken", bd=1, bg="#9F281F")
# fr2.pack(side="right")

# b2a = tkinter.Button(fr2, text="Schaltfläche 2a", bg="#FFFF89")
# b2a.pack(ipadx=10, ipady=10)  # Abstand innerhalb des Buttons

# b2b = tkinter.Button(fr2, text="Schaltfläche 2b", bg="#FFFF89")
# b2b.pack(padx=5, pady=5)


# # Frame 3
# fr3 = tkinter.Frame(main, width=200, height=120, relief="sunken", bd=1)
# # expand und fill führen dazu, dass das Fenster bei einer Größenveränderung größer wird
# fr3.pack(side="bottom", expand=1, fill="both")

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()


# # X einfacher Taschenrechner mit Frames

# # Ziffern 0 bis 1
# def anz(ziffer):
#     lb["text"] += str(ziffer)


# # Anzeige leeren
# def clear():
#     lb["text"] = ""


# # Kehrwert
# def kw():
#     if not lb["text"]:
#         return
#     z = float(lb["text"])
#     z = 1/z
#     lb["text"] = str(z)


# # Quadrat
# def qu():
#     if not lb["text"]:
#         return
#     z = float(lb["text"])
#     z = z*z
#     lb["text"] = str(z)


# # Dezimalpunkt
# def anzp():
#     if lb["text"].find(".") == -1:
#         lb["text"] += "."


# main = tkinter.Tk()

# # Frame A mit Anzeige
# fra = tkinter.Frame(main)
# fra.pack(expand=1, fill="x")

# lb = tkinter.Label(fra, text="", width=100, bg="#FFFFFF",
#                    # Anchor e sorgt dafür, dass Inhalte rechtsbündig sind
#                    bd=5, relief="sunken", anchor="e")
# lb.pack(expand=1, fill="x", pady=10)

# # Frame B mit 3 Funktionen
# frb = tkinter.Frame(main)
# frb.pack()

# bkw = tkinter.Button(frb, text="1/x", command=kw, width=7)
# bkw.pack(side="left")
# bqu = tkinter.Button(frb, text="x^2", command=qu, width=7)
# bqu.pack(side="left")
# bdez = tkinter.Button(frb, text=".", command=anzp, width=7)
# bdez.pack(side="left")


# # Frame C mit 1, 2 + 3
# frc = tkinter.Frame(main)
# frc.pack()

# b1 = tkinter.Button(frc, text="1", command=lambda: anz(1), width=7)
# b1.pack(side="left")

# b2 = tkinter.Button(frc, text="2", command=lambda: anz(2), width=7)
# b2.pack(side="left")

# b3 = tkinter.Button(frc, text="3", command=lambda: anz(3), width=7)
# b3.pack(side="left")

# # Frame D mit 4, 5 + 6
# frd = tkinter.Frame(main)
# frd.pack()

# b4 = tkinter.Button(frd, text="4", command=lambda: anz(4), width=7)
# b4.pack(side="left")

# b5 = tkinter.Button(frd, text="5", command=lambda: anz(5), width=7)
# b5.pack(side="left")

# b6 = tkinter.Button(frd, text="6", command=lambda: anz(6), width=7)
# b6.pack(side="left")

# # Frame E mit 7, 8, 9
# fre = tkinter.Frame(main)
# fre.pack()
# b7 = tkinter.Button(fre, text="7", command=lambda: anz(7), width=7)
# b7.pack(side="left")

# b8 = tkinter.Button(fre, text="8", command=lambda: anz(8), width=7)
# b8.pack(side="left")

# b9 = tkinter.Button(fre, text="9", command=lambda: anz(9), width=7)
# b9.pack(side="left")


# # Frame F mit 0
# frf = tkinter.Frame(main)
# frf.pack()

# bclear = tkinter.Button(main, text="clear", command=clear)
# bclear.pack()

# b0 = tkinter.Button(frf, text="0", command=lambda: anz(0), width=7)
# b0.pack(side="left")


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()


# main.mainloop()


# X einfacher Taschenrechner mit grid

# # Ziffern 0 bis 1
# def anz(ziffer):
#     lb["text"] += str(ziffer)


# # Anzeige leeren
# def clear():
#     lb["text"] = ""


# # Kehrwert
# def kw():
#     if not lb["text"]:
#         return
#     z = float(lb["text"])
#     z = 1/z
#     lb["text"] = str(z)


# # Quadrat
# def qu():
#     if not lb["text"]:
#         return
#     z = float(lb["text"])
#     z = z*z
#     lb["text"] = str(z)


# # Dezimalpunkt
# def anzp():
#     if lb["text"].find(".") == -1:
#         lb["text"] += "."


# main = tkinter.Tk()


# # Frame A mit Anzeige
# lb = tkinter.Label(main, text="", width=30, bg="#FFFFFF",
#                    # Anchor e sorgt dafür, dass Inhalte rechtsbündig sind
#                    bd=5, relief="sunken", anchor="e")
# lb.grid(row=0, column=0, columnspan=3)  # ganz oben über 3 Spalten

# # Reihe 1 erste 3 Knöpfe
# bkw = tkinter.Button(main, text="1/x", command=kw, width=7)
# bkw.grid(row=1, column=0)
# bqu = tkinter.Button(main, text="x^2", command=qu, width=7)
# bqu.grid(row=1, column=1)
# bdez = tkinter.Button(main, text=".", command=anzp, width=7)
# bdez.grid(row=1, column=2)


# # Reihe2 mit 1, 2 + 3
# b1 = tkinter.Button(main, text="1", command=lambda: anz(1), width=7)
# b1.grid(row=2, column=0)
# b2 = tkinter.Button(main, text="2", command=lambda: anz(2), width=7)
# b2.grid(row=2, column=1)
# b3 = tkinter.Button(main, text="3", command=lambda: anz(3), width=7)
# b3.grid(row=2, column=2)

# # Reihe 3 mit 4, 5 + 6
# b4 = tkinter.Button(main, text="4", command=lambda: anz(4), width=7)
# b4.grid(row=3, column=0)
# b5 = tkinter.Button(main, text="5", command=lambda: anz(5), width=7)
# b5.grid(row=3, column=1)
# b6 = tkinter.Button(main, text="6", command=lambda: anz(6), width=7)
# b6.grid(row=3, column=2)

# # Reihe 4 mit 7, 8, 9
# b7 = tkinter.Button(main, text="7", command=lambda: anz(7), width=7)
# b7.grid(row=4, column=0)
# b8 = tkinter.Button(main, text="8", command=lambda: anz(8), width=7)
# b8.grid(row=4, column=1)
# b9 = tkinter.Button(main, text="9", command=lambda: anz(9), width=7)
# b9.grid(row=4, column=2)


# # Reihe 5 mit 0
# bclear = tkinter.Button(main, text="clear", command=clear, width=17)
# bclear.grid(row=5, column=1, columnspan=2)

# b0 = tkinter.Button(main, text="0", command=lambda: anz(0), width=7)
# b0.grid(row=5, column=0)


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.grid(row=6, column=1)


# main.mainloop()


# X place und relative Veränderung von Koordinaten
# Mit place(x, y) # Können Widgets direkt in einem FEnster platziert werden
# mit place(relx, rely) können auch relative Koordinaten mitgegeben werden
# >> diese beziehen sich auf die Höhe/Breite des Elements (Werte zwischen 0 und 1 möglich)

# posx = 20
# posy = 20


# def down():
#     global posx, posy
#     posy += 20
#     lb.place(x=posx, y=posy)


# def right():
#     '''blah'''
#     global posx, posy
#     posx += 20
#     lb.place(x=posx, y=posy)


# main = tkinter.Tk()

# fra = tkinter.Frame(main, width=300, height=300, bd=5, relief="raised")
# fra.grid(row=0, column=0, columnspan=3)

# lb = tkinter.Label(fra, text="text")
# lb.place(x=posx, y=posy)

# frb = tkinter.Frame(main, width=300,  relief="sunken")
# frb.grid(row=1, column=0)

# bdown = tkinter.Button(frb, text="down", command=down)
# bdown.pack()

# bright = tkinter.Button(frb, text="right", command=right)
# bright.pack()


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.grid(row=2, column=1)

# main.mainloop()


# X Menüs, Messageboxen und Dialogfenster
# In der Regel verfügen Programme über eine Menüleiste, deren Kontextmenüs
# nur bei Zugriff auf eine Kategorie geöffnet werden
# def farbwechsel():
#     fr["bg"] = farbe.get()


# def randwechsel():
#     if rand.get():
#         fr["relief"] = "sunken"
#     else:
#         fr["relief"] = "flat"


# main = tkinter.Tk()

# # Fenster für Menübefehle
# fr = tkinter.Frame(main, height=100, width=300, bg="#FFFFFF", bd=10)
# fr.pack()

# # Menüleiste erzeugen
# mBar = tkinter.Menu(main)

# # erstes Menüobjekt
# mFile = tkinter.Menu(mBar)

# # Elemente im ersten Menü
# mFile.add_command(label="Neu")
# mFile.add_command(label="Laden")
# mFile.add_command(label="Speichern")
# mFile.add_separator()

# mFile.add_command(label="Beenden", command=main.destroy)

# # Widget-Var mit Radio-Button für Menü
# farbe = tkinter.StringVar()
# farbe.set("#FFFFFF")

# rand = tkinter.IntVar()
# rand.set(0)

# # zweites Menü
# mView = tkinter.Menu(mBar)
# mView["tearoff"] = 0  # nicht abtrennen

# # Elemente im zweiten Menü
# mView.add_radiobutton(label="Rot", variable=farbe,
#                       value="#FF0000", underline=0, command=farbwechsel)
# mView.add_radiobutton(label="Gelb", variable=farbe,
#                       value="#FFFF00", underline=0, command=farbwechsel)
# mView.add_radiobutton(label="Blau", variable=farbe,
#                       value="#0000FF", underline=0, command=farbwechsel)
# mView.add_radiobutton(label="Magenta", variable=farbe,
#                       value="#FF00FF", underline=0, command=farbwechsel)
# mView.add_separator()
# mView.add_checkbutton(label="Rand sichtbar", variable=rand, onvalue=1,
#                       offvalue=0, underline=5, command=randwechsel)

# # Erstes und zweites Menu zur Leiste hinzufügen
# mBar.add_cascade(label="Datei", menu=mFile)
# mBar.add_cascade(label="Ansicht", menu=mView)

# # Menü zum Fenster hinzufügen
# main["menu"] = mBar


# main.mainloop()


# X Kontextmenüs
# def farbwechsel():
#     lb["bg"] = farbe.get()


# def lbpop(e):
#     mpop.tk_popup(e.x_root, e.y_root)  # erstellt ein Pop-up Menü


# main = tkinter.Tk()

# # Fenster für Menübefehle
# fr = tkinter.Frame(main, height=600, width=500, bg="#FFFFFF", bd=10)
# fr.pack()

# # Label mit Bild
# im = tkinter.PhotoImage(file="fgty.gif")
# lb = tkinter.Label(main, image=im, relief="ridge", bd=5, bg="#000000")
# lb.bind("<Button 3>", lbpop)
# lbx = 60
# lby = 30
# lb.place(x=lbx, y=lby, anchor="nw", )

# # Widget-Variable der Farbe
# farbe = tkinter.StringVar()
# farbe.set("#000000")

# # Menü zur Farbeinstellung
# mpop = tkinter.Menu(main)
# mpop["tearoff"] = 0
# mpop.add_radiobutton(label="rot", variable=farbe,
#                      value="#FF0000", command=farbwechsel)
# mpop.add_radiobutton(label="gelb", variable=farbe,
#                      value="#FFFF00", command=farbwechsel)
# mpop.add_radiobutton(label="schwarz", variable=farbe,
#                      value="#000000", command=farbwechsel)


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.place(relx=1, rely=0, anchor="ne")

# main.mainloop()


# X Messageboxen
# Messageboxen sind Dialogfenster, die dem Nutzer Informationen vermitteln. Sie werden mit tkinter.messagebox() erstellt
# - showinfo        Schaltfläche OK     Information übermitteln und bestätigen
# - showwarning     Schaltfläche OK     Warnung und bestätigen
# - showerror       Schaltfläche OK     Fehlermeldung und bestätigen
# - askyesno        Ja oder Nein        Antwort auf Ja-Nein Frage
# - askokcancel     Ok, Abbrechen       Antwort auf Ok oder Abbrechen
# - askretycancel   Retry, Abbrechen    Antwort auf Retry oder Abbrechen
# - show            Individuel          Allgemeine Antwort erfragen

# def msginfo():
#     tkinter.messagebox.showinfo("INFO", "Eine Infobox")


# def msgwarning():
#     tkinter.messagebox.showwarning("WARNUNG", "Eine Warnbox")


# def msgerror():
#     tkinter.messagebox.showerror("ERROR", "Errorbox")


# def msgyesno():
#     antwort = tkinter.messagebox.askyesno("JA/NEIN", "Ja/Nein-Box")
#     lbanz["text"] = "Ja" if antwort == 1 else "no"


# def msgokcancel():
#     antwort = tkinter.messagebox.askokcancel("OK/CANCEL", "Ok-Cance-Box")
#     lbanz["text"] = "Ok" if antwort == 1 else "Abbrechen"


# def msgfrage():
#     msgbox = tkinter.messagebox.Message(main, type=tkinter.messagebox.ABORTRETRYIGNORE,
#                                         icon=tkinter.messagebox.QUESTION,
#                                         title="Beenden/Wiederholen/Ignorieren",
#                                         message="Beenden, Wiederholen oder Ignorieren")

#     antwort = msgbox.show()
#     lbanz["text"] == antwort

#     if antwort == "abort":
#         lbanz["text"] == antwort
#     elif antwort == " retry":
#         lbanz["text"] == "wiederholen"
#     else:
#         lbanz["text"] == "ignorieren"


# main = tkinter.Tk()

# lbanz = tkinter.Label(main, height=10, width=50,
#                       bg="#FFFFFF", border=5, relief="sunken")
# lbanz.grid(row=0, column=0, columnspan=3)

# # Box-Buttons
# binfo = tkinter.Button(main, text="Info", width=10, command=msginfo)
# binfo.grid(row=1, column=0, padx=5, pady=5)

# bwarn = tkinter.Button(main, text="Warning", width=10, command=msgwarning)
# bwarn.grid(row=1, column=1, padx=5, pady=5)

# berror = tkinter.Button(main, text="Error", width=10, command=msgerror)
# berror.grid(row=1, column=2, padx=5, pady=5)

# byesno = tkinter.Button(main, text="Yes/No", width=10, command=msgyesno)
# byesno.grid(row=2, column=0, padx=5, pady=5)

# bokcanc = tkinter.Button(main, text="Yes/No", width=10, command=msgokcancel)
# bokcanc.grid(row=2, column=1, padx=5, pady=5)

# bfrage = tkinter.Button(main, text="Frage", width=10, command=msgfrage)
# bfrage.grid(row=2, column=2, padx=5, pady=5)


# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.grid(row=3, column=1)

# main.mainloop()


# X Eigene Dialogfenster erzeugen

def endeneu():
    global status
    neu.destroy()
    status = "main"  # über den EInbau von Status kann verhindert werden, dass das Hauptfenster bedient wird,
    # wenn dasandere Fenster offen ist


def fenster():
    global status, neu
    if status != "main":
        return
    status = "neu"
    neu = tkinter.Toplevel(main)
    tkinter.Button(neu, text="Ende neu", command=endeneu).pack()


main = tkinter.Tk()
status = "main"

bneu = tkinter.Button(main, text="neu", command=fenster)
bneu.pack()

bende = tkinter.Button(main, text="Ende", command=main.destroy)
bende.pack()

main.mainloop()


# X
# main = tkinter.Tk()

# bende = tkinter.Button(main, text="Ende", command=main.destroy)
# bende.pack()

# main.mainloop()
