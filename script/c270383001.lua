--avarosan trapper
local s,id=GetID()
function s.initial_effect(c)
	--excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end

s.listed_names={270383000}
function s.filter(c)
	return c:IsCode(270383000)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToDeck,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(s.filter,nil)
	if ct>0 then
		local yeti=g:Filter(s.filter, nil):GetFirst()
		Duel.MoveSequence(yeti,0)
		Duel.ConfirmDecktop(tp,1)
		g:RemoveCard(yeti)
		Duel.MoveToDeckBottom(g,tp)
		Duel.SortDeckbottom(tp,tp,4)
	else 
		Duel.MoveToDeckBottom(g,tp)
		Duel.SortDeckbottom(tp,tp,5)
	end
end