--Trifarian Shieldbreaker
local s,id = GetID()
function s.initial_effect(c)
	--Link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	--destroy on summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
    e2:SetCondition(s.tdcon)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.dfilter(c)
	return c:GetColumnGroup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
	if chk==0 then return c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)>0 end
    local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if Duel.Destroy(g,REASON_EFFECT)<1 then return end
    for tc in aux.Next(Duel.GetOperatedGroup()) do
        if tc:IsType(TYPE_MONSTER) then
            zone=(2^tc:GetPreviousSequence())
        else
            zone=(2^tc:GetPreviousSequence())<<8
        end
        Debug.Message(zone)
        if tc:IsControler(tp) then
            zone=zone
        else
            zone=zone<<16
        end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE_FIELD)
        e1:SetRange(LOCATION_MZONE)
        e1:SetOperation(s.disop)
        e1:SetLabel(zone)
        c:RegisterEffect(e1,tp)
    end
end
function s.disop(e,tp)
	return e:GetLabel()
end