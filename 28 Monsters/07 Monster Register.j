library MonsterRegister requires UnitProperty, UnitAttackSpeed, MonsterGrade

function Apply_Monster_Property takes unit u returns nothing
    call SetUnitLifePercentBJ( u, 100 )
    call SetUnitManaPercentBJ( u, 100 )
endfunction

function Monster_Property_Register takes unit u, boolean is_grade returns nothing
    local integer unit_type_id = GetUnitTypeId(u)
    
    call Set_Unit_Property( u, AD, LoadInteger(HT, unit_type_id, AD) )
    call Set_Unit_Property( u, AP, LoadInteger(HT, unit_type_id, AP) )
    call Set_Unit_Property( u, AS, LoadInteger(HT, unit_type_id, AS) )
    call Set_Unit_Property( u, MS, LoadInteger(HT, unit_type_id, MS) )
    call Set_Unit_Property( u, CRIT, LoadInteger(HT, unit_type_id, CRIT) )
    call Set_Unit_Property( u, CRIT_COEF, LoadInteger(HT, unit_type_id, CRIT_COEF) )
    call Set_Unit_Property( u, ENHANCE_AD, LoadInteger(HT, unit_type_id, ENHANCE_AD) )
    call Set_Unit_Property( u, ENHANCE_AP, LoadInteger(HT, unit_type_id, ENHANCE_AP) )
    call Set_Unit_Property( u, DEF_AD, LoadInteger(HT, unit_type_id, DEF_AD) )
    call Set_Unit_Property( u, DEF_AP, LoadInteger(HT, unit_type_id, DEF_AP) )
    call Set_Unit_Property( u, HP, LoadInteger(HT, unit_type_id, HP) )
    call Set_Unit_Property( u, MP, LoadInteger(HT, unit_type_id, MP) )
    call Set_Unit_Property( u, REDUCE_AD, LoadInteger(HT, unit_type_id, REDUCE_AD) )
    call Set_Unit_Property( u, REDUCE_AP, LoadInteger(HT, unit_type_id, REDUCE_AP) )
    call Set_Unit_Property( u, LEVEL, LoadInteger(HT, unit_type_id, LEVEL) )
    call Set_Unit_Property( u, CLASS, LoadInteger(HT, unit_type_id, CLASS) )
    call Set_Unit_Property( u, REGION, LoadInteger(HT, unit_type_id, REGION) )
    
    if is_grade == true then
        call Set_Random_Monster_Grade(u)
        call Grade_Property(u, true)
    endif
    
    call Apply_Monster_Property(u)
endfunction

endlibrary