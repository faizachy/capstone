import os
import subprocess

# arg = ['runas', '/user:fchu6', "C:\Program Files\Siemens\Simcenter MAGNET 2212.0002\MagNet.exe"]
# subprocess.call(arg)

with open('magnet_script2.1.vbs', 'r') as file:
    data = file.readlines()
print(data)
file.close()



arg = "C:\\Users\\fchu6\\Desktop\\BLDC12slot1layer4pole_success1.mn"
data[3] = 'CALL openDocument("' + arg + '")\n'

with open('magnet_script2.1.vbs', 'w') as file:
    file.writelines( data )
file.close()

subprocess.call(["C:\\Program Files\\Siemens\\Simcenter MAGNET 2212.0002\\MagNet.exe", "-RunScriptVisible=C:\\Users\\fchu6\\Desktop\\magnet_script2.1.vbs"])