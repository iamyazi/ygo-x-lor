--Spirit Journey
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
        tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,1))
        e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetCondition(s.retcon)
        e1:SetOperation(s.sumop)
        Duel.RegisterEffect(e1,tp)  
    end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    local tg=e:GetLabelObject()
    Duel.SpecialSummon(tg,0,tg:GetControler(),tg:GetControler(),false,false,POS_FACEUP)
end