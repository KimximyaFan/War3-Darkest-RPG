library CourtyardFrame requires CourtyardController

globals
    private integer sprite
    private integer courtyard_button
    private integer courtyard_box
    
    private integer courtyard_title
    private integer courtyard_zone_text
    private integer courtyard_index_left_button
    private integer courtyard_index_right_button
    private integer courtyard_auto_text
    private integer courtyard_auto_checkbox
    private integer courtyard_loop_text
    private integer courtyard_loop_checkbox
    private integer courtyard_mercenary_button
    private integer courtyard_start_button
    private integer courtyard_end_button
    
    private boolean is_box_on = false
endglobals


function Courtyard_Button_Hide takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzFrameShow(courtyard_button, false)
    endif
endfunction

function Courtyard_Button_Show takes integer pid returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzFrameShow(sprite, true)
        call DzFrameShow(courtyard_button, true)
    endif
endfunction

// 껐다 켰다 
private function Courtyard_Button_Clicked takes nothing returns nothing
    call DzFrameShow(sprite, false)
    
    if is_box_on == true then
        set is_box_on = false
        call DzFrameShow(courtyard_box, false)
    else
        set is_box_on = true
        call DzFrameShow(courtyard_box, true)
    endif
endfunction

// ========================================================

private function End_Button_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId(DzGetTriggerUIEventPlayer())
    
    // This Function In Courtyard Controller
    call Courtyard_Combat_End(pid)
    
    // Hide Interface
    call Courtyard_Button_Clicked()
endfunction

private function Start_Button_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId(DzGetTriggerUIEventPlayer())
    
    // This Function In Courtyard Controller
    call Courtyard_Combat_Start(pid)
    
    // Hide Interface
    call Courtyard_Button_Clicked()
endfunction

private function Mercenary_Button_Clicked takes nothing returns nothing

endfunction

private function Loop_Unchecked takes nothing returns nothing
    set courtyard_is_loop = 0
endfunction

private function Loop_Checked takes nothing returns nothing
    set courtyard_is_loop = 1
endfunction

private function Auto_Unchecked takes nothing returns nothing
    set courtyard_is_auto = 0
endfunction

private function Auto_Checked takes nothing returns nothing
    set courtyard_is_auto = 1
endfunction

private function Index_Right_Button_Clicked takes nothing returns nothing
    set courtyard_level_index = Mod(courtyard_level_index + 1, courtyard_max_level+1)
    call DzFrameSetText(courtyard_zone_text, I2S(courtyard_level_index) + " 구역" )
endfunction

private function Index_Left_Button_Clicked takes nothing returns nothing
    set courtyard_level_index = Mod(courtyard_level_index - 1, courtyard_max_level+1)
    call DzFrameSetText(courtyard_zone_text, I2S(courtyard_level_index) + " 구역" )
endfunction

private function Box_Inner_Frame takes nothing returns nothing
    local real x = 0.025
    local real y = -0.025
    
    // 제목
    set courtyard_title = DzCreateFrameByTagName("TEXT", "", courtyard_box, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(courtyard_title, JN_FRAMEPOINT_TOPLEFT, courtyard_box, JN_FRAMEPOINT_TOPLEFT, x+0.02, y-0.01)
    call DzFrameSetText(courtyard_title, "방치된 안뜰" )
    // 몇 구역
    set courtyard_zone_text = DzCreateFrameByTagName("TEXT", "", courtyard_box, "TeamLadderRankValueTextTemplate", 0)
    call DzFrameSetPoint(courtyard_zone_text, JN_FRAMEPOINT_CENTER, courtyard_title, JN_FRAMEPOINT_CENTER, 0.00, -0.06)
    call DzFrameSetText(courtyard_zone_text, I2S(courtyard_level_index) + " 구역" )
    // 왼쪽
    set courtyard_index_left_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", courtyard_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(courtyard_index_left_button, JN_FRAMEPOINT_CENTER, courtyard_zone_text, JN_FRAMEPOINT_CENTER, -0.04, -0.07)
    call DzFrameSetSize(courtyard_index_left_button, 0.045, 0.035)
    call DzFrameSetText(courtyard_index_left_button, "이전")
    call DzFrameSetScriptByCode(courtyard_index_left_button, JN_FRAMEEVENT_CONTROL_CLICK, function Index_Left_Button_Clicked, false)
    // 오른쪽 
    set courtyard_index_right_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", courtyard_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(courtyard_index_right_button, JN_FRAMEPOINT_CENTER, courtyard_zone_text, JN_FRAMEPOINT_CENTER, 0.04, -0.07)
    call DzFrameSetSize(courtyard_index_right_button, 0.045, 0.035)
    call DzFrameSetText(courtyard_index_right_button, "다음")
    call DzFrameSetScriptByCode(courtyard_index_right_button, JN_FRAMEEVENT_CONTROL_CLICK, function Index_Right_Button_Clicked, false)
    
    // 용병 추가 버튼
    set courtyard_mercenary_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", courtyard_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(courtyard_mercenary_button, JN_FRAMEPOINT_BOTTOMRIGHT, courtyard_box, JN_FRAMEPOINT_BOTTOMRIGHT, -0.025, 0.075)
    call DzFrameSetSize(courtyard_mercenary_button, 0.1, 0.045)
    call DzFrameSetText(courtyard_mercenary_button, "용병 추가")
    call DzFrameSetScriptByCode(courtyard_mercenary_button, JN_FRAMEEVENT_CONTROL_CLICK, function Mercenary_Button_Clicked, false)
    // 시작 버튼
    set courtyard_start_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", courtyard_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(courtyard_start_button, JN_FRAMEPOINT_CENTER, courtyard_mercenary_button, JN_FRAMEPOINT_CENTER, -0.025, -0.05)
    call DzFrameSetSize(courtyard_start_button, 0.05, 0.045)
    call DzFrameSetText(courtyard_start_button, "시작")
    call DzFrameSetScriptByCode(courtyard_start_button, JN_FRAMEEVENT_CONTROL_CLICK, function Start_Button_Clicked, false)
    // 종료 버튼
    set courtyard_end_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", courtyard_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(courtyard_end_button, JN_FRAMEPOINT_CENTER, courtyard_mercenary_button, JN_FRAMEPOINT_CENTER, 0.025, -0.05)
    call DzFrameSetSize(courtyard_end_button, 0.05, 0.045)
    call DzFrameSetText(courtyard_end_button, "종료")
    call DzFrameSetScriptByCode(courtyard_end_button, JN_FRAMEEVENT_CONTROL_CLICK, function End_Button_Clicked, false)
    
    
    // 자동 전투 텍스트
    set courtyard_auto_text = DzCreateFrameByTagName("TEXT", "", courtyard_box, "", 0)
    call DzFrameSetPoint(courtyard_auto_text, JN_FRAMEPOINT_CENTER, courtyard_mercenary_button, JN_FRAMEPOINT_CENTER, -0.01, 0.075)
    call DzFrameSetText(courtyard_auto_text, "자동 전투" )
    // 자동 전투 체크박스
    set courtyard_auto_checkbox = DzCreateFrameByTagName("GLUECHECKBOX", "", courtyard_box, "QuestCheckBox", 0)
    call DzFrameSetPoint(courtyard_auto_checkbox, JN_FRAMEPOINT_LEFT, courtyard_auto_text, JN_FRAMEPOINT_RIGHT, 0.005, 0.0)
    call DzFrameSetScriptByCode(courtyard_auto_checkbox, JN_FRAMEEVENT_CHECKBOX_CHECKED, function Auto_Checked, false)
    call DzFrameSetScriptByCode(courtyard_auto_checkbox, JN_FRAMEEVENT_CHECKBOX_UNCHECKED, function Auto_Unchecked, false)
    // 반복 전투 텍스트
    set courtyard_loop_text = DzCreateFrameByTagName("TEXT", "", courtyard_box, "", 0)
    call DzFrameSetPoint(courtyard_loop_text, JN_FRAMEPOINT_CENTER, courtyard_auto_text, JN_FRAMEPOINT_CENTER, 0, -0.03)
    call DzFrameSetText(courtyard_loop_text, "반복 전투" )
    // 반복 전투 체크박스
    set courtyard_loop_checkbox = DzCreateFrameByTagName("GLUECHECKBOX", "", courtyard_box, "QuestCheckBox", 0)
    call DzFrameSetPoint(courtyard_loop_checkbox, JN_FRAMEPOINT_LEFT, courtyard_loop_text, JN_FRAMEPOINT_RIGHT, 0.005, 0.0)
    call DzFrameSetScriptByCode(courtyard_loop_checkbox, JN_FRAMEEVENT_CHECKBOX_CHECKED, function Loop_Checked, false)
    call DzFrameSetScriptByCode(courtyard_loop_checkbox, JN_FRAMEEVENT_CHECKBOX_UNCHECKED, function Loop_Unchecked, false)
endfunction

private function Button_N_Box_Frame takes nothing returns nothing
    set courtyard_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(courtyard_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_RIGHT, -0.08, -0.11)
    call DzFrameSetSize(courtyard_button, 0.048, 0.048)
    call DzFrameSetText(courtyard_button, "방치된\n안뜰")
    call DzFrameSetScriptByCode(courtyard_button, JN_FRAMEEVENT_CONTROL_CLICK, function Courtyard_Button_Clicked, false)
    call DzFrameShow(courtyard_button, false)
    
    set courtyard_box = DzCreateFrameByTagName("BACKDROP", "", courtyard_button, "EscMenuBackdrop", 0)
    call DzFrameSetPoint(courtyard_box, JN_FRAMEPOINT_BOTTOMRIGHT, courtyard_button, JN_FRAMEPOINT_TOPLEFT, 0.0, 0.0)
    call DzFrameSetSize(courtyard_box, 0.28, 0.22)
    call DzFrameShow(courtyard_box, false)
    
    set sprite = DzCreateFrameByTagName("SPRITE", "", courtyard_button, "", 0)
    call DzFrameSetModel(sprite, "UI-ModalButtonOn_1.26x.mdx", 0, 0)
    call DzFrameSetAllPoints(sprite, courtyard_button)
    call DzFrameShow(sprite, false)
endfunction

function Courtyard_Frame_Init takes nothing returns nothing
    call Button_N_Box_Frame()
    call Box_Inner_Frame()
endfunction

endlibrary