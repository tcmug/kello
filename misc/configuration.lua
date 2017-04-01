
local json = require("json")

module = {}

function module:get(key, default)

    if not self.configuration then
        local base = system.pathForFile("kello-config.json", system.DocumentsDirectory)
        local configuration = {}
        local file = io.open( base, "r" )
        if file then
            local jsoncontents = file:read( "*a" )
            print(jsoncontents)
            self.configuration = json.decode(jsoncontents)
            io.close( file )
        end

        if self.configuration == nil then
            self.configuration = {}
        end
    end

    if self.configuration[key] ~= nil then
        return self.configuration[key]
    end

    return default
end

function module:set(key, value)

    if self.configuration then
        self.configuration[key] = value
    else
        self.configuration = {
            key = value
        }
    end

    local base = system.pathForFile("kello-config.json", system.DocumentsDirectory)
    local file = io.open(base, "w")

    if file then
        local contents = json.encode(self.configuration)
        print(contents)
        file:write( contents )
        io.close( file )
    end
end

return module
