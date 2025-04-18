library ItemPicked requires EquipAPI, Base, DroppedItem

private function Random_Equip_Picked takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local item the_item = GetManipulatedItem()
    local integer item_type = GetItemTypeId(the_item)
    local integer check
    local real x = GetItemX(the_item)
    local real y = GetItemY(the_item)
    local integer w0 = 0
    local integer w1 = 0
    local integer w2 = 0
    local integer w3 = 0
    local integer w4 = 0
    
    if item_type == 'I000' then
        set w0 = 100
    elseif item_type == 'I001' then
        set w1 = 100
    elseif item_type == 'I002' then
        set w2 = 100
    elseif item_type == 'I003' then
        set w3 = 100
    elseif item_type == 'I004' then
        set w4 = 100
    endif
    
    set check = Create_Random_Equip(pid, w0, w1, w2, w3, w4, 0, 100)

    if check == -1 then
        call Random_Equip_Item_Drop(null, x, y, w0, w1, w2, w3, w4, 100, 1)
    endif
    
    call RemoveItem(the_item)
    
    set u = null
    set the_item = null
endfunction

private function Random_Equip_Picked_Con takes nothing returns boolean
    if GetItemTypeId(GetManipulatedItem()) == 'I000' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I001' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I002' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I003' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I004' then
        return true
    endif
    
    return false
endfunction

function Item_Picked_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( trg, Condition( function Random_Equip_Picked_Con ) )
    call TriggerAddAction( trg, function Random_Equip_Picked )
    
    set trg = null
endfunction

endlibrary