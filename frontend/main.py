import os
import json
import shutil
from datetime import datetime
import PySimpleGUI as sg
import magnet
import calling_paraview

# Set the theme for the GUI
sg.theme('SystemDefault1')

VTK_OUT = 'output/model_out.vtp'
file_cache = {}

def save_file_to_cache(path):
    if not os.path.exists(VTK_OUT):
        print(f"Error: {VTK_OUT} does not exist, skipping cache.")
        return
    try:
        if not os.path.exists("output"):
            os.makedirs("output")

        
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        with open("file_cache.json", "wt") as f:
            file_num = file_cache[path][0] if path in file_cache else len(file_cache)
            cached_path = f"VTKoutput/BLDC_degree{file_num}.vtp"
            shutil.copy(VTK_OUT, cached_path)
            file_cache[path] = {
                "file_num": file_num,
                "cached_path": cached_path,
                "last_modified": os.path.getmtime(path),
                "processed_time": current_time  # Add the current date and time
            }

            # Write the JSON to the file with indentation for readability
            json.dump(file_cache, f, indent=4)


        print(f"File saved to cache at: {cached_path}")

    except Exception as e:
        print(f"Caught error writing file_cache: {e}")
    return None


def main(): 
    layout = [
        [sg.Text('VTP Script', font=('Helvetica', 15, 'bold'), justification=('center'))],
        [sg.Text('Please select all .mn files using "Browse" and click "Run"', font=('Helvetica', 10), justification=('left'))],
        #[sg.Text('2. Click on "Run"', font=('Helvetica', 10), justification=('left'))],
        [sg.FilesBrowse(key="file",  file_types=(("MN Files", "*.mn"),)), sg.Button('Run'), sg.Button('Exit')],
        #[sg.Text('Selection of fields to display in Omniverse', font=('Helvetica', 16))],
        #[sg.Radio('Magnetic Field', 'loss', size=(12, 1), key="B"), sg.Radio('Electric Field', 'loss', size=(12, 1), key="E")],
        #[sg.Text('Select a solution type', font=('Helvetica', 16))],
        #[sg.Radio('Animation', 'loss', size=(12, 1), key="transient"), sg.Radio('Static', 'loss', size=(12, 1), key="static")],
        #[sg.Button('Run Solution'), sg.Button('Exit')]
        [sg.Text('clark.pineau@mail.mcgill.ca for help', font=('Helvetica', 8, 'italic'), justification=('right'))]
    ]
    window = sg.Window("VTP script", layout)

    while True:
        event, values = window.read()
        if event == sg.WIN_CLOSED:
            break
        if event == 'Run':
            if "file" not in values:
                print("no file(s) specified")
                continue
            #starting process
            print(f"visualizing H and E field")
            #save all path to the different
            file_list = values["file"].split(';')

            for file_path in file_list:
                file_path = os.path.abspath(file_path)

                # Run the external scripts regardless of cache state
                print(f"Processing file: {file_path}")
                magnet.set_filename(file_path)
                magnet.run_script()
                print("Magnet extraction done, parsing into ParaView")
                calling_paraview.run_parser()
                print("ParaView parsing done, saving file to cache")
                save_file_to_cache(file_path)




                #used to open paraview but doesn't work
                #Visualize the field using ParaView
                #calling_paraview.run_displayer(field)
                #print(f"Display conversion for {file_path} done")
            break

        if event == 'Exit':
            break




    window.close()

if __name__ == '__main__':

    main()