GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})


-------------------------------------------------------------------------------------------------------

TUNING.PERISH_FRIDGE_MULT = GetModConfigData("rotspeed_fridge")

TUNING.PERISH_SALTBOX_MULT = GetModConfigData("rotspeed_saltbox")

-------------------------------------------------------------------------------------------------------

TUNING.FIRESUPPRESSOR_MAX_FUEL_TIME = TUNING.TOTAL_DAY_TIME*GetModConfigData("firesuppressor_max_time")

local function modfiresuppressor(inst)
	local fuel_bonusmult = GetModConfigData("firesuppressor_fuel_bonusmult")
	if inst.components.fueled then
		inst.components.fueled.bonusmult = fuel_bonusmult
	end
end

AddPrefabPostInit("firesuppressor", modfiresuppressor)

-------------------------------------------------------------------------------------------------------

local function mandrakerespawn(inst)
    inst:DoTaskInTime(0, function()
        if TheWorld.state.isfullmoon then
            inst:DoTaskInTime(math.random(TUNING.NIGHT_TIME_DEFAULT-1), function()
                local pos = Vector3(inst.Transform:GetWorldPosition())
                local respawn_pos
                local angle = math.random() * 2 * PI
                local offset = FindWalkableOffset(pos, angle, math.random(8, 12), 16, false, true, NoHoles)
                if offset then respawn_pos = pos + offset end
                if respawn_pos then SpawnAt("mandrake_planted",respawn_pos) end
            end)
        end
    end)
end

local function modmoonbase(inst)
    if TheWorld.ismastersim then
	    inst:WatchWorldState("isfullmoon", mandrakerespawn)
    end
end

if GetModConfigData("respawn_mandrake_switch") == 1 then
    AddPrefabPostInit("moonbase",modmoonbase)
end

-------------------------------------------------------------------------------------------------------

local respawn_time =  GetModConfigData("respawn_time") * TUNING.TOTAL_DAY_TIME
local creatures_list = {"beefalo","lightninggoat"}
local nest_list = {"houndmound","slurtlehole","tallbirdnest"}

-------------------------------------------------------------------------------------------------------

local function nest_respawn(prefabname, respawn_time)
    local function GetTileTypeAtPosition(x, z)
        local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
        return tile
    end

    local function FindSameTileTypePosition(x, z)
        local tile_type = GetTileTypeAtPosition(x, z)
        local offset

        repeat
            offset = FindWalkableOffset(Vector3(x, 0, z), math.random() * 2 * PI, 6, 12, true, false)
            if offset then
                local new_x, new_z = x + offset.x, z + offset.z
                if GetTileTypeAtPosition(new_x, new_z) == tile_type then
                    return new_x, new_z
                end
            end
        until not offset

        return nil, nil
    end

    local function OnEntityDestroyed(inst)
        if TheWorld.ismastersim then
            local x, y, z = inst.Transform:GetWorldPosition()
            TheWorld:DoTaskInTime(respawn_time, function()
                local new_x, new_z = FindSameTileTypePosition(x, z)

                if new_x and new_z then
                    local new_nest = SpawnPrefab(inst.prefab)
                    new_nest.Transform:SetPosition(new_x, y, new_z)
                end
            end)
        end
    end

    AddPrefabPostInit(prefabname, function(inst)
        inst:ListenForEvent("onremove", OnEntityDestroyed)
    end)
end

-------------------------------------------------------------------------------------------------------

local function near_respawn(prefabname, respawn_time)
    AddPrefabPostInit(prefabname, function(inst)
        inst:ListenForEvent("death", function(inst)
            if TheWorld.ismastersim then
                local death_pos = Vector3(inst.Transform:GetWorldPosition())
                local nearby_prefab = TheSim:FindEntities(death_pos.x, death_pos.y, death_pos.z, 1000, {prefabname})
                if #nearby_prefab - 1 < 3 then
                    TheWorld:DoTaskInTime(respawn_time, function()
                        local angle = math.random() * 2 * PI
                        local offset = FindWalkableOffset(death_pos, angle, math.random(4, 8), 16, false, true, NoHoles)
                        if offset then
                            local respawn_pos = death_pos + offset
                            if respawn_pos then
                                SpawnPrefab(prefabname).Transform:SetPosition(respawn_pos.x, respawn_pos.y, respawn_pos.z)
                            end
                        end
                    end)
                end
            end
        end)   
    end)
end

-------------------------------------------------------------------------------------------------------
if GetModConfigData("protect_switch") == 1 then
    for index, prefabname in pairs(nest_list) do
        if GetModConfigData(prefabname) == 1 then
            nest_respawn(prefabname, respawn_time)
        end
    end

    for index, prefabname in pairs(creatures_list) do
        if GetModConfigData(prefabname) == 1 then
            near_respawn(prefabname, respawn_time)
        end
    end
end

