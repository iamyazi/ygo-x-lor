--Dami'yin the Unbound
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--attach cont s/t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.amcon)
	e1:SetTarget(s.amtg)
	e1:SetOperation(s.amop)
	c:RegisterEffect(e1)
	--change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetCountLimit(1)
    e2:SetCost(aux.dxmcostgen(2,2,nil))
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.reptg)
	c:RegisterEffect(e3)
    --pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
	--def
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
function s.amcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.amfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.amtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.amfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.amfilter,tp,LOCATION_GRAVE,0,1,99,nil)
end
function s.amop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=Duel.GetTargetCards(e)
    local tc=g:GetFirst()
	for tc in aux.Next(g) do
        if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
            Duel.Overlay(c,tc)
    	end
	end
end
function s.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function s.atkval(e,c)
	return c:GetOverlayCount()*300
end