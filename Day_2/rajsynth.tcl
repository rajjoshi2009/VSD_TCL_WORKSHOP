#! /bin/env tclsh

#--------------------------------------------------------------#
#----- Checks whether rajsynth usage is correct or not --------#
#--------------------------------------------------------------#
set enable_prelayout_timing 1
set working_dir [exec pwd]

# Fix 1: Use underscore _ instead of hyphen - (Tcl sees - as math)
set vsd_array_length [llength [split [lindex $argv 0] .]]
set input [lindex [split [lindex $argv 0] .] [expr {$vsd_array_length-1}]]

# Fix 2: Changed 'csc' to 'csv'
if {![regexp {^csv} $input] || $argc!=1} {
        puts "Error in usage"
        puts "Usage: ./rajsynth <.csv>"
        puts "where <.csv> file has required inputs"
        exit
} else {
#-------------------------------------------------------------------------------------------------------#
#----- converts .csv to matrix and creates variables (DesignName, OutputDirectory, etc.) ---------------#
#-------------------------------------------------------------------------------------------------------#
        set filename [lindex $argv 0]
        package require csv
        package require struct::matrix
        struct::matrix m
        set f [open $filename]
        csv::read2matrix $f m , auto
        close $f
        
        m link my_arr
        set num_of_rows [m rows]
        set i 0
        
        while {$i < $num_of_rows} {
                # Fix 3: Added $ before num_of_rows and removed space in $my_arr(0,$i)
                puts "\nInfo: Setting $my_arr(0,$i) as '$my_arr(1,$i)'"
                
                if {$i == 0} {
                        # Fix 4: Changed 'sets' to 'set' and fixed string map syntax
                        set [string map {" " ""} $my_arr(0,$i)] $my_arr(1,$i)
                } else {
                        # Fix 5: Changed $1 to $i in the index
                        set [string map {" " ""} $my_arr(0,$i)] [file normalize $my_arr(1,$i)]
                }
                set i [expr {$i+1}]
        }
}

puts "\nInfo: Listing initial variables and their values:"
puts "------------------------------------------------------"
puts "DesignName       = $DesignName"
puts "OutputDirectory  = $OutputDirectory"
puts "NetlistDirectory = $NetlistDirectory"
puts "EarlyLibraryPath = $EarlyLibraryPath"
puts "LateLibraryPath  = $LateLibraryPath"
puts "ConstraintsFile  = $ConstraintsFile"


#--------------------------------------------------------------------------------------------#
#-----Below script checks if directories and files mentioned in the csv fie,exits or not-----#
#--------------------------------------------------------------------------------------------#


if ![file isdirectory $OutputDirectory] {
	puts "\nInfo: Cannot find the directory $OutputDirectory. Creating $OutputDirectory"
	file mkdir $OutputDirectory
} else {
	puts "\nInfo : Output directory found in path $OutputDirectory"
}


if ![file isdirectory $NetlistDirectory] {
	puts "\nInfo: Cannot find the RTL netlist directory $NetlistDirectory. Existing..."
	exit
} else {
	puts "\nInfo : RTL netlist directory found in path $NetlistDirectory"
}

if { ! [file exists $EarlyLibraryPath] } {
	puts "\nError: Connot find the early cell library in path $EarlyLibraryPath. Exiting...."
} else {
	puts "\nInfo: Early cell library found in path $EarlyLibraryPath"
}

if { ! [file exists $LateLibraryPath] } {
	puts "\nError: Connot find the late cell library in path $LateLibraryPath. Exiting...."
} else {
	puts "\nInfo: Late cell library found in path $LateLibraryPath"
}

if { ! [file exists $ConstraintFile] } {
	puts "\nError: Connot find ConstraintFile in path $ConstraintsFile. Exiting...."
} else {
	puts "\nInfo: ConstraintFile found in path $ConstraintFile"
}

return
#-------------------------------------------------------------------------------------------#
#---------------------------------Constraints FILE creations--------------------------------#
#----------------------------------------SDC Format-----------------------------------------#
#-------------------------------------------------------------------------------------------#

puts "\nInfo: Dumping SDC Constraints for $DesignName"
::struct::matrix constaints
set chan [open $ConstrainsFile]
csv::read2matrix $chan constraints , auto
close $chan 
set number_of_rows [constraints rows]
set number_of_columns [constraints columns]

#----check row number for "clocks" and column number for "IO delays and skew section" in constraints.csv----#

set clock_start [lindex [lindex [constraints search all CLOCKS] 0 ] 1]
set clock_start_column [lindex [lindex [constraints search all CLOCKS] 0 ] 0]

#----check row number for "input" section in constraints.csc----##
set input_ports_start [lindex [lindex [constraints search all INPUTS] 0 ] 1]

#----check row number for "outputs" section in constraints.csc----##
set output_ports_start [lindex [lindex [constraints search all OUTPUTS] 0 ] 1]

#---------------------clock constraints-----------------------##
#-------------clock latency constraints-----------------------#

set clock_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_rise_delay] 0 ] 0]

set clock_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_fall_delay] 0 ] 0]

set clock_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_rise_delay] 0 ] 0]

set clock_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_fall_delay] 0 ] 0]




