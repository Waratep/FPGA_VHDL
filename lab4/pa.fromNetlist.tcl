
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name lab4 -dir "C:/Users/WARA/Desktop/2D_2/Advance Digital System Design Laboratory/lab4/planAhead_run_5" -part xc3s400tq144-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/WARA/Desktop/2D_2/Advance Digital System Design Laboratory/lab4/lab4.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/WARA/Desktop/2D_2/Advance Digital System Design Laboratory/lab4} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "lab4.ucf" [current_fileset -constrset]
add_files [list {lab4.ucf}] -fileset [get_property constrset [current_run]]
link_design
