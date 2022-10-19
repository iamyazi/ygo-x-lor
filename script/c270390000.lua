--Supercool Starchart
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreater(c,s.ritual_filter)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_series={0x384}
function s.ritual_filter(c)
	return c:IsRitualMonster() and c:IsLevelBelow(3) and c:IsSetCard(0x384)
end
function s.thfilter(c)
	return c:IsSetCard(0x384) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then return end
	local rg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp,rg)
	local tg=rg:RandomSelect(1-tp,1)
	local tc=tg:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	rg:RemoveCard(tc)
	Duel.SendtoGrave(rg,REASON_EFFECT)
end
