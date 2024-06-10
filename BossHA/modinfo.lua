name = "Hp&ATK setting"
description = "custom the boss health and attack"
author = "tiny rain"

version = "1.0.1"
api_version_dst = 10
forumthread = ""

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

server_only_mod = true
client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 0
mod_dependencies = {}
server_filter_tags = {"boss","health","damage","毒菌蟾蜍","血量调整","攻击力调整"}


local function title(str)
    return { name = "", label = str, hover = "", options = {{description = "", data = false}}, default = false }
end

local function setConfig(name, title, options, default, desc)
    local _options = {}
    for i=1,#options  do
        _options[i] = {
            description = options[i][1],
            data = options[i][2],
            hover = options[i][3]
        }
    end
    options = _options

    return { name = name, label = title, hover = desc, options = options, default = default }
end


configuration_options = {
    setConfig(
        "patch_opt", "作用于used to", 
        {
            {"关闭OFF", 0}, {"Boss", 1500}, {"Epic Boss", 10000}, {"Shit Boss", 50000}
        }, 0, 
        [[
            Boss果蝇王以上；Epic Boss诸如远古犀牛的万血boss；Shit Boss 毒菌蟾蜍
            Boss: stronger than Fruit Flies Lord...;
            Epic Boss: like Ancient Guardian;
            Shit Boss: Toadstool
        ]]
    ),
    
    title("血量相关"),
	setConfig("health_ratio", "Health",
        {   
            {"50%", .5}, {"75%", .75}, {"100%", 1}, {"125%", 1.25}, {"150%", 1.5}, {"200%", 2}, {"300%", 3}
        }, 1, 
        "该选项调整生物的血量为原基础的 x %"
    ),
	
    title("攻击力相关"),
    setConfig("damage_ratio", "Attack",
        {   
            {"50%", .5}, {"75%", .75}, {"100%", 1}, {"125%", 1.25}, {"150%", 1.5}, {"200%", 2}
        }, 1, 
        "该选项调整生物的伤害为原基础的 x %"
    ),

}