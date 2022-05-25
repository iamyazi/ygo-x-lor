--biggest fan
local s,id=GetID()
function s.initial_effect(c)
	--stack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--flip (recycle)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.operation2)
	c:RegisterEffect(e3)
end

s.listed_names={270381000}
function s.filter(c)
	return c:IsCode(270381000)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==2 then
		Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_HAND)
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 0, tp, 1)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()   
	--hg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if op==1 then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	elseif op==2 then
		Duel.SendtoDeck(Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil),tp,1,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end

s.listed_names={1001}
function s.filter2(c)
	return c:IsCode(1001) and c:IsAbleToDeck()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter2(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg~=2 or Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=2 then return end
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==2 then
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end