-- Lexical analyzer
local Lexer = {}

function Lexer:new(input)
    local obj = { input = input, pos = 1, current_char = input:sub(1, 1) }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Lexer:advance()
    self.pos = self.pos + 1
    if self.pos > #self.input then
        self.current_char = nil
    else
        self.current_char = self.input:sub(self.pos, self.pos)
    end
end

function Lexer:skip_whitespace()
    while self.current_char ~= nil and self.current_char:match('%s') do
        self:advance()
    end
end

function Lexer:get_next_token()
    while self.current_char ~= nil do
        if self.current_char:match('%s') then
            self:skip_whitespace()
            goto continue
        end

        ::continue::
        end

        if self.current_char:match('[a-zA-Z]') then
            return self:read_identifier()
        end

        if self.current_char:match('[0-9]') then
            return self:read_number()
        end

        local token = nil

        if self.current_char == '+' then
            token = { type = 'PLUS', value = '+' }
        elseif self.current_char == '-' then
            token = { type = 'MINUS', value = '-' }
        elseif self.current_char == '*' then
            token = { type = 'MULTIPLY', value = '*' }
        elseif self.current_char == '/' then
            token = { type = 'DIVIDE', value = '/' }
        elseif self.current_char == '(' then
            token = { type = 'LPAREN', value = '(' }
        elseif self.current_char == ')' then
            token = { type = 'RPAREN', value = ')' }
        elseif self.current_char == '=' then
            token = { type = 'ASSIGN', value = '=' }
        elseif self.current_char == ';' then
            token = { type = 'SEMICOLON', value = ';' }
        elseif self.current_char == ',' then
            token = { type = 'COMMA', value = ',' }
        elseif self.current_char == '{' then
            token = { type = 'LBRACE', value = '{' }
        elseif self.current_char == '}' then
            token = { type = 'RBRACE', value = '}' }
        end

        if token then
            self:advance()
            return token
        end

        error('Unknown character: ' .. self.current_char)
    end

    return { type = 'EOF', value = nil }
end

function Lexer:read_identifier()
    local result = ''
    while self.current_char ~= nil and self.current_char:match('[a-zA-Z0-9_]') do
        result = result .. self.current_char
        self:advance()
    end

    -- Check for keywords
    local keywords = {
        ['if'] = 'IF',
        ['then'] = 'THEN',
        ['else'] = 'ELSE',
        ['end'] = 'END',
        ['while'] = 'WHILE',
        ['do'] = 'DO',
        ['function'] = 'FUNCTION',
        ['return'] = 'RETURN',
        ['local'] = 'LOCAL'
    }

    if keywords[result] then
        return { type = keywords[result], value = result }
    else
        return { type = 'IDENTIFIER', value = result }
    end
end

function Lexer:read_number()
    local result = ''
    while self.current_char ~= nil and self.current_char:match('[0-9]') do
        result = result .. self.current_char
        self:advance()
    end

    if self.current_char == '.' then
        result = result .. '.'
        self:advance()
        while self.current_char ~= nil and self.current_char:match('[0-9]') do
            result = result .. self.current_char
            self:advance()
        end
        return { type = 'NUMBER', value = tonumber(result) }
    end

    return { type = 'NUMBER', value = tonumber(result) }
end

return Lexer
