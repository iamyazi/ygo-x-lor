--Homecoming
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)	
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
    e:SetLabelObject(g1:GetFirst())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
    local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local sc=g:GetNext()
    if sc==e:GetLabelObject() then tc,sc=sc,tc end
    if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)~=0 and sc:IsRelateToEffect(e) then
        Duel.SendtoHand(sc,sc:GetPreviousControler(),REASON_EFFECT)
    end
end
