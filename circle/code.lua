Coder = {}
Coder.__index = Coder

function Coder:create()
    local coder = {}
    coder.codes = {}
    coder.codes["A"]=7
    coder.codes["B"]=14
    coder.codes["C"]=21
    coder.codes["D"]=28
    setmetatable(coder, Coder)
    return coder
end
function Coder:encode(text)
    print(text)
    local empty = 360
    local tempcode = {}
    for i = 1, string.len(text) do
        local c = string.sub(text,i,i)
        local t = self.codes[c]
        empty = empty-t
        table.insert(tempcode,t)
    end
    local result = {}
    for i,t in pairs(tempcode) do
        table.insert(result,t)
        table.insert(result,empty / string.len(text))
    end
    return result
end