--Aloof Travelers
local s,id=GetID()
function s.initial_effect(c)
    --pendulum summon
    Pendulum.AddProcedure(c)
    --pend eff
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.dcon)
	e1:SetTarget(s.dtg)
	e1:SetOperation(s.dop)
	c:RegisterEffect(e1)
    --monster eff
    --draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id)
	e2:SetTarget(s.drawtg)
	e2:SetOperation(s.drawop)
    c:RegisterEffect(e2)
    --handes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.hdcon)
	e3:SetTarget(s.hdtg)
    e3:SetOperation(s.hdop)
    c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x1770)
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if #g==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
