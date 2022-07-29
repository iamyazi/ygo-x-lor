--Make It Rain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DICE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --set on dmg
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DAMAGE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCondition(s.damcon)
    e2:SetTarget(s.damtg)
    e2:SetOperation(s.damop)
    c:RegisterEffect(e2)
end
s.roll_dice=true
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
	return true
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    local ct={1,2,3,4,5,6}
    local op=Duel.AnnounceNumber(tp,table.unpack(ct))
    e:SetLabel(op)
    Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,5)
end
function s.filter(c,tp)
    return c:IsInExtraMZone(1-tp)
  end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,dmg=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    local op=e:GetLabel()
    for i = 1,7,1
    do
        local d=Duel.TossDice(tp,1)
        local card=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5-d)
        if d==op then
            Duel.Damage(p,dmg,REASON_EFFECT)
        end
        if d==6 then
            local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,tp)
            local tc=g:GetFirst()
            if #g>0 then
                for tc in aux.Next(g) do
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_UPDATE_ATTACK)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    e1:SetValue(-400)
                    tc:RegisterEffect(e1)
                    if not tc:IsType(TYPE_LINK) then
                        local e2=e1:Clone()
                        e2:SetCode(EFFECT_UPDATE_DEFENSE)
                        tc:RegisterEffect(e2)
                    end
                end
            end
        end
        if card then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e1:SetValue(-400)
            card:RegisterEffect(e1)
            if not card:IsType(TYPE_LINK) then
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                card:RegisterEffect(e2)
            end
        end
    end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	--return ep~=tp and rp==tp
    return (r&REASON_EFFECT~=0 and rp~=ep) or r&REASON_BATTLE~=0
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		--Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end