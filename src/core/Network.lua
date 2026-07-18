local servs = require("./Services")
local Logger = require("./Logger")

local Network = {
    Knit = nil,
    _servicesCache = {},
    _remoteToServiceMap = {}, -- Maps "ToLobby" -> "WaveService"
    _mapped = false
}

-- Private Helper: Lazy-load Knit
local function getKnit()
    if Network.Knit then return Network.Knit end
    
    local packages = servs.ReplicatedStorage:FindFirstChild("Packages")
    local knitModule = packages and packages:FindFirstChild("Knit") or packages:FindFirstChild("knit")
    
    if knitModule then
        local success, knit = pcall(require, knitModule)
        if success then
            Network.Knit = knit
            return knit
        end
    end
    
    Logger.error("Network: Knit could not be found or required!")
    return nil
end

-- Private Helper: Automatically maps every remote name to its respective service
local function mapRemotes()
    if Network._mapped then return end
    
    local knitFolder = servs.ReplicatedStorage:FindFirstChild("Knit")
    local servicesFolder = knitFolder and knitFolder:FindFirstChild("Services")
    
    if not servicesFolder then
        -- If Knit hasn't fully started yet, we can't map. 
        -- It will run again automatically on the next network call.
        return 
    end

    for _, serviceFolder in ipairs(servicesFolder:GetChildren()) do
        local serviceName = serviceFolder.Name
        
        -- Knit groups remotes into RF (Functions) and RE (Events) folders
        for _, folderName in ipairs({ "RE", "RF" }) do
            local folder = serviceFolder:FindFirstChild(folderName)
            if folder then
                for _, remote in ipairs(folder:GetChildren()) do
                    Network._remoteToServiceMap[remote.Name] = serviceName
                end
            end
        end
    end
    
    Network._mapped = true
end

-- Private Helper: Safely gets a Knit service on the client
local function getService(serviceName)
    if Network._servicesCache[serviceName] then
        return Network._servicesCache[serviceName]
    end
    
    local knit = getKnit()
    if knit then
        local success, service = pcall(function()
            return knit.GetService(serviceName)
        end)
        if success and service then
            Network._servicesCache[serviceName] = service
            return service
        end
    end
    
    Logger.warn("Network: Could not find Knit service:", serviceName)
    return nil
end

-- Private Helper: Finds which service owns a specific remote/method name
local function getServiceByRemoteName(remoteName)
    mapRemotes() -- Ensure our map is up to date
    
    local serviceName = Network._remoteToServiceMap[remoteName]
    if not serviceName then
        -- Fallback: If it's a direct method and not an event, we can scan active cached services
        Logger.warn(("Network: Could not automatically resolve service for remote '%s'. Make sure Knit has started."):format(remoteName))
        return nil
    end
    
    return getService(serviceName)
end

--------------------------------------------------------------------------------
-- PUBLIC API
--------------------------------------------------------------------------------

-- Automatically finds the service and connects to the event
-- Usage: Network.Connect("GetNewBlessing", function(blessing) ... end)
function Network.Connect(eventName, callback)
    local service = getServiceByRemoteName(eventName)
    if service and service[eventName] then
        return service[eventName]:Connect(callback)
    end
    Logger.warn(("Network: Failed to connect to event '%s'"):format(eventName))
    return nil
end

-- Automatically finds the service and fires the event/method
-- Usage: Network.Fire("ToLobby")
function Network.Fire(eventName, ...)
    local service = getServiceByRemoteName(eventName)
    if service and service[eventName] then
        if type(service[eventName]) == "table" and service[eventName].Fire then
            service[eventName]:Fire(...)
            return true
        elseif type(service[eventName]) == "function" then
            task.spawn(service[eventName], service, ...)
            return true
        end
    end
    Logger.warn(("Network: Could not fire remote '%s'"):format(eventName))
    return false
end

-- Automatically finds the service and invokes the method (returns server response)
-- Usage: local path = Network.Invoke("GetNewPath")
function Network.Invoke(methodName, ...)
    local service = getServiceByRemoteName(methodName)
    if service and service[methodName] then
        local success, result = pcall(service[methodName], service, ...)
        if success then
            return result
        else
            Logger.warn(("Network: Error invoking '%s' -> %s"):format(methodName, tostring(result)))
        end
    end
    return nil
end

-- Returns a Knit Controller by name
-- Usage: local uiController = Network.GetController("UIController")
function Network.GetController(controllerName)
    local knit = getKnit()
    if knit then
        local success, controller = pcall(function()
            return knit.GetController(controllerName)
        end)
        if success and controller then
            return controller
        end
    end
    Logger.warn("Network: Could not find Knit controller:", controllerName)
    return nil
end

return Network