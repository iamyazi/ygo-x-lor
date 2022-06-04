--vaults of helia
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy to special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.desfilter(c,e,tp)
	return c:IsFaceup() and c:HasLevel() and not c:IsCode(270384004)
end
function s.spfilter(c,e,tp,maxlv)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,e,tp)
	local maxg=g:GetMaxGroup(Card.GetLevel)
	local maxlv=maxg:GetFirst():GetLevel()
    return c:IsLevel(maxlv+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,maxlv) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	if #g==0 then return end
	local maxg=g:GetMaxGroup(Card.GetLevel)
	local lv=maxg:GetFirst():GetLevel()
	if #maxg>1 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
		maxg=maxg:Select(tp,1,1,nil)
	end
	function s.ssfilter(c,e,tp)
		return c:IsLevel(lv+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	if Duel.Destroy(maxg,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local spg=Duel.SelectMatchingCard(tp,s.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #spg>0 then
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
			--make fiend
			local sstg=spg:GetFirst()
			c:SetCardTarget(sstg)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			--e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			--e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(RACE_FIEND)
			--e1:SetCondition(s.rcon)
			sstg:RegisterEffect(e1)
		end
	end
end
function s.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end