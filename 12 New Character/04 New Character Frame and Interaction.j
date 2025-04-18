library NewCharacterFrame requires Base, NewCharacterCamera, NewCharacterBuild, FrameShow

globals
    private integer select_index = 0

    integer new_character_back_drop
    
    private integer left_button
    private integer right_button
    
    private integer select_button
    private integer donate_text
    
    private real img_size = 0.050
    
    private integer img_back_drop
    private integer name_text
    private integer atk_type_text
    private integer explain_text
    
    private real Min_X = -15360
    private real Min_Y = -15612
    private real Max_X = 15359
    private real Max_Y = 14723
endglobals

private function Character_Select_Sync takes nothing returns nothing
    local string str = DzGetTriggerSyncData()
    local integer pid = S2I(JNStringSplit(str, "/", 0))
    local integer character_select_index = S2I(JNStringSplit(str, "/", 1))
    
    // 카메라 락 해제
    call New_Character_Camera_Unlock(pid)
    
    // 캐릭 생성
    call New_Character_Build( pid, New_Character_Unit_Type(character_select_index) )
    
    // 캐릭터 존 시야 파괴
    call Destroy_Select_Zone_View(pid)
    
    // 각플
    if GetLocalPlayer() == Player(pid) then
        // 카메라 바운드 해제
        call SetCameraBounds(Min_X, Min_Y, Min_X, Max_Y, Max_X, Max_Y, Max_X, Min_Y)
        // 카메라 리셋
        call ResetToGameCamera(0.5)
        // 맵 중앙으로 카메라 이동
        call PanCameraToTimed(map_center_x, map_center_y, 0.2)
        // 미니맵 보임
        call DzFrameShow(DzFrameGetMinimap(), true)
        // 캐릭 확정되서 플레이하면 기본적인 프레임들 보여줌
        call Show_Normal_Frames()
        // 포탈 저장 스트링을 불린 어레이에 등록, 지역 포탈석상 등록 용이하게 하기 위함 
        call Set_Potal_State_Check()
    endif
    
endfunction

private function Explaination_Refresh takes nothing returns nothing
    call DzFrameSetTexture(img_back_drop, New_Character_Img(select_index), 0)
    call DzFrameSetText(name_text, New_Character_Name(select_index) )
    call DzFrameSetText(atk_type_text, New_Character_Atk_Type(select_index) )
    call DzFrameSetText(explain_text, New_Character_Explaination(select_index) )
endfunction


// 이 스트링은 Map Start 폴더의 Player_Build 에 있다
private function Character_Lock_Check takes nothing returns boolean
    local string str = JNStringSplit(character_lock, "/", select_index)
    
    if str == "1" then
        return true
    else
        return false
    endif
endfunction

private function Select_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    if Character_Lock_Check() == true then
        call New_Character_Frame_Hide()
        call DzSyncData("chsel", I2S(pid) + "/" + I2S(select_index))
    endif
endfunction

private function Right_Clicked takes nothing returns nothing
    set select_index = Mod( select_index + 1, hero_type_count)
    call New_Character_Set_Camera(select_index)
    call Explaination_Refresh()
    
    if Character_Lock_Check() == true then
        call DzFrameShow(select_button, true)
        call DzFrameShow(donate_text, false)
    else
        call DzFrameShow(select_button, false)
        call DzFrameShow(donate_text, true)
    endif
endfunction

private function Left_Clicked takes nothing returns nothing
    set select_index = Mod( select_index - 1, hero_type_count)
    call New_Character_Set_Camera(select_index)
    call Explaination_Refresh()
    
    if Character_Lock_Check() == true then
        call DzFrameShow(select_button, true)
        call DzFrameShow(donate_text, false)
    else
        call DzFrameShow(select_button, false)
        call DzFrameShow(donate_text, true)
    endif
endfunction

private function Explaination_Init takes nothing returns nothing
    set img_back_drop = DzCreateFrameByTagName("BACKDROP", "", new_character_back_drop, "QuestButtonPushedBackdropTemplate", 0)
    call DzFrameSetPoint(img_back_drop, JN_FRAMEPOINT_CENTER, new_character_back_drop, JN_FRAMEPOINT_CENTER, 0, 0.10 )
    call DzFrameSetSize(img_back_drop, img_size, img_size)
    call DzFrameSetTexture(img_back_drop, New_Character_Img(select_index), 0)
    
    set name_text = DzCreateFrameByTagName("TEXT", "", new_character_back_drop, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(name_text, JN_FRAMEPOINT_CENTER, new_character_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.06)
    call DzFrameSetText(name_text, New_Character_Name(select_index) )
    
    set atk_type_text = DzCreateFrameByTagName("TEXT", "", new_character_back_drop, "TeamLabelTextTemplate", 0)
    call DzFrameSetPoint(atk_type_text, JN_FRAMEPOINT_CENTER, new_character_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.03)
    call DzFrameSetText(atk_type_text, New_Character_Atk_Type(select_index) )
    
    set explain_text = DzCreateFrameByTagName("TEXT", "", new_character_back_drop, "", 0)
    call DzFrameSetPoint(explain_text, JN_FRAMEPOINT_TOP, new_character_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetText(explain_text, New_Character_Explaination(select_index) )
endfunction

// 버튼들
private function Buttons_Init takes nothing returns nothing
    set left_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", new_character_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(left_button, JN_FRAMEPOINT_CENTER, new_character_back_drop, JN_FRAMEPOINT_CENTER, -0.045, -0.10)
    call DzFrameSetSize(left_button, 0.045, 0.035)
    call DzFrameSetText(left_button, "이전")
    call DzFrameSetScriptByCode(left_button, JN_FRAMEEVENT_CONTROL_CLICK, function Left_Clicked, false)
    
    set right_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", new_character_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(right_button, JN_FRAMEPOINT_CENTER, new_character_back_drop, JN_FRAMEPOINT_CENTER, 0.045, -0.10)
    call DzFrameSetSize(right_button, 0.045, 0.035)
    call DzFrameSetText(right_button, "다음")
    call DzFrameSetScriptByCode(right_button, JN_FRAMEEVENT_CONTROL_CLICK, function Right_Clicked, false)
    
    set select_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", new_character_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(select_button, JN_FRAMEPOINT_CENTER, new_character_back_drop, JN_FRAMEPOINT_CENTER, 0.0, 0.21)
    call DzFrameSetSize(select_button, 0.12, 0.05)
    call DzFrameSetText(select_button, "캐릭터 선택")
    call DzFrameSetScriptByCode(select_button, JN_FRAMEEVENT_CONTROL_CLICK, function Select_Clicked, false)
    
    set donate_text = DzCreateFrameByTagName("TEXT", "", new_character_back_drop, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(donate_text, JN_FRAMEPOINT_CENTER, select_button, JN_FRAMEPOINT_CENTER, 0.0, 0.00)
    call DzFrameSetText(donate_text, "후원 전용" )
    call DzFrameShow(donate_text, false)
endfunction

// 백드롭
private function Box_Init takes nothing returns nothing
    set new_character_back_drop = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(new_character_back_drop, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.29, 0.0)
    call DzFrameSetSize(new_character_back_drop, 0.20, 0.30)
    call DzFrameShow(new_character_back_drop, false)
endfunction

private function Sync_Trigger_Init takes nothing returns nothing
    local trigger trg
    
    // 캐릭터 선택 동기화
    set trg = CreateTrigger()
    call DzTriggerRegisterSyncData(trg, "chsel", false)
    call TriggerAddAction( trg, function Character_Select_Sync )
    
    set trg = null
endfunction

function New_Character_Frame_Init takes nothing returns nothing
    call Sync_Trigger_Init()
    call Box_Init()
    call Buttons_Init()
    call Explaination_Init()
    call Sync_Trigger_Init()
endfunction

endlibrary