--Succession
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_ATTACK+TIMING_BATTLE_START)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
end
s.listed_names={270385003}
function s.filter(c,e,tp)
	return c:IsCode(270385003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.equipfilter(c,e,tp)
    return aux.HasListedSetCode(c,0x1388) and c:IsType(TYPE_EQUIP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end

    if Duel.IsExistingMatchingCard(s.equipfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.SelectYesNo(tp,aux.Stringid(id,0)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        eq=Duel.SelectMatchingCard(tp,s.equipfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        local ec=eq:GetFirst()
        Duel.Equip(tp,ec,tc)
    end
end