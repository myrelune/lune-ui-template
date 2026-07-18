getgenv().debugMode = true
local Logger = require("./core/Logger")

local UIManager = require("./ui/UIManager")
UIManager.init("Template")

Logger.info("Script running!")