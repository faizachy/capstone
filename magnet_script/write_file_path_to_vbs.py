import os
import subprocess

def set_filename(filename):
    with open('magnet_script.vbs', 'r') as file:
        data = file.readlines()
    print(data)
    file.close()

    data[3] = 'CALL openDocument("' + filename + '")\n'

    with open('magnet_script.vbs', 'w') as file:
        file.writelines(data)
    file.close()

    subprocess.call(["C:\\Program Files\\Siemens\\Simcenter MAGNET 2212.0002\\MagNet.exe", "-RunScriptVisible=magnet_script.vbs"])

def run_script():
    subprocess.call(["C:\\Program Files\\Siemens\\Simcenter MAGNET 2212.0002\\MagNet.exe", "-RunScriptVisible=magnet_script.vbs"])
