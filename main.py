
import PySimpleGUI as sg

sg.theme('GreenTan')

def main():
    l = ["magnetic field", "electric field", "material view"]
    layout = [
        [sg.Text('Selection of fields to display in Omniverse', font=('Helvetica', 16))],
        [sg.DD(l,size=(70,70),default_value="Choose field to display")],
        [sg.Text('Select field vizualisation type ', font=('Helvetica', 16))],
        [sg.Radio('Arrows', 'loss', size=(12, 1)), sg.Radio('Color', 'loss', size=(12, 1))],
        [sg.Text('Select a solution type ', font=('Helvetica', 16))],
        [sg.Radio('Animation', 'loss', size=(12, 1)), sg.Radio('Static', 'loss', size=(12, 1))],
        [sg.Button('Apply'), sg.Button('Exit')]
        ]

    window = sg.Window("NVIDA vizualisation app", layout)
    while True:
        event, values = window.read()
        if event == sg.WIN_CLOSED:
            break
        if event == 'Apply':
            sg.popup("Loading vizualisation of the ", values[0], " in the Omniverse")
        if event == 'Exit':
            break

    window.close()

if __name__ == '__main__':

    main()

