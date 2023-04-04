#!/usr/bin/env pvpython
from paraview.simple import *

def convert_value(e):
    try:
        return int(e)
    except:
        try:
            return float(e)
        except:
            return e

def get_file_data(filename):
    res={}
    curproblem=""
    cur=""
    types=None
    values=[]
    with open(filename,"r") as f:
        for ln in f:
            elems=tuple(e.strip(" \n\t") for e in ln.split(",") if e.strip(" \n\t")!="")
            if len(elems)==1:
                if cur!=None:
                    if types!=None:
                        res[curproblem][cur]=(types,values)
                        values=[]
                        types=None
                    curproblem=elems[0]
                    if curproblem not in res:
                        res[curproblem]={}
                    cur=None
                else:
                    cur=elems[0]
            elif types==None:
                types=elems
            else:
                values.append(tuple(convert_value(e) for e in elems)) # note the node numbers are 1-indexed, so will need to offset
    if types!=None:
        res[curproblem][cur]=(types,values)
    return res

        
if __name__=="__main__":
    from sys import argv

    if len(argv)<2:
        print("usage: python parse.py <file>")
        exit(1)
    res=get_file_data(argv[1])
    #print(res)

    pos_type, pos_vals = res["Problem ID: 1"]["Mesh node coordinates for Entire model"]

    # get active view
    renderView1 = GetActiveViewOrCreate('RenderView')
    renderView1.ViewSize = [1670, 1091]

    for pos in pos_vals[:300]:
    
        # Lets create a sphere
        sphere=Sphere(Radius = 0.1, Center = pos[1:])
        Show(sphere)

    # save screenshot
    Render()
    SaveScreenshot('greenSphereScreenshot.png', renderView1,ImageResolution=[1670, 1091])
