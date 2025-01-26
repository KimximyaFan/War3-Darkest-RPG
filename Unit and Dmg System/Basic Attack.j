library BasicAttack requires Base, UnitDamage

function Basic_Attack takes unit u, unit target, attacktype attack_type returns nothing
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local boolean dmg_type 
    local real dmg
    
    // 평타가 물리인지 마법인지 판별 ( 이 맵에서는 일반이 물리고, 관통이 마법임 )
    if attack_type == ConvertAttackType(AD_BASIC_ATTACK) then
        set dmg_type = AD_TYPE
    elseif attack_type == ConvertAttackType(AP_BASIC_ATTACK) then
        set dmg_type = AP_TYPE
    else
        // 평타 아님
        return
    endif
    
    // 공격력 or 주문력 그리고 물리뎀증 or 마법뎀증 까지 계산한 값을 받아옴
    set dmg = Get_Unit_Dmg(u, 0, 1.0, dmg_type)
    
    // 딜넣음
    call Unit_Dmg_Target( u, target, dmg, dmg_type)
endfunction

endlibrary
