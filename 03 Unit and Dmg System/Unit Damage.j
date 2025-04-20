library UnitDamage requires UnitProperty

// 크리, 공격 타입에 따라 딜줌
function Unit_Dmg_Target takes unit u, unit target, real dmg, boolean dmg_type returns real
    local integer def_ad = Get_Unit_Property(target, DEF_AD)
    local integer def_ap = Get_Unit_Property(target, DEF_AP)
    local integer reduce_ad = Get_Unit_Property(target, REDUCE_AD)
    local integer reduce_ap = Get_Unit_Property(target, REDUCE_AP)
    local integer ran = GetRandomInt(1, 100)
    local boolean is_crit = false
    
    //call BJDebugMsg("Unit_Dmg_Target : " + R2S(dmg))
    
    if ran <= Get_Unit_Property(u, CRIT) then
        set is_crit = true
        set dmg = dmg * ( (100.0 + Get_Unit_Property(u, CRIT_COEF)) / 100.0 )
    endif
    
    if dmg_type == AD_TYPE then
        set dmg = (((100.0 - reduce_ad) / 100.0) * dmg) - def_ad
    elseif dmg_type == AP_TYPE then
        set dmg = (((100.0 - reduce_ap) / 100.0) * dmg) - def_ap
    endif
    
    if dmg < 1 then
        set dmg = 1
    endif

    // 물리 노크리
    if dmg_type == AD_TYPE and is_crit == false then
        call UnitDamageTargetBJ( u, target, dmg, ATTACK_TYPE_SIEGE, DAMAGE_TYPE_NORMAL )
    
    // 마법 노크리
    elseif dmg_type == AP_TYPE and is_crit == false then
        call UnitDamageTargetBJ( u, target, dmg, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL )
    
    // 물리 크리
    elseif dmg_type == AD_TYPE and is_crit == true then
        call UnitDamageTargetBJ( u, target, dmg, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_NORMAL )
            
    // 마법 크리
    elseif dmg_type == AP_TYPE and is_crit == true then
        call UnitDamageTargetBJ( u, target, dmg, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL )
    endif
    
    return dmg
endfunction

// 영웅의 물리피해강화, 마법피해강화, 공격력, 주문력을 활용
function Get_Unit_Dmg takes unit u, real base_dmg, real coef, boolean dmg_type returns real
    local integer ad = Get_Unit_Property(u, AD)
    local integer ap = Get_Unit_Property(u, AP)
    local integer enhance_ad = Get_Unit_Property(u, ENHANCE_AD)
    local integer enhance_ap = Get_Unit_Property(u, ENHANCE_AP)
    
    if dmg_type == AD_TYPE then
        return ((100 + enhance_ad) / 100) * ( base_dmg + (coef * ad) )
    else
        return ((100 + enhance_ap) / 100) * ( base_dmg + (coef * ap) )
    endif
endfunction

// 그냥 공격력 주문력에 계수 곱한 값만 따오는 것
function Get_Coef_Dmg takes unit u, real coef, boolean dmg_type returns real
    local integer ad = Get_Unit_Property(u, AD)
    local integer ap = Get_Unit_Property(u, AP)
    
    if dmg_type == AD_TYPE then
        return coef * ad
    else
        return coef * ap
    endif
endfunction

endlibrary