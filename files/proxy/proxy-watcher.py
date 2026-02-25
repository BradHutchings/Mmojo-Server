#!/usr/bin/env python3

# THIS IS A WORK IN PROGRESS. -Brad 2026-02-25

import tkinter as tk
from pathlib import Path

p = Path("requests")
for entry in p.iterdir():
    print(entry.name)

#----------------------------------------
# values are the request file names.
# value is the active request file name.
#----------------------------------------

values=[]
value = ""

def loadValues():
    global values
    values.clear()
    for i in range(1, 11):
        values.append(f"{i:07d}")
    values.sort()


def indexOfValue():
    global values, value
    result = -1
    try:
        result = values.index(value)
    except:
        result = -1
    return result

def setValue(value_index):
    global values, value
    if (value_index >= 0) and (value_index < len(values)):
        value = values[value_index]

def prev():
    global values, value
    value_index = indexOfValue()

    if value_index > 0:
        value_index = value_index - 1
    else:
        value_index = 0

    setValue(value_index)
    showValue()

def next():
    global values, value
    value_index = indexOfValue()
    if value_index < (len(values) - 1):
        value_index = value_index + 1

    setValue(value_index)
    showValue()

def showValue():
    global values, value
    request.config(text=value)

loadValues()
value = "No request."
if len(values) > 0:
    value = values[0]

#----------------------------------------
# Control layout.
#----------------------------------------

root = tk.Tk()
root.geometry("800x600")
root.title("Mmojo Proxy Watcher")

top_frame = tk.Frame(root)
top_frame.pack(padx=(20, 20), pady=(12, 12))

prev_button = tk.Button(top_frame, text="<", command=prev)
request = tk.Label(top_frame, text="", font=("Helvetica", 24))
next_button = tk.Button(top_frame, text=">", command=next)

prev_button.grid(row=0, column=0, padx=(0, 12))
request.grid(row=0, column=1, padx=(0, 12))
next_button.grid(row=0, column=2, padx=(0, 0))

showValue()

root.mainloop()

