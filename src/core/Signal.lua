local Signals = {}
Signals._listeners = {}

local function safeCall(callback, ...)
    local success, err = pcall(callback, ...)
    if not success then
        task.spawn(error, "Error in event listener: " .. tostring(err), 2)
    end
end

function Signals.on(eventName, callback)
    if not Signals._listeners[eventName] then
        Signals._listeners[eventName] = {}
    end
    
    Signals._listeners[eventName][callback] = true
    
    return function()
        if Signals._listeners[eventName] then
            Signals._listeners[eventName][callback] = nil
            if not next(Signals._listeners[eventName]) then
                Signals._listeners[eventName] = nil
            end
        end
    end
end

function Signals.fire(eventName, ...)
    local list = Signals._listeners[eventName]
    if not list then return end
    
    local listenersToFire = {}
    for cb in pairs(list) do
        table.insert(listenersToFire, cb)
    end
    
    for _, cb in ipairs(listenersToFire) do
        safeCall(cb, ...)
    end
end

function Signals.once(eventName, callback)
    local unsubscribe
    local fired = false
    
    unsubscribe = Signals.on(eventName, function(...)
        if fired then return end
        fired = true
        unsubscribe()
        callback(...)
    end)
    
    return unsubscribe
end

return Signals