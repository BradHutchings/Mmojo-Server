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
TEXT_FONT = "Helvetica"
TEXT_SIZE = 14

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

ui_prompt_frame = tk.Frame(ui_data_frame)
ui_prompt_frame.pack(side = "left", fill = "both", expand = True, padx = (0, 12), pady = (0, 0))

ui_prev_button = tk.Button(ui_top_frame, text = "<", command = prev)
ui_request = tk.Label(ui_top_frame, text = "", font = (TEXT_FONT, TEXT_SIZE))
ui_next_button = tk.Button(ui_top_frame, text = ">", command = next)
ui_path = tk.Label(ui_top_frame, text = "(Path goes here.)", anchor = "w", font = (TEXT_FONT, TEXT_SIZE))

ui_prompt = tk.Text(ui_prompt_frame, width = 20, height = 10, wrap = "word", \
    background = "#E0E0E0", relief = "solid")
ui_completion = tk.Text(ui_data_frame, width = 20, height = 10, wrap = "word", \
    background = "#F0F0F0", relief = "solid")

var_show_system_prompt = tk.IntVar()
ui_show_system_prompt = tk.Checkbutton(ui_prompt_frame, text = "Show System Prompt", \
    variable = var_show_system_prompt, font = (TEXT_FONT, TEXT_SIZE), anchor = "w")

ui_prev_button.pack(side="left", padx = (0, 12))
ui_request.pack(side="left", padx = (0, 12))
ui_next_button.pack(side="left", padx = (0, 12))
ui_path.pack(side = "left", fill = "both", expand = True, padx = (0,0))

ui_prompt.pack(side = "top", fill = "both", expand = True, padx = (0, 0), pady = (0, 12))
ui_show_system_prompt.pack(side = "top", fill = "both", padx = (0, 0), pady = (0, 0))

ui_completion.pack(side = "left", fill = "both", expand = True, padx = (0, 0))

ui_prompt.config(state = tk.DISABLED )
ui_completion.config(state = tk.DISABLED )

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

    try:
        value_index = values.index(value)
    except:
        value_index = -1

    if value_index > 0:
        ui_prev_button.config(state = tk.NORMAL )
    else:
        ui_prev_button.config(state = tk.DISABLED )
    if (value_index >= 0) and (value_index < (len(values) - 1)):
        ui_next_button.config(state = tk.NORMAL )
    else:
        ui_next_button.config(state = tk.DISABLED )

    ui_request.config(text=value)
    request_data = {}
    tries = 0
    if (value != "") and (value != NO_REQUESTS):
        while (tries < 5) and not request_data:
            try:
                with open(REQUESTS_PATH + value, 'r') as file:
                    request_data = json.load(file)
            except Exception as e:
                print("Exception reading file: " + str(e))
                request_data = {}
                time.sleep(0.5)
            tries = tries + 1

    if "path" in request_data:
        ui_path.config(text = request_data["path"])
    else:
        ui_path.config(text = "")

    # ui_prompt.config(state = tk.NORMAL )
    # ui_prompt.delete("1.0", tk.END)
    # if "request_body" in request_data:
    #    ui_prompt.insert("1.0", str(request_data["request_body"]))
    # else:
    #    ui_prompt.insert("1.0", "Nothing to see here.")
    # ui_prompt.config(state = tk.DISABLED )

    new_prompt = "No prompt."
    if "request_body" in request_data:
        request_body = request_data["request_body"]
        if "messages" in request_body:
            messages = request_body["messages"]
            new_prompt = getPrompt(messages, var_show_system_prompt.get())

    # the data from the Text has a \n tacked on the end. Grrrrr.
    # https://stackoverflow.com/questions/4609382/getting-the-total-number-of-lines-in-a-tkinter-text-widget
    # int(text_widget.index('end-1c').split('.')[0]) - 1
    # then subtract text.cget("height") ??
    old_prompt = ui_prompt.get("1.0", tk.END)
    if  (new_prompt != old_prompt) and ((new_prompt + "\n") != old_prompt):
        save_scroll = ui_prompt.yview()[0]
        ui_prompt.config(state = tk.NORMAL )
        ui_prompt.delete("1.0", tk.END)
        ui_prompt.insert("1.0", new_prompt)
        ui_prompt.config(state = tk.DISABLED )

        # This scrolls a percent, not to a particular line. Will revisit.
        if new_prompt.startswith(old_prompt):
            ui_prompt.yview("moveto", save_scroll)
        if new_prompt.startswith(old_prompt[:-1]):
            ui_prompt.yview("moveto", save_scroll)

    new_completion = "Nothing to see here."
    if "completion" in request_data:
        new_completion = str(request_data["completion"])
    old_completion = ui_completion.get("1.0", tk.END)

    # the data from the Text has a \n tacked on the end. Grrrrr.
    # https://stackoverflow.com/questions/4609382/getting-the-total-number-of-lines-in-a-tkinter-text-widget
    # int(text_widget.index('end-1c').split('.')[0]) - 1
    # then subtract text.cget("height") ??
    if (new_completion != old_completion) and ((new_completion + "\n") != old_completion):
        save_scroll = ui_completion.yview()[0]
        ui_completion.config(state = tk.NORMAL )
        ui_completion.delete("1.0", tk.END)
        ui_completion.insert("1.0", new_completion)
        ui_completion.config(state = tk.DISABLED )

        # This scrolls a percent, not to a particular line. Will revisit.
        if new_completion.startswith(old_completion):
            ui_completion.yview("moveto", save_scroll)
        if new_completion.startswith(old_completion[:-1]):
            ui_completion.yview("moveto", save_scroll)

#----------------------------------------
# getPrompt formats the prompt.
#----------------------------------------

def getPrompt(messages, showSystemPrompt):
    result = ""
    first_message = True
    for message in messages:
        role = ""
        content = ""
        add_to_prompt = ""
        if ("role" in message) and ("content" in message):
            role = message["role"]
            content = message["content"]

        if isinstance(content, str):
            d = {"type": "text", "text": content}
            content = [ d ]

        if isinstance(content, list):
            for elt in content:
                elt_content = ""
                if ("type" in elt) and (elt["type"] == "text"):
                    if ("text" in elt):
                        elt_content = elt["text"]
                    else:
                        elt_content= "PROXY: Cannot retrieve content text."
                else:
                    elt_content = "PROXY: Non-text content."

                if (role == "system") and showSystemPrompt:
                    add_to_prompt = "system:\n\n" + elt_content + "\n--------------------\n"
                elif (role == "user"):
                    add_to_prompt = "user:\n\n" + elt_content + "\n--------------------\n"
                elif (role == "assistant"):
                    add_to_prompt = "assistant:\n\n" + elt_content + "\n--------------------\n"

                if add_to_prompt != "":
                    if not first_message:
                        result = result + "\n"
                    first_message = False
                    result = result + add_to_prompt

    return result

#----------------------------------------
# Main control.
#----------------------------------------

timerLoadValues()
ui_root.mainloop()

# deal with the quit problem. See method 2 of this:
# https://share.google/aimode/omk19semg1pQVipya
