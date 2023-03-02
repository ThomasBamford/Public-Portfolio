<#
Name: Create_Ideate_Dependencies.ps1
Author: Thomas Bamford 2023-02-22

This script identifies active projects within a specified directory structure, saves the list to a text file, then begins a follow-up script.
Parameters for "active" projects are: 
	Project does not include an archival tag, like "...0013.rvt", or "Archive" or "detached" in its name.
	Project must be an architectural model, not a site model
	Project must be modified within the last 30 days
#>
$Directory = "P:\Architecture\[0-2]??????\C-Design Coordination\BIM\Central Model\"
$List_Path = "N:\BIM\Audit\Reports\Revit_File_List.txt"
Get-ChildItem -Path $Directory -recurse -Include *.rvt -Exclude *????.rvt, *detached* | ? { $_.FullName -notmatch 'Archive' } | ? { $_.FullName -notmatch 'SITE' } | Where-Object {$_.lastwritetime -gt (get-date).AddDays(-30) -and -not $_PSIsContainer} | Set-Content -Path $List_Path
$pythonPath = "N:\BIM\Audit\Reports\Create_Ideate_CSV.py"
$prefix = $env:LOCALAPPDATA
& "$prefix\Programs\Python\Python311\python.exe" $pythonPath
