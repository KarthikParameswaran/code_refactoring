# Code Refactoring

### Initial Code Explanation
The code generates sorted and audited output files from the input data file. Workspace folder consists of multiple files with project performance details of different date.
The application will select the lastest file using the file name(filename contains the performance date) and generates the sorted & audited output files.

### For running the code
1. ```ruby modifier.rb ```
This will generate the audited and sorted result file using latest record.
    
2. ```ruby multiple_file_modifier.rb```
This will generate the audited and sorted result file using multiple files available for a particular performance review date.
### Assumptions
Since the Combiner class inputs multiple Enumerator and generates combined Enumerator results(also as explained in the spec file), I assume the system also handles multiple files details and each column may have multiple data with reference to the key. So I have written all the methods in such a way that it can be reused for multiple data array also.

### Refactoring Explanation
- Followed and updated codes using Rubocop standards. 
- Optimized code and updated methods in a logical and reusable manner.
- Added ruby-version file and Gemfile.
- Added new classes and methods for handling TEXT files, CSV files, and Hash records.
- String and Float methods where moved to the overrides folder.
- Created input files
    - CSV columns are separated using ' | '.
    - CSV rows are separated using the new line.
    - Input sample data were entered considering the conditions explained in the code.
- Added multiple_file_modifier for handling multiple files and generate output file.
