
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Clock -dir "D:/digital lab/Clock/planAhead_run_1" -part xc3s400tq144-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/digital lab/Clock/Clock.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/digital lab/Clock} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "clockpin.ucf" [current_fileset -constrset]
add_files [list {clockpin.ucf}] -fileset [get_property constrset [current_run]]
link_design
