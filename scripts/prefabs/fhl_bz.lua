local Assets =
{
	Asset("ANIM", "anim/sweet_n_sour.zip"),
    Asset("ATLAS", "images/inventoryimages/fhl_bz.xml"),
}

local prefabs = 
{
	"spoiled_food",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	
	inst.AnimState:SetBank("sweet_n_sour")
	inst.AnimState:SetBuild("sweet_n_sour")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("preparedfood")
	inst:AddTag("honeyed")

	--if not TheNet:GetIsServer() then
    --    return inst
    --end
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible.healthvalue = 120
	inst.components.edible.hungervalue = 160
	inst.components.edible.sanityvalue = 30

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_bz.xml"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED*10)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	
	return inst
end


return Prefab( "common/inventory/fhl_bz", fn, Assets )