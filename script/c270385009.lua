--Field Promotion
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c,0)
    --make "vanguard"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_ADD_SETCODE)
    e1:SetValue(0x1388)
    c:RegisterEffect(e1)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetValue(s.xyzlv)
	c:RegisterEffect(e2)
end
function s.xyzlv(e,c,rc)
    if rc:IsSetCard(0x1388) then
        return 1,2,3,4,5,6,7,8,9,10,11,12,e:GetHandler():GetLevel()
    else
        return e:GetHandler():GetLevel()
    end
end