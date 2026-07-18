local Library = require("./Library")
local TabsRegistry = require("./TabsRegistry")
local Logger = require("../core/Logger")

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

	TabsRegistry.register("Template", require("./Tabs/TemplateTab").build, "play")

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

return UIManager