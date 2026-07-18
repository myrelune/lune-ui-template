local servs = require("../../core/Services")

local function build(tab)
    local TemplateSection = tab:AddSection("Template")

	TemplateSection:AddSlider({
		Name = "Player Walkspeed",
		Min = 1,
		Max = 1000,
		Default = 16,
		Flag = "PlayerWalkSpeed",
		Callback = function(value)
            local humanoid = servs.Players.LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = value
		end,
	})
end

return {build = build}