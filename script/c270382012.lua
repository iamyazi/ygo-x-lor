--Thermogenic Beam
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,spellcount)
    return c:GetDefense()<=(spellcount*500) and c:IsFaceup()
end
function s.spellfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local sg=Duel.GetMatchingGroup(s.spellfilter,tp,LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and s.filter(chkc,#sg) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,#sg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,#sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(s.spellfilter,tp,LOCATION_GRAVE,0,nil)
    local tc=Duel.GetFirstTarget()
    local cost=math.floor(tc:GetDefense()/500)+1
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and #sg>=cost then
        local g=Duel.GetMatchingGroup(s.spellfilter,tp,LOCATION_GRAVE,0,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end