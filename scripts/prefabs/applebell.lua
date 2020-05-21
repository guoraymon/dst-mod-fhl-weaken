local assets =
{
    Asset("ANIM", "anim/applebell.zip"),
    Asset("ATLAS", "images/inventoryimages/applebell.xml"),
}

local SPAWN_DIST = 30

local function OpenEye(inst)
    inst.isOpenEye = true
    inst.components.inventoryitem:ChangeImageName(inst.openEye)
end
  
local function CloseEye(inst)
    inst.isOpenEye = nil
    inst.components.inventoryitem:ChangeImageName(inst.closedEye)
end
  
local function RefreshEye(inst)
    if inst.isOpenEye then
        OpenEye(inst)
    else
        CloseEye(inst)
    end
end

local function MorphShadowApplebell(inst)
    inst.AnimState:SetBuild("applebell")

    inst.openEye = "applebell"
    inst.closedEye = "applebell"
    RefreshEye(inst)

    inst.ApplebellState = "SHADOW"
end

local function MorphSnowApplebell(inst)
    inst.AnimState:SetBuild("applebell")

    inst.openEye = "applebell"
    inst.closedEye = "applebell"
    RefreshEye(inst)

    inst.ApplebellState = "SNOW"
end

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST
    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end

local function SpawnApple(inst)
    --print("chester_eyebone - SpawnChester")
	if not inst.owner then
        print("Error: Applebell has no linked player!")
        return
    end

    local pt = inst:GetPosition()
    --print("    near", pt)
        
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        --print("    at", spawn_pt)
        local apple = SpawnPrefab("apple")
        if apple ~= nil then
            apple.Physics:Teleport(spawn_pt:Get())
            apple:FacePoint(pt:Get())
			if inst.owner then
                inst.owner.apple = apple
            end

            return apple
        end

    --else
        -- this is not fatal, they can try again in a new location by picking up the bone again
        --print("chester_eyebone - SpawnChester: Couldn't find a suitable spawn point for chester")
    end
end

local StartRespawn

local function StopRespawn(inst)
    --print("chester_eyebone - StopRespawn")
    if inst.respawntask ~= nil then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindApple(inst, apple)
    apple = apple or (inst.owner and inst.owner.apple)
    if apple ~= nil then
	if inst.owner then
            apple.components.named:SetName(inst.owner.name.."的苹果")
        end
        inst.AnimState:PlayAnimation("idle_loop", true)
        OpenEye(inst)
        inst:ListenForEvent("death", function()
		 if inst.owner then
                inst.owner.apple = nil
            end
		StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME) end, apple)

        if apple.components.follower.leader ~= inst then
            apple.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnApple(inst)
    --print("chester_eyebone - RespawnChester")
    StopRespawn(inst)
    RebindApple(inst, (inst.owner and inst.owner.apple) or SpawnApple(inst))
end

StartRespawn = function(inst, time)
    StopRespawn(inst)

    time = time or 0
    inst.respawntask = inst:DoTaskInTime(time, RespawnApple)
    inst.respawntime = GetTime() + time
    inst.AnimState:PlayAnimation("dead", true)
    CloseEye(inst)
end

local function FixApple(inst)
	inst.fixtask = nil
	--take an existing chester if there is one
	if not RebindApple(inst) then
        inst.AnimState:PlayAnimation("dead", true)
        CloseEye(inst)
		
		if inst.components.inventoryitem.owner ~= nil then
			local time_remaining = 0
			local time = GetTime()
			if inst.respawntime and inst.respawntime > time then
				time_remaining = inst.respawntime - time		
			end
			StartRespawn(inst, time_remaining)
		end
	end
end

local function OnPutInInventory(inst)
    if inst.fixtask == nil then
        inst.fixtask = inst:DoTaskInTime(1, FixApple)
    end
end

local function OnSave(inst, data)
    if inst.respawntime ~= nil then
        local time = GetTime()
        if inst.respawntime > time then
            data.respawntimeremaining = inst.respawntime - time
        end
    end
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end

    if data.ApplebellState == "SHADOW" then
        MorphShadowApplebell(inst)
    elseif data.ApplebellState == "SNOW" then
        MorphSnowApplebell(inst)
    end

    if data.respawntimeremaining ~= nil then
        inst.respawntime = data.respawntimeremaining + GetTime()
    end
end

local function GetStatus(inst)
    if inst.respawntask ~= nil then
        return "WAITING"
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst:AddTag("applebell")
    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")
	inst:AddTag("_named")

    inst.AnimState:SetBank("applebell")
    inst.AnimState:SetBuild("applebell")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/applebell.xml"
	inst.components.inventoryitem:ChangeImageName("applebell")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    inst.ApplebellState = "NORMAL"
    inst.openEye = "applebell"
    inst.closedEye = "applebell"

    inst.isOpenEye = nil
    OpenEye(inst)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()
	inst.components.inspectable.nameoverride = "applebell"

    inst:AddComponent("leader")
	
	inst:AddComponent("named")

    MakeHauntableLaunch(inst)

    inst.MorphSnowApplebell = MorphSnowApplebell
    inst.MorphShadowApplebell = MorphShadowApplebell

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.fixtask = inst:DoTaskInTime(1, FixApple)
	inst.RebindApple = RebindApple

    return inst
end

return Prefab("common/inventory/applebell", fn, assets)