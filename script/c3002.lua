--tall tales
local s,id=GetID()
function s.initial_effect(c)
	--excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.ssfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xBB8)
end
function s.cfilter(c)
	return c:IsCode(3000)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ss,mz=Duel.IsExistingMatchingCard(s.ssfilter,tp,LOCATION_MZONE,0,1,nil),Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ss,mz=Duel.IsExistingMatchingCard(s.ssfilter,tp,LOCATION_MZONE,0,1,nil),Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if #g>0 then
		if ss and mz and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		else
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end