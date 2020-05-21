local assets=
{
	Asset("ANIM", "anim/ancient_soul.zip"),
	
	Asset("ATLAS", "images/inventoryimages/ancient_soul.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_soul.tex"),
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

    inst.AnimState:SetBank("ancient_soul")
    inst.AnimState:SetBuild("ancient_soul")
    inst.AnimState:PlayAnimation("idle")

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(.5)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(238/255, 255/255, 143/255)
	
	inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
    --inst:AddComponent("edible")
    --inst.components.edible.foodtype = "ELEMENTAL"
    --inst.components.edible.hungervalue = 2
    inst:AddComponent("tradable")
    
    inst:AddComponent("inspectable")
	
    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ancient_soul.xml"
  
    return inst
end

return Prefab( "common/inventory/ancient_soul", fn, assets) 
