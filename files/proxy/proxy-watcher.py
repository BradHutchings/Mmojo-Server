#!/usr/bin/env python3

# THIS IS A WORK IN PROGRESS. -Brad 2026-02-25

import tkinter as tk
from pathlib import Path
import threading
import datetime
import json
import time

#----------------------------------------
# values are the request file names.
# value is the active request file name.
#----------------------------------------

NO_REQUESTS = "No requests."
REQUESTS_PATH = "requests/"

values=[]
value = ""

def indexOfValue():
    global values, value
    result = -1
    try:
        result = values.index(value)
    except:
        result = -1
    return result

def loadValues():
    global values, value
    values.clear()
    try:
        p = Path(REQUESTS_PATH)
        for entry in p.iterdir():
            values.append(entry.name)
    except:
        pass
    values.sort()
    value_index = indexOfValue()
    setValue(value_index)

def setValue(value_index):
    global values, value
    if (value_index >= 0) and (value_index < len(values)):
        value = values[value_index]
    elif (len(values) > 0):
        value = values[0]
    else:
        value = NO_REQUESTS

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

#----------------------------------------
# Control layout.
#----------------------------------------

ui_root = tk.Tk()
ui_root.geometry("800x600")
ui_root.title("Mmojo Proxy Watcher")

ui_top_frame = tk.Frame(ui_root)
ui_top_frame.pack(side = "top", fill = "both", padx = (20, 20), pady = (12, 20))

ui_data_frame = tk.Frame(ui_root)
ui_data_frame.pack(side = "top", fill = "both", expand = True, padx = (20, 20), pady = (0, 12))

ui_prev_button = tk.Button(ui_top_frame, text = "<", command = prev)
ui_request = tk.Label(ui_top_frame, text = "", font = ("Helvetica", 18))
ui_next_button = tk.Button(ui_top_frame, text = ">", command = next)
ui_path = tk.Label(ui_top_frame, text = "(Path goes here.)", anchor = "w", font = ("Helvetica", 18))

ui_request_data = tk.Text(ui_data_frame, width = 20, height = 10, wrap = "word", background = "#E0E0E0", relief = "solid")
ui_response_data = tk.Text(ui_data_frame, width = 20, height = 10, wrap = "word", background = "#F0F0F0", relief = "solid")

ui_prev_button.pack(side="left", padx = (0, 12))
ui_request.pack(side="left", padx = (0, 12))
ui_next_button.pack(side="left", padx = (0, 12))
ui_path.pack(side = "left", fill = "both", expand = True, padx = (0,0))

ui_request_data.pack(side = "left", fill = "both", expand = True, padx = (0, 12))
ui_response_data.pack(side = "left", fill = "both", expand = True, padx = (0, 0))

ui_request_data.config(state = tk.DISABLED )
ui_response_data.config(state = tk.DISABLED )

#----------------------------------------
# Timer for repeatedly loading.
#----------------------------------------

def timerLoadValues():
    global ui_root
    loadValues()
    showValue()
    ui_root.update()

    timer = threading.Timer(3.0, timerLoadValues)
    timer.start()

#----------------------------------------
# showValue loads the data from the file.
#----------------------------------------

def showValue():
    global values, value
    ui_request.config(text=value)
    request_data = {}
    tries = 0
    if (value != ""):
        while (tries < 5) and not request_data:
            try:
                with open(REQUESTS_PATH + value, 'r') as file:
                    request_data = json.load(file)
            except Exception as e:
                print("exception: " + str(e))
                request_data = {}
                time.sleep(0.5)
            tries = tries + 1

    if "path" in request_data:
        ui_path.config(text = request_data["path"])
    else:
        ui_path.config(text = "")

    ui_request_data.config(state = tk.NORMAL )
    ui_request_data.delete("1.0", tk.END)
    if "request_body" in request_data:
        ui_request_data.insert("1.0", str(request_data["request_body"]))
    else:
        ui_request_data.insert("1.0", "Nothing to see here.")
    ui_request_data.config(state = tk.DISABLED )


    new_response_data = "Nothing to see here."
    if "response" in request_data:
        new_response_data = str(request_data["response"])
    old_response_data = ui_response_data.get("1.0", tk.END)

    # the data from the Text has a \n tacked on the end. Grrrrr.
    if (new_response_data != old_response_data) and ((new_response_data + "\n") != old_response_data):
        print("Replacing old_response_data.\n----------")
        save_scroll = ui_response_data.yview()[0]
        ui_response_data.config(state = tk.NORMAL )
        ui_response_data.delete("1.0", tk.END)
        ui_response_data.insert("1.0", new_response_data)
        ui_response_data.config(state = tk.DISABLED )

        # This scrolls a percent, not to a particular line. Will revisit.
        if new_response_data.startswith(old_response_data):
            ui_response_data.yview("moveto", save_scroll)
        if new_response_data.startswith(old_response_data[:-1]):
            ui_response_data.yview("moveto", save_scroll)

#----------------------------------------
# Main control.
#----------------------------------------

timerLoadValues()
ui_root.mainloop()
