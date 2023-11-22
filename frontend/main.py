import os
import subprocess

import PySimpleGUI as sg

import magnet
import calling_paraview

sg.theme('GreenTan')

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
            field = "E" if values["E"] else "B"
            print(f"visualizing {field} field")
            print("extracting magnet solutions")
            magnet.set_filename(values["file"])
            magnet.run_script()
            print("magnet extraction done, parsing into paraview")
            calling_paraview.run_parser()
            print("paraview parsing done")
            calling_paraview.run_displayer("E" if values["E"] else "B")
            print("display conversion done")
            break
        if event == 'Exit':
            break

    window.close()

if __name__ == '__main__':

    main()
