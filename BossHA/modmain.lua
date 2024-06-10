GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})

-- Modifying Toadstool's health and attack damage with server-side restrictions

local health_ratio = GetModConfigData("health_ratio")
local damage_ratio = GetModConfigData("damage_ratio")
local patch_opt = GetModConfigData("patch_opt")

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
local monster_list = {}


local function ModSetHeathAndAttack(health_ratio,damage_ratio,patch_opt)
    for key, value in pairs(TUNING) do
        if type(value) == "number" and value >= patch_opt and string.match(key, "HEALTH$") then
            table.insert(monster_list, key)
            if key ~= "WILSON_HEALTH" then

                TUNING[key] = value * health_ratio

                local key = key:gsub("HEALTH$", "DAMAGE")
                if TUNING[key] then
                    if type(TUNING[key]) == "number" and math.floor(value) == value then
                        TUNING[key] = TUNING[key] * damage_ratio
                    elseif type(TUNING[key]) == "table" then
                        for k, v in pairs(TUNING[key]) do
                            if type(v) == "number" and math.floor(v) == v then
                                TUNING[key][k] = v * damage_ratio
                            end                        
                        end
                    end
                end

            end

        end
    end


    for _, monster in ipairs(monster_list) do
        print("monster:", monster)
    end
end

if GetModConfigData("patch_opt") ~= 0 then
    ModSetHeathAndAttack(health_ratio,damage_ratio,patch_opt)
end
--------------------------------------------------------------------------------------------------------
