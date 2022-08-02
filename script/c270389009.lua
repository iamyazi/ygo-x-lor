--Obelisk of Power
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x388)
	--counter on act
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--remove counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.rcop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE_COUNTER+0x388)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.tgcon)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
    --buff on destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.activate2)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,1,nil)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	    Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():IsFaceup() then
        e:GetHandler():AddCounter(0x388,3)
    end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
	end
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsCanRemoveCounter(tp,0x388,1,REASON_EFFECT) then
		c:RemoveCounter(tp,0x388,1,REASON_EFFECT)
		Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+0x388,e,REASON_EFFECT,tp,tp,1)
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x388)==0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
	end
end