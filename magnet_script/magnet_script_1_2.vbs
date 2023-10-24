Call SetLocale("en-us")


CALL openDocument("C:\Users\fchu6\Desktop\MotorsolveBLDC_12slots4poles_WORKS.mn")

Call getDocument().newCircuitWindow()

Set Doc = getDocument()

Set Sol= Doc.getSolution()


Quantity = "B"


Fields= Doc.getFields()


Set mesh=Sol.getMesh(1)

Set field=Sol.getSystemField(mesh, "B")


Dim temp1

temp1 = Field.getNumberOfFieldNodesPerElement()


Dim n_temp

n_temp = mesh.getNumberOfElements()*temp1


Dim csvFileName

csvFileName = "C:\Users\fchu6\Desktop\B_fields2.csv"

Dim fso, csvFile

Set fso = CreateObject("Scripting.FileSystemObject")

Set csvFile = fso.CreateTextFile(csvFileName, True)

 

' ' get element indices - N * 3

' Dim Elements()

' CALL mesh.getElements(Elements)

 

Dim Data()

CALL field.getFieldData(Data)

Dim Data2()

Redim data2(mesh.getNumberOfElements - 1, 11)



For i= 0 To mesh.getNumberOfElements - 1 ' for each element

    data2(i, 0) = data(4*i, 0)
    data2(i, 1) = data(4*i + 1, 0)
    data2(i, 2) = data(4*i + 2, 0)
    data2(i, 3) = data(4*i + 3, 0)

    data2(i, 4) = data(4*i, 1)
    data2(i, 5) = data(4*i + 1, 1)
    data2(i, 6) = data(4*i + 2, 1)
    data2(i, 7) = data(4*i + 3, 1)

    data2(i, 8) = data(4*i, 2)
    data2(i, 9) = data(4*i + 1, 2)
    data2(i, 10) = data(4*i + 2, 2)
    data2(i, 11) = data(4*i + 3, 2)

Next

 

csvFile.WriteLine "Problem ID: 1"

csvFile.WriteLine "B values for Entire model"

line3 = "Element" & "," & "Bx for Node #1" & ","  &"Bx for Node #2" & "," & "Bx for Node #3" & "," & "Bx for Node #4" & "," & "By for Node #1" & "," & "By for Node #2" & "," & "By for Node #3" & "," & "Bx for Node #4"& "," & "By for Node #1" & "," & "By for Node #2" & "," & "By for Node #3"& "," & "Bx for Node #4"

csvFile.WriteLine line3

' For i= 0 To ( mesh.getNumberOfElements() * field.getNumberOfFieldNodesPerElement()) - 1

'     line =  (i+1) & "," & Data(i,0) & "," & Data(i,1) & "," & Data(i,2)

'     csvFile.WriteLine line

' Next

 csvFile.WriteLine n_temp

 line5 = mesh.getNumberOfElements
 csvFile.WriteLine line5


For i= 0 To mesh.getNumberOfElements -1

    line =  (i+1) & "," & Data2(i,0) & "," & Data2(i,1) & "," & Data2(i,2) & "," & Data2(i,3) & "," & Data2(i,4) & "," & Data2(i,5) & "," & Data2(i,6) & "," & Data2(i,7) & "," & Data2(i,8) & "," & Data2(i,9) & "," & Data2(i,10) & "," & Data2(i,11)

    csvFile.WriteLine line

Next

csvFile.Close


