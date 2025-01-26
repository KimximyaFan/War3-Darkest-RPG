library UnitProperty requires UnitAttackSpeed

function Get_Unit_Property takes unit u, integer property returns integer
    return LoadInteger(HT, GetHandleId(u), property)
endfunction

function Set_Unit_Property takes unit u, integer property, integer value returns nothing
    call SaveInteger(HT, GetHandleId(u), property, value)
    
    if property == HP then
        call JNSetUnitMaxHP(u, value)
    elseif property == MP then
        call JNSetUnitMaxMana(u, value)
    elseif property == AS then
        call Set_Unit_Atk_Speed(u, value)
    elseif property == MS then
        call SetUnitMoveSpeed(u, value)
    endif
endfunction

endlibrary