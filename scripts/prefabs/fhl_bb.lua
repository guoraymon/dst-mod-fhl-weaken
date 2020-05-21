local assets =
{
    Asset("ANIM", "anim/swap_fhl_bb.zip"),
    Asset("ANIM", "anim/fhl_bb.zip"),
	
	Asset("ATLAS", "images/inventoryimages/fhl_bb.xml")
}

-- local function AcceptTest(inst, item)
-- 	if item.prefab == "ancient_soul" and inst.components.armor:GetPercent() < 1 then
-- 		return true
-- 	elseif inst.components.armor:GetPercent() == 1 then
-- 		local owner = item.components.inventoryitem:GetGrandOwner()
-- 		owner.components.talker:Say("耐久已满!\nDurability is full!")
-- 	else
-- 		local owner = item.components.inventoryitem:GetGrandOwner()
-- 		owner.components.talker:Say("qwq这个无法用来修复背包哦!\nThis can't be used to repairing the backpack!")
-- 	end
-- end

-- local function OnGetItemFromPlayer(inst, giver, item)
-- 	if item.prefab == "ancient_soul" and inst.components.armor:GetPercent() < 1 then
-- 		giver.components.inventory:ConsumeByName("ancient_soul", 1)
-- 		local backpack_repaired = TUNING.ARMORMARBLE*1.2
-- 		inst.components.armor.condition = inst.components.armor.condition + backpack_repaired
-- 		if inst.components.armor:GetPercent() > 1 then
-- 			inst.components.armor:SetCondition(TUNING.ARMORMARBLE*3)
-- 		end
-- 	end
-- end

local function onbreak(owner,data)
	local armor = data ~= nil and data.armor or nil
	if armor and armor.components.container then
		armor.components.container:DropEverything()
		armor.components.container:Close()
		armor:RemoveComponent("container")
	end
end

local function onequip(inst, owner)
	-- 风幻龙专属
	if owner.prefab == "fhl"  then
		owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "symbol_15220700")
		owner.AnimState:OverrideSymbol("swap_body", "swap_fhl_bb", "symbol_b6d8e12e")
		inst.components.container:Open(owner)
		inst:ListenForEvent("armorbroke",onbreak,owner)
	else
		owner:DoTaskInTime(0, function()
			local inventory = owner.components.inventory 
			if inventory then
				inventory:DropItem(inst)
			end

			local talker = owner.components.talker 
			if talker then
				talker:Say(STRINGS.FHL_TEDING)
			end
		end)
	end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    if inst.components.container ~= nil then
		inst.components.container:Close(owner)
	end
	inst:RemoveEventCallback("armorbroke",onbreak,owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("pirate_booty_bag")
    inst.AnimState:SetBuild("swap_fhl_bb")
    inst.AnimState:PlayAnimation("anim")

    --inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("backpack")
	inst:AddTag("fridge")
    inst:AddTag("icebox_valid")
	inst:AddTag("trader")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

	inst:AddComponent("talker")
    inst.components.talker.fontsize = 20
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(0.6, 0.9, 0.9, 1)
    inst.components.talker.offset = Vector3(0,100,0)
    inst.components.talker.symbol = "swap_object"	
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_bb.xml"
	
	-- inst:AddComponent("waterproofer")
    -- inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE)
	
	-- if TUNING.FHL_HJOPEN then
	-- 	inst:AddComponent("armor")
	-- 	inst.components.armor:InitCondition(TUNING.ARMORMARBLE*3, 0.8)
	-- 	inst:AddComponent("trader")
	-- 	inst.components.trader:SetAcceptTest(AcceptTest)
	-- 	inst.components.trader.onaccept = OnGetItemFromPlayer
	-- end
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
	
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("common/inventory/fhl_bb", fn, assets)