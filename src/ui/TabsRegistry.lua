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

return TabsRegistry