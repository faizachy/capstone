'sets the locale to English (United States)
Call SetLocale("en-us")
'DO NOT TOUCH THE ORDER OF LINE 5: because line 5 was hard coded
'opens a document or file for further processing
CALL openDocument("C:\Users\tduran2\Desktop\IPM 24S4P.mn")
'sets the variable Doc to the document object returned by the function getDocument(); used to retrieve the document that was opened in line 5
Set Doc = getDocument()
'sets the variable Sol to the solution object obtained from the document (Doc). It's likely that the document contains some kind of solution data that the script will work with.
Set Sol= Doc.getSolution()
'assigns the solution type obtained from the Sol object to the variable SolType; might be used to determine the type of solution data and how to process it further
SolType=Sol.getSolutionType()
'retrieves the fields from the document (Doc) and stores them in the variable Fields
Fields= Doc.getFields()
SolType = Sol.getSolutionType()
'declare various arrays and variables that will be used in the script. They reserve memory space for these variables.
Dim arr_type
Dim fso, csvFileName1, csvFileName2, csvFileName3, csvFileName3_mass_density
Dim arr
Dim count
Dim Elements()
Dim mass_density_data()
Dim Data()
Dim Data2()
Dim Data_E()
Dim GlobalTimeInstants
'number of time steps for a simulation, indicating that the script might perform some sort of time-based simulation or analysis.. There is a tradeoff between a smoother animation and time to run.
Dim NumberOfTimeSteps
NumberOfTimeSteps = 3


If (SolType = "TransientMagnetic") Then
    'initializes an array arr_type with two elements (1, 1). This array may be used as parameters for accessing specific elements within the solution data.
    arr_type = Array(1,1)
    'retrieves the mesh associated with the solution Sol using the array arr_type as parameters. A mesh typically represents the geometric structure of the simulation domain.
    Set mesh=Sol.getMesh(arr_type)
    'retrieves the magnetic field data (denoted by "B") associated with the mesh 'mesh' from the solution Sol.
    Set field=Sol.getSystemField(mesh, "B")
    'don't know yet why they are retrieving it twice
    Set field_B=Sol.getSystemField(mesh, "B")
    'retrieves the electric field data (denoted by "E") associated with the mesh 'mesh' from the solution Sol.
    Set field_E=Sol.getSystemField(mesh, "E")
    'retrieves the mass density data associated with the mesh 'mesh' from the solution Sol.
    Set field_mass=Sol.getSystemField(mesh, "Mass density")

    'Check that it is not solved in 2D.
    If Not mesh.is3DMesh() Then
        MsgBox "ERROR: User must input a 3D solution of the model to vizualize in NVIDIA"
        'may handle the closing of the program or some cleanup operations. terminate the script.
        Call Close(False)
    End if

    'Create CSV files
    'create text files and set their file names
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
    'retrieves the coordinates of the field nodes and stores them in the array arr.
    CALL field.getFieldCoordinates(arr)
    'writes a header to the CSV file indicating the problem ID and what the data represents.
    csvFile1.WriteLine "Problem ID: 1"
    csvFile1.WriteLine "Mesh node coordinates for Entire model"
    'creates a header line for the CSV file with column names "Node", "x", "y", and "z".
    line3 = "Node" & "," & "x" & "," & "y" & "," & "z"
    'writes the header line to the CSV file.
    csvFile1.WriteLine line3
    'creates a dictionary object named uniqueCoordinates to store unique coordinate lines.
    Set uniqueCoordinates = CreateObject("Scripting.Dictionary")
    count = 1
    'iterating over each field node.
    For i = 0 to field.getNumberOfFieldNodes() -1
        'constructs a line of CSV data representing the node's coordinates in the format "x,y,z".
        line = arr(i,0) & "," & arr(i,1) & "," & arr(i,2)
        'checks if the line representing the coordinates already exists in the uniqueCoordinates dictionary.
        If Not uniqueCoordinates.Exists(line) Then
            'constructs a new line for the CSV file including the node number (count) and the coordinates.
            line2 = count & "," & line
            'writes the line to the CSV file.
            csvFile1.WriteLine line2
            'adds the line to the dictionary uniqueCoordinates to mark it as existing.
            uniqueCoordinates(line) = True
            Count = Count + 1 'increment
        End if
    Next
    'closes the CSV file.
    csvFile1.Close

    'Connectivity
    'retrieves the mesh element node connectivity data and stores it in the array Elements.
    CALL mesh.getElements(Elements)
    csvFile2.WriteLine "Problem ID: 1"
    csvFile2.WriteLine "Element mesh node connectivity for Entire model"
    'creates a header line for the CSV file with column names "Element", "Node #1", "Node #2", "Node #3", and "Node #4".
    line3 = "Element" & "," & "Node #1" & ","  & "Node #2" & "," & "Node #3" & "," & "Node #4"
    csvFile2.WriteLine line3
    'iterating over each mesh element.
    For i= 0 To mesh.getNumberOfElements() - 1
        'constructs a line of CSV data representing the element's node connectivity. The element number is incremented by 1 to start from 1 rather than 0, and each node number retrieved from the Elements array is incremented by 1 to start from 1 rather than 0 (assuming node numbering starts from 0).
        line = (i+1) & "," & Elements(i,0)+1 & "," & Elements(i,1)+1 & "," & Elements(i,2)+1 & "," & Elements(i,3)+1
        csvFile2.WriteLine line
    Next
    csvFile2.Close

    'Mass density
    'retrieves mass density data
    CALL field_mass.getFieldData(mass_density_data)
    csvFileName3_mass_density.WriteLine "Problem ID: 1"
    csvFileName3_mass_density.WriteLine "Mass density values for Entire model"
    line3 = "Element" & "," & "Mass density for Node#1" & ","  & "Mass density for Node#2" & "," & "Mass density for Node#3" & "," & "Mass density for Node#4"
    csvFileName3_mass_density.WriteLine line3
    'iterates through each element, constructing a line of CSV data for each, including the element number and mass density values for each node.
    For i= 0 To mesh.getNumberOfElements() - 1
        line = (i+1) & "," & mass_density_data(4*i) & "," & mass_density_data(4*i+1) & "," & mass_density_data(4*i+2) & "," & mass_density_data(4*i+3)
        csvFileName3_mass_density.WriteLine line
    Next
    csvFileName3_mass_density.Close

    'retrieves global solution time instances
    ms_time_instants = Sol.getGlobalSolutionTimeInstants(1, GlobalTimeInstants)
    'have to figure out what is "time_instants"
    n_time_instants = Sol.getFieldSolutionTimeInstants(1, time_instants)
    'calculates the number of time instances and quarter time steps.
    quarter_time_steps = Int(n_time_instants/NumberOfTimeSteps)
    'iterates through each time instance, obtaining the mesh and field data for the magnetic and electric fields.
    for j = 0 to (n_time_instants - 1) Step quarter_time_steps
        arr_type = Array(1,j)
        Set mesh=Sol.getMesh(arr_type)
        Set field_B=Sol.getSystemField(mesh, "B")
        Set field_E=Sol.getSystemField(mesh, "E")

        'B field
        CALL field_B.getFieldData(Data)
        Redim data2(mesh.getNumberOfElements - 1, 11)
        For i= 0 To mesh.getNumberOfElements - 1

            'X field values
            data2(i, 0) = data(4*i, 0)     'Node#1 for ith iteration
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

        'For each field, it constructs CSV files with headers indicating the problem ID, field values for the entire model, and the specific time instance. It then iterates through each element, constructing lines of CSV data for each, including the element number and field values for each node.
        csvFile3_B.WriteLine "Problem ID: 1"
        csvFile3_B.WriteLine "B values for Entire model at time instance: " & GlobalTimeInstants(j)  & " ms"
        line3 = "Element" & "," & "Bx for Node #1" & ","  &"Bx for Node #2" & "," & "Bx for Node #3" & "," & "Bx for Node #4" & "," & "By for Node #1" & "," & "By for Node #2" & "," & "By for Node #3" & "," & "Bx for Node #4"& "," & "By for Node #1" & "," & "By for Node #2" & "," & "By for Node #3"& "," & "Bx for Node #4"
        csvFile3_B.WriteLine line3

        For i= 0 To mesh.getNumberOfElements -1
            line =  (i+1) & "," & Data2(i,0) & "," & Data2(i,1) & "," & Data2(i,2) & "," & Data2(i,3) & "," & Data2(i,4) & "," & Data2(i,5) & "," & Data2(i,6) & "," & Data2(i,7) & "," & Data2(i,8) & "," & Data2(i,9) & "," & Data2(i,10) & "," & Data2(i,11)
            csvFile3_B.WriteLine line
        Next

        'E field
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
        csvFile3_E.WriteLine "E values for Entire model at time instance: " & GlobalTimeInstants(j) & " ms"
        line3 = "Element" & "," & "Ex for Node #1" & ","  &"Ex for Node #2" & "," & "Ex for Node #3" & "," & "Ex for Node #4" & "," & "Ey for Node #1" & "," & "Ey for Node #2" & "," & "Ey for Node #3" & "," & "Ex for Node #4"& "," & "Ey for Node #1" & "," & "Ey for Node #2" & "," & "Ey for Node #3"& "," & "Ex for Node #4"
        csvFile3_E.WriteLine line3

        For i= 0 To mesh.getNumberOfElements -1
            line =  (i+1) & "," & Data2_E(i,0) & "," & Data2_E(i,1) & "," & Data2_E(i,2) & "," & Data2_E(i,3) & "," & Data2_E(i,4) & "," & Data2_E(i,5) & "," & Data2_E(i,6) & "," & Data2_E(i,7) & "," & Data2_E(i,8) & "," & Data2_E(i,9) & "," & Data2_E(i,10) & "," & Data2_E(i,11)
            csvFile3_E.WriteLine line
        Next
  
    Next
    csvFile3_B.Close
    csvFile3_E.Close

'same process, but for static analysis
ElseIf (SolType = "StaticMagnetic") Then
    arr_type = 1
    Set mesh=Sol.getMesh(arr_type)
    Set field=Sol.getSystemField(mesh, "B")
    Set field_B=Sol.getSystemField(mesh, "B")
    Set field_E=Sol.getSystemField(mesh, "E")
    Set field_mass=Sol.getSystemField(mesh, "Mass density")
    
    'Check that it is not solved in 2D.
    If Not mesh.is3DMesh() Then
        MsgBox "ERROR: User must input a 3D solution of the model to vizualize in NVIDIA"
        Call Close(False)
    End if

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
    CALL field.getFieldCoordinates(arr)
    csvFile1.WriteLine "Problem ID: 1"
    csvFile1.WriteLine "Mesh node coordinates for Entire model"
    line3 = "Node" & "," & "x" & "," & "y" & "," & "z"
    csvFile1.WriteLine line3
    Set uniqueCoordinates = CreateObject("Scripting.Dictionary")
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

    'Mass density
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



    'B field
    CALL field_B.getFieldData(Data)
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

Else
    'Figure something out for this, maybe error handling code'
    MsgBox "ERROR: User must input a a static or transient solution of the model to vizualize in NVIDIA"
End If
'test:
