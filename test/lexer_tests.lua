-- Lexical analyzer unit tests
local luaunit = require("luaunit")
local Lexer = require("../src/lexer")

function test_lexer_identifiers()
    local lexer = Lexer:new("x y z variable_name")
    luaunit.assertEquals(lexer:get_next_token(), { type = "IDENTIFIER", value = "x" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "IDENTIFIER", value = "y" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "IDENTIFIER", value = "z" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "IDENTIFIER", value = "variable_name" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "EOF", value = nil })
end

function test_lexer_keywords()
    local lexer = Lexer:new("function if then else end while do return local")
    luaunit.assertEquals(lexer:get_next_token(), { type = "FUNCTION", value = "function" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "IF", value = "if" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "THEN", value = "then" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "ELSE", value = "else" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "END", value = "end" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "WHILE", value = "while" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "DO", value = "do" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "RETURN", value = "return" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "LOCAL", value = "local" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "EOF", value = nil })
end

function test_lexer_numbers()
    local lexer = Lexer:new("123 45.67 0.89")
    luaunit.assertEquals(lexer:get_next_token(), { type = "NUMBER", value = 123 })
    luaunit.assertEquals(lexer:get_next_token(), { type = "NUMBER", value = 45.67 })
    luaunit.assertEquals(lexer:get_next_token(), { type = "NUMBER", value = 0.89 })
    luaunit.assertEquals(lexer:get_next_token(), { type = "EOF", value = nil })
end

function test_lexer_operators()
    local lexer = Lexer:new("+ - * / =")
    luaunit.assertEquals(lexer:get_next_token(), { type = "PLUS", value = "+" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "MINUS", value = "-" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "MULTIPLY", value = "*" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "DIVIDE", value = "/" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "ASSIGN", value = "=" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "EOF", value = nil })
end

function test_lexer_punctuation()
    local lexer = Lexer:new("; , ( ) { }")
    luaunit.assertEquals(lexer:get_next_token(), { type = "SEMICOLON", value = ";" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "COMMA", value = "," })
    luaunit.assertEquals(lexer:get_next_token(), { type = "LPAREN", value = "(" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "RPAREN", value = ")" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "LBRACE", value = "{" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "RBRACE", value = "}" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "EOF", value = nil })
end

function test_lexer_complete_expression()
    local lexer = Lexer:new("x = 10 + 20 * 30;")
    luaunit.assertEquals(lexer:get_next_token(), { type = "IDENTIFIER", value = "x" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "ASSIGN", value = "=" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "NUMBER", value = 10 })
    luaunit.assertEquals(lexer:get_next_token(), { type = "PLUS", value = "+" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "NUMBER", value = 20 })
    luaunit.assertEquals(lexer:get_next_token(), { type = "MULTIPLY", value = "*" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "NUMBER", value = 30 })
    luaunit.assertEquals(lexer:get_next_token(), { type = "SEMICOLON", value = ";" })
    luaunit.assertEquals(lexer:get_next_token(), { type = "EOF", value = nil })
end

os.exit(luaunit.LuaUnit.run())
