--[[
使用过程中出现问题或有建议反馈，欢迎联系qq1261005633
风幻龙由老熊绘图，小北制作。另外感谢steam平台BoredPlayer13的反馈和支持。
感谢各位的支持。
Problems appeared in the process of using or any Suggestions feedback, welcome to contact Tencent qq1261005633.
In here ,Thinks for BoredPlayer13's feedback and support.
Thank you for your support,bless you.
]]
name = "Syelza风幻龙--"
description = "略微调低了一点点属性，宝具只能专属"
author = "颠三倒四"
version = "1.0.2"

forumthread = ""

api_version = 6
api_version_dst = 10

dst_compatible = true 

dont_starve_compatible = false
reign_of_giants_compatible = false 
shipwrecked_compatible = false  

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
	"character",
}

configuration_options =
{
	{
		name = "fhl_cos",
		label = "符文结晶爆率",
		hover = "Drop probability of The Ancient soul",
		options =	
		{
			{description = "5%(default)", data = .05},
			{description = "7%", data = .07},
			{description = "10%", data = .1},
		},

		default = .05,
	},
	
	{
	    name = "zzj_fireopen",
		label = "配剑火焰特效:",
		hover = "The Golden wujing's fire effect",
		options = 
		{
			{description = "open", data = true},
			{description = "close(default)", data = false},
		},
		default = false,
	},
	
	{
	    name = "zzj_pre",
		label = "配剑特效伤害百分比:",
		hover = "The Golden wujing's Damage percentage",
		options = 
		{
			{description = "50%", data = .5},
		    {description = "100%(default)", data = 1},
			{description = "150%", data = 1.5},
		},
		default = 1,
	},
	
	{
	    name = "openlight",
		label = "幻儿自己会发光吗:",
		hover = "Can Syelza herself shine?",
		options = 
		{
		    {description = "yes", data = true},
			{description = "no(default)", data = false},
		},
		default = false,
	},
	
	{
	    name = "likeornot",
		label = "About the apple",
		options = 
		{
		    {description = "big", data = true},
			{description = "normal(df)", data = false},
		},
		default = false,
	},

	{
		name = "zzj_finiteuses",
		label = "配剑耐久度:",
		hover = "The Golden wujing's finiteuses",
		options =
		{
			{description = "120", data = 120},
			{description = "210(default)", data = 210},
			{description = "300", data = 300},
			--{description = "420", data = 420},
			--{description = "endless", data = 0},
		},
		default = 210,
	},
	
	{
		name = "openli",
		label = "狗箱发光",
		hover = "Can the apple(chester) shine?",
		options =	
		{
			{description = "yes", data = true},
			{description = "no(default)", data = false},
		},

		default = false,
	}
}