--Yordle Explorer
local s,id=GetID()
function s.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,nil,2,nil,s.spcheck)
	--Add from Deck to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
    c:RegisterEffect(e1)
    --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.tgtg)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
end
function s.spcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetRace,lc,sumtype,tp)
end
function s.thcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function s.thfilter1(c,tp)
    local ls=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetScale()
    local rs=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetScale()
    if ls<rs then
        return c:IsSetCard(0x1770) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() 
            and c:GetLevel()>ls and c:GetLevel()<rs
    else
        return c:IsSetCard(0x1770) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() 
        and c:GetLevel()<ls and c:GetLevel()>rs
    end
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) and not
        (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.atkfilter(c)
    return c:IsFaceup() and c:GetRace()~=0
end
function s.atkval(e,c)
    local gr=Duel.GetMatchingGroup(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
    local ct=gr:GetClassCount(Card.GetRace)
    return ct*300
end
function s.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x1770) 
end