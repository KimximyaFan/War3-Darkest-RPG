library PotalFrame requires PotalGeneric

globals
    private integer region_count = 4
    
    private integer select_index = 0
    
    public integer camp_potal_back_drop
    private integer camp_potal_title_text
    private integer camp_potal_region_text
    
    private integer left_button
    private integer right_button
    
    private integer array camp_potal_point_back_drop
    private integer array camp_potal_point_img
    private integer array camp_potal_point_button
    private integer array camp_potal_point_text
    
    private real square_size = 0.048
    private real img_size = 0.046
    
    private real potal_point_x = -0.075
    private real potal_point_y = 0.075
    
    private real camp_potal_region_y = -0.125
    
    private string icon_img = "ReplaceableTextures\\CommandButtons\\BTNLamp.blp"
    
    public integer region_potal_back_drop
    private integer region_potal_title_text
    
    private integer yes_button
    private integer no_button
endglobals

private function Potal_List_Initialize takes nothing returns nothing
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 3
        call DzFrameShow(camp_potal_point_back_drop[i], false)
        call DzFrameShow(camp_potal_point_img[i], false)
    endloop
endfunction

function Potal_List_Refresh takes nothing returns nothing
    local string region_potal_state
    local integer i
    local integer state
    
    call Potal_List_Initialize()
    
    call DzFrameSetText( camp_potal_title_text, PotalGeneric_region_name[select_index] )
    call DzFrameSetText( camp_potal_region_text, I2S(select_index + 1) + " 지역" )
    
    if is_Test == true then
        set region_potal_state = JNStringSplit(potal_save_state_test, "#", select_index)
    else
        set region_potal_state = JNStringSplit(potal_save_state, "#", select_index)
    endif
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= PotalGeneric_region_potal_point_count[select_index]
        call DzFrameShow(camp_potal_point_back_drop[i], true)
        
        set state = S2I(JNStringSplit(region_potal_state, "/", i))
        
        if state == 1 then
            call DzFrameShow(camp_potal_point_img[i], true)
            call DzFrameSetText(camp_potal_point_text[i], PotalGeneric_region_potal_point[PotalGeneric_prefix_sum[select_index] + i] )
        endif
    endloop
endfunction

private function Potal_Point_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( JNStringSplit(str, "/", 0) )
    local integer index = S2I( JNStringSplit(str, "/", 1) )
    local integer selected_index = S2I( JNStringSplit(str, "/", 2) )
    local real x = PotalGeneric_region_point_x[PotalGeneric_prefix_sum[selected_index] + index]
    local real y = PotalGeneric_region_point_y[PotalGeneric_prefix_sum[selected_index] + index]
    
    call Teleport(player_hero[pid].Get_Hero_Unit(), x, y, null)
endfunction

private function Potal_Point_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local integer index = S2I( JNStringSplit(DzFrameGetName(DzGetTriggerUIEventFrame()), "/", 1) )
    
    call PlaySoundBJ(gg_snd_BigButtonClick)
    call DzFrameShow(PotalFrame_camp_potal_back_drop, false)

    call DzSyncData("c_potal", I2S(pid) + "/" + I2S(index) + "/" + I2S(select_index))
endfunction

// 지역 포탈 석상 작동시, 1지역 ~ 4지역 고르는 버튼
private function Right_Clicked takes nothing returns nothing
    set select_index = Mod( select_index + 1, region_count)
    call Potal_List_Refresh()
endfunction

// 지역 포탈 석상 작동시, 1지역 ~ 4지역 고르는 버튼
private function Left_Clicked takes nothing returns nothing
    set select_index = Mod( select_index - 1, region_count)
    call Potal_List_Refresh()
endfunction

private function Potal_Region_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I( str )
    
    call Teleport(player_hero[pid].Get_Hero_Unit(), 1, 351, null)
endfunction

// 지역 포탈 석상 작동시, No 누르면 취소
private function No_Clicked takes nothing returns nothing
    call DzFrameShow(region_potal_back_drop, false)
endfunction

// 지역 포탈 석상 작동시, Yes 누르면 마을 귀환
private function Yes_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    call DzFrameShow(region_potal_back_drop, false)
    
    call DzSyncData("r_potal", I2S(pid))
endfunction

// 지역에 있는 포탈 석상 접근시 보여지는 프레임
private function Region_Potal_Frame takes nothing returns nothing
    set region_potal_back_drop = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(region_potal_back_drop, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetSize(region_potal_back_drop, 0.26, 0.16)
    call DzFrameShow(region_potal_back_drop, false)
    
    set region_potal_title_text = DzCreateFrameByTagName("TEXT", "", region_potal_back_drop, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(region_potal_title_text, JN_FRAMEPOINT_CENTER, region_potal_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.03)
    call DzFrameSetText(region_potal_title_text, "마을로 귀환" )
    
    set yes_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", region_potal_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(yes_button, JN_FRAMEPOINT_CENTER, region_potal_back_drop, JN_FRAMEPOINT_CENTER, -0.05, -0.03)
    call DzFrameSetSize(yes_button, 0.060, 0.04)
    call DzFrameSetText(yes_button, "YES")
    call DzFrameSetScriptByCode(yes_button, JN_FRAMEEVENT_CONTROL_CLICK, function Yes_Clicked, false)
    
    set no_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", region_potal_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(no_button, JN_FRAMEPOINT_CENTER, region_potal_back_drop, JN_FRAMEPOINT_CENTER, 0.05, -0.03)
    call DzFrameSetSize(no_button, 0.060, 0.04)
    call DzFrameSetText(no_button, "NO")
    call DzFrameSetScriptByCode(no_button, JN_FRAMEEVENT_CONTROL_CLICK, function No_Clicked, false)
endfunction

// 마을에 있는 포탈 석상 접근시 보여지는 프레임
private function Camp_Potal_Frame takes nothing returns nothing
    local integer i
    
    set camp_potal_back_drop = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(camp_potal_back_drop, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.1)
    call DzFrameSetSize(camp_potal_back_drop, 0.25, 0.33)
    call DzFrameShow(camp_potal_back_drop, false)
    
    set camp_potal_title_text = DzCreateFrameByTagName("TEXT", "", camp_potal_back_drop, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(camp_potal_title_text, JN_FRAMEPOINT_CENTER, camp_potal_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.12)
    
    set camp_potal_region_text = DzCreateFrameByTagName("TEXT", "", camp_potal_back_drop, "LadderNameTextTemplate", 0)
    call DzFrameSetPoint(camp_potal_region_text, JN_FRAMEPOINT_CENTER, camp_potal_back_drop, JN_FRAMEPOINT_CENTER, 0.0, camp_potal_region_y)
    
    set left_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", camp_potal_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(left_button, JN_FRAMEPOINT_CENTER, camp_potal_back_drop, JN_FRAMEPOINT_CENTER, -0.055, camp_potal_region_y)
    call DzFrameSetSize(left_button, 0.045, 0.035)
    call DzFrameSetText(left_button, "이전")
    call DzFrameSetScriptByCode(left_button, JN_FRAMEEVENT_CONTROL_CLICK, function Left_Clicked, false)
    
    set right_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", camp_potal_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(right_button, JN_FRAMEPOINT_CENTER, camp_potal_back_drop, JN_FRAMEPOINT_CENTER, 0.055, camp_potal_region_y)
    call DzFrameSetSize(right_button, 0.045, 0.035)
    call DzFrameSetText(right_button, "다음")
    call DzFrameSetScriptByCode(right_button, JN_FRAMEEVENT_CONTROL_CLICK, function Right_Clicked, false)
    
    
    
    // 지역 포인트들 프레임, 백드롭 이미지 버튼 텍스트로 구성됨, 일단 루프 4번 돌리자 4개 이상 없음
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 3
        set camp_potal_point_back_drop[i] = DzCreateFrameByTagName("BACKDROP", "", camp_potal_back_drop, "QuestButtonPushedBackdropTemplate", 0)
        call DzFrameSetPoint(camp_potal_point_back_drop[i], JN_FRAMEPOINT_CENTER, camp_potal_back_drop, JN_FRAMEPOINT_CENTER, potal_point_x, potal_point_y + (i * -0.05) )
        call DzFrameSetSize(camp_potal_point_back_drop[i], square_size, square_size)
        call DzFrameShow(camp_potal_point_back_drop[i], false)
        
        set camp_potal_point_img[i] = DzCreateFrameByTagName("BACKDROP", "", camp_potal_point_back_drop[i], "QuestButtonPushedBackdropTemplate", 0)
        call DzFrameSetPoint(camp_potal_point_img[i], JN_FRAMEPOINT_CENTER, camp_potal_point_back_drop[i], JN_FRAMEPOINT_CENTER, 0, 0 )
        call DzFrameSetSize(camp_potal_point_img[i], img_size, img_size)
        call DzFrameSetTexture(camp_potal_point_img[i], icon_img, 0)
        call DzFrameShow(camp_potal_point_img[i], false)
        
        set camp_potal_point_button[i] = DzCreateFrameByTagName("BUTTON", "potalpoint/" + I2S(i), camp_potal_point_img[i], "ScoreScreenTabButtonTemplate", 0)
        call DzFrameSetPoint(camp_potal_point_button[i], JN_FRAMEPOINT_CENTER, camp_potal_point_img[i], JN_FRAMEPOINT_CENTER, 0, 0)
        call DzFrameSetSize(camp_potal_point_button[i], square_size, square_size)
        call DzFrameSetScriptByCode(camp_potal_point_button[i], JN_FRAMEEVENT_CONTROL_CLICK, function Potal_Point_Clicked, false)

        set camp_potal_point_text[i] = DzCreateFrameByTagName("TEXT", "", camp_potal_point_img[i], "LadderNameTextTemplate", 0)
        call DzFrameSetPoint(camp_potal_point_text[i], JN_FRAMEPOINT_CENTER, camp_potal_point_img[i], JN_FRAMEPOINT_CENTER, 0.08, 0.0)
        call DzFrameSetText(camp_potal_point_text[i], "" )
    endloop
endfunction

private function Sync_Trigger_Init takes nothing returns nothing
    local trigger trg
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "c_potal", false)
    call TriggerAddAction( trg, function Potal_Point_Sync )
    
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "r_potal", false)
    call TriggerAddAction( trg, function Potal_Region_Sync )
    
    set trg = null
endfunction

function Potal_Frame_Init takes nothing returns nothing
    call Camp_Potal_Frame()
    call Region_Potal_Frame()
    call Sync_Trigger_Init()
endfunction

endlibrary