--Aftershock
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e0:SetValue(s.con)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
end
function s.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		local chk=tc:GetColumnZone(LOCATION_SZONE,0,0,tp)>>8
		if zone&chk==0 then
			zone=zone|chk
		end
	end
	return zone
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	Duel.Destroy(g,REASON_EFFECT)
end