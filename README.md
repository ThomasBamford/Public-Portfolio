# Public-Portfolio

This repository hosts a collection of samples that I worked on alone or with a team. 
Some represent parts of a finished system that were used professionally, and some are from my own interests in analyzing data.
A full description of contents follows, and further documentation exists within each file.

## BIM [Building Information Modeling] Model Health Dashboard
The BIM Model Health Dashboard was developed in order to understand the impacts of Revit modeling practices on the performance of a working model. At a project scale, this is used to coordinate cleanup efforts among architects on the project. At the firm scale, the BIM team can assess systemic issues to train against or identify opportunities to apply resources.

Included files:

<b>Create_Ideate_Dependencies.ps1</b>  | This script looks through a directory for every file that matches a set of parameters.

<b>Create_Ideate_CSV.py</b>            | This script creates a csv using a list of file paths which can be used as a source file by Ideate Automation.

<b> Find_Duplicated_Families_BI.py</b> | This script runs within a Power BI report to identify elements that were duplicated by Revit.
