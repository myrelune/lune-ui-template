local __DARKLUA_BUNDLE_MODULES={cache={}::any}do do local function __modImpl()local Logger = {
	info = function(...)
		if not getgenv().debugMode then
			return
		end

		local args = { ... }

		task.spawn(function()
			for i, v in ipairs(args) do
				args[i] = tostring(v)
			end

			local msg = table.concat(args, "\t") .. "\n"
			
            print(msg)
		end)
	end,

	warn = function(...)
		if not getgenv().debugMode then
			return
		end

		local args = { ... }
        
		task.spawn(function()
			for i, v in ipairs(args) do
				args[i] = tostring(v)
			end

			local msg = "[!] " .. table.concat(args, "\t") .. "\n"
			
            warn(msg)
		end)
	end,
}

return Logger
end function __DARKLUA_BUNDLE_MODULES.a():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end do local function __modImpl()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/myrelune/LuneUI/refs/heads/main/Library.lua"))()
return Library end function __DARKLUA_BUNDLE_MODULES.b():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.b if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end return v.c end end do local function __modImpl()
local TabsRegistry = {}
TabsRegistry._tabs = {}

function TabsRegistry.register(name, factory, iconName, order)
	TabsRegistry._tabs[#TabsRegistry._tabs + 1] = {
		name = name,
		factory = factory,
		iconName = iconName,
		order = order or 999
	}
end

function TabsRegistry.getAll()
	table.sort(TabsRegistry._tabs, function(a, b) return a.order < b.order end)
	return TabsRegistry._tabs
end

function TabsRegistry.buildAll(window)
	for _, tabDef in ipairs(TabsRegistry.getAll()) do
		local tabObj = window:AddTab(tabDef.name, tabDef.iconName)
		if tabDef.factory then
			tabDef.factory(tabObj)
		end
	end
end

return TabsRegistry end function __DARKLUA_BUNDLE_MODULES.c():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.c if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c end end do local function __modImpl()
local function build(tab) 
    local TemplateSection = tab:AddSection("Template")

	TemplateSection:AddSlider({
		Name = "Player Walkspeed",
		Min = 1,
		Max = 1000,
		Default = 16,
		Flag = "PlayerWalkSpeed",
		Callback = function(value)
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = value
		end,
	})
end

return {build = build}end function __DARKLUA_BUNDLE_MODULES.d():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function __modImpl()
local Library = __DARKLUA_BUNDLE_MODULES.b()
local TabsRegistry = __DARKLUA_BUNDLE_MODULES.c()
local Logger = __DARKLUA_BUNDLE_MODULES.a()

local UIManager = {}

function UIManager.init(name)
	config = {}
	config.Title = "Lune"
	config.Size = config.Size or UDim2.fromOffset(600, 450)
	config.ConfigFolder = "LuneConfigs/" .. name
	config.ConfigName = "config"

	local window = Library:CreateWindow(config)
	if not window then
		Logger.warn("[UIManager] Failed to create window")
		return nil
	end

	TabsRegistry.register("Template", __DARKLUA_BUNDLE_MODULES.d().build, "play")

	TabsRegistry.buildAll(window)

	local tabs = TabsRegistry.getAll()
	if tabs[1] then
		window:SelectTab(tabs[1].name)
	end

	UIManager._window = window
	return window
end

function UIManager.getWindow()
	return UIManager._window
end

return UIManager end function __DARKLUA_BUNDLE_MODULES.e():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end end
getgenv().DebugMode = true
local Logger = __DARKLUA_BUNDLE_MODULES.a()

local UIManager = __DARKLUA_BUNDLE_MODULES.e()
UIManager.init("Template")

Logger.info("Script running!")