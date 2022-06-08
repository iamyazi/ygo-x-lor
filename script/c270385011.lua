--Gallant Rider
local s,id=GetID()
function s.initial_effect(c)
    --Xyz summon
    Xyz.AddProcedure(c,nil,4,2)
    c:EnableReviveLimit()
    
end
