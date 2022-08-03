--Risen Altar
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x388)
	--counter on act
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--remove counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.rcop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE_COUNTER+0x388)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.tgcon)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
    --sum dami'yin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.sumtg)
	e3:SetOperation(s.sumop)
	c:RegisterEffect(e3)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	e:GetHandler():AddCounter(0x388,3)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsCanRemoveCounter(tp,0x388,1,REASON_EFFECT) then
		c:RemoveCounter(tp,0x388,1,REASON_EFFECT)
		Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+0x388,e,REASON_EFFECT,tp,tp,1)
	end
end
function s.filter(c,e,tp)
	return c:IsCode(id-1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x388)==0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) end
end
