import os
import subprocess

def run_script():
    subprocess.call(["/mnt/d/paraview/ParaView 5.10.1-Windows-Python3.9-msvc2017-AMD64/bin/pvpython.exe", "parse.py", "output/*.csv"]) # TODO whatever is the paraview path
