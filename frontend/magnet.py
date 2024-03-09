import os
import subprocess

# sets up and executes magnet_script.vbs to automate the process of extracting field solutions from a MAGNET motor file and
# saving them into CSV files.

# to set the file name for our magnet script, we create an in-place edited copy of the script with the filename saved
# this is because magnet's scripting enviornment has no normal way to support command line arguments
# so magnet_script_temp will be written and run each time we do the field extraction, though magnet_script.vbs is what needs to be modified to make
# actual changes to the magnet script
# the CALL openDocument line in the magnet script needs to remain in the same place so it can be overwritten for the temp script
def set_filename(filename):
    with open('magnet_script.vbs', 'r') as file:
        data = file.readlines()
    #print(data)
    file.close()

    data[3] = 'CALL openDocument("' + filename + '")\n'

    with open('magnet_script_temp.vbs', 'w') as file:
        file.writelines(data)
    file.close()

# runs magnet with the script input to run invisibly; the install location is based on the lab computers and could vary for other magnet set ups
def run_script():
    subprocess.call(["C:\\Program Files\\Siemens\\Simcenter MAGNET 2212.0003\\MagNet.exe", "-RunScriptInvisible=magnet_script_temp.vbs"])
