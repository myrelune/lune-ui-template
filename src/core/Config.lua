local Config = {}
Config._registry = {}

function Config.register(systemName, defaults)
    defaults = defaults or {}

    local entry = Config._registry[systemName]
    if not entry then
        entry = {
            defaults = defaults,
            current = {}
        }
        Config._registry[systemName] = entry
    end

    for k, v in pairs(defaults) do
        if entry.current[k] == nil then
            entry.current[k] = v
        end
    end

    return entry.current
end

function Config.get(systemName)
    return Config._registry[systemName] and Config._registry[systemName].current or {}
end

function Config.set(systemName, settingsTable)
    local entry = Config._registry[systemName]
    if not entry then return false end

    for key, value in pairs(settingsTable) do
        if entry.defaults[key] == nil then
            error(("Unknown config key '%s' for '%s'"):format(key, systemName))
        end
        
        entry.current[key] = value
    end

    return true
end

function Config.reset(systemName)
    local entry = Config._registry[systemName]
    if not entry then return end

    entry.current = {}

    for k, v in pairs(entry.defaults) do
        entry.current[k] = v
    end
end

-- Usage in a system:
-- local cfg = Config.register("Placement", { defaultStrategy = "smart", autoEnabled = true })
-- cfg.defaultStrategy --> "smart"
-- Config.set("Placement", {defaultStrategy = "macro"})
-- Config.set("Placement", {defaultStrategy = "macro", autoEnabled = false})

return Config