' This material contains trade secrets or otherwise confidential information
' owned by Siemens Industry Software Inc. or its affiliates (collectively,
' “Siemens”), or its licensors. Access to and use of this information is
' strictly limited as set forth in the Customer’s applicable agreements with
' Siemens.
'
' Unpublished work. © 2023 Siemens
'
' Simcenter MAGNET 64-bit Version 2212.0003.0.305 (2022/12/1 0:0 R2023-B)
' Computer: 156EMACHINE02, User: tdorma
' Time: 2024-11-15 4:51:06 PM

Call SetLocale("en-us")

Call getDocument().getView().selectObject("Rotor", infoSetSelection)
Call getDocument().beginUndoGroup("Transform Component")
Call getDocument().rotateComponent(Array("Rotor"), 0, 0, 0, 0, 0, 1, -1, 1)
Call getDocument().endUndoGroup()
