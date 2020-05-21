require "prefabutil"
local brain = require "brains/applebrain"

local WAKE_TO_FOLLOW_DISTANCE = 4
local SLEEP_NEAR_LEADER_DISTANCE = 6

local assets =
{
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),

    Asset("ANIM", "anim/chester.zip"),
    Asset("ANIM", "anim/apple_build.zip"),

    Asset("SOUND", "sound/chester.fsb"),
}

local prefabs =
{
    "applebell",
}

local sounds =
{
    hurt = "dontstarve/creatures/chester/hurt",
    pant = "dontstarve/creatures/chester/pant",
    death = "dontstarve/creatures/chester/death",
    open = "dontstarve/creatures/chester/open",
    close = "dontstarve/creatures/chester/close",
    pop = "dontstarve/creatures/chester/pop",
    boing = "dontstarve/creatures/chester/boing",
    lick = "dontstarve/creatures/chester/lick",
}

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    --print(inst, "ShouldSleep", DefaultSleepTest(inst), not inst.sg:HasStateTag("open"), inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE))
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open") and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) and not TheWorld.state.isfullmoon
end


local function ShouldKeepTarget()
    return false -- apple can't attack, and won't sleep if he has a target
end

local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
    end
end

local function OnClose(inst)
    if not inst.components.health:IsDead() and inst.sg.currentstate.name ~= "transition" then
        inst.sg:GoToState("close")
    end
end

local function OnStopFollowing(inst)
    inst:RemoveTag("companion")
end

local function OnStartFollowing(inst)
    inst:AddTag("companion")
end

local function MorphShadowApple(inst)
    inst.AnimState:SetBuild("apple_build")
	inst:AddTag("spoiler")
	if TUNING.LIKEORNOT then
		inst.components.container:WidgetSetup("apple")
	else
		inst.components.container:WidgetSetup("chester")
	end
	
    local leader = inst.components.follower.leader    
    if leader ~= nil then
        inst.components.follower.leader:MorphShadowEyebone()
    end
	
    inst.AppleState = "SHADOW"
    inst._isshadowapple:set(true)
end

local function MorphSnowApple(inst)
    inst.AnimState:SetBuild("apple_build")
	inst:AddTag("fridge")
	--[[
	if TUNING.LIKEORNOT then
		inst.components.container:WidgetSetup("apple")
	else
		inst.components.container:WidgetSetup("chester")
	end
	]]
    local leader = inst.components.follower.leader
    if leader ~= nil then
        inst.components.follower.leader:MorphSnowEyebone()
    end

    inst.AppleState = "SNOW"
    inst._isshadowapple:set(false)
end

local function MorphNormalApple(inst)
    inst.AnimState:SetBuild("apple_build")

	inst:RemoveTag("fridge")
    inst:RemoveTag("spoiler")
    if TUNING.LIKEORNOT then
		inst.components.container:WidgetSetup("apple")
	else
		inst.components.container:WidgetSetup("chester")
	end

    local leader = inst.components.follower.leader    
    if leader ~= nil then
        inst.components.follower.leader:MorphNormalEyebone()
    end

    inst.AppleState = "NORMAL"
    inst._isshadowapple:set(false)
end

local function OnSave(inst, data)
    data.AppleState = inst.AppleState
end

local function OnPreLoad(inst, data)
    if data == nil then
        return
    elseif data.AppleState == "SHADOW" then
        DoMorph(inst, MorphShadowApple)
    elseif data.AppleState == "SNOW" then
        DoMorph(inst, MorphSnowApple)
    end
end

local function OnIsShadowAppleDirty(inst)
    if inst._isshadowapple:value() ~= inst._clientshadowmorphed then
        inst._clientshadowmorphed = inst._isshadowapple:value()
		if TUNING.LIKEORNOT then
			inst.replica.container:WidgetSetup(inst._clientshadowmorphed and "apple" or nil)
		else
			inst.replica.container:WidgetSetup(inst._clientshadowmorphed and "chester" or nil)
		end
    end
end

local function create_apple()

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	
	if TUNING.OPENLI and TheWorld.state.isnight then
		local light = inst.entity:AddLight()
		inst:AddComponent("lighttweener")
		inst.components.lighttweener:StartTween(light, 1, 0.5, 0.7, {237/255, 237/255, 209/255}, 0)
		light:Enable(true)
	end

	inst.MiniMapEntity:SetIcon("applebell.tex")
    inst.MiniMapEntity:SetCanUseCache(false)
    MakeCharacterPhysics(inst, 75, .5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("apple")
    inst:AddTag("notraptrigger")
    inst:AddTag("_named")

    --inst.MiniMapEntity:SetIcon("apple.tex")
    --inst.MiniMapEntity:SetCanUseCache(false)

    inst.AnimState:SetBank("apple")
    inst.AnimState:SetBuild("apple_build")

    inst.DynamicShadow:SetSize(2, 1.5)

    inst.Transform:SetFourFaced()

    inst._isshadowapple = net_bool(inst.GUID, "_isshadowapple", "onisshadowappledirty")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst:DoTaskInTime(0.1, function(inst)
			if TUNING.LIKEORNOT then
				inst.replica.container:WidgetSetup(inst._isshadowapple:value() and "apple" --[[or "chester"]])
			else
				inst.replica.container:WidgetSetup(inst._isshadowapple:value() and "chester")
			end
		end)
        inst._clientshadowmorphed = false
        inst:ListenForEvent("onisshadowappledirty", OnIsShadowAppleDirty)
        return inst
    end
	
	inst.persists = false

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst:AddTag("noauradamage")

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
    --inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable.nameoverride = "apple"

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 12
    inst.components.locomotor.runspeed = 14

    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    inst:AddComponent("knownlocations")

    inst:AddComponent("container")
	if TUNING.LIKEORNOT then
		inst.components.container:WidgetSetup("apple")
	else
		inst.components.container:WidgetSetup("chester")
	end
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose

	inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	
    inst:AddComponent("named")

    MakeHauntableDropFirstItem(inst)
    AddHauntableCustomReaction(inst, function(inst, haunter)
        if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
            inst.components.hauntable.panic = true
            inst.components.hauntable.panictimer = TUNING.HAUNT_PANIC_TIME_SMALL
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
            return true
        end
        return false
    end, false, false, true)

    inst:SetStateGraph("SGchester")
    inst.sg:GoToState("idle")

    inst:SetBrain(brain)
    inst.AppleState = "NORMAL"
    --[[inst.MorphChester = MorphApple
    inst:WatchWorldState("isfullmoon", CheckForMorph)
    inst:ListenForEvent("onclose", CheckForMorph)]]
	inst.sounds = sounds
    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad

    return inst
end

return Prefab("common/apple", create_apple, assets, prefabs)