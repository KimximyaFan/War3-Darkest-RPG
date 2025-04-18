
library BuyEquip requires EquipAPI

// part가 0이라면 랜덤템
private function Create_Equip takes integer pid, integer grade, integer part returns integer
    local integer result
    
    if grade == 0 then
        set result = Create_Random_Equip(pid, 100, 0, 0, 0, 0, part, 100)
    elseif grade == 1 then
        set result = Create_Random_Equip(pid, 0, 100, 0, 0, 0, part, 100)
    elseif grade == 2 then
        set result = Create_Random_Equip(pid, 0, 0, 100, 0, 0, part, 100)
    elseif grade == 3 then
        set result = Create_Random_Equip(pid, 0, 0, 0, 100, 0, part, 100)
    elseif grade == 4 then
        set result = Create_Random_Equip(pid, 0, 0, 0, 0, 100, part, 100)
    endif
    
    return result
endfunction

private function Buy_Equip takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )
    local integer grade
    local integer result
    local integer refund_gold
    
    if GetItemTypeId(GetManipulatedItem()) == 'I005' then
        set result = Create_Equip(pid, 0, 0)
        set refund_gold = 20
    elseif GetItemTypeId(GetManipulatedItem()) == 'I006' then
        set result = Create_Equip(pid, 1, 0)
        set refund_gold = 200
    elseif GetItemTypeId(GetManipulatedItem()) == 'I007' then
        set result = Create_Equip(pid, 2, 0)
        set refund_gold = 2000
    elseif GetItemTypeId(GetManipulatedItem()) == 'I008' then
        set result = Create_Equip(pid, 3, 0)
        set refund_gold = 20000
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00D' then
        set result = Create_Random_Equip(pid, 100, 0, 0, 0, 0, 2, 100)
        set refund_gold = 180
    endif
    
    call RemoveItem(GetManipulatedItem())
    
    if result == -1 then
        call AdjustPlayerStateBJ( refund_gold, Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    endif
    
    set u = null
endfunction

private function Random_Equip_Bought_Con takes nothing returns boolean
    if GetItemTypeId(GetManipulatedItem()) == 'I005' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I006' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I007' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I008' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00D' then
        return true
    endif
    
    return false
endfunction

//===========================================================================
function Buy_Equip_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( trg, Condition( function Random_Equip_Bought_Con ) )
    call TriggerAddAction( trg, function Buy_Equip )
    
    set trg = null
endfunction

endlibrary
