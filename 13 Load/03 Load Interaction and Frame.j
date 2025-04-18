library LoadInteraction requires Base, LoadGeneric, NewCharacter, LoadCharacter, LoadCharacterGeneric

globals
    integer choose_box
    
    private integer explain_text
    private integer yes_button
    private integer no_button
    
    
endglobals

private function No_Clicked takes nothing returns nothing
    call Choose_Frame_Hide()
    call Load_Frame_Show()
endfunction

// 캐릭터를 로드하거나, 새로 생성한다
private function Yes_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    
    call Choose_Frame_Hide()
    
    if is_Test == false and current_difficulty_cleared[current_load_index] < MAP_DIFFICULTY then
        call Load_Frame_Show()
        call BJDebugMsg("이전 난이도를 클리어 하세요...\n\n")
        return
    endif
    
    call Load_Frame_Hide()
    
    if is_character_loaded[current_load_index] == true then
        // Load Character Init 에 함수 있음
        call Load_Character_Code(pid)
        call Load_Extensive_Code(pid)
        call Load_Potal_State_Code(pid)
        
        // 각플
        if GetLocalPlayer() == Player(pid) then
            // 맵 중앙으로 카메라 이동
            call PanCameraToTimed(map_center_x, map_center_y, 0.1)
            // 미니맵 보임
            call DzFrameShow(DzFrameGetMinimap(), true)
            // 캐릭 확정되서 플레이하면 기본적인 프레임들 보여줌
            call Show_Normal_Frames()
            // 포탈 저장 스트링을 불린 어레이에 등록, 지역 포탈석상 등록 용이하게 하기 위함 
            call Set_Potal_State_Check()
        endif
    else
        call New_Character_Set_Camera(0)
        call New_Character_Camera_Lock_Start(pid)
        call New_Character_Frame_Show()
    endif
endfunction

function Load_Button_Clicked takes nothing returns nothing
    local integer index = S2I( JNStringSplit(DzFrameGetName(DzGetTriggerUIEventFrame()), "/", 0) )
    
    set current_load_index = index
    
    call PlaySoundBJ(gg_snd_BigButtonClick)
    
    if is_character_loaded[index] == true then
        call DzFrameSetText(explain_text, "캐릭터를 로드 합니다" )
        call Choose_Frame_Show()
        call Load_Frame_Hide()
    else
        if is_Test == false and MAP_DIFFICULTY >= NIGHTMARE then
            call BJDebugMsg("나이트메어 이상 난이도는\n새 캐릭터 생성 불가\n\n")
        else
            call DzFrameSetText(explain_text, "새 캐릭터를 생성 합니다" )
            call Choose_Frame_Show()
            call Load_Frame_Hide()
        endif
    endif
endfunction

private function Choose_Frame_Init takes nothing returns nothing
    set choose_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(choose_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.0)
    call DzFrameSetSize(choose_box, 0.26, 0.16)
    call DzFrameShow(choose_box, false)
    
    set explain_text = DzCreateFrameByTagName("TEXT", "", choose_box, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(explain_text, JN_FRAMEPOINT_CENTER, choose_box, JN_FRAMEPOINT_CENTER, 0.0, 0.03)
    call DzFrameSetText(explain_text, "" )
    
    set yes_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", choose_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(yes_button, JN_FRAMEPOINT_CENTER, choose_box, JN_FRAMEPOINT_CENTER, -0.05, -0.03)
    call DzFrameSetSize(yes_button, 0.060, 0.04)
    call DzFrameSetText(yes_button, "YES")
    call DzFrameSetScriptByCode(yes_button, JN_FRAMEEVENT_CONTROL_CLICK, function Yes_Clicked, false)
    
    set no_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", choose_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(no_button, JN_FRAMEPOINT_CENTER, choose_box, JN_FRAMEPOINT_CENTER, 0.05, -0.03)
    call DzFrameSetSize(no_button, 0.060, 0.04)
    call DzFrameSetText(no_button, "NO")
    call DzFrameSetScriptByCode(no_button, JN_FRAMEEVENT_CONTROL_CLICK, function No_Clicked, false)
endfunction

function Load_Interaction_Init takes nothing returns nothing
    call Choose_Frame_Init()
endfunction

endlibrary