' Modifier: clark Pineau clark.pineau@mail.mcgill.ca
' Software design to solve a stepper with 3 poles motor rotation for all of it's degrees
' any information needed, email me, siemens is very good at making weird script coding measures
' its also easily revrt ingneerable lol, siemens hire plz




Call SetLocale("en-us")

' Number of iterations
Dim i
Dim iterations
iterations = 90

'part 1: coil 5 and 6 on
For i = 1 To iterations

    'set coils
   If i < 30 Then
        Call getDocument().setParameter("Coil#1", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#3", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#2", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#4", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#5", "Current", "5", infoNumberParameter)
        Call getDocument().setParameter("Coil#6", "Current", "5", infoNumberParameter)
    ElseIf i >= 30 And i < 60 Then
        Call getDocument().setParameter("Coil#1", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#3", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#2", "Current", "5", infoNumberParameter)
        Call getDocument().setParameter("Coil#4", "Current", "5", infoNumberParameter)
        Call getDocument().setParameter("Coil#5", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#6", "Current", "0", infoNumberParameter)
    ElseIf i >= 60 And i < 90 Then
        Call getDocument().setParameter("Coil#1", "Current", "5", infoNumberParameter)
        Call getDocument().setParameter("Coil#3", "Current", "5", infoNumberParameter)
        Call getDocument().setParameter("Coil#2", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#4", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#5", "Current", "0", infoNumberParameter)
        Call getDocument().setParameter("Coil#6", "Current", "0", infoNumberParameter)
    End If


    'rotate rotor
    Call getDocument().getView().selectObject("Rotor", infoSetSelection)
    Call getDocument().beginUndoGroup("Transform Component")
    Call getDocument().rotateComponent(Array("Rotor"), 0, 0, 0, 0, 0, 1, -1, 1)
    Call getDocument().endUndoGroup()
    Set Doc= getDocument()
    If (Doc.isValidForStatic3dSolver()) Then
        If (Doc.solveStatic3d()) Then
            Call RefreshSolutionMeshesInViews(Doc)
            Call RefreshFieldsInViews(Doc, "Contour", infoScalarField)
            Call RefreshFieldsInViews(Doc, "Shaded", infoScalarField)
            Call RefreshFieldsInViews(Doc, "Arrow", infoVectorField)
        End If
    End If
    Set Doc= Nothing

    Call getDocument().save("C:\Users\tdorma\Desktop\Script\StepperScript\Output\STEPPER_degree" & i & ".mn")
Next







' *******************************************************************
' Start of code used to start a static solve.
' The subroutines and functions defined below help do the work.
' *******************************************************************
'
' Refreshes the meshes in the views if the view is
' displaying solution meshes. This will really only
' add missing meshes or update for a new solution.
'
Sub RefreshSolutionMeshesInViews(Doc)
   Set Sol= Doc.getSolution()
   Views= Doc.getViews()
   For Each View In Views
      If (View.getOverlayIndex("Mesh") <> -1) Then
         OldMeshes= View.getMeshes()
         For Each OldMesh In OldMeshes
            NewMesh= Null
            On Error Resume Next
            If (Sol.getCoordinateFrame() = info3D) Then
               If (OldMesh.is3DMesh()) Then Set NewMesh= Sol.getMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
               If (OldMesh.is2DMesh() Or OldMesh.isShellSurfaceMesh()) Then Set NewMesh= Sol.getShellMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
               If (OldMesh.isSliceMesh()) Then Set NewMesh= Sol.getSliceMesh(OldMesh.getSolutionId(), OldMesh.getSlice(), OldMesh.getZoneDefinition())
            Else
               If (OldMesh.isShellContourMesh()) Then
                  Set NewMesh= Sol.getShellMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
               Else
                  Set NewMesh= Sol.getMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
               End If
            End If
            If (Err.Number = 0 And Not IsNull(NewMesh)) Then Call View.addMesh(NewMesh)
            Call Err.Clear()
            On Error Goto 0
            If (Not IsNull(NewMesh)) Then Call View.removeMesh(OldMesh)
            Set NewMesh= Nothing
         Next
         Set OldMesh= Nothing
         Erase OldMeshes
      End If
   Next
   Set View= Nothing
   Set Sol= Nothing
   Erase Views
End Sub
'
' Refreshes the fields in the views if the view is
' displaying the plot type. This will really only
' add missing fields or update for a new solution.
'
Sub RefreshFieldsInViews(Doc, PlotType, FieldType)
   Set Sol= Doc.getSolution()
   Views= Doc.getViews()
   For Each View In Views
      If (View.getOverlayIndex(PlotType & " Plot") <> -1) Then
         OldFields= Eval("View.getFields(info" & PlotType & "Plot)")
         For Each OldField in OldFields
            If (OldField.isSystem()) Then
               NewMesh= Null
               NewField= Null
               Set OldMesh= OldField.getMesh()
               On Error Resume Next
               If (Sol.getCoordinateFrame() = info3D) Then
                  If (OldMesh.is3DMesh()) Then Set NewMesh= Sol.getMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
                  If (OldMesh.is2DMesh() Or OldMesh.isShellSurfaceMesh()) Then Set NewMesh= Sol.getShellMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
                  If (OldMesh.isSliceMesh()) Then Set NewMesh= Sol.getSliceMesh(OldMesh.getSolutionId(), OldMesh.getSlice(), OldMesh.getZoneDefinition())
               Else
                  If (OldMesh.isShellContourMesh()) Then
                     Set NewMesh= Sol.getShellMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
                  Else
                     Set NewMesh= Sol.getMesh(OldMesh.getSolutionId(), OldMesh.getZoneDefinition())
                  End If
               End If
               If (Err.Number = 0 And Not IsNull(NewMesh)) Then Set NewField= Sol.getSystemField(NewMesh, OldField.getQuantity())
               If (Err.Number = 0 And Not IsNull(NewField)) Then
                  If (NewField.getType() = FieldType) Then
                     Call Execute("Call View.addField(NewField, info" & PlotType & "Plot)")
                     If (PlotType = "Arrow" And View.getOverlayIndex("Arrow Plot") <> -1) Then
                        If (OldField.getMesh().is2DMesh() And Not NewField.getMesh().is2DMesh()) Then
                           View.getOverlay("Arrow Plot").setStyleType(infoConeArrow)
                        ElseIf (Not OldField.getMesh().is2DMesh() And NewField.getMesh().is2DMesh()) Then
                           View.getOverlay("Arrow Plot").setStyleType(infoFilledTriangleArrow)
                        End If
                     End If
                  End If
               End If
               Call Err.Clear()
               On Error Goto 0
               Call Execute("Call View.removeField(OldField, info" & PlotType & "Plot)")
               Set OldMesh= Nothing
               Set NewMesh= Nothing
               Set NewField= Nothing
            End If
         Next
         Set OldField= Nothing
         Erase OldFields
      End If
   Next
   Set View= Nothing
   Set Sol= Nothing
   Erase Views
End Sub

' *******************************************************************
' End of code used to start a static solve.
' *******************************************************************
