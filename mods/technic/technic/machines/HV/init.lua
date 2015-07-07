
technic.register_tier("HV", "High Voltage")

local path = technic.modpath.."/machines/HV"

dofile(path.."/cables.lua")
dofile(path.."/battery_box.lua")
dofile(path.."/solar_array.lua")
dofile(path.."/generator.lua")
dofile(path.."/forcefield.lua")

