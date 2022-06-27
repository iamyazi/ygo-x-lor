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
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_END_PHASE)
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
    local g1=Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
    e:SetLabelObject(g2:GetFirst())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetTargetCards(e)
	if #g<2 then return end
	local tc=g:GetFirst()
    local oc=g:GetNext()
    if oc==e:GetLabelObject() then tc,oc=oc,tc end
    local atk=oc:GetBaseAttack()
    local def=oc:GetBaseDefense()
	if not (tc:IsFaceup() and oc:IsFaceup()) then return end
	if Duel.Equip(tp,oc,tc) then
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
        oc:RegisterEffect(e1)
        --sp sum equipped back to owner
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
        e2:SetCode(EFFECT_DESTROY_REPLACE)
        e2:SetTarget(s.reptg)
        oc:RegisterEffect(e2)
        --atkdown
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_EQUIP)
        e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        e3:SetValue(-atk)
        oc:RegisterEffect(e3)
        --defdown
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        e4:SetValue(-def)
        oc:RegisterEffect(e4)
    end
end
function s.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) end
    local tg=c:GetEquipTarget()
    if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP) and Duel.Destroy(tg, REASON_EFFECT) then
    return false
    else return true end
end
