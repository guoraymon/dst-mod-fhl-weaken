local assets=
{
	Asset("ANIM", "anim/fhl_tree.zip"),
	
	Asset("ATLAS", "images/inventoryimages/fhl_tree.xml"),
    Asset("IMAGE", "images/inventoryimages/fhl_tree.tex"),
}


local function fn()
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	--inst.entity:AddSoundEmitter()
	--inst.entity:AddPhysics()
	inst.entity:AddNetwork()
	inst.entity:AddLight()
	
    MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )    
	
    inst.AnimState:SetBank("fhl_tree")
    inst.AnimState:SetBuild("fhl_tree")
    inst.AnimState:PlayAnimation("idle")

	inst.Light:Enable(true)
	inst.Light:SetRadius(.5)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(238/255, 155/255, 143/255)
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
    inst:AddComponent("tradable")
    
    inst:AddComponent("inspectable")
    
	local function OnDeploy (inst, pt)
    SpawnPrefab("cave_banana_tree").Transform:SetPosition(pt.x, pt.y, pt.z)
    inst.components.stackable:Get():Remove()
    end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
	
    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fhl_tree.xml"

    --inst:AddComponent("bait")
    --inst:AddTag("molebait")
    
    return inst
end

return Prefab( "common/inventory/fhl_tree", fn, assets) 