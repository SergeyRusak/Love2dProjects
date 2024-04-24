Block = {}
Block.__index = Block

function Block:create(x, y)
    local block = {}
    setmetatable(block, Block)
    return block
end
