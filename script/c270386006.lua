--Rissu, The Silent Storm
local s,id=GetID()
function s.initial_effect(c)
    --pendulum summon
    Pendulum.AddProcedure(c)
    --pend eff
	--Add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(s.ctop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(s.ccon)
    e2:SetCountLimit(99)
    c:RegisterEffect(e2)
    --summon stormcloud
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
    --monster eff
    --return and change battle position
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.postg)
	e4:SetOperation(s.posop)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e4)
end
function s.ccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCanAddCounter(0x1776,1) then
		c:AddCounter(0x1776,1)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local c=e:GetHandler()
    local atk = c:GetCounter(0x1776)*400
    if Duel.Destroy(c,REASON_EFFECT)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,atk,0,1,RACE_THUNDER,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,id+1)
        if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
            --set atk
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_BASE_ATTACK)
            e1:SetValue(atk)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            token:RegisterEffect(e1)
            --cannot be tributed
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(3304)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_UNRELEASABLE_SUM)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
            e2:SetValue(1)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            token:RegisterEffect(e2,true)
            --double damage
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
            e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
            token:RegisterEffect(e3)
            Duel.SpecialSummonComplete()
        end
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and c:IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK) and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
