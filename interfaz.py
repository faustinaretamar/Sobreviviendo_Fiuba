from tkinter import *
from tkinter import messagebox

raiz = Tk()

minombre= StringVar()
miapellido= StringVar()
mimail= StringVar()


raiz.title("Ingreso de datos")
raiz.geometry("500x300")
miframe= Frame(raiz, width=500, height=500)
miframe.pack()

Entry(miframe,textvariable=minombre).grid(row=0 , column=1,padx=10,pady=10)
Entry(miframe,textvariable= miapellido).grid(row=1,column=1,padx=10,pady=10)
Entry(miframe,textvariable=mimail).grid(row=2,column=1,padx=10,pady=10)

Label(miframe, text="Nombre: ").grid(row=0,column=0,padx=10,pady=10,sticky="e")
Label(miframe, text="Apellido: ").grid(row=1,column=0,padx=10,pady=10,sticky="e")
Label(miframe, text="Email: ").grid(row=2,column=0,padx=10,pady=10,sticky="e")
def enviar_datos():
    minombre.set("Leandro")
    miapellido.set("Jerez")

def validar_cadena(cadena):
    valido = False
    if cadena.isalpha() and len(cadena) <= 25:
        valido = True
    return valido


def validar_email(email):
    valido= True
    i = 0 
    arrobas = 0
    if len(email) > 20:
        valido = False
    while valido and i<len(email):
        if email[i] == '@':
            arrobas +=1
        if arrobas > 1:
            valido = False
    return valido

def enviar_datos():
    nombre = minombre.get()
    apellido = miapellido.get()
    email = mimail.get()

    if not validar_cadena(nombre):
        messagebox.showerror("Error", "El nombre debe contener solo letras y tener un máximo de 25 caracteres.")
        return
    if not validar_cadena(apellido):
        messagebox.showerror("Error", "El apellido debe contener solo letras y tener un máximo de 25 caracteres.")
        return
    if not validar_email(email):
        messagebox.showerror("Error", "El email debe contener una única '@', no al inicio ni al final, y no superar los 20 caracteres.")
        return

    messagebox.showinfo("Éxito", "Datos enviados correctamente.")
    print(f"Nombre: {nombre}")
    print(f"Apellido: {apellido}")
    print(f"Email: {email}")

Button(raiz, text="Enviar", command=enviar_datos).pack(pady=10)
raiz.mainloop()