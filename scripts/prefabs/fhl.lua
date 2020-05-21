
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/fhl.zip" ),
        Asset( "ANIM", "anim/ghost_fhl_build.zip" ),
}
local prefabs = {}

-- 自定义启动项
local start_inv = {
    --"fhl_zzj",
	--"fhl_bz",
	"fhl_cake",
	"bj_11",
	--"fhl_cy",
}

local function onkilledother(inst, data)
	local chance = TUNING.FHL_COS
	local victim = data.victim
		if victim.components.freezable or victim:HasTag("monster") then
		if math.random() < chance then
			if victim.components.lootdropper then
				victim.components.lootdropper:SpawnLootPrefab("ancient_soul")
			end
		end 
	end 
end


local function FhlFire(inst)
	if TheWorld.state.isnight and TUNING.OPENLIGHT then
		inst.Light:Enable(true)
		inst.Light:SetRadius(6)
    	inst.Light:SetFalloff(.8)
    	inst.Light:SetIntensity(.8)
    	inst.Light:SetColour(237/255,237/255,209/255)
	end
end

--升级机制
local function applyupgrades(inst)

	local max_upgrades = 30
	local upgrades = math.min(inst.level, max_upgrades)
	
	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()

	inst.components.hunger.max = math.ceil (120 + upgrades * 2) --150
	inst.components.sanity.max = math.ceil (200 + upgrades * 2) --250
	inst.components.health.maxhealth = math.ceil (120 + upgrades * 2) --150
	
	inst.components.locomotor.walkspeed = math.ceil (6 + upgrades / 10) --9
	inst.components.locomotor.runspeed = math.ceil (8 + upgrades / 10) --11
	
	inst.components.talker:Say("QWQ Level up: ".. (inst.level).. "\n你还有".. (inst.jnd).. "点技能点!\n加点帮助请按R,当前状态请按T!".. "\nyou have ".. (inst.jnd).. " skill points!\nClick R for help,Click T for State!")
	
	if inst.level >29 then
		inst.components.talker:Say("W.W Level Max!\n你还有".. (inst.jnd).. "点技能点!\n加点帮助请按R,当前状态请按T!".. "\nyou have ".. (inst.jnd).. " skill points!\nClick R for help,Click T for State!")
	end

	inst.components.hunger:SetPercent(hunger_percent)
	inst.components.health:SetPercent(health_percent)
	inst.components.sanity:SetPercent(sanity_percent)

end

-- 当这个角色从人类复活
local function onbecamehuman(inst)
	-- 设置速度加载或恢复时从鬼(可选)
	inst.components.locomotor.walkspeed = 6
	inst.components.locomotor.runspeed = 8
	applyupgrades(inst)
end


local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
	
    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end


local function oneat(inst, food)
	if food and food.components.edible and food.prefab == "dragonpie" or food.prefab == "dragonfruit" or food.prefab == "dragonfruit_cooked" then
		if inst.level < 30 then
			if math.random()>0.03*inst.level then
				inst.level = inst.level + 1
				inst.jnd = inst.jnd + 1
				applyupgrades(inst)	
				inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
			else
				inst.components.talker:Say("QWQ 升级失败了!\nlevel up failed!")
			end
		else
			inst.components.talker:Say("QWQ 满级了!\nQWQ level Max!")
		end
	end
end

local function onpreload(inst, data)
	if data then
		if data.jnd then
			inst.jnd = data.jnd
		else
			inst.jnd = data.level
		end
		
		if data.je then
			inst.je = data.je
		else
			inst.je = 0
		end
		
		if data.level then
			inst.level = data.level
			applyupgrades(inst)
			if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)
			inst.components.sanity:DoDelta(0)
		end
		applyupgrades(inst)
	end
	if data.absorb then
		inst.components.health.absorb = data.absorb
	end
	if data.hungerrate then
		inst.components.hunger.hungerrate = data.hungerrate
	end
	if data.damagemultiplier then
		inst.components.combat.damagemultiplier = data.damagemultiplier
	end
	if data.inherentinsulation then
		inst.components.temperature.inherentinsulation = data.inherentinsulation
	end
end

local function onsave(inst, data)
	data.level = inst.level
	data.jnd = inst.jnd
	data.je = inst.je
	data.hungerrate = inst.components.hunger.hungerrate or nil
	data.absorb = inst.components.health.absorb or nil
	data.damagemultiplier = inst.components.combat.damagemultiplier or nil
	data.inherentinsulation = inst.components.temperature.inherentinsulation or nil
end

-- 这对服务器和客户端初始化。可以添加标注。
local common_postinit = function(inst) 
	-- 小地图图标
	inst.MiniMapEntity:SetIcon( "fhl.tex" )
	inst.soundsname = "willow"
	inst:AddTag("fhl")
	inst:AddTag("speciallickingowner")
	inst:AddTag("bookbuilder")
	--inst:AddTag("insomniac")
end

-- 这对于服务器初始化。组件被添加。
local master_postinit = function(inst)
	-- 选择这个角色的声音
	inst.level = 0
	inst.jnd = 0
	inst.je = 0
	inst.components.eater:SetOnEatFn(oneat)
	applyupgrades(inst)
	
	inst:AddComponent("reader")	
    ------------------------------------------
    inst:AddComponent("leader")
    ------------------------------------------
    inst:AddComponent("knownlocations")
	
	inst:WatchWorldState("phase", FhlFire)
	inst:ListenForEvent( "hungerdelta", FhlFire)
	
	-- 属性设置	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	inst.components.locomotor.walkspeed = 6
	inst.components.locomotor.runspeed = 8
	inst.components.health.absorb = 0.00
	inst.components.combat.damagemultiplier = 1.00
	inst.components.hunger.hungerrate = (TUNING.WILSON_HUNGER_RATE * 1.00)
	inst.components.temperature.inherentinsulation = (TUNING.INSULATION_PER_BEARD_BIT * 0.00)
	--inst.components.health:StartRegen(1,4)
	-- 增加击杀掉落
	inst:ListenForEvent("killed", onkilledother)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("fhl", prefabs, assets, common_postinit, master_postinit, start_inv)
