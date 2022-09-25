--Starshaping
local s,id=GetID()
function s.initial_effect(c)
    Ritual.AddProcGreater(c,s.ritual_filter)
	--change position
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.bfgcost)
    e1:SetTarget(s.rectg)
    e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
end
s.listed_series={0x384}
function s.ritual_filter(c)
	return c:IsRitualMonster() and c:IsLevelAbove(7) and c:IsSetCard(0x384)
end
function s.recfilter(c)
	return c:IsSetCard(0x384) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.recfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.recfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end