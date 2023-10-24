Call SetLocale("en-us")

Set myModel = openDocument("C:\Users\tduran2\Desktop\BLDC tutorial\BLDC12slot1layer4pole_success1.mn")

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

Dim n_int
n_int = CInt(n_temp)

Dim arr()

CALL field.getFieldCoordinates(arr)

Dim csvFileName
csvFileName = "C:\Users\tduran2\Desktop\BLDC tutorial\B_fields.csv"
Dim fso, csvFile
Set fso = CreateObject("Scripting.FileSystemObject")
Set csvFile = fso.CreateTextFile(csvFileName, True)




For i= 0 To field.getNumberOfFieldNodes() - 1
    line = arr(i,0) & "," & arr(i,1)
    csvFile.WriteLine line
Next

csvFile.Close
	
