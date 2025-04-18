library InvenUpgrade requires Save, EquipPropertyPreprocess, EquipAPI, Base

globals
    boolean isUpgrade = false
    
    private integer current_upgrade_item_index
    
    private integer upgrade_button /* 인벤 창에 있는 장비강화 버튼 */
    private integer upgrade_box
    private integer x_button
    
    private integer upgrade_img
    private integer upgrade_name
    private integer upgrade_grade
    private integer upgrade_type
    private integer array upgrade_stats
    
    private integer required_gold_text
    private integer upgrade_result_text
    
    private integer upgrade_up_button /* 업그레이드 창에 있는 강화 버튼 */
    
    private trigger sync_trg
    
    private integer upgrade_tool_tip_back_drop
    private integer upgrade_tool_tip_text
    
    private boolean upgrade_possible = true
    
    private real upgrade_cool_time = 0.8 
endglobals

private function Upgrade_Cooldown takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    
    if GetLocalPlayer() == Player(pid) then
        set upgrade_possible = true
    endif
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Upgrade_Tool_Tip_Leave takes nothing returns nothing
    call DzFrameShow(upgrade_tool_tip_back_drop, false)
endfunction

private function Upgrade_Tool_Tip_Enter takes nothing returns nothing
    call DzFrameShow(upgrade_tool_tip_back_drop, true)
endfunction

private function Interface_Refresh takes integer pid, integer upgrade_index returns nothing
    local Equip E = Hero(pid+1).Get_Inven_Item(upgrade_index)
    local integer grade = E.Get_Grade()
    local integer upgrade_count = E.Get_Upgrade_Count()
    local integer count = 0
    local integer required_gold
    local boolean is_possible = true
    local integer saved_index = -1
    local string saved_string
    
    if GetLocalPlayer() == Player(pid) then
    
        call DzFrameSetText(upgrade_name, E.Get_Name() + " +" + I2S(upgrade_count) )
        
        if upgrade_count >= (grade + 2) then
            // 강화 횟수 최대로 강화 불가
            set is_possible = false 
        elseif upgrade_count == 0 then
            set required_gold = ITEM_UPGRADE_GOLD_0
        elseif upgrade_count == 1 then
            set required_gold = ITEM_UPGRADE_GOLD_1
        elseif upgrade_count == 2 then
            set required_gold = ITEM_UPGRADE_GOLD_2
        elseif upgrade_count == 3 then
            set required_gold = ITEM_UPGRADE_GOLD_3
        elseif upgrade_count == 4 then
            set required_gold = ITEM_UPGRADE_GOLD_4
        elseif upgrade_count == 5 then
            set required_gold = ITEM_UPGRADE_GOLD_5
        endif
        
        if is_possible == true then
            call DzFrameSetText(required_gold_text, "강화 필요 골드 : " + I2S(required_gold))
        else
            call DzFrameSetText(required_gold_text, "최대 강화 횟수 도달")
        endif
        
        if E.Get_AD() != 0 then
            call DzFrameSetText(upgrade_stats[count], "공격력 " + I2S(E.Get_AD()))
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_AP() != 0 then
            call DzFrameSetText(upgrade_stats[count], "주문력 " + I2S(E.Get_AP()))
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_AS() != 0 then
            call DzFrameSetText(upgrade_stats[count], "공격속도 " + I2S(E.Get_AS()) + "%" )
            call DzFrameShow(upgrade_stats[count], true)
            
            if E.Get_Type() == GLOVE then
                set saved_index = count
                set saved_string = DzFrameGetText(upgrade_stats[count])
            endif
            
            set count = count + 1
        endif
        if E.Get_MS() != 0 then
            call DzFrameSetText(upgrade_stats[count], "이동속도 " + I2S(E.Get_MS()))
            call DzFrameShow(upgrade_stats[count], true)
            
            if E.Get_Type() == BOOTS then
                set saved_index = count
                set saved_string = DzFrameGetText(upgrade_stats[count])
            endif
            
            set count = count + 1
        endif
        if E.Get_CRIT() != 0 then
            call DzFrameSetText(upgrade_stats[count], "치명확률 " + I2S(E.Get_CRIT()) + "%")
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_CRIT_COEF() != 0 then
            call DzFrameSetText(upgrade_stats[count], "치명피해 " + I2S(E.Get_CRIT_COEF()) + "%")
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_DEF_AD() != 0 then
            call DzFrameSetText(upgrade_stats[count], "물리방어 " + I2S(E.Get_DEF_AD()))
            call DzFrameShow(upgrade_stats[count], true)
            
            if E.Get_Type() == HELMET or E.Get_Type() == SHIELD then
                set saved_index = count
                set saved_string = DzFrameGetText(upgrade_stats[count])
            endif
            
            set count = count + 1
        endif
        if E.Get_DEF_AP() != 0 then
            call DzFrameSetText(upgrade_stats[count], "마법방어 " + I2S(E.Get_DEF_AP()))
            call DzFrameShow(upgrade_stats[count], true)
            
            if E.Get_Type() == BELT then
                set saved_index = count
                set saved_string = DzFrameGetText(upgrade_stats[count])
            endif
            
            set count = count + 1
        endif
        if E.Get_HP() != 0 then
            call DzFrameSetText(upgrade_stats[count], "체력 " + I2S(E.Get_HP()))
            call DzFrameShow(upgrade_stats[count], true)
            
            if E.Get_Type() == ARMOR then
                set saved_index = count
                set saved_string = DzFrameGetText(upgrade_stats[count])
            endif
            
            set count = count + 1
        endif
        if E.Get_MP() != 0 then
            call DzFrameSetText(upgrade_stats[count], "마나 " + I2S(E.Get_MP()))
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_HP_REGEN() != 0 then
            call DzFrameSetText(upgrade_stats[count], "체력회복 " + I2S(E.Get_HP_REGEN()))
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_MP_REGEN() != 0 then
            call DzFrameSetText(upgrade_stats[count], "마나회복 " + I2S(E.Get_MP_REGEN()))
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_ENHANCE_AD() != 0 then
            call DzFrameSetText(upgrade_stats[count], "물리피해강화 " + I2S(E.Get_ENHANCE_AD()) + "%")
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_ENHANCE_AP() != 0 then
            call DzFrameSetText(upgrade_stats[count], "마법피해강화 " + I2S(E.Get_ENHANCE_AP()) + "%")
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_REDUCE_AD() != 0 then
            call DzFrameSetText(upgrade_stats[count], "물리피해감소 " + I2S(E.Get_REDUCE_AD()) + "%")
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        if E.Get_REDUCE_AP() != 0 then
            call DzFrameSetText(upgrade_stats[count], "마법피해감소 " + I2S(E.Get_REDUCE_AP()) + "%")
            call DzFrameShow(upgrade_stats[count], true)
            set count = count + 1
        endif
        
        // 주스탯 있는 장비들 위한 코드
        if saved_index != -1 then
            call DzFrameSetText(upgrade_stats[saved_index], DzFrameGetText(upgrade_stats[0]))
            call DzFrameSetText(upgrade_stats[0], saved_string)
        endif
        
        call DzFrameShow(upgrade_result_text, true)
    endif
endfunction

private function Upgrade_Result_Renewal takes integer pid, integer property, integer before_value, integer after_value returns nothing
    local string str
    

    if property == AS or property == CRIT or property == CRIT_COEF or property == ENHANCE_AD or property == ENHANCE_AP or property == REDUCE_AD or property == REDUCE_AP then
        set str = "%"
    else
        set str = ""
    endif
    
    if GetLocalPlayer() == Player(pid) then
        call DzFrameSetText(upgrade_result_text, Property_To_String(property) + " " + I2S(before_value) + str + " -> " + I2S(after_value) + str  )
    endif
endfunction

private function Set_Upgrade_Property takes integer pid, Equip E, integer property, integer grade returns nothing
    local integer before_value
    local integer after_value
    
    if property == AD then
        set before_value = E.Get_AD()
        set after_value = before_value + Get_Random_Upgrade_Value(AD, grade)
        call E.Set_AD( after_value )
        
    elseif property == AP then
        set before_value = E.Get_AP()
        set after_value = before_value + Get_Random_Upgrade_Value(AP, grade)
        call E.Set_AP( after_value )
        
    elseif property == AS then
        set before_value = E.Get_AS()
        set after_value = before_value + Get_Random_Upgrade_Value(AS, grade)
        call E.Set_AS( after_value )
        
    elseif property == MS then
        set before_value = E.Get_MS()
        set after_value = before_value + Get_Random_Upgrade_Value(MS, grade)
        call E.Set_MS( after_value )
        
    elseif property == CRIT then
        set before_value = E.Get_CRIT()
        set after_value = before_value + Get_Random_Upgrade_Value(CRIT, grade)
        call E.Set_CRIT( after_value )
        
    elseif property == CRIT_COEF then
        set before_value = E.Get_CRIT_COEF()
        set after_value = before_value + Get_Random_Upgrade_Value(CRIT_COEF, grade)
        call E.Set_CRIT_COEF( after_value )
        
    elseif property == DEF_AD then
        set before_value = E.Get_DEF_AD()
        set after_value = before_value + Get_Random_Upgrade_Value(DEF_AD, grade)
        call E.Set_DEF_AD( after_value )
        
    elseif property == DEF_AP then
        set before_value = E.Get_DEF_AP()
        set after_value = before_value + Get_Random_Upgrade_Value(DEF_AP, grade)
        call E.Set_DEF_AP( after_value )
        
    elseif property == HP then
        set before_value = E.Get_HP()
        set after_value = before_value + Get_Random_Upgrade_Value(HP, grade)
        call E.Set_HP( after_value )
        
    elseif property == MP then
        set before_value = E.Get_MP()
        set after_value = before_value + Get_Random_Upgrade_Value(MP, grade)
        call E.Set_MP( after_value )
        
    elseif property == HP_REGEN then
        set before_value = E.Get_HP_REGEN()
        set after_value = before_value + Get_Random_Upgrade_Value(HP_REGEN, grade)
        call E.Set_HP_REGEN( after_value )
        
    elseif property == MP_REGEN then
        set before_value = E.Get_MP_REGEN()
        set after_value = before_value + Get_Random_Upgrade_Value(MP_REGEN, grade)
        call E.Set_MP_REGEN( after_value )
        
    elseif property == ENHANCE_AD then
        set before_value = E.Get_ENHANCE_AD()
        set after_value = before_value + Get_Random_Upgrade_Value(ENHANCE_AD, grade)
        call E.Set_ENHANCE_AD( after_value )
        
    elseif property == ENHANCE_AP then
        set before_value = E.Get_ENHANCE_AP()
        set after_value = before_value + Get_Random_Upgrade_Value(ENHANCE_AP, grade)
        call E.Set_ENHANCE_AP( after_value )
        
    elseif property == REDUCE_AD then
        set before_value = E.Get_REDUCE_AD()
        set after_value = before_value + Get_Random_Upgrade_Value(REDUCE_AD, grade)
        call E.Set_REDUCE_AD( after_value )
        
    elseif property == REDUCE_AP then
        set before_value = E.Get_REDUCE_AP()
        set after_value = before_value + Get_Random_Upgrade_Value(REDUCE_AP, grade)
        call E.Set_REDUCE_AP( after_value )
    endif
    
    call Upgrade_Result_Renewal(pid, property, before_value, after_value)
endfunction


private function Upgrade_Item takes integer pid, integer upgrade_index returns nothing
    local Equip E = Hero(pid+1).Get_Inven_Item(upgrade_index)
    local integer grade = E.Get_Grade()
    local integer count = 0
    local integer array property
    local integer ran
    
    if E.Get_AD() != 0 then
        set property[count] = AD
        set count = count + 1
    endif
    if E.Get_AP() != 0 then
        set property[count] = AP
        set count = count + 1
    endif
    if E.Get_AS() != 0 then
        set property[count] = AS
        set count = count + 1
    endif
    if E.Get_MS() != 0 then
        set property[count] = MS
        set count = count + 1
    endif
    if E.Get_CRIT() != 0 then
        set property[count] = CRIT
        set count = count + 1
    endif
    if E.Get_CRIT_COEF() != 0 then
        set property[count] = CRIT_COEF
        set count = count + 1
    endif
    if E.Get_DEF_AD() != 0 then
        set property[count] = DEF_AD
        set count = count + 1
    endif
    if E.Get_DEF_AP() != 0 then
        set property[count] = DEF_AP
        set count = count + 1
    endif
    if E.Get_HP() != 0 then
        set property[count] = HP
        set count = count + 1
    endif
    if E.Get_MP() != 0 then
        set property[count] = MP
        set count = count + 1
    endif
    if E.Get_HP_REGEN() != 0 then
        set property[count] = HP_REGEN
        set count = count + 1
    endif
    if E.Get_MP_REGEN() != 0 then
        set property[count] = MP_REGEN
        set count = count + 1
    endif
    if E.Get_ENHANCE_AD() != 0 then
        set property[count] = ENHANCE_AD
        set count = count + 1
    endif
    if E.Get_ENHANCE_AP() != 0 then
        set property[count] = ENHANCE_AP
        set count = count + 1
    endif
    if E.Get_REDUCE_AD() != 0 then
        set property[count] = REDUCE_AD
        set count = count + 1
    endif
    if E.Get_REDUCE_AP() != 0 then
        set property[count] = REDUCE_AP
        set count = count + 1
    endif
    
    call E.Set_Upgrade_Count(E.Get_Upgrade_Count() + 1)
    
    call Set_Upgrade_Property(pid, E, property[GetRandomInt(0, count-1)], grade)
endfunction

private function Delayed_Refresh takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local integer pid = LoadInteger(HT, id, 0)
    local integer upgrade_index = LoadInteger(HT, id, 1)
    
    call Interface_Refresh(pid, upgrade_index)
    
    if GetLocalPlayer() == Player(pid) then
        if is_Test == false then
            call Forced_Save(pid)
        endif
        call PlaySoundBJ(gg_snd_BlacksmithWhat1)
    endif
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Upgrade_Up_Synchronize takes nothing returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local timer t2 = CreateTimer() /* 업그레이드 쿨타임용 */
    local integer id2 = GetHandleId(t) /* 업그레이드 쿨타임용 */
    local string sync_data = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(sync_data, "/", 0) )
    local integer upgrade_index = S2I( JNStringSplit(sync_data, "/", 1) )
    local Equip E = Hero(pid+1).Get_Inven_Item(upgrade_index)
    local integer upgrade_count = E.Get_Upgrade_Count()
    local integer grade = E.Get_Grade()
    local integer player_gold = GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD)
    local integer required_gold
    
    // 최대 강화횟수 도달
    if upgrade_count >= (grade + 2) then
        if GetLocalPlayer() == Player(pid) then
            set upgrade_possible = true
        endif
        return
    endif
    
    if upgrade_count == 0 then
        set required_gold = ITEM_UPGRADE_GOLD_0
    elseif upgrade_count == 1 then
        set required_gold = ITEM_UPGRADE_GOLD_1
    elseif upgrade_count == 2 then
        set required_gold = ITEM_UPGRADE_GOLD_2
    elseif upgrade_count == 3 then
        set required_gold = ITEM_UPGRADE_GOLD_3
    elseif upgrade_count == 4 then
        set required_gold = ITEM_UPGRADE_GOLD_4
    elseif upgrade_count == 5 then
        set required_gold = ITEM_UPGRADE_GOLD_5
    endif
    
    if is_Test == false then
        // 필요 골드 부족
        if player_gold < required_gold then
            if GetLocalPlayer() == Player(pid) then
                set upgrade_possible = true
            endif
            return
        endif
        
        call AdjustPlayerStateBJ( -required_gold, Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    endif
    
    call Upgrade_Item(pid, upgrade_index)

    call SaveInteger(HT, id, 0, pid)
    call SaveInteger(HT, id, 1, upgrade_index)
    call TimerStart(t, 0.08, false, function Delayed_Refresh)
    
    // 업그레이드 쿨타임
    call SaveInteger(HT, id2, 0, pid)
    call TimerStart(t2, upgrade_cool_time, false, function Upgrade_Cooldown)
    
    set t = null
    set t2 = null
endfunction

private function Upgrade_Up_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    if current_upgrade_item_index == -1 then
        return
    endif
    
    if upgrade_possible == false then
        return
    endif
    
    set upgrade_possible = false
    
    call DzSyncData("upgra", I2S(pid) + "/" + I2S(current_upgrade_item_index))
endfunction

private function Upgrade_Interface_Setting takes integer pid, integer index returns nothing
    local integer count = 0
    local integer i
    local integer grade
    local integer upgrade_count
    local integer required_gold
    local real pad_2 = 0.12
    local real pad_3 = 0.0075
    local boolean is_possible = true
    local Equip E
    local integer saved_index = -1
    local string saved_string
    
    set current_upgrade_item_index = index
    
    set E = Hero(pid+1).Get_Inven_Item(index)
    
    set upgrade_count = E.Get_Upgrade_Count()
    set grade = E.Get_Grade()
    
    call DzFrameSetTexture(upgrade_img, E.Get_Img(), 0)
    
    if upgrade_count > 0 then
        call DzFrameSetText(upgrade_name, E.Get_Name() + " +" + I2S(upgrade_count) )
    else
        call DzFrameSetText(upgrade_name, E.Get_Name() )
    endif
    
    call DzFrameSetText(upgrade_grade, item_grade[ grade ])
    call DzFrameSetText(upgrade_type, "|cff9E9E9E " + E.Integer_To_Type() + " |r")
    
    if upgrade_count >= (grade + 2) then
        // 강화 횟수 최대로 강화 불가
        set is_possible = false 
    elseif upgrade_count == 0 then
        set required_gold = ITEM_UPGRADE_GOLD_0
    elseif upgrade_count == 1 then
        set required_gold = ITEM_UPGRADE_GOLD_1
    elseif upgrade_count == 2 then
        set required_gold = ITEM_UPGRADE_GOLD_2
    elseif upgrade_count == 3 then
        set required_gold = ITEM_UPGRADE_GOLD_3
    elseif upgrade_count == 4 then
        set required_gold = ITEM_UPGRADE_GOLD_4
    elseif upgrade_count == 5 then
        set required_gold = ITEM_UPGRADE_GOLD_5
    endif
    
    if is_possible == true then
        call DzFrameSetText(required_gold_text, "강화 필요 골드 : " + I2S(required_gold))
    else
        call DzFrameSetText(required_gold_text, "최대 강화 횟수 도달")
    endif
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        call DzFrameSetPoint(upgrade_stats[i], JN_FRAMEPOINT_CENTER, upgrade_name, JN_FRAMEPOINT_CENTER, pad_2, pad_3 * grade -i * 0.015)
    endloop
    
    if E.Get_AD() != 0 then
        call DzFrameSetText(upgrade_stats[count], "공격력 " + I2S(E.Get_AD()))
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_AP() != 0 then
        call DzFrameSetText(upgrade_stats[count], "주문력 " + I2S(E.Get_AP()))
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_AS() != 0 then
        call DzFrameSetText(upgrade_stats[count], "공격속도 " + I2S(E.Get_AS()) + "%" )
        call DzFrameShow(upgrade_stats[count], true)
        
        if E.Get_Type() == GLOVE then
            set saved_index = count
            set saved_string = DzFrameGetText(upgrade_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_MS() != 0 then
        call DzFrameSetText(upgrade_stats[count], "이동속도 " + I2S(E.Get_MS()))
        call DzFrameShow(upgrade_stats[count], true)
        
        if E.Get_Type() == BOOTS then
            set saved_index = count
            set saved_string = DzFrameGetText(upgrade_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_CRIT() != 0 then
        call DzFrameSetText(upgrade_stats[count], "치명확률 " + I2S(E.Get_CRIT()) + "%")
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_CRIT_COEF() != 0 then
        call DzFrameSetText(upgrade_stats[count], "치명피해 " + I2S(E.Get_CRIT_COEF()) + "%")
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_DEF_AD() != 0 then
        call DzFrameSetText(upgrade_stats[count], "물리방어 " + I2S(E.Get_DEF_AD()))
        call DzFrameShow(upgrade_stats[count], true)
        
        if E.Get_Type() == HELMET or E.Get_Type() == SHIELD then
            set saved_index = count
            set saved_string = DzFrameGetText(upgrade_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_DEF_AP() != 0 then
        call DzFrameSetText(upgrade_stats[count], "마법방어 " + I2S(E.Get_DEF_AP()))
        call DzFrameShow(upgrade_stats[count], true)
        
        if E.Get_Type() == BELT then
            set saved_index = count
            set saved_string = DzFrameGetText(upgrade_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_HP() != 0 then
        call DzFrameSetText(upgrade_stats[count], "체력 " + I2S(E.Get_HP()))
        call DzFrameShow(upgrade_stats[count], true)
        
        if E.Get_Type() == ARMOR then
            set saved_index = count
            set saved_string = DzFrameGetText(upgrade_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_MP() != 0 then
        call DzFrameSetText(upgrade_stats[count], "마나 " + I2S(E.Get_MP()))
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_HP_REGEN() != 0 then
        call DzFrameSetText(upgrade_stats[count], "체력회복 " + I2S(E.Get_HP_REGEN()))
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_MP_REGEN() != 0 then
        call DzFrameSetText(upgrade_stats[count], "마나회복 " + I2S(E.Get_MP_REGEN()))
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_ENHANCE_AD() != 0 then
        call DzFrameSetText(upgrade_stats[count], "물리피해강화 " + I2S(E.Get_ENHANCE_AD()) + "%")
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_ENHANCE_AP() != 0 then
        call DzFrameSetText(upgrade_stats[count], "마법피해강화 " + I2S(E.Get_ENHANCE_AP()) + "%")
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_REDUCE_AD() != 0 then
        call DzFrameSetText(upgrade_stats[count], "물리피해감소 " + I2S(E.Get_REDUCE_AD()) + "%")
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    if E.Get_REDUCE_AP() != 0 then
        call DzFrameSetText(upgrade_stats[count], "마법피해감소 " + I2S(E.Get_REDUCE_AP()) + "%")
        call DzFrameShow(upgrade_stats[count], true)
        set count = count + 1
    endif
    
    // 주스탯 있는 장비들 위한 코드
    if saved_index != -1 then
        call DzFrameSetText(upgrade_stats[saved_index], DzFrameGetText(upgrade_stats[0]))
        call DzFrameSetText(upgrade_stats[0], saved_string)
    endif
endfunction

public function Upgrade_Box_Off takes nothing returns nothing
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        call DzFrameShow(upgrade_stats[i], false)
    endloop
    
    call DzFrameShow(upgrade_result_text, false)
    
    set current_upgrade_item_index = -1
    set isUpgrade = false
    call DzFrameShow(upgrade_box, false)
endfunction

private function Upgrade_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    if inven_clicked_index == -1 then
        return
    endif
    
    if isUpgrade == false then
        set isUpgrade = true
        call DzFrameShow(upgrade_box, true)
        call Upgrade_Interface_Setting(pid, inven_clicked_index)
        set inven_clicked_index = -1
        call Inven_Sprite_Hide()
    else
        call Upgrade_Box_Off()
    endif
endfunction

// 백드롭과 이미지 그리고 텍스트들 버튼도
private function Upgrade_Interface_Init takes nothing returns nothing
    local integer i
    local real pad_0 = -0.06
    local real pad_1 = -0.01
    local real pad_2 = 0.12
    local real pad_3 = 0
    
    set upgrade_img = DzCreateFrameByTagName("BACKDROP", "", upgrade_box, "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(upgrade_img, JN_FRAMEPOINT_CENTER, upgrade_box, JN_FRAMEPOINT_TOP, pad_0, pad_1 -0.01 - (inven_item_size/2) )
    call DzFrameSetSize(upgrade_img, inven_item_size, inven_item_size)
    
    set upgrade_name = DzCreateFrameByTagName("TEXT", "", upgrade_box, "", 0)
    call DzFrameSetPoint(upgrade_name, JN_FRAMEPOINT_CENTER, upgrade_box, JN_FRAMEPOINT_TOP, pad_0, pad_1 -(inven_item_size + 0.020))
    
    set upgrade_grade = DzCreateFrameByTagName("TEXT", "", upgrade_box, "", 0)
    call DzFrameSetPoint(upgrade_grade, JN_FRAMEPOINT_CENTER, upgrade_box, JN_FRAMEPOINT_TOP, pad_0, pad_1 -(inven_item_size + 0.035))
    
    set upgrade_type = DzCreateFrameByTagName("TEXT", "", upgrade_box, "", 0)
    call DzFrameSetPoint(upgrade_type, JN_FRAMEPOINT_CENTER, upgrade_box, JN_FRAMEPOINT_TOP, pad_0, pad_1 -(inven_item_size + 0.050))
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        set upgrade_stats[i] = DzCreateFrameByTagName("TEXT", "", upgrade_name, "", 0)
        call DzFrameSetPoint(upgrade_stats[i], JN_FRAMEPOINT_CENTER, upgrade_name, JN_FRAMEPOINT_CENTER, pad_2, pad_3 -i * 0.015)
        call DzFrameShow(upgrade_stats[i], false)
    endloop
    
    // 누르면 장비 강화하는 버튼
    set upgrade_up_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", upgrade_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(upgrade_up_button, JN_FRAMEPOINT_BOTTOMRIGHT, upgrade_box, JN_FRAMEPOINT_BOTTOMRIGHT, -0.01, 0.01)
    call DzFrameSetSize(upgrade_up_button, 0.060, 0.04)
    call DzFrameSetText(upgrade_up_button, "강화")
    call DzFrameSetScriptByCode(upgrade_up_button, JN_FRAMEEVENT_CONTROL_CLICK, function Upgrade_Up_Clicked, false)
    
    // 필요골드, 소지골드
    set required_gold_text = DzCreateFrameByTagName("TEXT", "", upgrade_box, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(required_gold_text, JN_FRAMEPOINT_BOTTOMLEFT, upgrade_box, JN_FRAMEPOINT_BOTTOMLEFT, 0.02, 0.02)
    call DzFrameSetText(required_gold_text, "" )
    
    // 강화 결과
    set upgrade_result_text = DzCreateFrameByTagName("TEXT", "", upgrade_box, "TeamLadderRankValueTextTemplate", 0)
    call DzFrameSetPoint(upgrade_result_text, JN_FRAMEPOINT_CENTER, upgrade_box, JN_FRAMEPOINT_CENTER, 0.00, -0.02)
    call DzFrameSetText(upgrade_result_text, "" )
    call DzFrameShow(upgrade_result_text, false)
endfunction

// 끄기 버튼
private function Upgrade_Box_X_Button takes nothing returns nothing
    set x_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", upgrade_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(x_button, JN_FRAMEPOINT_TOPLEFT, upgrade_box, JN_FRAMEPOINT_TOPLEFT, 0, 0)
    call DzFrameSetSize(x_button, 0.032, 0.032)
    call DzFrameSetText(x_button, "X")
    call DzFrameSetScriptByCode(x_button, JN_FRAMEEVENT_CONTROL_CLICK, function Upgrade_Box_Off, false)
endfunction

// 백드롭
private function Inven_Upgrade_Box takes nothing returns nothing
    set upgrade_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(upgrade_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.07)
    call DzFrameSetSize(upgrade_box, 0.30, 0.30)
    call DzFrameShow(upgrade_box, false)
endfunction

// 가져다대면 설명해주는 툴팁
private function Inven_Upgrade_Tool_Tip takes nothing returns nothing
    set upgrade_tool_tip_back_drop = DzCreateFrameByTagName("BACKDROP", "", inven_box, "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(upgrade_tool_tip_back_drop, JN_FRAMEPOINT_CENTER, upgrade_button, JN_FRAMEPOINT_CENTER, -0.03, 0.04)
    call DzFrameSetSize(upgrade_tool_tip_back_drop, 0.14, 0.05)

    set upgrade_tool_tip_text = DzCreateFrameByTagName("TEXT", "", upgrade_tool_tip_back_drop, "", 0)
    call DzFrameSetPoint(upgrade_tool_tip_text, JN_FRAMEPOINT_CENTER, upgrade_tool_tip_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetText(upgrade_tool_tip_text, "인벤칸 아이템 클릭 후\n 장비강화 버튼 클릭")
    
    call DzFrameShow(upgrade_tool_tip_back_drop, false)
endfunction

// 인벤창에 있는 장비강화창 여는 버튼
private function Inven_Upgrade_Button takes nothing returns nothing
    set upgrade_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", inven_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(upgrade_button, JN_FRAMEPOINT_CENTER, inven_box, JN_FRAMEPOINT_CENTER, -0.045, 0.12)
    call DzFrameSetSize(upgrade_button, 0.060, 0.04)
    call DzFrameSetText(upgrade_button, "장비\n강화")
    call DzFrameSetScriptByCode(upgrade_button, JN_FRAMEEVENT_CONTROL_CLICK, function Upgrade_Clicked, false)
    // 장비강화 버튼 마우스 들어가면 툴팁생성 
    call DzFrameSetScriptByCode(upgrade_button, JN_FRAMEEVENT_MOUSE_ENTER, function Upgrade_Tool_Tip_Enter, false)
    call DzFrameSetScriptByCode(upgrade_button, JN_FRAMEEVENT_MOUSE_LEAVE, function Upgrade_Tool_Tip_Leave, false)
endfunction

function Inven_Upgrade_Init takes nothing returns nothing
    call Inven_Upgrade_Button()
    call Inven_Upgrade_Box()
    call Upgrade_Box_X_Button()
    call Upgrade_Interface_Init()
    call Inven_Upgrade_Tool_Tip()
    
    // 강화 동기화
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "upgra", false)
    call TriggerAddAction( sync_trg, function Upgrade_Up_Synchronize )
    
    if is_Test == true then
        set upgrade_cool_time = 0.05
    endif
endfunction

endlibrary