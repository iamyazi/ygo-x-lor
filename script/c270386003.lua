--Yordle Newbie
local s,id=GetID()
function s.initial_effect(c)
    --pendulum summon
    Pendulum.AddProcedure(c)
    --pend eff
	--add from extra
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con)
	e1:SetTarget(s.pendtg)
	e1:SetOperation(s.pendop)
    c:RegisterEffect(e1)
    --monster eff
    --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
    e2:SetCondition(s.con)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.pfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1770) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.pendtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function s.pendop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    if Duel.Destroy(e:GetHandler(), REASON_EFFECT)~=0 then
        local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(1400)
    c:RegisterEffect(e2)
end