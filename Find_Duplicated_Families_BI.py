#
# Name: Find_Duplicated_Families_BI.py
# Author: Thomas Bamford
#
# This script runs within Power BI.
# Given a list of family names from a Revit project, the script locates every name that ends in a single integer preceded by a non-space integer.
# Afterward, it creates two columns, one which returns the value if the initial filter matches, and a second which returns the original value, with the integer removed.
#

import re
import json


# Use the Family Name column as the list "ft".
# 'dataset' holds the input data for this script.
ft = dataset['Family Name']

# Get the length of the Family Name dataset.
string_len = ft.str.len()

# Return values where they match this regular expression.
# If there are multiple matches, delimit with a semicolon.
def get_duplicates(text):
    duplicates = re.findall(r'.*[^ |^0-9|\-|_][1-9]{1}(?!.)', text)
    duplicates = ';'.join(duplicates)
    return duplicates

# Create the list of values which may be duplicates using the get_duplicates function.
duplicates_list = []
for i in range(len(dataset)):
    # This selects data from the third column.
    text = dataset.iat[i,3]
    duplicate = get_duplicates(text)
    # Append duplicates to the list.
    duplicates_list.append(duplicate)

# get the original name of the duplicate (String without the final integer).
def str_less_one(text):
    string_len = len(text)
    orig_len = string_len - 1
    orig_text = text[:orig_len]
    return orig_text

# Create the list of original names using str_less_one function.
orig_names = []
for duplicate in duplicates_list:
    orig_name = str_less_one(duplicate)
    orig_names.append(orig_name)

# Create the lists of duplicate name and expected original name.
dataset['duplicate'] = duplicates_list
dataset['Original Name'] = orig_names