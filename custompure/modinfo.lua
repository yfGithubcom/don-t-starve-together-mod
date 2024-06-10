name = "PureMod"
description = [[
你可以按自己的喜好修改
1 冰箱和盐盒的保鲜效果(增强or返鲜)
2 雪球机的运行时间 或者 加入更少的燃料让其到达上限
3 月台附近将生成一颗曼德拉草，这只在月圆生效，防止曼草汤的意外
4 皮弗娄牛和电羊数量过低时过一段时间会重生，该时间可以设置但无法用trim跳天数跳过
5 高鸟巢、猎犬丘和蛞蝓窝将会在被破坏后的一段时间后再生
防止多人游玩存档时造成部分生物灭绝
You can modify it as you like
1 Preservation effect of fridge and salt box (up or return fresh)
2 firesuppressor's worktime and add less fuel to it
3 A mandrake will be generated near moonbase, it only works during a full moon
4 beefalo and lightninggoat will trigger respawn, you can set the wait time
5 tallbird nest, hound mound and slurtlehole which is destroyed will regenerate after some time
Prevent some creatures to be extincted when multiplayerFile is saved
]]
author = "tiny rain"
version = "1.0.4"
forumthread = ""
api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dont_starve_compatible = true
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
server_only_mod = true
client_only_mod = false
all_clients_require_mod = true
server_filter_tags = {"雪球机","冰箱","盐盒","返鲜","再生","曼德拉","纯净mod","firesuppressor","icebox","fridge","refresh","respawn","mandrake","hound","pure"}

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
	{
		name = "rotspeed_fridge",
		label = "Fridge keep fresh",
		hover = [[
			冰箱的保鲜效果提高
			improve the fresh-keeping effect of fridge
		]],
		options = {
			{description = "off", data = 0.5},
			{description = "+50%", data = 0.33},
			{description = "+100%", data = 0.25},
			{description = "+400%", data = 0.1},
			{description = "never rot", data = 0},
			{description = "refresh", data = -0.5},
		},
		default = 0.5,
	},
	{
		name = "rotspeed_saltbox",
		label = "Saltbox keep fresh",
		hover = [[
			盐盒的保鲜效果提高
			improve the fresh-keeping effect of saltbox
		]],
		options = {
			{description = "off", data = 0.25},
			{description = "+50%", data = 0.165},
			{description = "+100%", data = 0.125},
			{description = "+400%", data = 0.05},
			{description = "never rot", data = 0},
			{description = "refresh", data = -1},
		},
		default = 0.25,
	},

	{
		name = "firesuppressor_max_time",
		label = "Firesuppressor max worktime",
		hover = "雪球机(满燃料状态下)的最大工作时间",
		options = {
			{description = "off", data = 5},
			{description = "+100%", data = 10},
			{description = "+300%", data = 20},
			{description = "very long", data = 999999},
		},
		default = 5,
	},
	{
		name = "firesuppressor_fuel_bonusmult",
		label = "Firesuppressor fuel bonusmult",
		hover = [[
			会改变雪球机的燃料效率(base 5x)，你只需放入相对较少的燃料
			a piece of charcoal can use one minute => two minutes or more
		]],
		options = {
			{description = "off", data = 5},
			{description = "+100%(10X)", data = 10},
			{description = "+300%(20X)", data = 20},
		},
		default = 5,
	},

	{
		name = "respawn_mandrake_switch",
		label = "Mandrake respawn",
		hover = [[
			当月圆时，月台附近将随机生成一颗曼德拉草
			a mandrake will respawn on fullmoon beside the moonbase
		]],
		options = {
			{description = "off", data = 0},
			{description = "on", data = 1},
		},
		default = 0,
	},

	title("species protection"),
	setConfig("protect_switch", "protection",
		{
			{"off", 0}, {"on", 1}
		}, 0,
		[[
			保护濒危生物，除非它们已经灭绝了，开启该开关使以下设置生效
			protect endangered species unless they're already extinct!
			Turn on this switch to make the following Settings make effects
		]]
	),
	setConfig("respawn_time", "respawn time",
		{
			{"after 1 day", 1}, {"after 3 day", 3}, {"after 7 day", 7}
		}, 1,
		[[
			再生需要消耗的时间
			the time waiting for respawn
		]]
	),

	title("species kinds"),
	setConfig("beefalo", "beefalo", {{"off", 0}, {"on", 1}}, 0, "皮弗娄牛 beefalo"),
	setConfig("lightninggoat", "lightninggoat", {{"off", 0}, {"on", 1}}, 0, "伏特羊 lightninggoat"),

	setConfig("houndmound", "houndmound", {{"off", 0}, {"on", 1}}, 0, "猎犬丘 houndmound"),
	setConfig("slurtlehole", "slurtlehole", {{"off", 0}, {"on", 1}}, 0, "蛞蝓龟窝 slurtlehole"),

	setConfig("tallbirdnest", "tallbirdnest", {{"off", 0}, {"on", 1}}, 0, "高脚鸟巢 tallbirdnest"),
}

