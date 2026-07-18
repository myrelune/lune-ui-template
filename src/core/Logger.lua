local Logger = {
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
