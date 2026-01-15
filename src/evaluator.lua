-- the evaluator, executes the abstract syntax tree (AST)

-- Interpreter
local Interpreter = {}

function Interpreter:new()
    local obj = { environment = {} }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Interpreter:interpret(ast)
    if ast.type == 'program' then
        return self:execute_program(ast)
    else
        error('Unknown AST type')
    end
end

function Interpreter:execute_program(program)
    local last_value = nil
    for _, statement in ipairs(program.statements) do
        last_value = self:execute_statement(statement)
    end
    return last_value
end

function Interpreter:execute_statement(statement)
    if statement.type == 'assignment' then
        return self:execute_assignment(statement)
    elseif statement.type == 'function_definition' then
        return self:execute_function_definition(statement)
    elseif statement.type == 'if_statement' then
        return self:execute_if_statement(statement)
    elseif statement.type == 'while_statement' then
        return self:execute_while_statement(statement)
    elseif statement.type == 'return_statement' then
        return self:execute_return_statement(statement)
    elseif statement.type == 'expression_statement' then
        return self:evaluate_expression(statement.expression)
    end
    error('Unknown statement type')
end

function Interpreter:execute_assignment(assignment)
    local value = self:evaluate_expression(assignment.right)
    self.environment[assignment.left.value] = value
    return value
end

function Interpreter:execute_function_definition(func_def)
    local func = {
        type = 'function',
        name = func_def.name,
        params = func_def.params,
        body = func_def.body
    }
    self.environment[func_def.name] = func
    return func
end

function Interpreter:execute_if_statement(if_stmt)
    local condition_value = self:evaluate_expression(if_stmt.condition)
    if condition_value then
        return self:execute_block(if_stmt.consequence)
    elseif if_stmt.alternative then
        return self:execute_block(if_stmt.alternative)
    end
    return nil
end

function Interpreter:execute_while_statement(while_stmt)
    while self:evaluate_expression(while_stmt.condition) do
        local result = self:execute_block(while_stmt.body)
        if result ~= nil and result.type == 'return' then
            return result
        end
    end
    return nil
end

function Interpreter:execute_return_statement(return_stmt)
    local value = nil
    if return_stmt.expression then
        value = self:evaluate_expression(return_stmt.expression)
    end
    return { type = 'return', value = value }
end

function Interpreter:execute_block(block)
    for _, statement in ipairs(block.statements) do
        local result = self:execute_statement(statement)
        if result ~= nil and result.type == 'return' then
            return result
        end
    end
    return nil
end

function Interpreter:evaluate_expression(expression)
    if expression.type == 'number' then
        return expression.value
    elseif expression.type == 'identifier' then
        return self.environment[expression.value]
    elseif expression.type == 'binary_operation' then
        return self:evaluate_binary_operation(expression)
    end
    error('Unknown expression type')
end

function Interpreter:evaluate_binary_operation(bin_op)
    local left = self:evaluate_expression(bin_op.left)
    local right = self:evaluate_expression(bin_op.right)

    if bin_op.operator == 'PLUS' then
        return left + right
    elseif bin_op.operator == 'MINUS' then
        return left - right
    elseif bin_op.operator == 'MULTIPLY' then
        return left * right
    elseif bin_op.operator == 'DIVIDE' then
        return left / right
    end
    error('Unknown binary operator')
end

return Interpreter
