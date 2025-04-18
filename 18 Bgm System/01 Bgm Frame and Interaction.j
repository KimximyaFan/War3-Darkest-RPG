library BgmFrame requires BgmGeneric

globals
    private boolean is_bgm = false
    
    

    private integer bgm_button
    private integer bgm_back_drop
    private integer bgm_on_and_off_text
    private integer on_button
    private integer off_button
    
    private integer bgm_volume_text
    private integer volume_control_bar
    private real bgm_volume_value = 100 /* 프레임 아님, 볼륨 수치 */
endglobals

function Bgm_Button_Show takes nothing returns nothing
    call DzFrameShow(bgm_button, true)
endfunction

// Volume 슬라이더 조절됨
public function Volume_Control_Refresh takes nothing returns nothing
    local integer pid = 0

    loop
    exitwhen pid > bj_MAX_PLAYERS
        if GetLocalPlayer() == Player(pid) then
            if is_bgm == true and Hero(pid+1).Get_Hero_Unit() != null then
                if DzFrameGetValue(volume_control_bar) != bgm_volume_value then
                    set bgm_volume_value = DzFrameGetValue(volume_control_bar)
                    call DzFrameSetText(bgm_volume_text, "Volume " + I2S(R2I(bgm_volume_value + 0.01)) )
                    call SetSoundVolumeBJ( BgmGeneric_bgm[BgmGeneric_current_bgm_state], bgm_volume_value )
                endif
            endif
        endif
        set pid = pid + 1
    endloop
endfunction

// BGM 끔
private function Off_Clicked takes nothing returns nothing
    set BgmGeneric_is_bgm_on = false
    call BgmGeneric_Bgm_Off()
endfunction

// BGM 들림
private function On_Clicked takes nothing returns nothing
    set BgmGeneric_is_bgm_on = true
    call BgmGeneric_Bgm_On()
endfunction

// 링크 프레임 껐다 켰다 
private function Bgm_Button_Clicked takes nothing returns nothing
    if is_bgm == true then
        set is_bgm = false
        call DzFrameShow(bgm_back_drop, false)
    else
        set is_bgm = true
        call DzFrameShow(bgm_back_drop, true)
    endif
endfunction

// bgm 프레임 오픈 버튼, bgm On & Off 기능, 볼륨 조절 기능
private function Bgm_Frame takes nothing returns nothing

    set bgm_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(bgm_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.37, -0.08)
    call DzFrameSetSize(bgm_button, 0.039, 0.039)
    call DzFrameSetText(bgm_button, "bgm")
    call DzFrameSetScriptByCode(bgm_button, JN_FRAMEEVENT_CONTROL_CLICK, function Bgm_Button_Clicked, false)
    call DzFrameShow(bgm_button, false)
    
    set bgm_back_drop = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(bgm_back_drop, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.231, -0.02)
    call DzFrameSetSize(bgm_back_drop, 0.24, 0.14)
    call DzFrameShow(bgm_back_drop, false)
    
    set bgm_on_and_off_text = DzCreateFrameByTagName("TEXT", "", bgm_back_drop, "TeamLabelTextTemplate", 0)
    call DzFrameSetPoint(bgm_on_and_off_text, JN_FRAMEPOINT_CENTER, bgm_back_drop, JN_FRAMEPOINT_CENTER, -0.035, 0.04)
    call DzFrameSetText(bgm_on_and_off_text, "BGM" )
    
    set on_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", bgm_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(on_button, JN_FRAMEPOINT_CENTER, bgm_back_drop, JN_FRAMEPOINT_CENTER, -0.06, -0.01)
    call DzFrameSetSize(on_button, 0.045, 0.04)
    call DzFrameSetText(on_button, "ON")
    call DzFrameSetScriptByCode(on_button, JN_FRAMEEVENT_CONTROL_CLICK, function On_Clicked, false)
    
    set off_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", bgm_back_drop, "ScriptDialogButton", 0)
    call DzFrameSetPoint(off_button, JN_FRAMEPOINT_CENTER, bgm_back_drop, JN_FRAMEPOINT_CENTER, -0.01, -0.01)
    call DzFrameSetSize(off_button, 0.045, 0.04)
    call DzFrameSetText(off_button, "OFF")
    call DzFrameSetScriptByCode(off_button, JN_FRAMEEVENT_CONTROL_CLICK, function Off_Clicked, false)
    
    
    set bgm_volume_text = DzCreateFrameByTagName("TEXT", "", bgm_back_drop, "LadderNameTextTemplate", 0)
    call DzFrameSetPoint(bgm_volume_text, JN_FRAMEPOINT_CENTER, bgm_back_drop, JN_FRAMEPOINT_CENTER, 0.05, 0.04)
    call DzFrameSetText(bgm_volume_text, "Volume " + I2S(R2I(bgm_volume_value + 0.01)) )
    
    // 안되면 버튼으로 바꿔야지 뭐
    set volume_control_bar = DzCreateFrameByTagName("SLIDER", "", bgm_back_drop, "QuestMainListScrollBar", 0)
    call DzFrameClearAllPoints(volume_control_bar)
    call DzFrameSetAbsolutePoint(volume_control_bar, JN_FRAMEPOINT_CENTER, 0, 0)
    call DzFrameSetSize(volume_control_bar, 0.012, 0.06)
    call DzFrameSetMinMaxValue(volume_control_bar, 0, 100)
    call DzFrameSetValue(volume_control_bar, bgm_volume_value)
    call DzFrameSetStepValue(volume_control_bar, 1)
    call DzFrameSetPoint(volume_control_bar, JN_FRAMEPOINT_CENTER, bgm_back_drop, JN_FRAMEPOINT_CENTER, 0.05, -0.01)
endfunction

function Bgm_Frame_Init takes nothing returns nothing
    call Bgm_Frame()
endfunction

endlibrary