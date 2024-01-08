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

This script calls `pvpython` to parse and display data from csv file into vtk file. 

## magnet.py

This script writes user defined MAGNET motor file location into VBScript file and executes the MAGNET with the updated VBScript to extract field solutions. 

## magnet_script.vbs

Script written in VBScript. It is used to extract field values from a MAGNET .mn motor file into CSV files. These files can be found 
in the csv files folder inside the frontend folder. 

## main.py

The main control flow of the program. It takes user input, extracts data from MAGNET and pipe data into ParaView. 

## paraviewScript.py

Display the VTK file in ParaView. This file can be generated from `Trace` functionalities in `ParaView`. 

## parse.py

Python script used to parse the csv files and creates a VTK file that encompasses all the information of the CSV files.








