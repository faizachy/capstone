import subprocess

# Paraview Python path must be stored as a global variable before use
# This is configured for install on lab machines; it may need to be changed for other install setups
pvpython_path = "C:\\Program Files\\ParaView 5.11.2\\bin\\pvpython.exe"

# the paraview scripts are written in python but they cannot be called directly from the frontend as normal python imports because they need to be run from the paraview python enviornment, which does not have the python-tkinter support needed by the frontend. thus we have to issue subprocess calls for these too

# issues paraview script converting output vtk file into properly rescaled paraview with colored vectors
def run_displayer(variable2):
    # Define the two additional variables for path of model file and specified field
    variable1 = "output/model_out.vtp"

    # Run the script with pvpython and the additional arguments
    try:
        result = subprocess.run(
            [pvpython_path, "paraviewScript.py", variable1, variable2],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )

        # If the call was successful, print the output
        print("Successful")
        print(result.stdout)

    except subprocess.CalledProcessError as e:
        # If there was an error, print it
        print("Error:")
        print(e.stderr)

# issues paraview script for converting the csv files output from the magnet to a vtk file
def run_parser():
    subprocess.call([pvpython_path, "parse.py", "output/*.csv"])

if __name__ == "__main__": # testing
    run_displayer("B")
