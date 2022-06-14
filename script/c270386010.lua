--Wizened Wizard
local s,id=GetID()
function s.initial_effect(c)
    --pendulum summon
    Pendulum.AddProcedure(c)
    --pend eff
	--lv change on summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LVCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.pcon)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --monster eff
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(s.mcon)
	e3:SetTarget(s.mtg)
    e3:SetOperation(s.mop)
    c:RegisterEffect(e3)
end
function s.filter(c,tp)
    return c:IsSummonPlayer(tp)
end
function s.tgfilter(c,e)
    return c:IsFaceup() and c:HasLevel()
end
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return eg:IsContains(chkc) and s.filter(chkc,e,1-tp) end
    if chk==0 then return Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_MZONE, 0, 1, nil,e) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil,e)
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,tc,1,0,0)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local op=0
		if tc:IsLevel(1) then
			op=Duel.SelectOption(tp,aux.Stringid(id,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if op==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
	end
end
function s.mcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
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
function s.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetFirstTarget()
    --Duel.HintSelection(Group.FromCards(tc))
    --Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
    local scale = s.getscale(tg)
    local opt = (scale <= 1) and 1 or 2
    if opt == 2 then
        opt = Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
    else
        opt = Duel.SelectOption(tp,aux.Stringid(id,2))
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
    tg:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_RSCALE)
    tg:RegisterEffect(e2)
end