--ゾディアックＳ
--Zodiac Sign
--Scripted by Eerie code
function c675319.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf2))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--at limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c675319.atlimit)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c675319.reptg)
	e5:SetValue(c675319.repval)
	e5:SetOperation(c675319.repop)
	c:RegisterEffect(e5)
end

function c675319.atkfil(c,atk)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and c:GetAttack()>atk
end
function c675319.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and Duel.IsExistingMatchingCard(c675319.atkfil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetAttack())
end

function c675319.repfilter(c,tp,e)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0xf2) and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(675319)==0
end
function c675319.desfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND)
		and c:IsType(TYPE_MONSTER) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c675319.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c675319.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
		and eg:IsExists(c675319.repfilter,1,nil,tp,e) and e:GetHandler():GetFlagEffect(675319)==0 end
	if Duel.SelectYesNo(tp,aux.Stringid(675319,0)) then
		local g=eg:Filter(c675319.repfilter,nil,tp,e)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c675319.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
		Duel.HintSelection(tg)
		Duel.SetTargetCard(tg)
		tg:GetFirst():RegisterFlagEffect(675319,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
		tg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c675319.repval(e,c)
	return c==e:GetLabelObject()
end
function c675319.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	e:GetHandler():RegisterFlagEffect(675319,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end