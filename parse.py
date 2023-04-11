#!/usr/bin/env pvpython
from paraview.simple import *
import vtk

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
def add_outside_face(face_set, f):
    if f in face_set:
        face_set.remove(f)
    else:
        face_set.add(f)

        
if __name__=="__main__":
    from sys import argv

    if len(argv)<2:
        print("usage: python parse.py <file>")
        exit(1)
    res=get_file_data(argv[1])
    print(res["Problem ID: 1"].keys())
    
    pos_type, pos_vals = res["Problem ID: 1"]["Mesh node coordinates for Entire model"]
    print(pos_type)
    fac_type, fac_vals = res["Problem ID: 1"]["Element mesh node connectivity for Entire model"]
    print(fac_type)

    vtk_points = vtk.vtkPoints()
    vtk_faces = vtk.vtkCellArray()
    for pos in pos_vals:
        vtk_points.InsertNextPoint(pos[1:])
    
    faces = set()
    for f_val in fac_vals:
        f = tuple(sorted(f_val[1:]))
        add_outside_face(faces, (f[0], f[1], f[2]))
        add_outside_face(faces, (f[0], f[1], f[3]))
        add_outside_face(faces, (f[0], f[2], f[3]))
        add_outside_face(faces, (f[1], f[2], f[3]))
    
    for face in faces:
        vtk_face = vtk.vtkTriangle()
        ids = vtk_face.GetPointIds()
        for i, node in enumerate(face):
            ids.SetId(i, node - 1) # because magnet export 1-indexed
        vtk_faces.InsertNextCell(vtk_face)
        
    vtk_data = vtk.vtkPolyData()
    vtk_data.SetPoints(vtk_points)
    vtk_data.SetPolys(vtk_faces)

    writer = vtk.vtkXMLPolyDataWriter()
    writer.SetFileName('model_out.vtp')
    writer.SetInputData(vtk_data)
    writer.Write()
