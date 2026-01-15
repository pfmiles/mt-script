-- Syntax parser
local Parser = {}

function Parser:new(lexer)
    local obj = { lexer = lexer, current_token = lexer:get_next_token() }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Parser:eat(token_type)
    if self.current_token.type == token_type then
        self.current_token = self.lexer:get_next_token()
    else
        error('Syntax error: expecting ' .. token_type .. ', but got ' .. self.current_token.type)
    end
end

function Parser:program()
    local nodes = {}
    while self.current_token.type ~= 'EOF' do
        table.insert(nodes, self:statement())
    end
    return { type = 'program', statements = nodes }
end

function Parser:statement()
    if self.current_token.type == 'IDENTIFIER' then
        return self:assignment_statement()
    elseif self.current_token.type == 'FUNCTION' then
        return self:function_definition()
    elseif self.current_token.type == 'IF' then
        return self:if_statement()
    elseif self.current_token.type == 'WHILE' then
        return self:while_statement()
    elseif self.current_token.type == 'RETURN' then
        return self:return_statement()
    else
        return self:expression_statement()
    end
end

function Parser:assignment_statement()
    local node = { type = 'assignment', left = { type = 'identifier', value = self.current_token.value } }
    self:eat('IDENTIFIER')
    self:eat('ASSIGN')
    node.right = self:expression()
    self:eat('SEMICOLON')
    return node
end

function Parser:function_definition()
    self:eat('FUNCTION')
    local node = { type = 'function_definition', name = self.current_token.value }
    self:eat('IDENTIFIER')
    self:eat('LPAREN')
    node.params = self:parameter_list()
    self:eat('RPAREN')
    self:eat('LBRACE')
    node.body = self:block()
    self:eat('RBRACE')
    return node
end

function Parser:if_statement()
    self:eat('IF')
    local node = { type = 'if_statement', condition = self:expression() }
    self:eat('THEN')
    node.consequence = self:block()
    if self.current_token.type == 'ELSE' then
        self:eat('ELSE')
        node.alternative = self:block()
    end
    self:eat('END')
    return node
end

function Parser:while_statement()
    self:eat('WHILE')
    local node = { type = 'while_statement', condition = self:expression() }
    self:eat('DO')
    node.body = self:block()
    self:eat('END')
    return node
end

function Parser:return_statement()
    self:eat('RETURN')
    local node = { type = 'return_statement' }
    if self.current_token.type ~= 'SEMICOLON' then
        node.expression = self:expression()
    end
    self:eat('SEMICOLON')
    return node
end

function Parser:expression_statement()
    local node = { type = 'expression_statement', expression = self:expression() }
    self:eat('SEMICOLON')
    return node
end

function Parser:block()
    local nodes = {}
    while self.current_token.type ~= 'RBRACE' and self.current_token.type ~= 'END' and self.current_token.type ~= 'ELSE' do
        table.insert(nodes, self:statement())
    end
    return { type = 'block', statements = nodes }
end

function Parser:parameter_list()
    local params = {}
    if self.current_token.type ~= 'RPAREN' then
        local param = { type = 'identifier', value = self.current_token.value }
        table.insert(params, param)
        self:eat('IDENTIFIER')
        while self.current_token.type == 'COMMA' do
            self:eat('COMMA')
            param = { type = 'identifier', value = self.current_token.value }
            table.insert(params, param)
            self:eat('IDENTIFIER')
        end
    end
    return params
end

function Parser:expression()
    return self:equality_expression()
end

function Parser:equality_expression()
    local left = self:comparison_expression()
    return left
end

function Parser:comparison_expression()
    local left = self:addition_expression()
    return left
end

function Parser:addition_expression()
    local left = self:multiplication_expression()
    while self.current_token.type == 'PLUS' or self.current_token.type == 'MINUS' do
        local token = self.current_token
        if token.type == 'PLUS' then
            self:eat('PLUS')
        else
            self:eat('MINUS')
        end
        left = { type = 'binary_operation', left = left, operator = token.type, right = self:multiplication_expression() }
    end
    return left
end

function Parser:multiplication_expression()
    local left = self:primary_expression()
    while self.current_token.type == 'MULTIPLY' or self.current_token.type == 'DIVIDE' do
        local token = self.current_token
        if token.type == 'MULTIPLY' then
            self:eat('MULTIPLY')
        else
            self:eat('DIVIDE')
        end
        left = { type = 'binary_operation', left = left, operator = token.type, right = self:primary_expression() }
    end
    return left
end

function Parser:primary_expression()
    local token = self.current_token
    if token.type == 'NUMBER' then
        self:eat('NUMBER')
        return { type = 'number', value = token.value }
    elseif token.type == 'IDENTIFIER' then
        self:eat('IDENTIFIER')
        return { type = 'identifier', value = token.value }
    elseif token.type == 'LPAREN' then
        self:eat('LPAREN')
        local expr = self:expression()
        self:eat('RPAREN')
        return expr
    end
    error('Syntax error: unknown expression type')
end

return Parser
