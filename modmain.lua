local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
TECH = GLOBAL.TECH
local ACTIONS = GLOBAL.ACTIONS
local TheNet = GLOBAL.TheNet
local next = GLOBAL.next
local ThePlayer = GLOBAL.ThePlayer
local IsServer = GLOBAL.TheNet:GetIsServer()
local containers = require("containers")
local TheInput = GLOBAL.TheInput

modimport("fhl_util/fhl_util.lua")
modimport("scripts/containers_fhl.lua")

PrefabFiles = {
	"fhl",
	"bj_11",
	"fhl_zzj",
	"fhl_zzj1",
	"fhl_zzj2",
	"fhl_zzj3",
	"fhl_zzj4",
	"fhl_zzj5",
	"fhl_hsf",
	"fhl_bz",
	"fhl_cake",
	"fhl_x",
	"fhl_cy",
	"apple",
	"applebell",
	"ancient_soul",
	"ancient_gem",
	"fhl_tree",
	"fhl_bb",
}

STRINGS.FHL_TEDING = "这是风幻妹子的东西！"

GLOBAL.TUNING.FHL = {}

GLOBAL.STRINGS.NAMES.BJ_11 = "萌妹子的宝具"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.BJ_11 = "I can use this to do everything."
GLOBAL.STRINGS.RECIPE_DESC.BJ_11 = "this is the Production tools."

GLOBAL.STRINGS.NAMES.ANCIENT_GEM = "耀古之晶"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_GEM = "I felt the ancient's smell."
GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_GEM = "The seeds of the ancient tower."

GLOBAL.STRINGS.NAMES.FHL_TREE = "希雅蕾丝树枝"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_TREE = "I felt the banana's smell."
GLOBAL.STRINGS.RECIPE_DESC.FHL_TREE = "The seeds of the banana trees."

GLOBAL.STRINGS.NAMES.ANCIENT_SOUL = "Ancient soul"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANCIENT_SOUL = "this is the ancient soul."
GLOBAL.STRINGS.RECIPE_DESC.ANCIENT_SOUL = "this is the ancient soul."

STRINGS.NAMES.FHL_ZZJ = "金芜菁之杖-初阶"
STRINGS.RECIPE_DESC.FHL_ZZJ = "Golden wujing Lv1\nATK:20 Ice chance:4%"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ = "This is the Golden wujing Lv1"

STRINGS.NAMES.FHL_ZZJ1 = "金芜菁之杖-中阶"
STRINGS.RECIPE_DESC.FHL_ZZJ1 = "Golden wujing Lv2\nATK:35 Ice chance:8%"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ1 = "This is the Golden wujing Lv2"

STRINGS.NAMES.FHL_ZZJ2 = "金芜菁之杖-高阶"
STRINGS.RECIPE_DESC.FHL_ZZJ2 = "Golden wujing Lv3\nATK:50Ice chance:12%"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ2 = "This is the Golden wujing Lv3"

STRINGS.NAMES.FHL_ZZJ3 = "金芜菁之杖-史诗"
STRINGS.RECIPE_DESC.FHL_ZZJ3 = "Golden wujing Lv4\nATK:65Ice chance:16%"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ3 = "This is the Golden wujing Lv4"

STRINGS.NAMES.FHL_ZZJ4 = "金芜菁之杖-传说"
STRINGS.RECIPE_DESC.FHL_ZZJ4 = "Golden wujing Lv5\nATK85Ice chance:20%"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ4 = "This is the Golden wujing Lv5"

STRINGS.NAMES.FHL_ZZJ5 = "诸神黄昏之杖"
STRINGS.RECIPE_DESC.FHL_ZZJ5 = "Golden wujing Lv6\nATK120Icechance30%"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_ZZJ5 = "This is the Golden wujing Lv6"

STRINGS.CHARACTER_TITLES.fhl = "风幻龙-瑟尔泽"
STRINGS.CHARACTER_NAMES.fhl = "风幻龙-瑟尔泽"
STRINGS.CHARACTER_DESCRIPTIONS.fhl = "*The Dragonfruit can strengthen her force\n*Using The Golden wujing\n*She is the friend of the librarian"
STRINGS.CHARACTER_QUOTES.fhl = "\"风幻龙-瑟尔泽.\""

STRINGS.NAMES.FHL_HSF = "Syelza's Amulet"
STRINGS.RECIPE_DESC.FHL_HSF = "由塞尔泽的羽毛制成\n守护持有者"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_HSF = "这是守护者的神器啊!"

STRINGS.NAMES.FHL_BZ = "Rainbow cake"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BZ = "这是传说中的彩虹糕啊"
STRINGS.RECIPE_DESC.FHL_BZ = "美味可口的彩虹糕"

STRINGS.NAMES.FHL_CAKE = "Pumpkin pudding"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CAKE = "看上去似乎很美味."
STRINGS.RECIPE_DESC.FHL_CAKE = "简单的点心"

STRINGS.NAMES.FHL_X = "Drinking-X"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_X = "这是...一瓶药水?"
STRINGS.RECIPE_DESC.FHL_X = "祝您长命百岁!"

STRINGS.NAMES.FHL_CY = "Relaxing tea"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_CY = "looks great."
STRINGS.RECIPE_DESC.FHL_CY = "回复生命和脑力的\n饮品"

STRINGS.NAMES.APPLE = "风幻的苹果"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.APPLE = "这是......葫芦娃?"
STRINGS.NAMES.APPLEBELL = "风幻的铃铛"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.APPLEBELL = "铃铛的声音很好听."

--GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.KRAMPUS_SACK = "it looks great."
--GLOBAL.STRINGS.RECIPE_DESC.KRAMPUS_SACK = "集冰箱护甲暖石一身的\n高级背包"

STRINGS.NAMES.FHL_BB = "Syelza's Backpack"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FHL_BB = "it looks great."
STRINGS.RECIPE_DESC.FHL_BB = "冰箱+护甲+雨衣\nhastag:fridge/raincoat/armor"

-- 人物语言反馈
STRINGS.CHARACTERS.GENERIC.DESCRIBE.fhl = 
{
	GENERIC = "这是风幻妹子啊!",
	ATTACKER = "风幻妹妹攻击很强啊...",
	MURDERER = "谋杀啊!",
	REVIVER = "风幻将一生一世守护塞尔菲亚大陆.",
	GHOST = "风幻虽死不悔.",
}

-- 人物的名字出现在游戏中
STRINGS.NAMES.fhl = "风幻龙"

-- 人物说话
STRINGS.CHARACTERS.ESCTEMPLATE = require "speech_fhl"

Assets = {
    --存档界面人物头像
    Asset( "IMAGE", "images/saveslot_portraits/fhl.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/fhl.xml" ),

    --选择人物界面的人物头像
    Asset( "IMAGE", "images/selectscreen_portraits/fhl.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/fhl.xml" ),
    --人物大图
    Asset( "IMAGE", "bigportraits/fhl.tex" ),
    Asset( "ATLAS", "bigportraits/fhl.xml" ),
    --地图上的人物图标
	Asset( "IMAGE", "images/map_icons/fhl.tex" ),
	Asset( "ATLAS", "images/map_icons/fhl.xml" ),
    --人物头像
	Asset( "IMAGE", "images/avatars/avatar_fhl.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_fhl.xml" ),
    --人物死后图像
	Asset( "IMAGE", "images/avatars/avatar_ghost_fhl.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_fhl.xml" ),
	--剑小图标
	Asset( "ATLAS", "images/inventoryimages/fhl_zzj.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhl_zzj.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/fhl_zzj1.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhl_zzj1.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/fhl_zzj2.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhl_zzj2.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/fhl_zzj3.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhl_zzj3.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/fhl_zzj4.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhl_zzj4.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/fhl_zzj5.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhl_zzj5.tex" ),

	Asset( "ATLAS", "images/inventoryimages/fhltab.xml"),
	Asset( "IMAGE", "images/inventoryimages/fhltab.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/fhl_hsf.xml"),
	
	Asset("ANIM", "anim/sweet_n_sour.zip"),
	Asset( "IMAGE", "images/inventoryimages/fhl_bz.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fhl_bz.xml" ),
	
	Asset("ANIM", "anim/cake.zip"),
	Asset( "IMAGE", "images/inventoryimages/fhl_cake.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fhl_cake.xml" ),
	
	Asset("ANIM", "anim/dy_x.zip"),
	Asset( "IMAGE", "images/inventoryimages/fhl_x.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fhl_x.xml" ),
	
	Asset("ANIM", "anim/fhl_cy.zip"),
	Asset( "IMAGE", "images/inventoryimages/fhl_cy.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fhl_cy.xml" ),
	
	Asset("ANIM", "anim/ancient_soul.zip"),
	Asset("ATLAS", "images/inventoryimages/ancient_soul.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_soul.tex"),
	
	Asset("ANIM", "anim/ancient_gem.zip"),
	Asset("ATLAS", "images/inventoryimages/ancient_gem.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_gem.tex"),
	
	Asset("ANIM", "anim/fhl_tree.zip"),
	Asset("ATLAS", "images/inventoryimages/fhl_tree.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_tree.tex"),
	
	Asset("ATLAS", "images/inventoryimages/fhl_bb.xml"),
	Asset("IMAGE", "images/inventoryimages/fhl_bb.tex"),
	
	Asset("ATLAS", "images/minimapicons/applebell.xml"),
	Asset("IMAGE", "images/minimapicons/applebell.tex"),

}

------------------box


local oldwidgetsetup = containers.widgetsetup
containers.widgetsetup = function(container, prefab)
if not prefab and container.inst.prefab == "fhl_bb" then
prefab = "krampus_sack" end
oldwidgetsetup(container, prefab)
end

--AddPrefabPostInit("maxwellintro", InoriMaxwellIntro)
----------------------------------------------------------------------------------------------------

local function GiveApplebell(inst)
	local applebell = GLOBAL.SpawnPrefab("applebell")
	if applebell then
		applebell.owner = inst
		inst.applebell = applebell
		inst.components.inventory.ignoresound = true
		inst.components.inventory:GiveItem(applebell)
		inst.components.inventory.ignoresound = false
		applebell.components.named:SetName(inst.name.."的铃铛")
		return applebell 
	end 
end
	
local function GetSpawnPoint(pt)
	local theta = math.random() * 2 * GLOBAL.PI
	local radius = 4
	local offset = GLOBAL.FindWalkableOffset(pt, theta, radius, 12, true)
	return offset ~= nil and (pt + offset) or nil
end

local function PersonalApple(inst)
	if not inst:HasTag("appleowner") then------------------- Tag:appleowner
		return	
	end

	local OnDespawn_prev = inst.OnDespawn
	local OnDespawn_new = function(inst)
		-- Remove apple
		if inst.apple then
			-- Don't allow apple to despawn with irreplaceable items
			inst.apple.components.container:DropEverythingWithTag("irreplaceable")
			-- We need time to save before despawning.
			inst.apple:DoTaskInTime(0.1, function(inst)
				if inst and inst:IsValid() then
					inst:Remove() 
				end 
			end) 
		end
		if inst.applebell then
			-- applebell drops from whatever its in
			local owner = inst.applebell.components.inventoryitem.owner
			if owner then
				-- Remember if applebell is held
				if owner == inst then
					inst.applebell.isheld = true
				else
					inst.applebell.isheld = false 
				end
				if owner.components.container then
					owner.components.container:DropItem(inst.applebell)
				elseif owner.components.inventory then
					owner.components.inventory:DropItem(inst.applebell)
				end	
			end
			-- Remove applebell
			inst.applebell:DoTaskInTime(0.1, function(inst)
				if inst and inst:IsValid() then
					inst:Remove() 
				end 
			end) 
		else
			print("Error: Player has no linked applebell!")
		end
		if OnDespawn_prev then
			return OnDespawn_prev(inst)	
		end	
	end
	inst.OnDespawn = OnDespawn_new
	
	local OnSave_prev = inst.OnSave
	local OnSave_new = function(inst, data)
		local references = OnSave_prev and OnSave_prev(inst, data)
		if inst.apple then
			-- Save apple
			local refs = {}
			if not references then references = {} end
			data.apple, refs = inst.apple:GetSaveRecord()
			if refs then
				for k,v in pairs(refs) do
					table.insert(references, v)
				end 
			end	
		end
		if inst.applebell then
			-- Save applebell
			local refs = {}
			if not references then references = {} end
			data.applebell, refs = inst.applebell:GetSaveRecord()
			if refs then
				for k,v in pairs(refs) do
					table.insert(references, v)	
				end 
			end
			-- Remember if was holding applebell
			if inst.applebell.isheld then
				data.holdingapplebell = true
			else
				data.holdingapplebell = false
			end	
		end	
		return references 
	end
    inst.OnSave = OnSave_new
	
	local OnLoad_prev = inst.OnLoad
	local OnLoad_new = function(inst, data, newents)
		if data.apple ~= nil then
			-- Load apple
		inst.apple = GLOBAL.SpawnSaveRecord(data.apple, newents) 
		else 
		end
			--print("Warning: No apple was loaded from save file!")
		if data.applebell ~= nil then
			-- Load apple
			inst.applebell = GLOBAL.SpawnSaveRecord(data.applebell, newents)
			-- Look for applebell at spawn point and re-equip
			inst:DoTaskInTime(0, function(inst)
				if data.holdingapplebell or (inst.applebell and inst:IsNear(inst.applebell,4)) then
					--inst.components.inventory:GiveItem(inst.applebell)
					inst:ReturnApplebell()
				end	
			end) 
		else
			print("Warning: No applebell was loaded from save file!") 
		end
		-- Create new applebell if none loaded
		if not inst.applebell then GiveApplebell(inst) end
		inst.applebell.owner = inst
		if OnLoad_prev then
			return OnLoad_prev(inst, data, newents)
		end	end inst.OnLoad = OnLoad_new
	local OnNewSpawn_prev = inst.OnNewSpawn
	local OnNewSpawn_new = function(inst)
		-- Give new applebell. Let apple spawn naturally.
		GiveApplebell(inst)
		if OnNewSpawn_prev then
			return OnNewSpawn_prev(inst) end end
    inst.OnNewSpawn = OnNewSpawn_new
	if GLOBAL.TheNet:GetServerGameMode() == "wilderness" then
		local function ondeath(inst, data)
			-- Kill player's apple in wilderness mode :(
			if inst.apple then inst.apple.components.health:Kill() end
			if inst.applebell then
				inst.applebell:Remove()
			end	end	inst:ListenForEvent("death", ondeath) end
	-- Debug function to return applebell
	inst.ReturnApplebell = function()
		if inst.applebell and inst.applebell:IsValid() then
			if inst.applebell.components.inventoryitem.owner ~= inst then
				inst.components.inventory:GiveItem(inst.applebell)
			end	else GiveApplebell(inst) end
		if inst.apple and not inst:IsNear(inst.apple, 20) then
			local pt = inst:GetPosition()
			local spawn_pt = GetSpawnPoint(pt)
			if spawn_pt ~= nil then
				inst.apple.Physics:Teleport(spawn_pt:Get())
				inst.apple:FacePoint(pt:Get()) 
			end 
		end 
	end 
end
				
GLOBAL.c_returnapplebell = function(inst)
	if not inst then
		inst = GLOBAL.ThePlayer or GLOBAL.AllPlayers[1]	end
	if not inst or not inst.ReturnApplebell then 
		print("Error: Cannot return applebell")
		return end inst:ReturnApplebell() end
AddPlayerPostInit(PersonalApple)

local function HasApplebell(doer)
    if doer.components.inventory and doer.components.inventory:FindItem(function(item)
        if item.prefab == "applebell" then return true end
    end) ~= nil then return true else return false 
	end 
end

local oldAPPLESTORE = GLOBAL.ACTIONS.STORE.fn
GLOBAL.ACTIONS.STORE.fn = function(act)
    if act.target and act.target.prefab == "apple" and act.target.components.container ~= nil and act.invobject.components.inventoryitem ~= nil and act.doer.components.inventory ~= nil then
        print(act.doer.name,"is trying to do something with a Apple")
        if HasApplebell(act.doer) then
            print(act.doer.name,"has Applebell, proceed")
            return oldAPPLESTORE(act) else
            print(act.doer.name,"doesn't has the Applebell, exit")
            if act.doer.components.talker then act.doer.components.talker:Say("没铃铛就不给你放东西!") end return true
		end 
	else 
		return oldAPPLESTORE(act) 
	end 
end

local old_APPLEMAGE = GLOBAL.ACTIONS.RUMMAGE.fn 
GLOBAL.ACTIONS.RUMMAGE.fn = function(act)
    if act.target and act.target.prefab == "apple" then  
        print("GLOBAL.ACTIONS.RUMMAGE--"..tostring(act.doer.components.inventory))
        result = act.doer.components.inventory:FindItem(function(item)
            if item.prefab == "applebell" then 
            print("GLOBAL.ACTIONS.RUMMAGE--"..tostring(item).."--ok--") 
            return true end end)
        if result then return old_APPLEMAGE(act) else
            print("GLOBAL.ACTIONS.RUMMAGE--"..tostring(item).."--fail--") 
            act.doer:DoTaskInTime(1, function ()
            act.doer.components.talker:Say("就不给你看!")
			end) return false 
		end 
	else
		return old_APPLEMAGE(act) 
	end 
end

AddMinimapAtlas("images/minimapicons/applebell.xml")

TUNING.FHL_COS = GetModConfigData("fhl_cos")
TUNING.ZZJ_FINITE_USES = GetModConfigData("zzj_finiteuses")
TUNING.ZZJ_PRE = GetModConfigData("zzj_pre")
TUNING.OPENLIGHT = GetModConfigData("openlight")
TUNING.OPENLI = GetModConfigData("openli")
TUNING.ZZJ_FIREOPEN = GetModConfigData("zzj_fireopen")
TUNING.LIKEORNOT = GetModConfigData("likeornot")

GLOBAL.STRINGS.TABS.FHL = "Syelza"
GLOBAL.RECIPETABS['FHL'] = {str = "FHL", sort=10, icon = "fhltab.tex", icon_atlas = "images/inventoryimages/fhltab.xml", "fhl"}

local ancient_soul18 = Ingredient( "ancient_soul", 18)
ancient_soul18.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul8 = Ingredient( "ancient_soul", 8)
ancient_soul8.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul5 = Ingredient( "ancient_soul", 5)
ancient_soul5.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul3 = Ingredient( "ancient_soul", 3)
ancient_soul3.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul2 = Ingredient( "ancient_soul", 2)
ancient_soul2.atlas = "images/inventoryimages/ancient_soul.xml"

local ancient_soul1 = Ingredient( "ancient_soul", 1)
ancient_soul1.atlas = "images/inventoryimages/ancient_soul.xml"

local fhl_zzj = AddRecipe("fhl_zzj", {ancient_soul1,Ingredient("goldnugget", 3)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_zzj.xml")

local fhl_zzj1 = AddRecipe("fhl_zzj1", {Ingredient("fhl_zzj", 1,"images/inventoryimages/fhl_zzj.xml"),ancient_soul2,Ingredient("goldnugget", 6)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_zzj1.xml")

local fhl_zzj2 = AddRecipe("fhl_zzj2", {Ingredient("fhl_zzj1", 1,"images/inventoryimages/fhl_zzj1.xml"),ancient_soul3,Ingredient("goldnugget", 12)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_zzj2.xml")

local fhl_zzj3 = AddRecipe("fhl_zzj3", {Ingredient("fhl_zzj2", 1,"images/inventoryimages/fhl_zzj2.xml"),ancient_soul5,Ingredient("goldnugget", 24),Ingredient("bluegem", 3)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_zzj3.xml")

local fhl_zzj4 = AddRecipe("fhl_zzj4", {Ingredient("fhl_zzj3", 1,"images/inventoryimages/fhl_zzj3.xml"),ancient_soul8,Ingredient("goldnugget", 36),Ingredient("bluegem", 9)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_zzj4.xml")

local fhl_zzj5 = AddRecipe("fhl_zzj5", {Ingredient("fhl_zzj4", 1,"images/inventoryimages/fhl_zzj4.xml"),ancient_soul18,Ingredient("goldnugget", 64),Ingredient("bluegem", 21)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_zzj5.xml")

local fhl_hsf = AddRecipe("fhl_hsf", {Ingredient( "feather_robin",3),Ingredient("feather_crow", 3),ancient_soul5}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_hsf.xml")

local fhl_bz = AddRecipe("fhl_bz", {Ingredient( "berries",8), Ingredient("watermelon", 2)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_bz.xml")

local fhl_cake = AddRecipe("fhl_cake", {Ingredient( "berries",4), Ingredient("pumpkin", 2)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_cake.xml")

local fhl_x = AddRecipe("fhl_x", {Ingredient( "froglegs_cooked",1), Ingredient("berries", 2)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_x.xml")

local fhl_cy = AddRecipe("fhl_cy", {Ingredient( "butterflywings",5), Ingredient("honey", 2)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_cy.xml")

--local ancient_soul = AddRecipe("ancient_soul", {Ingredient( "flint",8), Ingredient("goldnugget", 4)}, RECIPETABS.FHL, {SCIENCE=0}, 
--nil, nil, nil, nil, "fhl","images/inventoryimages/ancient_soul.xml")

local ancient_gem = AddRecipe("ancient_gem", { ancient_soul18, Ingredient("goldnugget", 12)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/ancient_gem.xml")

local fhl_tree = AddRecipe("fhl_tree", { ancient_soul1, Ingredient("twigs", 3)}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_tree.xml")

local fhl_bb = AddRecipe("fhl_bb", {Ingredient("cutgrass", 5),Ingredient("twigs", 5),ancient_soul8}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/fhl_bb.xml")

local bj_11 = AddRecipe("bj_11", {Ingredient("cutgrass", 5),Ingredient("twigs", 2),Ingredient("goldnugget", 1),ancient_soul1}, RECIPETABS.FHL, {SCIENCE=0}, 
nil, nil, nil, nil, "fhl","images/inventoryimages/bj_11.xml")

----BOOK----
AddRecipe("book_birds", {Ingredient("papyrus", 2), Ingredient("bird_egg", 2)}, RECIPETABS.FHL, TECH.NONE, nil, nil, nil, nil,"bookbuilder")
AddRecipe("book_gardening", {Ingredient("papyrus", 2), Ingredient("seeds", 1), Ingredient("poop", 1)}, RECIPETABS.FHL, TECH.NONE, nil, nil, nil, nil,"bookbuilder")
AddRecipe("book_sleep", {Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.FHL, TECH.NONE, nil, nil, nil, nil,"bookbuilder")
AddRecipe("book_brimstone", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, RECIPETABS.FHL, TECH.NONE, nil, nil, nil, nil,"bookbuilder")
AddRecipe("book_tentacles", {Ingredient("papyrus", 2), Ingredient("tentaclespots", 1)}, RECIPETABS.FHL, TECH.NONE, nil, nil, nil, nil,"bookbuilder")


-----------创建地图图标和角色基础属性
AddMinimapAtlas("images/map_icons/fhl.xml")
AddModCharacter("fhl","FEMALE")

GLOBAL.glassesdrop = 0