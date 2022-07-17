--Rex
local s,id=GetID()
function s.initial_effect(c)
	--trib summ eff
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (r&REASON_EFFECT~=0 and rp~=ep) or r&REASON_BATTLE~=0 then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,id)~=0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,5)
end
function s.filter(c,tp)
    return c:IsInExtraMZone(1-tp)
  end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local p,dmg=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    for i = 1,7,1
    do
        local d=Duel.TossDice(tp,1)
        local card=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5-d)
        local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,tp)
        if d==6 then

        end
        if card then
            Duel.Destroy(card,REASON_EFFECT)
        elseif d==6 and #g~=0 then
            local tc=g:GetFirst()
            for tc in aux.Next(g) do
                Duel.Destroy(tc,REASON_EFFECT)
            end
        else
            Duel.Damage(p,dmg,REASON_EFFECT)
        end
    end
end