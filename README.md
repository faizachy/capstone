# Inside the industrial Metaverse with Siemens MAGNET and NVIDIA Omniverse

This is an electro-magnetic field visualization tool for Siemens MAGNET motor file with a 3D solution. This program is written in Python and Visual Basic Script. Note that a Python package `PySimpleGUI` is required in the running Python environment. User may install the required package by executing `pip install pysimplegui` in the desired Python environment. 


The visulization is completed in ParaView and presented in NVIDIA Omniverse. The user should manage to install the Omniverse Paraview Connector, a Nucleus Server and a Omniverse Composer within the Omniverse Launcher for a proper visualization. Detailed information on the installation process can be found on the official website respectively. 


Therefore, it is required to have Siemens MAGNET, ParaView, NVIDIA Omniverse and Python environment installed on a Windows machine. Note that proper licenses may be required for certain softwares. 

# Usage

The program is designed to run from the command line. Execute `python main.py` within the `capstone/frontend` directory to start the program. Within the Graphic Interface, the user should select a MagNet motor file with `.mn` extension. This motor file should contain a 3D solution. The user should also select the type of field to visualize. 


When running for the first time, the user should verify the connectivity from ParaView to NVIDIA Omniverse following the instruction from the installation of Omniverse Paraview Connector. Also, the user should create a local server on Omniverse Nucleus to store the rendering data from ParaView. 


Once the Python program finishes execution, the user should open the Omniverse Composer application from Omniverse Launcher and found generated `.usd` file in `user/test/session_xx` (the default location). 

Note that this Python program includes a cache feature. When a `.mn` file was visualized for once, further visualizations on the same motor file (same file name in same directory) will not update the visualization content. 

# Brief Explanation on Scripts

The program relies on code in directory `capstone/frontend` only. 

## calling_paraview.py
This script interacts with `pvpython` to process and visualize data:
- `run_parser`: Converts CSV files in the `output/` directory into a VTK file using `parse.py`.
- `run_displayer`: Displays the generated VTK file in ParaView using `paraviewScript.py`. It also supports specifying a field to visualize (e.g., "B").
- Ensure the path to `pvpython` in `calling_paraview.py` is correctly set to match your ParaView installation. The default path in the script is: pvpython_path = "C:\\Program Files\\ParaView 5.11.2\\bin\\pvpython.exe"


## magnet.py

This script automates the process of extracting field solutions from a MAGNET motor file by dynamically generating a temporary VBScript (magnet_script_temp.vbs) with the specified motor file path. It then executes MAGNET with this script to output field solutions as CSV files.

## magnet_script.vbs

This is a Visual Basic Script designed to extract and export simulation data from a 3D transient magnetic analysis model. It processes mesh coordinates, element connectivity, and field data (magnetic, electric, and mass density) across time steps, saving the results as CSV files for visualization and analysis.

## main.py

The main control flow of the program. It takes user input, extracts data from MAGNET and pipe data into ParaView. The script provides a graphical user interface (GUI) using PySimpleGUI, where users can select .mn files, run the analysis, and visualize the output fields in ParaView.
File Selection: Users can select one or more .mn files to process.
Magnet Data Processing: For each selected file, the program uses the magnet module to extract data and then pipes it to ParaView using the calling_paraview module.
Cache Management: The script caches the output VTK files for reuse, storing the cache information in a file_cache.json file.
Error Handling: If any file or processing step fails, appropriate error messages are printed.

## paraviewScript.py

Display the VTK file in ParaView. This file can be generated from `Trace` functionalities in `ParaView`. 

## parse.py

Python script used to parse the csv files and creates a VTK file that encompasses all the information of the CSV files.

## degreeScript.vbs

Simulates the rotation of a BLDC motor across 360 degrees by:

Selecting and rotating components of the motor model.
Solving static electromagnetic simulations for each degree.
Saving results as .mn files for further processing.

## Output

Processed .usd files are stored in the directory:
user/test/session_xx






