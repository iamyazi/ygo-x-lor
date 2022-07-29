--Xerath
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--suck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.suckcon)
	e1:SetTarget(s.sucktg)
	e1:SetOperation(s.suckop)
	c:RegisterEffect(e1)
	--shuffle to add helia
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(s.addcon)
	e5:SetTarget(s.addtg)
	e5:SetOperation(s.addop)
	c:RegisterEffect(e5)
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP)
	and c:IsPreviousControler(tp)
end
function s.suckcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sucktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end
function s.suckop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	local dg=g:GetMinGroup(Card.GetAttack)
	if #dg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		dg=dg:Select(tp,1,1,nil)
	end
	local tc=dg:GetFirst()
	if tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local c=e:GetHandler()
		local atk=math.ceil(tc:GetAttack()/2)
		local def=math.ceil(tc:GetDefense()/2)
		--Halve ATK/DEF
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3:SetValue(def)
		tc:RegisterEffect(e3)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			--Increase ATK/DEF
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(atk)
			c:RegisterEffect(e2)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			e4:SetValue(def)
			c:RegisterEffect(e4)
		end
	end
end
function s.filter(c)
	return c:IsCode(id) and c:IsFaceup()
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter2(c)
	return c:IsCode(270389001) and c:IsAbleToHand()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)
	and c:IsAbleToDeckAsCost() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local shuffle=Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
	if shuffle==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
