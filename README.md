
# VSD_TCL_PROGRAMMING_WORKSHOP


## DAY 1: Creating a TCL command and passing a .csv file from the UNIX shell to the TCL script

### Objective
The goal of this day is to **understand how a TCL-based automation flow can process design data from an Excel/CSV input**, synthesise it using **Yosys**, and perform **timing analysis with OpenTimer**, all wrapped inside the execution wrapper flow.

### Scenario 1: User does not provide the .csv file
When executing the wrapper binary without required design configurations, the argument interpreter must safely catch the usage fault and display manual interface parameters.

<img width="1920" height="1103" alt="scenerio1" src="https://github.com/user-attachments/assets/10bd5e1b-e57b-4939-91f7-cac5d6265711" />



### Scenario 2: User provides the name of .csv file but it does not exist
If a file name is provided but the physical file is missing from the working directory, the script must flag the missing file path rather than crashing midway.

<img width="1920" height="1103" alt="scenerio2" src="https://github.com/user-attachments/assets/d20cc672-7723-4b72-abe1-76fa813a7526" />


### Scenario 3: User requests for help regarding the excel sheet content and execution using --help / -help
When the user passes the help argument, processing stops to display an interactive explanation of data fields, thread configs, and syntax usage matrices.

<img width="1920" height="1103" alt="sceneio3" src="https://github.com/user-attachments/assets/4e74d58e-b42c-4d60-847c-bcbbfd2764f6" />


### Creating CSV File
The design structural and processing characteristics are tracked within standard comma-separated matrix templates containing pointers to directory paths, constraint parameters, and cell libraries.

<img width="1920" height="1102" alt="filedetails" src="https://github.com/user-attachments/assets/efee7237-a229-4d71-8513-ac3fa9c50008" />

### Source the UNIX shell to tcl script by passing the csv file
Execution format to safely run the main processing shell wrapper:
```bash
./rajsynth openMSP430_design_details.csv
```

## DAY 2: Automated Design Setup and Synthesis Flow Initialisation

### Objective
The focus of Day 2 is preparing and validating the physical design environment. `rajsynth` programmatically parses the main configuration CSV to extract workspace variables, verifies file paths for libraries and RTL sources, and dynamically initializes an isolated output directory structure.

### 1. Variable Extraction & Matrix Mapping
The script utilises the Tcl `csv` and `struct::matrix` packages to read the design details spreadsheet. Rows are parsed sequentially to convert hardware descriptions (Design Name, Output Directory, Netlist Directory, and Library Paths) into active Tcl global variables.

<img width="1920" height="1103" alt="variableautocreation1st_DAY2" src="https://github.com/user-attachments/assets/b36ba7a7-5ac6-4b7c-884b-473d31dd9893" />


### 2. Pre-Flight Path and File Validation
To prevent runtime crashes during heavy synthesis, `rajsynth` performs proactive validation checks on the Unix file system:
* **Directory Verification:** Ensures the RTL netlist folder exists and is readable.
* **Library Verification:** Confirms that the target technology file (`osu018_stdcells.lib`) is present in the specified directory path.
* **Constraints Verification:** Validates that the secondary SDC input spreadsheet exists before parsing begins.


### 3. Dynamic Output Workspace Creation
If the target output directory (e.g., `outdir_openMSP430`) does not exist, the script automatically executes system-level directory creation commands to set up a clean, isolated workspace for synthesis logs and report generation.

---

### 📈 Day 2 Tool Execution & Initialization Logs

When execution runs successfully, the console outputs a complete summary listing the validated paths and confirming environment readiness:

<img src="day2_success_banner.png" width="800">

*(Note: Upload your terminal screenshot showing your customized RAJSYNTH ASCII art banner and the "Listing initial variables and their values" log, then name it `day2_success_banner.png` to load it here!)*
