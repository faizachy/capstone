import os
import subprocess
import json
import shutil

import PySimpleGUI as sg

import magnet
import calling_paraview

sg.theme('GreenTan')

VTK_OUT = 'output/model_out.vtp'

file_cache = {}

def check_if_file_solved(path):
    try:
        with open("file_cache.json", "rt") as f:
            global file_cache
            file_cache = json.loads(f.read())
            # print(file_cache)
            if path in file_cache:
                modified = os.path.getmtime(path)
                _, cached_path, cached_modified = file_cache[path]
                if modified == cached_modified:
                    return cached_path
    except Exception as e:
        print("caught error reading file_cache", e)
    return None

def save_file_to_cache(path):
    if not os.path.exists(VTK_OUT):
        return
    try:
        with open("file_cache.json", "wt") as f:
            file_num = file_cache[path][0] if path in file_cache else len(file_cache)
            cached_path = f"data_cache/vtk_saved_{file_num}.vtp"
            shutil.copy(VTK_OUT, cached_path)
            file_cache[path] = (file_num, cached_path, os.path.getmtime(path))
            f.write(json.dumps(file_cache))
    except Exception as e:
        print("caught error writing file_cache", e)

def main():
    layout = [
        [sg.Text('Choose a solved .mn file', font=('Helvetica', 16))],
        [sg.FileBrowse(key="file")],
        [sg.Text('Selection of fields to display in Omniverse', font=('Helvetica', 16))],
        [sg.Radio('Magnetic Field', 'loss', size=(12, 1), key="B"), sg.Radio('Electric Field', 'loss', size=(12, 1), key="E")],
        #[sg.Text('Select a solution type', font=('Helvetica', 16))],
        #[sg.Radio('Animation', 'loss', size=(12, 1), key="transient"), sg.Radio('Static', 'loss', size=(12, 1), key="static")],
        [sg.Button('Run Solution'), sg.Button('Exit')]
    ]

    window = sg.Window("NVIDA vizualisation app", layout)
    while True:
        event, values = window.read()
        if event == sg.WIN_CLOSED:
            break
        if event == 'Run Solution':
            if "file" not in values:
                print("no file specified")
                continue

            field = "E" if values["E"] else "B"
            print(f"visualizing {field} field")

            values["file"] = os.path.abspath(values["file"]);
            solved_path = check_if_file_solved(values["file"])
            if solved_path is not None:
                print("using cached file result")
                shutil.copy(solved_path, VTK_OUT)
            else:
                print("extracting magnet solutions")
                magnet.set_filename(values["file"])
                magnet.run_script()
                print("magnet extraction done, parsing into paraview")
                calling_paraview.run_parser()
                print("paraview parsing done, saving file to cache")
                save_file_to_cache(values["file"])

            calling_paraview.run_displayer(field)
            print("display conversion done")
            break
        if event == 'Exit':
            break

    window.close()

if __name__ == '__main__':

    main()
