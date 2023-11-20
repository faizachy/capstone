import subprocess

# Paraview Python path must be stored as a global variable before use
pvpython_path = "/Applications/ParaView-5.11.0.app/Contents/bin/pvpython"
script_path = "paraviewScript.py"  # Replace with your script's actual path

# Define the two additional variables for path of model file and specified field
variable1 = "/Users/johantrippitelli/Desktop/model_out.vtp"
variable2 = "E"

# Run the script with pvpython and the additional arguments
try:
    result = subprocess.run(
        [pvpython_path, script_path, variable1, variable2],
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
