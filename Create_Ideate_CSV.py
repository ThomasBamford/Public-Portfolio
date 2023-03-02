#
# Name: Create_Ideate_CSV.py 
# Authors: Thomas Bamford & Pete Heibel (get_rvt_file_version) 2023-02-13
#
# Using a list of paths from a text file, this script generates a .csv which is referenced by a data extraction automation software for Revit.
# The included function identifies the Revit version that each file was saved from, and the main for loop formats the columns.
#

import os
import re
import csv

# Revit files are 'Mircosoft OLE2 files', aka 'Structured Storage' files
# this package contains modules to parse OLE2 files
import olefile

# The name of the text file containing the list of Revit file paths
revit_file_list = 'N:\BIM\Audit\Reports\Revit_File_List.txt'

# Get the format information via the olefile filestream of BasicFileInfo (PH)
def get_rvt_file_version(rvt_file):
    if os.path.exists(rvt_file):
        if olefile.isOleFile(rvt_file):
            rvt_ole = olefile.OleFileIO(rvt_file)
            bfiLe = rvt_ole.openstream("BasicFileInfo")
            file_infoLe = bfiLe.read().decode("utf-16le", "replace")
            bfiBe = rvt_ole.openstream("BasicFileInfo")
            file_infoBe = bfiBe.read().decode("utf-16be", "replace")
            file_info = file_infoBe if "਀" in file_infoLe else file_infoLe
            if "Format" in file_info:
                rvt_file_version = re.search(r"Format.+?(\d{4})", file_info).group(1)
            else:
                rvt_file_version = re.search(r"(\d{4}).+Build", file_info).group(1)
            return rvt_file_version

# Read the file paths from the text file
with open(revit_file_list, 'r') as f:
    file_list = f.read().splitlines()

# Create a list to store the output data
output_data = []

# Loop through each file in the list
for file in file_list:
    # Get the absolute file path
    file_path = os.path.abspath(file)

    # Get the display name by removing '.rvt' from the file name
    display_name = os.path.basename(file).split('.')[0]

    # Get the file name
    file_name = os.path.basename(file)

    # Get the version using the defined function above
    revit_version = get_rvt_file_version(file)

    # Add the data to the output list
    output_data.append([file_path, display_name, revit_version, file_path, file_name])

# Write the output data to a CSV file, Ideate Automation requires this folder/file
localAppData = os.getenv('LOCALAPPDATA')
networkModels = localAppData + r'\Ideate\Ideate Software\CachedFileData\NetworkModels.csv'

with open(networkModels, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Id", "Display Name", "Revit Version", "Unified Path", "File Name"])
    writer.writerows(output_data)
