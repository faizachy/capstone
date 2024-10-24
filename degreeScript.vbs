' This material contains trade secrets or otherwise confidential information
' owned by Siemens Industry Software Inc. or its affiliates (collectively,
' “Siemens”), or its licensors. Access to and use of this information is
' strictly limited as set forth in the Customer’s applicable agreements with
' Siemens.
'
' Unpublished work. © 2023 Siemens
'
' Simcenter MAGNET 64-bit Version 2212.0003.0.305 (2022/12/1 0:0 R2023-B)
' Computer: 156EMACHINE02, User: cpinea
' Time: 2024-06-21 11:23:14 AM
' Modifier: clark Pineau clark.pineau@mail.mcgill.ca
' Software design to solve a bldc motor rotation for all of it's degrees
' any information needed, email me


Call SetLocale("en-us")

' Number of iterations
Dim i
Dim iterations
iterations = 360

'the loop
For i = 1 To iterations

   Call getDocument().getView().selectObject("Rotor (Surface mounted with parallel magnets),Rotor Core", infoSetSelection)
   Call getDocument().getView().selectObject(Array("Rotor (Surface mounted with parallel magnets),Rotor Core", "Rotor (Surface mounted with parallel magnets),Magnet 1 1A", "Rotor (Surface mounted with parallel magnets),Magnet 1 1B", "Rotor (Surface mounted with parallel magnets),Magnet 1 2A", "Rotor (Surface mounted with parallel magnets),Magnet 1 2B", "Rotor (Surface mounted with parallel magnets),Magnet 1 3A", "Rotor (Surface mounted with parallel magnets),Magnet 1 3B", "Rotor (Surface mounted with parallel magnets),Magnet 1 4A", "Rotor (Surface mounted with parallel magnets),Magnet 1 4B"), infoSetSelection)

   Call getDocument().beginUndoGroup("Transform Component")
   Call getDocument().rotateComponent(Array("Rotor (Surface mounted with parallel magnets),Rotor Core", "Rotor (Surface mounted with parallel magnets),Magnet 1 1A", "Rotor (Surface mounted with parallel magnets),Magnet 1 1B", "Rotor (Surface mounted with parallel magnets),Magnet 1 2A", "Rotor (Surface mounted with parallel magnets),Magnet 1 2B", "Rotor (Surface mounted with parallel magnets),Magnet 1 3A", "Rotor (Surface mounted with parallel magnets),Magnet 1 3B", "Rotor (Surface mounted with parallel magnets),Magnet 1 4A", "Rotor (Surface mounted with parallel magnets),Magnet 1 4B"), 0, 0, 0, 0, 0, 1, -1, 1)
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

   Call getDocument().save("C:\Users\tdorma\Desktop\Script\BLDCscript\output\BLDC_degree" & i & ".mn") ' CAREFULLLL here

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

