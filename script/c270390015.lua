--beyond the infinite
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp,rg,ft)
	return c:IsSetCard(0x384) and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and rg:CheckWithSumEqual(Card.GetLevel,lv,1,ft)
end
function s.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsControler(tp) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,e,tp,rg,ft)
	end
	local rg=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,rg,ft)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,rg,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if sg and #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,true,POS_FACEUP)
	end
--[[local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Release(rg,REASON_COST)
	if ft<=0 then return end
	local lv=rg:GetFirst():GetLevel()
	local sp=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,rg,lv,ft,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if rg:CheckWithSumEqual(Card.GetLevel,lv,1,ft) then
		local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,ft)
		Duel.SpecialSummon(rm,0,tp,tp,false,true,POS_FACEUP)
	end]]--
end
