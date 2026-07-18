local clonegetserv = clonefunction and clonefunction(game.GetService) or game.GetService
local cloneref = cloneref and (clonefunction and clonefunction(cloneref) or cloneref) or function(x) return x end

local servs = setmetatable({}, {
    __index = function(s, n)
        s[n] = cloneref(clonegetserv(game, n))
        return s[n]
    end
})

return servs