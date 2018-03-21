
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name lab4 -dir "C:/Users/WARA/Desktop/2D_2/Advance Digital System Design Laboratory/lab4/planAhead_run_3" -part xc3s400tq144-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "lab4.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {lab4.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top lab4 $srcset
add_files [list {lab4.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s400tq144-4
