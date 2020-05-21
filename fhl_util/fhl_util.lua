local ThePlayer = GLOBAL.ThePlayer
local TheInput = GLOBAL.TheInput
local TheNet = GLOBAL.TheNet

local KEY_T = GLOBAL.KEY_T
AddModRPCHandler(modname, "T", function(player)
	if not player:HasTag("playerghost") and player.prefab == "fhl" then
		if player.level > 30 then player.level = 30 end
		if player.jnd == 0 and player.je then
			if player.level < 30 then
				player.components.talker:Say("Current State : Lv ".. (player.level).. "\n当前状态:\n寒冷抗性(The cold resistance):".. (player.components.temperature.inherentinsulation).. "/240".. "\n伤害减免(Damage reduction):".. (player.components.health.absorb*100).. "%".. "\n伤害提升(Damage ascension):".. ((player.components.combat.damagemultiplier-1)*100).. "%".. "\n饥饿抗性(Hunger resistance):".. (player.je*5).. "%")
			else
				player.components.talker:Say("Current State : Lv 30".. "\n当前状态:\n寒冷抗性(The cold resistance):".. (player.components.temperature.inherentinsulation).. "/240".. "\n伤害减免(Damage reduction):".. (player.components.health.absorb*100).. "%".. "\n伤害提升(Damage ascension):".. ((player.components.combat.damagemultiplier-1)*100).. "%".. "\n饥饿抗性(Hunger resistance):".. (player.je*5).. "%")
			end
		else
			player.components.talker:Say("请点完技能点再来查看!\nPlease point out skill points to see again!")
		end
	end
end)

local KEY_UP = GLOBAL.KEY_UP
AddModRPCHandler(modname, "UP", function(player)
	if not player:HasTag("playerghost") and player.prefab == "fhl" then
		if player.jnd > 0 then
			if player.components.temperature.inherentinsulation < 230 then
				player.jnd = player.jnd - 1
				player.components.temperature.inherentinsulation = player.components.temperature.inherentinsulation + 30
				player.components.talker:Say("寒冷抗性已上升!\nThe cold resistance has go up!")
			else
				player.components.talker:Say("寒冷抗性已至上限!\nThe cold resistance has to limit!")
			end
		else
			player.components.talker:Say("技能点不足!\nhave no skill points!")
		end
	end
end)

local KEY_DOWN = GLOBAL.KEY_DOWN
AddModRPCHandler(modname, "DOWN", function(player)
	if not player:HasTag("playerghost") and player.prefab == "fhl" then
		if player.jnd > 0 then
			player.jnd = player.jnd - 1
			player.components.health.absorb = player.components.health.absorb + 0.03
			player.components.talker:Say("伤害减免已提升3%!\nDamage reduction has up 3%!")
		else
			player.components.talker:Say("技能点不足!\nhave no skill points!")
		end
	end
end)

local KEY_LEFT = GLOBAL.KEY_LEFT
AddModRPCHandler(modname, "LEFT", function(player)
	if not player:HasTag("playerghost") and player.prefab == "fhl" then
		if player.jnd > 0 then
			player.jnd = player.jnd - 1
			player.components.combat.damagemultiplier = player.components.combat.damagemultiplier + 0.05
			player.components.talker:Say("输出伤害已提升5%!\nDamage ascension has up 5%!")
		else
			player.components.talker:Say("技能点不足!\nhave no skill points!")
		end
	end
end)

local KEY_RIGHT = GLOBAL.KEY_RIGHT
AddModRPCHandler(modname, "RIGHT", function(player)
	if not player:HasTag("playerghost") and player.prefab == "fhl" then
		if player.jnd > 0 and player.je then
			if player.components.hunger.hungerrate > 0.1 then
				player.jnd = player.jnd - 1
				player.je = player.je + 1
				player.components.hunger.hungerrate = (1 - 0.05*player.je) * TUNING.WILSON_HUNGER_RATE
				player.components.talker:Say("饥饿抗性已提升5%!\nHunger resistance has up 5%!")
			else
				player.components.talker:Say("饥饿抗性已至上限!\nHunger resistance has to limit!")
			end
		else
			player.components.talker:Say("技能点不足!\nhave no skill points!")
		end
	end
end)

local KEY_R = GLOBAL.KEY_R
AddModRPCHandler(modname, "R", function(player)
	if not player:HasTag("playerghost") and player.prefab == "fhl" then
		player.components.talker:Say("你还有".. (player.jnd).. "点技能点!".. "\nyou have ".. (player.jnd).. " skill points!".. "\n向上键提升寒冷抗性,向下键提升伤害减免\n向左键提升输出伤害,向右键提升饥饿抗性".. "\nUsing KEY_UP to up The cold resistance,Using KEY_DOWN to up The Damage reduction\nUsing KEY_LEFT to up The Damage ascension,Using KEY_RIGHT to up The Hunger resistance.")
	end
end)

local fhl_handlers = {}
AddPlayerPostInit(function(inst)
	-- We hack
	inst:DoTaskInTime(0, function()
		-- We check if the character is ourselves
		-- So if another horo player joins, we don't get the handlers
		if inst == GLOBAL.ThePlayer then
			-- If we are horo
			if inst.prefab == "fhl" then
				-- We create and store the key handlers
				fhl_handlers[0] = TheInput:AddKeyDownHandler(KEY_T, function()
					SendModRPCToServer(MOD_RPC[modname]["T"])
				end)
				fhl_handlers[1] = TheInput:AddKeyDownHandler(KEY_UP, function()
					SendModRPCToServer(MOD_RPC[modname]["UP"])
				end)
				fhl_handlers[2] = TheInput:AddKeyDownHandler(KEY_DOWN, function()
					SendModRPCToServer(MOD_RPC[modname]["DOWN"])
				end)
				fhl_handlers[3] = TheInput:AddKeyDownHandler(KEY_LEFT, function()
					SendModRPCToServer(MOD_RPC[modname]["LEFT"])
				end)
				fhl_handlers[4] = TheInput:AddKeyDownHandler(KEY_RIGHT, function()
					SendModRPCToServer(MOD_RPC[modname]["RIGHT"])
				end)
				fhl_handlers[5] = TheInput:AddKeyDownHandler(KEY_R, function()
					SendModRPCToServer(MOD_RPC[modname]["R"])
				end)
			else
				-- If not, we go to the handlerslist and empty it
				-- This is to avoid having the handlers if we switch characters in wilderness
				-- If it's already empty, nothing changes
				fhl_handlers[0] = nil
				fhl_handlers[1] = nil
				fhl_handlers[2] = nil
				fhl_handlers[3] = nil
				fhl_handlers[4] = nil
				fhl_handlers[5] = nil
			end
		end
	end)
end)