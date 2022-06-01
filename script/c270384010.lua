--the second death
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.AddProcGreater(c,s.ritualfil,nil,nil,s.extrafil)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
function s.ritualfil(c)
	return c:IsCode(270384009)
end
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) 
		and c:HasLevel() 
		and c:IsRace(RACE_FIEND)
		and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
end
