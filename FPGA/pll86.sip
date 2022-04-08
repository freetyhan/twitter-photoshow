set_global_assignment -entity "pll86" -library "lib_pll86" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll86" -library "lib_pll86" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "pll86" -library "lib_pll86" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll86" -name SPD_FILE [file join $::quartus(sip_path) "pll86.spd"]

set_global_assignment -library "lib_pll86" -name MISC_FILE [file join $::quartus(sip_path) "pll86_sim/pll86.vo"]
