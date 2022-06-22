--Horns of the Dragon
local s,id=GetID()
function s.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.val)
    c:RegisterEffect(e1)
    --defup
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --double damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
    c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*100
end