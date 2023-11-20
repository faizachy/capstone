import subprocess

# Paraview Python path must be stored as a global variable before use
pvpython_path = "C:\\Program Files\\ParaView 5.11.2\\bin\\pvpython.exe"

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


def run_parser():
    subprocess.call([pvpython_path, "parse.py", "output/*.csv"])

if __name__ == "__main__":
    run_displayer("B")