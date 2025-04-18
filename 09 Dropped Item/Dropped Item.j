library DroppedItem requires Base

private function Item_Count_Down_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local item the_item = LoadItemHandle(HT, id, 0)
    local integer time = LoadInteger(HT, id, 1)
    local integer count = LoadInteger(HT, id, 2)
    
    if count >= time or IsItemVisible(the_item) == false then
        call Timer_Clear(t)
        call RemoveItem(the_item)
    else
        call SaveInteger(HT, id, 2, count + 1)
        call Text_Tag(GetItemX(the_item), GetItemY(the_item), 255, 255, 255, 7, 0, 45, 90, 185, 0.0, 0.6, I2S(time - count), null, -1, 0.0)
    endif

    set t = null
    set the_item = null
endfunction

function Item_Count_Down takes item the_item, integer time returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local integer count = 0
    
    call SaveItemHandle(HT, id, 0, the_item)
    call SaveInteger(HT, id, 1, time)
    call SaveInteger(HT, id, 2, count)
    call TimerStart(t, 1.00, true, function Item_Count_Down_Func)
    
    set t = null
endfunction

// direct 부분은 기본적으로 null이다
// 안뜰 아이템을 유닛에게 직접 줄려면 direct 부분에 killing_unit 집어넣기
function Random_Equip_Item_Drop takes unit direct, real x, real y, integer w0, integer w1, integer w2, integer w3, integer w4, real probability, integer count returns nothing
    local integer total_weight = w0 + w1 + w2 + w3 + w4
    local integer ran = GetRandomInt(1, total_weight)
    local integer grade = 0
    local integer i = -1
    local boolean is_drop = false
    local item dropped_item = null
    
    if count <= 0 then
        set count = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i >= count
        if GRR(0, 1) > probability / 100.0 then
            set is_drop = false
        else
            set is_drop = true
        endif

        if is_drop == true then
            if ran <= w0 then
                set dropped_item = CreateItem('I000', x, y)
            elseif ran <= w0 + w1 then
                set dropped_item = CreateItem('I001', x, y)
            elseif ran <= w0 + w1 + w2 then
                set dropped_item = CreateItem('I002', x, y)
            elseif ran <= w0 + w1 + w2 + w3 then
                set dropped_item = CreateItem('I003', x, y)
            elseif ran <= w0 + w1 + w2 + w3 + w4 then
                set dropped_item = CreateItem('I004', x, y)
            endif
            
            call Item_Count_Down(dropped_item, 60)
            
            if direct != null then
                call Msg_One(GetOwningPlayer(direct), 6.0, "아이템 획득!", 0.0)
                call UnitAddItem(direct, dropped_item)
            endif
        endif
    endloop
    
    set dropped_item = null
endfunction

endlibrary