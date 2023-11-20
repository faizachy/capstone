# trace generated using paraview version 5.11.0
import paraview
import sys

# paraview.compatibility.major = 5
# paraview.compatibility.minor = 11

#### import the simple module from the paraview
from paraview.simple import *

#### disable automatic camera reset on 'Show'

# Variable to determine which field to display

# Check if the required number of arguments is present (including the script name)
if len(sys.argv) < 3:
    print("Usage: pvpython paraviewScript.py fileName fieldType")
    sys.exit(1)

# Assign the arguments to variables
modelPath = sys.argv[1]
field = sys.argv[2]

if field == "B":
    field_vectors = "B field Vectors"
elif field == "E":
    field_vectors = "E field Vectors"
else:
    raise ValueError("field variable must be 'E' or 'B'")

# create a new 'XML PolyData Reader'
model_out2vtp = XMLPolyDataReader(
    registrationName="model_out.vtp",
    FileName=[modelPath],
)
model_out2vtp.CellArrayStatus = ["Mass density Magnitude"]
model_out2vtp.PointArrayStatus = ["B field Vectors", "E field Vectors"]

# Properties modified on model_out2vtp
model_out2vtp.TimeArray = "None"

# get active view
renderView1 = GetActiveViewOrCreate("RenderView")

# show data in view
model_out2vtpDisplay = Show(model_out2vtp, renderView1, "GeometryRepresentation")

# trace defaults for the display properties.
model_out2vtpDisplay.Representation = "Surface"
model_out2vtpDisplay.ColorArrayName = [None, ""]
model_out2vtpDisplay.SelectTCoordArray = "None"
model_out2vtpDisplay.SelectNormalArray = "None"
model_out2vtpDisplay.SelectTangentArray = "None"
model_out2vtpDisplay.OSPRayScaleArray = field_vectors
model_out2vtpDisplay.OSPRayScaleFunction = "PiecewiseFunction"
model_out2vtpDisplay.SelectOrientationVectors = field_vectors
model_out2vtpDisplay.ScaleFactor = 0.010486000031232835
model_out2vtpDisplay.SelectScaleArray = field_vectors
model_out2vtpDisplay.GlyphType = "Arrow"
model_out2vtpDisplay.GlyphTableIndexArray = field_vectors
model_out2vtpDisplay.GaussianRadius = 0.0005243000015616417
model_out2vtpDisplay.SetScaleArray = ["POINTS", field_vectors]
model_out2vtpDisplay.ScaleTransferFunction = "PiecewiseFunction"
model_out2vtpDisplay.OpacityArray = ["POINTS", field_vectors]
model_out2vtpDisplay.OpacityTransferFunction = "PiecewiseFunction"
model_out2vtpDisplay.DataAxesGrid = "GridAxesRepresentation"
model_out2vtpDisplay.PolarAxes = "PolarAxesRepresentation"
model_out2vtpDisplay.SelectInputVectors = ["POINTS", field_vectors]
model_out2vtpDisplay.WriteLog = ""

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
model_out2vtpDisplay.ScaleTransferFunction.Points = [
    -61.650726318359375,
    0.0,
    0.5,
    0.0,
    61.65370559692383,
    1.0,
    0.5,
    0.0,
]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
model_out2vtpDisplay.OpacityTransferFunction.Points = [
    -61.650726318359375,
    0.0,
    0.5,
    0.0,
    61.65370559692383,
    1.0,
    0.5,
    0.0,
]

# reset view to fit data
renderView1.ResetCamera(False)

# get the material library
materialLibrary1 = GetMaterialLibrary()

# update the view to ensure updated data information
renderView1.Update()

# create a new 'Calculator'
calculator1 = Calculator(registrationName="Calculator1", Input=model_out2vtp)
calculator1.Function = ""

# Properties modified on calculator1
calculator1.Function = ""

# show data in view
calculator1Display = Show(calculator1, renderView1, "GeometryRepresentation")

# trace defaults for the display properties.
calculator1Display.Representation = "Surface"
calculator1Display.ColorArrayName = [None, ""]
calculator1Display.SelectTCoordArray = "None"
calculator1Display.SelectNormalArray = "None"
calculator1Display.SelectTangentArray = "None"
calculator1Display.OSPRayScaleArray = field_vectors
calculator1Display.OSPRayScaleFunction = "PiecewiseFunction"
calculator1Display.SelectOrientationVectors = field_vectors
calculator1Display.ScaleFactor = 0.010486000031232835
calculator1Display.SelectScaleArray = field_vectors
calculator1Display.GlyphType = "Arrow"
calculator1Display.GlyphTableIndexArray = field_vectors
calculator1Display.GaussianRadius = 0.0005243000015616417
calculator1Display.SetScaleArray = ["POINTS", field_vectors]
calculator1Display.ScaleTransferFunction = "PiecewiseFunction"
calculator1Display.OpacityArray = ["POINTS", field_vectors]
calculator1Display.OpacityTransferFunction = "PiecewiseFunction"
calculator1Display.DataAxesGrid = "GridAxesRepresentation"
calculator1Display.PolarAxes = "PolarAxesRepresentation"
calculator1Display.SelectInputVectors = ["POINTS", field_vectors]
calculator1Display.WriteLog = ""

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
calculator1Display.ScaleTransferFunction.Points = [
    -61.650726318359375,
    0.0,
    0.5,
    0.0,
    61.65370559692383,
    1.0,
    0.5,
    0.0,
]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
calculator1Display.OpacityTransferFunction.Points = [
    -61.650726318359375,
    0.0,
    0.5,
    0.0,
    61.65370559692383,
    1.0,
    0.5,
    0.0,
]

# hide data in view
Hide(model_out2vtp, renderView1)

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on calculator1
calculator1.ResultArrayName = "normal"

if field == "B":
    # Properties modified on calculator1
    calculator1.Function = '"B field Vectors"/sqrt("B field Vectors_X"^2+"B field Vectors_Y"^2+"B field Vectors_Z"^2)'
elif field == "E":
    # Properties modified on calculator1
    calculator1.Function = '"E field Vectors"/sqrt("E field Vectors_X"^2+"E field Vectors_Y"^2+"E field Vectors_Z"^2)'


# update the view to ensure updated data information
renderView1.Update()

# create a new 'Glyph'
glyph1 = Glyph(registrationName="Glyph1", Input=calculator1, GlyphType="Arrow")
glyph1.OrientationArray = ["POINTS", "normal"]
glyph1.ScaleArray = ["POINTS", field_vectors]
glyph1.ScaleFactor = 0.010486000031232835
glyph1.GlyphTransform = "Transform2"

# show data in view
glyph1Display = Show(glyph1, renderView1, "GeometryRepresentation")

# trace defaults for the display properties.
glyph1Display.Representation = "Surface"
glyph1Display.ColorArrayName = [None, ""]
glyph1Display.SelectTCoordArray = "None"
glyph1Display.SelectNormalArray = "None"
glyph1Display.SelectTangentArray = "None"
glyph1Display.OSPRayScaleArray = field_vectors
glyph1Display.OSPRayScaleFunction = "PiecewiseFunction"
glyph1Display.SelectOrientationVectors = "normal_B"
glyph1Display.ScaleFactor = 0.12225894331932069
glyph1Display.SelectScaleArray = field_vectors
glyph1Display.GlyphType = "Arrow"
glyph1Display.GlyphTableIndexArray = field_vectors
glyph1Display.GaussianRadius = 0.006112947165966034
glyph1Display.SetScaleArray = ["POINTS", field_vectors]
glyph1Display.ScaleTransferFunction = "PiecewiseFunction"
glyph1Display.OpacityArray = ["POINTS", field_vectors]
glyph1Display.OpacityTransferFunction = "PiecewiseFunction"
glyph1Display.DataAxesGrid = "GridAxesRepresentation"
glyph1Display.PolarAxes = "PolarAxesRepresentation"
glyph1Display.SelectInputVectors = ["POINTS", "normal"]
glyph1Display.WriteLog = ""

# init the 'PiecewiseFunction' selected for 'ScaleTransferFunction'
glyph1Display.ScaleTransferFunction.Points = [
    -61.650726318359375,
    0.0,
    0.5,
    0.0,
    56.56791305541992,
    1.0,
    0.5,
    0.0,
]

# init the 'PiecewiseFunction' selected for 'OpacityTransferFunction'
glyph1Display.OpacityTransferFunction.Points = [
    -61.650726318359375,
    0.0,
    0.5,
    0.0,
    56.56791305541992,
    1.0,
    0.5,
    0.0,
]

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph1
glyph1.ScaleArray = ["POINTS", "normal"]

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph1
glyph1.ScaleFactor = 0.005243000015616417

# update the view to ensure updated data information
renderView1.Update()

# set scalar coloring
ColorBy(glyph1Display, ("POINTS", field_vectors, "Magnitude"))

# rescale color and/or opacity maps used to include current data range
glyph1Display.RescaleTransferFunctionToDataRange(True, False)

# show color bar/color legend
glyph1Display.SetScalarBarVisibility(renderView1, True)

# get 2D transfer function for 'BfieldVectors'
bfieldVectorsTF2D = GetTransferFunction2D("BfieldVectors")

# get color transfer function/color map for 'BfieldVectors'
bfieldVectorsLUT = GetColorTransferFunction("BfieldVectors")
bfieldVectorsLUT.TransferFunction2D = bfieldVectorsTF2D
bfieldVectorsLUT.RGBPoints = [
    0.0005679527295045824,
    0.231373,
    0.298039,
    0.752941,
    35.535166598578776,
    0.865003,
    0.865003,
    0.865003,
    71.06976524442805,
    0.705882,
    0.0156863,
    0.14902,
]
bfieldVectorsLUT.ScalarRangeInitialized = 1.0

# get opacity transfer function/opacity map for 'BfieldVectors'
bfieldVectorsPWF = GetOpacityTransferFunction("BfieldVectors")
bfieldVectorsPWF.Points = [
    0.0005679527295045824,
    0.0,
    0.5,
    0.0,
    71.06976524442805,
    1.0,
    0.5,
    0.0,
]
bfieldVectorsPWF.ScalarRangeInitialized = 1

# hide data in view
Hide(calculator1, renderView1)

# set active source
SetActiveSource(model_out2vtp)

# show data in view
model_out2vtpDisplay = Show(model_out2vtp, renderView1, "GeometryRepresentation")

# update the view to ensure updated data information
renderView1.Update()

# set scalar coloring
ColorBy(model_out2vtpDisplay, ("CELLS", "Mass density Magnitude"))

# rescale color and/or opacity maps used to include current data range
model_out2vtpDisplay.RescaleTransferFunctionToDataRange(True, False)

# show color bar/color legend
model_out2vtpDisplay.SetScalarBarVisibility(renderView1, True)

# get 2D transfer function for 'MassdensityMagnitude'
massdensityMagnitudeTF2D = GetTransferFunction2D("MassdensityMagnitude")

# get color transfer function/color map for 'MassdensityMagnitude'
massdensityMagnitudeLUT = GetColorTransferFunction("MassdensityMagnitude")
massdensityMagnitudeLUT.TransferFunction2D = massdensityMagnitudeTF2D
massdensityMagnitudeLUT.RGBPoints = [
    19600.0,
    0.231373,
    0.298039,
    0.752941,
    27680.0,
    0.865003,
    0.865003,
    0.865003,
    35760.0,
    0.705882,
    0.0156863,
    0.14902,
]
massdensityMagnitudeLUT.ScalarRangeInitialized = 1.0

# get opacity transfer function/opacity map for 'MassdensityMagnitude'
massdensityMagnitudePWF = GetOpacityTransferFunction("MassdensityMagnitude")
massdensityMagnitudePWF.Points = [19600.0, 0.0, 0.5, 0.0, 35760.0, 1.0, 0.5, 0.0]
massdensityMagnitudePWF.ScalarRangeInitialized = 1

# set active source
SetActiveSource(glyph1)

# ================================================================
# addendum: following script captures some of the application
# state to faithfully reproduce the visualization during playback
# ================================================================

# get layout
layout1 = GetLayout()

# --------------------------------
# saving layout sizes for layouts

# layout/tab size in pixels
layout1.SetSize(1800, 1134)

# -----------------------------------
# saving camera placements for views

# current camera placement for renderView1
renderView1.CameraPosition = [
    -0.023961155911634377,
    -0.0006015590877343993,
    -0.18766203396447664,
]
renderView1.CameraFocalPoint = [0.0, 0.0, 0.037450000643730164]
renderView1.CameraViewUp = [
    -0.8208929610135638,
    -0.564122637477454,
    0.08888417431615632,
]
renderView1.CameraParallelScale = 0.1895805530295287

# Render the scene
renderView1.ViewSize = [1920, 1080]  # Set the resolution of the output window
renderView1.ResetCamera()  # Reset the camera to view all data
Render()  # Render the scene

# --------------------------------------------
# Set the output file path
output_file_path = "output/image.png"  # You can change this to your desired output path and file name

# Save screenshot
SaveScreenshot(
    output_file_path,
    renderView1,
    ImageResolution=[1920, 1080],
    OverrideColorPalette="",
    StereoMode="No change",
    TransparentBackground=False,
    CompressionLevel="5",
)  # Compression level is optional and for formats that support it like png
# uncomment the following to render all views
RenderAllViews()
# alternatively, if you want to write images, you can use SaveScreenshot(...).
