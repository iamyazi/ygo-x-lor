--tail
local s,id=GetID()
function s.initial_effect(c)
    --when recalled, shuffle to add
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)    
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetCountLimit(1,id)
	e2:SetCondition(s.mcon)
	e2:SetTarget(s.mtg)
	e2:SetOperation(s.mop)
	c:RegisterEffect(e2)
	--destroy def pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
function s.filter(c)
	return c:IsCode(270387001) and c:IsAbleToHand()
end
function s.mcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and c:IsAbleToDeckAsCost() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local shuffle=Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
	if shuffle==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and d:IsDefensePos() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
