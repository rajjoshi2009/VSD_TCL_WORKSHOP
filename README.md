
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

<img width="1920" height="1102" alt="day2_constraints_2_matrix" src="https://github.com/user-attachments/assets/e4c10d54-efb4-4c42-8c11-2dab76cd4716" />

<img width="1920" height="1102" alt="cannotfind_file_createnewone" src="https://github.com/user-attachments/assets/e4c065ab-4b7c-4568-904d-8880ac20c7f6" />

<img width="1920" height="1103" alt="day_2_columns rows" src="https://github.com/user-attachments/assets/0c2ccae8-48f1-4a0c-93a3-d91f76e539a3" />

<img width="1920" height="1103" alt="clk_cln_row_allday2" src="https://github.com/user-attachments/assets/ba17cd62-de37-4b82-9565-182b55675df2" />


## DAY 3: Automated Synopsys Design Constraints (SDC) Mapping

### Objective
The goal of Day 3 is to parse timing constraints directly from the secondary CSV matrix (`openMSP430_design_constraints.csv`), compute clock frequencies, distinguish between single-bit ports and multi-bit buses, and write out a fully compatible standard `.sdc` file.

### 1. Robust Inclusive Bounding Box Searching (`rect`)
The script initially utilised precise coordinate geometry boundaries (`constraints search rect`) to isolate the `CLOCKS`, `INPUTS`, and `OUTPUTS` sections of the matrix. To handle empty lines seamlessly and protect the script from row-shifting crashes across different Tcl interpreter versions, the boundary searches were optimised to explicitly target named headers:
* `early_rise_delay`
* `early_fall_delay`
* `late_rise_delay`



### 2. Clock Waveform & Latency Calculations
Once the exact matrix indexes are located, the script extracts the target constraints to generate precise Synopsys-compatible tool parameters:
* **Clock Generation:** Converts spreadsheet frequencies directly to periods ($T = \frac{1}{f}$).
* **Duty Cycle Mapping:** Translates high/low operational windows into percentage arrays.
* **Latency Definitions:** Automatically compiles `set_clock_latency` properties for setup and hold verification.

<img width="1920" height="1103" alt="clk_cln_row_allday2" src="https://github.com/user-attachments/assets/b7c3c592-22eb-4b6b-a710-62c444b6ad06" />


### 📈 Day 3 Generated SDC Constraints File

When executed, the script successfully extracts the matrix dimensions and dumps the finalised constraint syntax:

<img width="1920" height="1117" alt="full_output_sdc_created_day3" src="https://github.com/user-attachments/assets/b05f1d3c-3211-47b6-8c5b-1e66d796d31c" />

<img width="1920" height="1117" alt="sdc_created_day3" src="https://github.com/user-attachments/assets/07e47515-0c6d-47b7-9eeb-8d42066d80e3" />

## DAY 4: Synthesis Gate-Level Mappings & Hierarchy Verification Engine

### Objective
The core focus of Day 4 is finalizing structural boundary parameters within the custom Synopsys Design Constraints (`.sdc`) matrix, checking modular behavioral descriptions for system hierarchy compliance, and driving the **Yosys Synthesis Engine** to compile hardware definitions.

---

### 1. Programmatic Hierarchy Verification Loop
Before invoking optimisation gate mappings, `rajsynth` dynamically writes out an isolated hierarchy script (`openMSP430.hier.ys`) and executes a backend validation pass. By scanning and tracking multi-module designs across the project netlist directory, the framework ensures no blocks are orphaned or misreferenced before logic optimization begins.

```text
Checking hierarchy.....
err flag is 0

Info: Hierarchy check PASS
```
<img width="1920" height="1103" alt="day4_heirarchy_check_pass" src="https://github.com/user-attachments/assets/f712c4f1-947b-431d-9071-b1ad94c16015" />

### 2. Automated Synthesis Script Formulation (`.ys`)

Once the structural hierarchy is cleared, `rajsynth` moves into the main synthesis phase. To make the process completely hands-free, the framework dynamically writes a custom execution script named `memory.ys`. This script programmatically loads the technology cell library, reads your validated Verilog design files, selects the top-level module, and executes the structural optimisation loops.

_Automated Yosys Target Script Generation View:_
<img width="1920" height="1117" alt="memoryys_file" src="https://github.com/user-attachments/assets/babd2297-1076-4f46-b39d-2c4953469953" />


### 3. Logic Pass Optimisations & Verification
During execution, the synthesis engine passes the design through multiple optimization cycles. It executes constant folding, removes dead branches, and deletes unused wires (`clean -purge`). This guarantees that the final netlist is fully optimized for speed and area before technology mapping.

Yosys Optimisation Passes and Verilog Backend Logs:

<img width="1920" height="1117" alt="output-memoryys_day4" src="https://github.com/user-attachments/assets/e5a77957-a399-42a4-b163-557a22af90a4" />



### 4. Structural Technology Gate Realisation
After logic optimisation, the high-level behavioural paths are mapped into real physical primitives using the standard cells from `osu018_stdcells.lib`. High-level behavioural variables are completely transformed into a structural netlist file (`memory_synth.v`) containing explicit cell mappings.

Synthesised Mapped Technology Netlist Primitives:

<img width="1920" height="1117" alt="cat_memory_synth_day4" src="https://github.com/user-attachments/assets/f4147df1-cd5a-472c-b657-bcd5da774178" />


By using the Graphviz dot engine, the framework lets you visually inspect the finalised technology cell interconnections, showing exactly how individual logic gates and positive-edge D-Flip-Flops (`DFFPOSX1`) are connected.

Finalised Gate-Level Schematic (via xdot Viewer Engine):
<img width="1920" height="1117" alt="memorysdiagramd_day4" src="https://github.com/user-attachments/assets/a837a64d-0c0b-4308-8922-50b0afe4f2ea" />



## DAY 5: Automated Static Timing Analysis (STA) & Closed-Loop QoR Generation

### Objective
The final stage of the `rajsynth` framework automates the generation of structural tool execution configurations (`.conf`), validates architectural hierarchies, generates production-ready synthesis netlists for Place and Route (PnR), and drives the **OpenTimer Engine** to extract performance margins.


### 1. Pre-Flight Proactive Error Handling (Hierarchy Validation)
To showcase the robustness of the framework's verification loops, the automated script was tested against a broken structural dependency module path (`omsp_clock_module_vsd`). The Tcl interpreter successfully caught the fault, logged an explicit error, flagged a `FAIL` status, and halted the pipeline before wasting compute resources on a corrupt compilation:

```text
Checking hierarchy.....
err flag is 1
Error: module 'omsp_clock_module_vsd' is not part of the design openMSP430.
Info: Hierarchy check FAIL
```
<img width="1920" height="1103" alt="synthesis_failed_day5" src="https://github.com/user-attachments/assets/0e7baad8-447d-48f6-8dc2-fabdada0d797" />
---

### 2. Successful Synthesis Execution Pass
After correcting the RTL module instances, the validation loop re-evaluated the system paths to print an unblocked `PASS` notification. The pipeline automatically generated the complete backend Yosys script and compiled the behavioural Verilog files into an optimised gate-level netlist structure:

_Corrected Logic Tree Clearing the Verification Loop and Finalising Synthesis:_

<img width="1920" height="1103" alt="day_5_success_synthesis_for_pnr" src="https://github.com/user-attachments/assets/4e6bab22-11f5-4be6-a3f9-cffa4c31d0e4" />

_Production-Ready Structural Netlist Output (`openMSP430.final.synth.v`):_
<img width="1920" height="1103" alt="synth_v_day5" src="https://github.com/user-attachments/assets/6b90d8be-74eb-4ce8-ad5d-1853c6f8bf1b" />

---

### 3. OpenTimer Configuration Logic (`.conf`)
To transition the design from structural logic mapping to performance verification, the framework automatically generates a dedicated OpenTimer configuration control file (`openMSP430.conf`). This control step links the multi-threaded calculation properties (`-localCpu 4`) with the early and late standard cell technology libraries (`osu018_stdcells.lib`) to prepare the timing graph grid.

_Auto-Generated OpenTimer Multi-Thread Configuration File inside Vim:_
<img width="1920" height="1103" alt="conf_file_day5" src="https://github.com/user-attachments/assets/ce758b33-5f1d-416f-9b0d-80d9117a2067" />

### 4. Final Timing Performance Quality of Results (QoR)
The framework calls the OpenTimer engine via system execution channels, traces data propagation paths across cell delays, evaluates parasitic conditions, and dumps a comprehensive performance summary reporting slack metrics across setup, hold, and output constraints:

_Final Closed-Loop Pipeline Execution and Prelayout Timing Results Table:_

<img width="1920" height="1103" alt="full_output_day5" src="https://github.com/user-attachments/assets/c6db4d9c-fbbb-4480-9475-c69c1563b0fa" />


### 📊 Final Timing Performance Report Matrix
| Core Performance Parameter | Framework Analytics Status |
| :--- | :--- |
| **Design Target Name** | openMSP430 Core Engine |
| **Total Standard Cell Count** | 7,477 Instances |
| **Timing Computation Speed** | 2 Seconds |
| **Worst Negative Setup Slack (WNS)** | -10.771179 ns (1 Violation) |
| **Worst Negative Hold Slack (WNS)** | 0.00 ns (PASSED — 0 Violations) |
| **Worst Output Pin Slack (RAT)** | -0.179107 ns |
| **Total Output Pin Violations** | 9,999 (Default Boundary Limit) |

---

###Certificate
[View my VSD TCL Workshop Certificate](Raj%20Joshi-certificate.pdf)

## 👨‍💻 Developer Profile

* **Project Automator:** Joshi Raj Maheshkumar
* **Academic Institution:** Birla Vishvakarma Mahavidyalaya (BVM Engineering College)
* **Specialisation Track:** B.Tech Honours in VLSI Design and Testing
* **Technical Focus Areas:** RTL Coding (Verilog), EDA Flow Automation (Tcl/Scripting), Synthesis & Static Timing Analysis (STA)
* **Professional Contact:** rajjoshi1220@gmail.com
* **GitHub Project Repository:** [VSD_TCL_WORKSHOP](https://github.com/rajjoshi2009/VSD_TCL_WORKSHOP)




