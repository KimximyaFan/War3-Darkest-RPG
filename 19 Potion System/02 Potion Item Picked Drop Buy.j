library PotionItem requires PotionFrame, Basic

globals
    private integer refund_gold = 60
endglobals

private function Potion_Buy_Full_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local integer is_health_potion = S2I( JNStringSplit(str, "/", 1) )
    
    if is_health_potion == 1 then
        call AdjustPlayerStateBJ( refund_gold, Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    else
        call AdjustPlayerStateBJ( refund_gold-10, Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    endif
    
    
endfunction

private function Potion_Pick_Full_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local integer is_health_potion = S2I( JNStringSplit(str, "/", 1) )
    local unit u = player_hero[pid].Get_Hero_Unit()
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    
    if is_health_potion == 1 then
        call Item_Count_Down(CreateItem('I009', x, y), 45)
    else
        call Item_Count_Down(CreateItem('I00A', x, y), 45)
    endif
    
    set u = null
endfunction

private function Local_Potion_Buy_Check takes integer pid, boolean is_health_potion returns nothing
    if GetLocalPlayer() == Player(pid) then
        if is_health_potion == true then
            if health_potion_count < POTION_LIMIT then
                set health_potion_count = health_potion_count + 1
                call Health_Potion_Frame_Refresh()
            else
                call BJDebugMsg("힐링포션 꽉참")
                call DzSyncData("p_refund", I2S(pid) + "/" + I2S(1))
            endif
        else
            if mana_potion_count < POTION_LIMIT then
                set mana_potion_count = mana_potion_count + 1
                call Mana_Potion_Frame_Refresh()
            else
                call BJDebugMsg("마나포션 꽉참")
                call DzSyncData("p_refund", I2S(pid) + "/" + I2S(0))
            endif
        endif
    endif
endfunction

private function Potion_Bought takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId( GetOwningPlayer(u) )

    
    if GetItemTypeId(GetManipulatedItem()) == 'I00B' then
        call Local_Potion_Buy_Check(pid, true)
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00C' then
        call Local_Potion_Buy_Check(pid, false)
    endif
    
    call RemoveItem(GetManipulatedItem())
    
    set u = null
endfunction

// dropped_item 은 기본적으로 null을 기입
function Potion_Drop takes real x, real y, real probability, item dropped_item returns item
    local integer ran = GetRandomInt(1, 100)
    
    if GRR(0, 1) > probability / 100 then
        return null
    endif

    if ran <= 50 then
        set dropped_item = CreateItem('I009', x, y)
    else
        set dropped_item = CreateItem('I00A', x, y)
    endif
    
    call Item_Count_Down(dropped_item, 45)
    
    return dropped_item
endfunction

private function Local_Potion_Pick_Check takes integer pid, boolean is_health_potion returns nothing
    if GetLocalPlayer() == Player(pid) then
        if is_health_potion == true then
            if health_potion_count < POTION_LIMIT then
                set health_potion_count = health_potion_count + 1
                call Health_Potion_Frame_Refresh()
            else
                call BJDebugMsg("힐링포션 꽉참")
                call DzSyncData("po_drop", I2S(pid) + "/" + I2S(1))
            endif
        else
            if mana_potion_count < POTION_LIMIT then
                set mana_potion_count = mana_potion_count + 1
                call Mana_Potion_Frame_Refresh()
            else
                call BJDebugMsg("마나포션 꽉참")
                call DzSyncData("po_drop", I2S(pid) + "/" + I2S(0))
            endif
        endif
    endif
endfunction

private function Potion_Picked takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer pid = GetPlayerId(GetOwningPlayer(u))
    local item the_item = GetManipulatedItem()
    local integer item_type = GetItemTypeId(the_item)
    local boolean is_health_potion = true
    local real x = GetItemX(the_item)
    local real y = GetItemY(the_item)
    
    if item_type == 'I009' then
        set is_health_potion = true
    elseif item_type == 'I00A' then
        set is_health_potion = false
    endif

    call Local_Potion_Pick_Check(pid, is_health_potion)
    
    call RemoveItem(the_item)
    
    set u = null
    set the_item = null
endfunction

private function Potion_Bought_Con takes nothing returns boolean
    if GetItemTypeId(GetManipulatedItem()) == 'I00B' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00C' then
        return true
    endif
    
    return false
endfunction

private function Potion_Picked_Con takes nothing returns boolean
    if GetItemTypeId(GetManipulatedItem()) == 'I009' then
        return true
    elseif GetItemTypeId(GetManipulatedItem()) == 'I00A' then
        return true
    endif
    
    return false
endfunction

function Potion_Item_Picked_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( trg, Condition( function Potion_Picked_Con ) )
    call TriggerAddAction( trg, function Potion_Picked )
    
    set trg = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( trg, EVENT_PLAYER_UNIT_PICKUP_ITEM )
    call TriggerAddCondition( trg, Condition( function Potion_Bought_Con ) )
    call TriggerAddAction( trg, function Potion_Bought )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "po_drop", false)
    call TriggerAddAction( trg, function Potion_Pick_Full_Sync )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "p_refund", false)
    call TriggerAddAction( trg, function Potion_Buy_Full_Sync )
    
    set trg = null
endfunction

endlibrary