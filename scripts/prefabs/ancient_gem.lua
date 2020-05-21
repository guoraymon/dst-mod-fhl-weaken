local assets=
{
	Asset("ANIM", "anim/ancient_gem.zip"),
	
	Asset("ATLAS", "images/inventoryimages/ancient_gem.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_gem.tex"),
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
	
    inst.AnimState:SetBank("ancient_gem")
    inst.AnimState:SetBuild("ancient_gem")
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
    
	-- 建造远古祭坛
	local function OnDeploy (inst, pt)
    SpawnPrefab("ancient_altar").Transform:SetPosition(pt.x, pt.y, pt.z)
    inst.components.stackable:Get():Remove()
	end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
	
    inst:AddComponent("stackable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ancient_gem.xml"

    --inst:AddComponent("bait")
    --inst:AddTag("molebait")
    
    return inst
end

return Prefab( "common/inventory/ancient_gem", fn, assets) 
