--deep meditation
local s,id=GetID()
function s.initial_effect(c)
	--count spells
    aux.GlobalCheck(s,function()
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_CHAINING)
        e3:SetOperation(s.regop)
        Duel.RegisterEffect(e3,0)
	end)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_SPELL) and Duel.GetTurnCount()%2==0 then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_END,0,2)
	elseif re:IsActiveType(TYPE_SPELL) and Duel.GetTurnCount()%2~=0 then
		Duel.RegisterFlagEffect(ep,id+1,RESET_PHASE+PHASE_END,0,2)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()%2~=0 then
		return Duel.GetFlagEffect(tp,id)>=2
	elseif Duel.GetTurnCount()%2==0 then
		return Duel.GetFlagEffect(tp,id+1)>=2
	end
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=6
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg3:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg4=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg4:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg5=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg5:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg6=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		sg1:Merge(sg4)
		sg1:Merge(sg5)
		sg1:Merge(sg6)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local cg=sg1:Select(1-tp,2,2,nil)
		--local tc=cg:GetFirst()
		Duel.SendtoHand(cg,tp,REASON_EFFECT)
	end
end
