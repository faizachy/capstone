import os
import subprocess

import PySimpleGUI as sg

import magnet
import paraview

sg.theme('GreenTan')

def main():
    l = ["magnetic field", "electric field", "material view"]
    layout = [
        [sg.Text('Choose a solved .mn file', font=('Helvetica', 16))],
        [sg.FileBrowse(key="file")],
        [sg.Text('Selection of fields to display in Omniverse', font=('Helvetica', 16))],
        [sg.DD(l,size=(70,70),default_value="Choose field to display", key="field")],
        [sg.Text('Select field vizualisation type ', font=('Helvetica', 16))],
        [sg.Radio('Arrows', 'loss', size=(12, 1), key="vector"), sg.Radio('Color', 'loss', size=(12, 1), key="magnitude")],
        [sg.Text('Select a solution type ', font=('Helvetica', 16))],
        [sg.Radio('Animation', 'loss', size=(12, 1), key="transient"), sg.Radio('Static', 'loss', size=(12, 1), key="static")],
        [sg.Button('Apply'), sg.Button('Exit')]
    ]

    window = sg.Window("NVIDA vizualisation app", layout)
    while True:
        event, values = window.read()
        print(values)
        if event == sg.WIN_CLOSED:
            break
        if event == 'Apply':
            sg.popup("Loading vizualisation of the ", values["field"], " in the Omniverse")
            magnet.set_filename(values["file"])
            magnet.run_script()
            paraview.run_script()
            print("paraview parsing done")
            break
        if event == 'Exit':
            break

    window.close()

if __name__ == '__main__':

    main()
