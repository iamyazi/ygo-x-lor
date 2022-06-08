--Detain
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToChangeControler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(s.cfilter,tp,0,LOCATION_MZONE,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sc=g:GetFirst()
    local tc=g:GetNext()
    if sc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        s.equipop(sc,e,tp,tc)
    end
end
function s.equipop(c,e,tp,sc)
    local atk=sc:GetBaseAttack()
    local def=sc:GetBaseDefense()
    if not aux.EquipByEffectAndLimitRegister(c,e,tp,sc,nil,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(true)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    sc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetTarget(s.reptg)
	--e2:SetOperation(s.repop)
    sc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetValue(-atk)
    sc:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    e4:SetValue(-def)
    sc:RegisterEffect(e4)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
    local c=e:GetHandler()
    local tg=c:GetEquipTarget()
    if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP) and Duel.Destroy(tg, REASON_EFFECT) then
    return false
	else return true end
end
--[[
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) end
    return true
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=c:GetEquipTarget()
    Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
    Duel.Destroy(tg, REASON_EFFECT)
end