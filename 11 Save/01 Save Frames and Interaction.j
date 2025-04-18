library SaveFrames requires Base, Serialization, UnitProperty

globals
    // 저장 가능 횟수
    private integer save_count = 4

    private integer save_button
    
    private integer save_box
    private integer count_text
    private integer send_button
    
    private boolean is_Save = false
endglobals

private function Time_Save takes integer pid returns nothing
    call JNObjectUserSetInt(USER_ID[pid], PLAY_TIME, play_time[pid])
    call JNObjectUserSave(MAP_ID, USER_ID[pid], SECRET_KEY, null)
endfunction

private function Build_Milestone_String takes integer pid returns string
    local string str
    local integer normal_milestone
    local integer nightmare_milestone
    local integer hell_milestone
    
    set normal_milestone = S2I( JNStringSplit(local_milestone_str, ",", 0) )
    set nightmare_milestone = S2I( JNStringSplit(local_milestone_str, ",", 1) )
    set hell_milestone = S2I( JNStringSplit(local_milestone_str, ",", 2) )
    
    if MAP_DIFFICULTY == NORMAL then
        set normal_milestone = milestone[pid]
    elseif MAP_DIFFICULTY == NIGHTMARE then
        set nightmare_milestone = milestone[pid]
    elseif MAP_DIFFICULTY == HELL then
        set hell_milestone = milestone[pid]
    endif
    
    set str = I2S(normal_milestone) + "," + I2S(nightmare_milestone) + "," + I2S(hell_milestone)
    
    return str
endfunction

private function Initial_Log takes integer pid returns nothing
    local string str
    local unit u = null

    set u = player_hero[pid].Get_Hero_Unit()
    set str = Get_Character_Name_From_Unit_Id(GetUnitTypeId(u)) + "#"
    set str = str + I2S(GetHeroLevel(u)) + "#ADAP"
    set str = str + I2S(Get_Unit_Property(u, AD)) + ","
    set str = str + I2S(Get_Unit_Property(u, AP)) + "#ASMS"
    set str = str + I2S(Get_Unit_Property(u, AS)) + ","
    set str = str + I2S(Get_Unit_Property(u, MS)) + "#CRI"
    set str = str + I2S(Get_Unit_Property(u, CRIT)) + ","
    set str = str + I2S(Get_Unit_Property(u, CRIT_COEF)) + "#DEF"
    set str = str + I2S(Get_Unit_Property(u, DEF_AD)) + ","
    set str = str + I2S(Get_Unit_Property(u, DEF_AP)) + "#HP"
    set str = str + I2S(Get_Unit_Property(u, HP)) + ","
    set str = str + I2S(Get_Unit_Property(u, MP)) + "#REG"
    set str = str + I2S(Get_Unit_Property(u, HP_REGEN)) + ","
    set str = str + I2S(Get_Unit_Property(u, MP_REGEN)) + "#ENH"
    set str = str + I2S(Get_Unit_Property(u, ENHANCE_AD)) + ","
    set str = str + I2S(Get_Unit_Property(u, ENHANCE_AP)) + "#RED"
    set str = str + I2S(Get_Unit_Property(u, REDUCE_AD)) + ","
    set str = str + I2S(Get_Unit_Property(u, REDUCE_AP)) + "#BUF"
    set str = str + I2S(exp_rate[pid]) + "/"
    set str = str + I2S(gold_drop_rate[pid]) + "/"
    set str = str + I2S(item_drop_rate[pid]) + "/"
    set str = str + I2S(potion_increase)
    set str = str + "#G"
    set str = str + I2S(GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD))
    set str = str + "#TIME"
    set str = str + I2S(play_time[pid])
    set str = str + "#SP"
    set str = str + I2S(player_hero[pid].Get_Stat_Point())
    
    call JNMapServerLog(MAP_ID, SECRET_KEY, USER_ID[pid], str)
    
    set u = null
endfunction


private function Potal_State_Save takes integer pid returns nothing
    call JNSetSaveCode(MAP_ID, USER_ID[pid], SECRET_KEY, "POTAL_STATE" + I2S(MAP_DIFFICULTY), potal_save_state)
endfunction


// 확장성 있는 저장
// & 를 기준으로 새로운 값들을 추가해 나가자
// & index 0 : 힐링포션 카운트
// & index 1 : 마나포션 카운트
// & index 2 : 마일스톤
private function Extensibility_Save takes integer pid returns nothing
    local string str = ""
    
    // 힐링포션 카운트 값
    set str = str + I2S(health_potion_count) + "&"
    
    // 마나포션 카운트 값
    set str = str + I2S(mana_potion_count) + "&"
    
    // 마일스톤
    set str = str + Build_Milestone_String(pid) + "&"
    
    call JNSetSaveCode(MAP_ID, USER_ID[pid], SECRET_KEY, "EXTENSIVE" + I2S(current_load_index), str)
endfunction

function Save_Button_Show takes nothing returns nothing
    call DzFrameShow(save_button, true)
endfunction

private function Build_Character_List takes integer pid returns string
    local string unit_type = I2S(GetUnitTypeId( Hero(pid+1).Get_Hero_Unit() ))
    local string str = "808/"
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 7
        if i == current_load_index then
            set str = str + unit_type + "," + I2S(current_difficulty_cleared[i]) + "#"
            /*
            if USER_ID[pid] == "kimximya" then
                set str = str + unit_type + "," + I2S(3) + "#"
            else
                
            endif
            */
        else
            set str = str + JNStringSplit(character_list, "#", i) + "#"
        endif
    endloop
    
    set str = SubString(str, 0, StringLength(str)-1)
    call BJDebugMsg(str)
    return str
endfunction

// 실제 저장
private function Send_Button_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local string str
    local string save_result
    
    if save_count <= 0 then
        call BJDebugMsg("횟수를 다 썼어용\n저장이 되지 않아용\n\n")
        return
    endif
    
    set save_count = save_count - 1
    
    // 카운트 텍스트 갱신
    call DzFrameSetText(count_text, "남은 저장 횟수 : " + I2S(save_count) )

    // 신캐일 경우
    if is_character_loaded[current_load_index] == false then
        set is_character_loaded[current_load_index] = true
    endif
    
    if is_Test == true then
        return
    endif
    
    set save_result = JNSetSaveCode(MAP_ID, USER_ID[pid], SECRET_KEY, CHARACTER_LIST, Build_Character_List(pid))
    call BJDebugMsg(save_result)
    
    set str = Serialize(pid)
    
    //call BJDebugMsg(str + "\n\n")
    call JNSetSaveCode(MAP_ID, USER_ID[pid], SECRET_KEY, "LOAD_INDEX" + I2S(current_load_index), str)
    
    call Extensibility_Save(pid)
    call Potal_State_Save(pid)
    call Initial_Log(pid)
    call Time_Save(pid)
endfunction

function Automatic_Save takes integer pid returns nothing
    local string str
    
    if is_Test == true then
        return
    endif
    
    // 신캐일 경우
    if is_character_loaded[current_load_index] == false then
        set is_character_loaded[current_load_index] = true
        call JNSetSaveCode(MAP_ID, USER_ID[pid], SECRET_KEY, CHARACTER_LIST, Build_Character_List(pid))
    endif
    
    set str = Serialize(pid)

    call JNSetSaveCode(MAP_ID, USER_ID[pid], SECRET_KEY, "LOAD_INDEX" + I2S(current_load_index), str)
endfunction


// 껐다 켰다 
private function Save_Button_Clicked takes nothing returns nothing
    if is_Save == true then
        set is_Save = false
        call DzFrameShow(save_box, false)
    else
        set is_Save = true
        call DzFrameShow(save_box, true)
    endif
endfunction

private function Save_Box_and_Send_Button takes nothing returns nothing
    set save_box = DzCreateFrameByTagName("BACKDROP", "", save_button, "EscMenuBackdrop", 0)
    call DzFrameSetPoint(save_box, JN_FRAMEPOINT_CENTER, save_button, JN_FRAMEPOINT_CENTER, 0.05, 0.08)
    call DzFrameSetSize(save_box, 0.15, 0.11)
    call DzFrameShow(save_box, false)
    
    set count_text = DzCreateFrameByTagName("TEXT", "", save_box, "TeamLabelTextTemplate", 0)
    call DzFrameSetPoint(count_text, JN_FRAMEPOINT_CENTER, save_box, JN_FRAMEPOINT_CENTER, 0.0, 0.020)
    call DzFrameSetText(count_text, "남은 저장 횟수 : " + I2S(save_count) )
    
    set send_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", save_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(send_button, JN_FRAMEPOINT_CENTER, save_box, JN_FRAMEPOINT_CENTER, 0.0, -0.0125)
    call DzFrameSetSize(send_button, 0.10, 0.040)
    call DzFrameSetText(send_button, "SAVE")
    call DzFrameSetScriptByCode(send_button, JN_FRAMEEVENT_CONTROL_CLICK, function Send_Button_Clicked, false)
endfunction

private function Save_Button takes nothing returns nothing
    set save_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(save_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.24, -0.16)
    call DzFrameSetSize(save_button, 0.06, 0.040)
    call DzFrameSetText(save_button, "저장")
    call DzFrameSetScriptByCode(save_button, JN_FRAMEEVENT_CONTROL_CLICK, function Save_Button_Clicked, false)
    call DzFrameShow(save_button, false)
endfunction

function Save_Frames_Init takes nothing returns nothing
    call Save_Button()
    call Save_Box_and_Send_Button()
endfunction

endlibrary