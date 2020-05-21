local params={}

params.apple =
{
	widget = 
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "",
		pos = GLOBAL.Vector3(0, 200, 0),
		side_align_tip = 160, 
	},
    type = "chest",
}

for y = 5, 0, -1 do
    for x = 0, 14 do
		table.insert(params.apple.widget.slotpos, GLOBAL.Vector3(60*x-60*2+-150, 60*y-60*2+10,0))
	end
end

local containers = GLOBAL.require "containers"

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.apple.widget.slotpos ~= nil and #params.apple.widget.slotpos or 0)

local old_widgetsetup = containers.widgetsetup
function containers.widgetsetup(container, prefab, data)
	local pref = prefab or container.inst.prefab
    if pref == "apple" then 
		local t = params[pref]
		if t ~= nil then 
			for k, v in pairs(t) do 
				container[k] = v 
			end
			container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0) 
		end
	else 
		return old_widgetsetup(container, prefab) 
	end 
end