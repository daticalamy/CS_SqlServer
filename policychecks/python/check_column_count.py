###
### This script warns when adding column(s) that the table has more than X columns.
###
### This script throws the following warning:
### Table column count > X
###
### Sample Script:
###
###  ALTER TABLE <schema_name>.<table_name> 
###  ADD <column1_name> <column1_type>, <column2_name> <column2_type>  ....;
###
### Query to find number of columns from MSSQL db:
### 
### SELECT COUNT(*)
### FROM INFORMATION_SCHEMA.COLUMNS
### WHERE table_schema = '<schema_name>'
### AND table_name = '<table_name>'

###
### Helpers come from Liquibase
###
import liquibase_utilities
import re
import sys


###
### Split Column Definitions
###
def split_column_definitions(add_clause: str):
    parts = []
    depth = 0
    start = 0

    for i, char in enumerate(add_clause):
        if char == '(':
            depth += 1
        elif char == ')':
            depth -= 1
        elif char == ',' and depth == 0:
            parts.append(add_clause[start:i].strip())
            start = i + 1

    parts.append(add_clause[start:].strip())  # Add the last column definition
    return parts

###
### main
###

###
### Retrieve log handler
### Ex. liquibase_logger.info(message)
###
liquibase_logger = liquibase_utilities.get_logger()

###
### Retrieve status handler
###
liquibase_status = liquibase_utilities.get_status()

###
### Define regex patterns for a Tablespace's DatabaseName and BufferPool
###
regex_pattern_alter_table = r'(?i)ALTER\s+TABLE\s+(?:\[.*?\]|".*?"|[a-zA-Z_][\w]*)\s*\.\s*(?:\[.*?\]|".*?"|[a-zA-Z_][\w]*)\s+ADD\s+(.*)'

###
### Retrieve all changes in changeset
###
changes = liquibase_utilities.get_changeset().getChanges()

###
### Loop through all changes
###
for change in changes:
    ###
    ### LoadData change types are not currently supported
    ###
    if "loaddatachange" in change.getClass().getSimpleName().lower():
        continue
    ###
    ### Split sql into a list of strings to remove whitespace
    ###
    raw_sql = liquibase_utilities.generate_sql(change)
    
    ###
    ### Look for alter table regex in SQL
    ###
    column_list = re.findall(regex_pattern_alter_table, raw_sql)
   
###
### Default return code
###
False