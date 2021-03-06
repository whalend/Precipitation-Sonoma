# ---------------------------------------------------------------------------
# AddPlotID.py
# Created on: Thu Mar 03 2011 11:58:38 AM
#   (generated by ArcGIS/ModelBuilder)
# ---------------------------------------------------------------------------

# Import system modules
import sys, string, os, arcgisscripting

# Create the Geoprocessor object
gp = arcgisscripting.create(9.3)

# Load required toolboxes...
gp.AddToolbox("C:\Program Files\ArcGIS\Desktop10.0\ArcToolbox\Toolboxes\Data Management Tools.tbx")

# Enter Path to your folder here ##############

workspace = r"V:\Projects\SOD\Sonoma\Microclimate\Processing.Microclimate\2009_RawInput.gdb"

###############################################

gp.workspace = workspace
Tables = gp.ListTables()

for Table in Tables:

    inTable = workspace + "\\" + Table
    Table1 = Table.split("_")
    Table2 = Table1[0]
    print inTable

    # Process: Add Field...
    gp.AddField_management(inTable, "PlotID", "TEXT", "", "", "", "", "NULLABLE", "NON_REQUIRED", "")

    # Process: Calculate Field...
    
    inExpression = '"' + Table2 + '"'

    print inExpression
    gp.CalculateField_management(inTable, "PlotID", inExpression, "VB", "")

