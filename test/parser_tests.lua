-- Test runner script
-- Load LuaUnit test framework
package.path = package.path .. ";./test/?.lua"
local luaunit = require("luaunit")

-- Load all test files
local test_files = {
    "test_lexer.lua",
    "test_parser.lua",
    "test_interpreter.lua"
}

for _, file in ipairs(test_files) do
    if io.open("./test/" .. file, "r") then
        require(file:gsub("%.lua$", ""))
    else
        print("Warning: Test file " .. file .. " does not exist")
    end
end

-- Run tests
os.exit(luaunit.LuaUnit.run())
