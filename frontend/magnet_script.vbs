
Call SetLocale("en-us")
'DO NOT TOUCH THE ORDER OF LINE 4: because we are hard coding line 4
CALL openDocument("C:\Users\tduran2\Desktop\Capstone\BLDC_Motors\Scaled_MotorsolveBLDC_12slots4poles_WORKS.mn")
Set Doc = getDocument()
Set Sol= Doc.getSolution()
SolType=Sol.getSolutionType()
Fields= Doc.getFields()
Dim arr_type

SolType = Sol.getSolutionType()
If (SolType = "TransientMagnetic") Then
    arr_type = Array(1,1)
ElseIf (SolType = "StaticMagnetic") Then
    arr_type = 1
Else
    'Figure something out for this, maybe error handling code'
    arr_type = 1
End If

If (mesh.is3DMesh()) Then

    Set mesh=Sol.getMesh(1)
    Set field=Sol.getSystemField(mesh, "B")
    Set field_B=Sol.getSystemField(mesh, "B")
    Set field_E=Sol.getSystemField(mesh, "E")
    Set field_mass=Sol.getSystemField(mesh, "Mass density")

    Dim fso, csvFileName1, csvFileName2, csvFileName3, csvFileName3_mass_density
    Set fso = CreateObject("Scripting.FileSystemObject")
    csvFileName1 = "output\fieldscoordinates.csv"
    csvFileName2 = "output\fieldsconnectivity.csv"
    csvFileName3_B = "output\B_fields.csv"
    csvFileName3_E = "output\E_fields.csv"
    csvFileName3_mass_density = "output\mass_density.csv"

    Set csvFile1 = fso.CreateTextFile(csvFileName1,True)
    Set csvFile2 = fso.CreateTextFile(csvFileName2,True)
    Set csvFile3_B = fso.CreateTextFile(csvFileName3_B,True)
    Set csvFile3_E = fso.CreateTextFile(csvFileName3_E,True)
    Set csvFileName3_mass_density = fso.CreateTextFile(csvFileName3_mass_density,True)

    'Coordinates
    Dim arr
    CALL field.getFieldCoordinates(arr)
    csvFile1.WriteLine "Problem ID: 1"
    csvFile1.WriteLine "Mesh node coordinates for Entire model"
    line3 = "Node" & "," & "x" & "," & "y" & "," & "z"
    csvFile1.WriteLine line3
    Set uniqueCoordinates = CreateObject("Scripting.Dictionary")
    Dim count
    count = 1
    For i = 0 to field.getNumberOfFieldNodes() -1
        line = arr(i,0) & "," & arr(i,1) & "," & arr(i,2)
        If Not uniqueCoordinates.Exists(line) Then
            line2 = count & "," & line
            csvFile1.WriteLine line2
            uniqueCoordinates(line) = True
            Count = Count + 1
        End if
    Next
    csvFile1.Close

    'Connectivity
    Dim Elements()
    CALL mesh.getElements(Elements)
    csvFile2.WriteLine "Problem ID: 1"
    csvFile2.WriteLine "Element mesh node connectivity for Entire model"
    line3 = "Element" & "," & "Node #1" & ","  & "Node #2" & "," & "Node #3" & "," & "Node #4"
    csvFile2.WriteLine line3
    For i= 0 To mesh.getNumberOfElements() - 1
    line = (i+1) & "," & Elements(i,0)+1 & "," & Elements(i,1)+1 & "," & Elements(i,2)+1 & "," & Elements(i,3)+1
    csvFile2.WriteLine line
    Next

    csvFile2.Close

    'B field
    Dim Data()
    CALL field_B.getFieldData(Data)
    Dim Data2()
    Redim data2(mesh.getNumberOfElements - 1, 11)
    For i= 0 To mesh.getNumberOfElements - 1

        'X field values
        data2(i, 0) = data(4*i, 0) 'Node#1 for ith iteration
        data2(i, 1) = data(4*i + 1, 0) 'Node#2 for ith iteration
        data2(i, 2) = data(4*i + 2, 0) 'Node#3 for ith iteration
        data2(i, 3) = data(4*i + 3, 0) 'Node#4 for ith iteration

        'Y field values
        data2(i, 4) = data(4*i, 1)
        data2(i, 5) = data(4*i + 1, 1)
        data2(i, 6) = data(4*i + 2, 1)
        data2(i, 7) = data(4*i + 3, 1)

        'Z field values
        data2(i, 8) = data(4*i, 2)
        data2(i, 9) = data(4*i + 1, 2)
        data2(i, 10) = data(4*i + 2, 2)
        data2(i, 11) = data(4*i + 3, 2)

    Next

    csvFile3_B.WriteLine "Problem ID: 1"
    csvFile3_B.WriteLine "B values for Entire model"
    line3 = "Element" & "," & "Bx for Node #1" & ","  &"Bx for Node #2" & "," & "Bx for Node #3" & "," & "Bx for Node #4" & "," & "By for Node #1" & "," & "By for Node #2" & "," & "By for Node #3" & "," & "Bx for Node #4"& "," & "By for Node #1" & "," & "By for Node #2" & "," & "By for Node #3"& "," & "Bx for Node #4"
    csvFile3_B.WriteLine line3

    For i= 0 To mesh.getNumberOfElements -1
        line =  (i+1) & "," & Data2(i,0) & "," & Data2(i,1) & "," & Data2(i,2) & "," & Data2(i,3) & "," & Data2(i,4) & "," & Data2(i,5) & "," & Data2(i,6) & "," & Data2(i,7) & "," & Data2(i,8) & "," & Data2(i,9) & "," & Data2(i,10) & "," & Data2(i,11)
        csvFile3_B.WriteLine line
    Next

    csvFile3_B.Close

    'E field
    Dim Data_E()
    CALL field_E.getFieldData(Data_E)
    Redim data2_E(mesh.getNumberOfElements - 1, 11)
    For i= 0 To mesh.getNumberOfElements - 1

        'X field values
        data2_E(i, 0) = data_E(4*i, 0) 'Node#1 for ith iteration
        data2_E(i, 1) = data_E(4*i + 1, 0) 'Node#2 for ith iteration
        data2_E(i, 2) = data_E(4*i + 2, 0) 'Node#3 for ith iteration
        data2_E(i, 3) = data_E(4*i + 3, 0) 'Node#4 for ith iteration

        'Y field values
        data2_E(i, 4) = data_E(4*i, 1)
        data2_E(i, 5) = data_E(4*i + 1, 1)
        data2_E(i, 6) = data_E(4*i + 2, 1)
        data2_E(i, 7) = data_E(4*i + 3, 1)

        'Z field values
        data2_E(i, 8) = data_E(4*i, 2)
        data2_E(i, 9) = data_E(4*i + 1, 2)
        data2_E(i, 10) = data_E(4*i + 2, 2)
        data2_E(i, 11) = data_E(4*i + 3, 2)

    Next

    csvFile3_E.WriteLine "Problem ID: 1"
    csvFile3_E.WriteLine "E values for Entire model"
    line3 = "Element" & "," & "Ex for Node #1" & ","  &"Ex for Node #2" & "," & "Ex for Node #3" & "," & "Ex for Node #4" & "," & "Ey for Node #1" & "," & "Ey for Node #2" & "," & "Ey for Node #3" & "," & "Ex for Node #4"& "," & "Ey for Node #1" & "," & "Ey for Node #2" & "," & "Ey for Node #3"& "," & "Ex for Node #4"
    csvFile3_E.WriteLine line3

    For i= 0 To mesh.getNumberOfElements -1
        line =  (i+1) & "," & Data2_E(i,0) & "," & Data2_E(i,1) & "," & Data2_E(i,2) & "," & Data2_E(i,3) & "," & Data2_E(i,4) & "," & Data2_E(i,5) & "," & Data2_E(i,6) & "," & Data2_E(i,7) & "," & Data2_E(i,8) & "," & Data2_E(i,9) & "," & Data2_E(i,10) & "," & Data2_E(i,11)
        csvFile3_E.WriteLine line
    Next

    csvFile3_E.Close

    Dim mass_density_data()
    CALL field_mass.getFieldData(mass_density_data)
    csvFileName3_mass_density.WriteLine "Problem ID: 1"
    csvFileName3_mass_density.WriteLine "Mass density values for Entire model"
    line3 = "Element" & "," & "Mass density for Node#1" & ","  & "Mass density for Node#2" & "," & "Mass density for Node#3" & "," & "Mass density for Node#4"
    csvFileName3_mass_density.WriteLine line3


    For i= 0 To mesh.getNumberOfElements() - 1
    line = (i+1) & "," & mass_density_data(4*i) & "," & mass_density_data(4*i+1) & "," & mass_density_data(4*i+2) & "," & mass_density_data(4*i+3)
    csvFileName3_mass_density.WriteLine line
    Next
    csvFileName3_mass_density.Close

Else 
    MsgBox "ERROR: User must input a 3D version of the model to vizualize in NVIDIA"
End if