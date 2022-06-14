--Bandle City Mayor
local s,id=GetID()
function s.initial_effect(c)
    --add to extra face up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    --scale change
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(s.cpscost)
	e2:SetTarget(s.cpstarget)
	e2:SetOperation(s.cpsoperation)
    c:RegisterEffect(e2)
    --rez
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.spcon)
	e4:SetCost(s.cpscost)
	e4:SetTarget(s.sptg)
    e4:SetOperation(s.spop)
    e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
function s.thfilter(c)
	return c:IsSetCard(0x1770) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local cg=sg1:Select(1-tp,1,1,nil)
		local tc=cg:GetFirst()
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
	end
end
function s.cpscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.cpstarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_PZONE,0,1,nil) end
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_PZONE,0,1,1,nil)
end
function s.getscale(c)
	if c == Duel.GetFieldCard(0,LOCATION_PZONE,0) or c == Duel.GetFieldCard(1,LOCATION_PZONE,0) then
		return c:GetLeftScale()
	else
		return c:GetRightScale()
	end
end
function s.cpsoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
		--Duel.HintSelection(Group.FromCards(tc))
		--Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
		local scale = s.getscale(tc)
		local opt = (scale <= 1) and 1 or 2
		if opt == 2 then
			opt = Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		else
			opt = Duel.SelectOption(tp,aux.Stringid(id,1))
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		if opt == 0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and not c:IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		--Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
