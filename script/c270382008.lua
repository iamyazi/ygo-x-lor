--rummage
local s,id=GetID()
function s.initial_effect(c)
	--active
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--in grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.drawcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.drawtg)
	e2:SetOperation(s.drawop)
	c:RegisterEffect(e2)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,2,nil)
	local discard=Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	if discard==0 then return end
	Duel.Draw(tp,discard,REASON_EFFECT)
end
function s.drawfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.drawfilter,1,nil,tp) and aux.exccon(e)
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

