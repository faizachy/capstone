#!/usr/bin/env pvpython

# from paraview.simple import *
from math import sqrt
from glob import glob
from sys import argv
import vtk

# we do a meter to milimeter conversion because magnet and paraview are using different units for lengths
scale_factor = 1000

# Define a function to convert a value to an integer or a float, or leave it as is if it cannot be converted.
def convert_value(e):
    try:
        return int(e)
    except:
        try:
            return float(e)
        except:
            return e

# opens a list of files, where each file name can be a glob, and from them builds a dictionary with the different values set by the csv files
# corresponding to each type of data
# we build this from multiple files because the field extractor can only extract one value at a time, and our csv extractor similarly extracts each value to seperate multiple files
# duplicate information is overwritten without failing; this will happen normally with mesh connectivity or node coordinates from the regular magnet field extractor, but our script will not have duplicated values
def get_file_data(filenames):
    res = {}
    filenames = set(sum((glob(x) for x in filenames), []))
    print("opening:", filenames)
    for filename in filenames:
        curproblem = ""
        cur = ""
        types = None
        values = []
        with open(filename, "r") as f:
            for ln in f:
                elems = tuple(e.strip(" \n\t") for e in ln.split(",") if e.strip(" \n\t") != "")
                if len(elems) == 1: # single entry lines can only be headers describing what the following data will represent
                    if cur != None:
                        if types != None:
                            res[curproblem][cur] = (types, values)
                            values = []
                            types = None
                        curproblem = elems[0]
                        if curproblem not in res:
                            res[curproblem] = {}
                        cur = None
                    else:
                        cur = elems[0]
                elif types == None: # each csv section will have its first line describing what type of values are in each collumn for the section
                    types = elems
                else:
                    values.append(tuple(convert_value(e) for e in elems)) # Note: node numbers are 1-indexed, so will need to offset
        if types != None:
            res[curproblem][cur] = (types, values)
    print(res.keys())
    return res

# Define a function to add an outside face to a set, ensuring no duplicates.
def add_outside_face(face_set, f, mass):
    if f in face_set:
        face_set[f] = max(mass, face_set[f])
    else:
        face_set[f] = mass

# Entry point of the script
def main():
    print("pvpython loaded...")

    if len(argv) < 2:
        print("usage: python parse.py <file>")
        exit(1)
    res = get_file_data(argv[1:])
    print("files red sucessfully")
    print(res["Problem ID: 1"].keys())

    if "Problem ID: 1" not in res:
        raise "Error: Files did not have a valid problem ID"
    # Extract mesh node coordinates, element connectivity, and B values from the parsed data.
    # it is possible for these values to be excluded
    hasbfield = "B values for Entire model" in res["Problem ID: 1"]
    hasefield = "E values for Entire model" in res["Problem ID: 1"]
    hasmass = "Mass density values for Entire model" in res["Problem ID: 1"]

    # these values should  be in every output ... will fail if they do not exist
    pos_type, pos_vals = res["Problem ID: 1"]["Mesh node coordinates for Entire model"]
    print(pos_type)
    fac_type, fac_vals = res["Problem ID: 1"]["Element mesh node connectivity for Entire model"]
    print(fac_type)

    # Create VTK data structures to store the mesh and B field magnitude.
    vtk_points = vtk.vtkPoints()
    vtk_faces = vtk.vtkCellArray()

    vtk_b = vtk.vtkFloatArray()
    vtk_b.SetNumberOfComponents(3)
    vtk_b.SetName("B field Vectors")
    # vtk_b_mag = vtk.vtkFloatArray()
    # vtk_b_mag.SetName("B field Magnitude")

    if hasbfield:
        mag_type, mag_vals = res["Problem ID: 1"]["B values for Entire model"]
        print(mag_type)
        # Create a dictionary to store point fields.
        b_point_fields = {}
        # Process and store B values for each node.
        for field in mag_vals:
            face = fac_vals[field[0] - 1]
            for i in range(0, 4):
                node = face[1 + i]
                node_b = tuple(field[1 + i : : 4])
                if node not in b_point_fields:
                    b_point_fields[node] = [node_b]
                else:
                    b_point_fields[node].append(node_b)
        #print(b_point_fields)
        # Populate VTK data structures with mesh node coordinates and computed B field magnitudes.
        for pos in pos_vals:
            fields = b_point_fields[pos[0]]
            f_x, f_y, f_z = 0, 0, 0
            for f in fields:
                f_x += f[0] * scale_factor
                f_y += f[1] * scale_factor
                f_z += f[2] * scale_factor
            # field_mag = sqrt(sum(x * x for x in (f_x, f_y, f_z)))
            # vtk_b_mag.InsertNextTuple1(field_mag)
            vtk_b.InsertNextTuple3(f_x, f_y, f_z)

    vtk_e = vtk.vtkFloatArray()
    vtk_e.SetNumberOfComponents(3)
    vtk_e.SetName("E field Vectors")
    # vtk_e_mag = vtk.vtkFloatArray()
    # vtk_e_mag.SetName("E field Magnitude")

    if hasefield:
        # Extract E field values for Entire model at time t = 0 ms
        e_type, e_vals = res["Problem ID: 1"]["E values for Entire model"]
        print(e_type)
        # Create a dictionary to store E field values for each node.
        e_point_fields = {}
        # Process and store E field values for each node.
        for field in e_vals:
            face = fac_vals[field[0] - 1]
            for i in range(0, 4):
                node = face[1 + i]
                node_e = tuple(field[1 + i : : 4])
                if node not in e_point_fields:
                    e_point_fields[node] = [node_e]
                else:
                    e_point_fields[node].append(node_e)
        #print(e_point_fields)
        # Populate VTK data structures with E field magnitudes.
        for pos in pos_vals:
            fields = e_point_fields.get(pos[0], [])  # Get E field values for the current node (if available)
            e_x, e_y, e_z = 0, 0, 0
            for f in fields:
                e_x += f[0] * scale_factor
                e_y += f[1] * scale_factor
                e_z += f[2] * scale_factor
            #field_mag = sqrt(sum(x * x for x in (e_x, e_y, e_z)))
            #vtk_e_mag.InsertNextTuple1(field_mag)
            vtk_e.InsertNextTuple3(e_x, e_y, e_z)


    vtk_mass_mag = vtk.vtkFloatArray()
    vtk_mass_mag.SetName("Mass density Magnitude")
    print("building connectivity")
    face_masses = {}
    # Get mass densities of points
    if hasmass:
        mas_type, mas_vals = res["Problem ID: 1"]["Mass density values for Entire model"]
        print(mas_type)
        for field in mas_vals:
            face = field[0] - 1
            face_mass = sum(field[1:])
            face_masses[face] = face_mass

    # Create faces set to keep track of unique faces.
    faces = {}
    for f_val in fac_vals:
        mass = face_masses[f_val[0] - 1] if hasmass else 5.0
        if hasmass and mass < 5.0: # Don't add air to mesh -- 5.0 is the mass density cutoff, with everything below it being air, and everything heavier being treated as something solid
            continue
        f = tuple(sorted(f_val[1:])) # we sort the node coordinates to ensure that face verticies always appear in the same order as they can be parts of different tetrahedrons
        add_outside_face(faces, (f[0], f[1], f[2]), mass) # each mesh node is a tetrahedron, so we add each face of the tetrahedron
        add_outside_face(faces, (f[0], f[1], f[3]), mass)
        add_outside_face(faces, (f[0], f[2], f[3]), mass)
        add_outside_face(faces, (f[1], f[2], f[3]), mass)

    # Create VTK triangle cells from the faces set.
    for pos in pos_vals:
        vtk_points.InsertNextPoint([x * scale_factor for x in pos[1:]])
    for (face, mass) in faces.items():
        vtk_face = vtk.vtkTriangle()
        ids = vtk_face.GetPointIds()
        for i, node in enumerate(face):
            ids.SetId(i, node - 1)  # Because magnet export is 1-indexed
        vtk_faces.InsertNextCell(vtk_face)
        if hasmass:
            vtk_mass_mag.InsertNextTuple1(mass)
    print("writing vtk...")
    # Create VTK polydata and add point and cell data.
    vtk_data = vtk.vtkPolyData()
    vtk_data.SetPoints(vtk_points)
    vtk_data.SetPolys(vtk_faces)
    if hasbfield:
        vtk_data.GetPointData().AddArray(vtk_b)
        # vtk_data.GetPointData().AddArray(vtk_b_mag)
    if hasefield:
        vtk_data.GetPointData().AddArray(vtk_e)
        # vtk_data.GetPointData().AddArray(vtk_e_mag)
    if hasmass:
        vtk_data.GetCellData().AddArray(vtk_mass_mag)

    # Write the VTK polydata to a file.
    writer = vtk.vtkXMLPolyDataWriter()
    writer.SetFileName('output/model_out.vtp')
    writer.SetInputData(vtk_data)
    writer.Write()

main()
