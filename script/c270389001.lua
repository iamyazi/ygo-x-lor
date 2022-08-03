--Rite of the Arcane
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)	
end
function s.filter1(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local b1=Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(s.filter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
    local b2=Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
    if chk==0 then return b1 or b2 end
    local op=aux.SelectEffect(tp,
    {b1,aux.Stringid(id,0)},
    {b2,aux.Stringid(id,1)})
    e:SetLabel(op)
    if op==1 then
        if chkc then return false end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
        local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
    end
    if op==2 then
        if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
        Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
    end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local op=e:GetLabel()
    if op==1 then
        local tc=g:GetFirst()
        local sc=g:GetNext()
        if sc==e:GetLabelObject() then tc,sc=sc,tc end
        if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and sc:IsRelateToEffect(e) then
            Duel.Destroy(sc, REASON_EFFECT)
        end
    end
    if op==2 then
        local tc=g:GetFirst()
        if tc:IsRelateToEffect(e) then
            Duel.Destroy(tc, REASON_EFFECT)
        end
    end
end
