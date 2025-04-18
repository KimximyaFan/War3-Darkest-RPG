library FrameShow requires LinkFrame, SaveFrames, InvenButtonAndBox, StatButtonAndBox, HpMpBar, PotionFrame, BgmFrame

function Show_Normal_Frames takes nothing returns nothing
    // 각종 프레임들
    call Inven_Button_Show()
    call Stat_Button_Show()
    call Save_Button_Show()
    call Link_Button_Show()
    call Hp_Mp_Bar_Show()
    call Potion_Frame_Show()
    call Bgm_Button_Show()
    call Buff_Button_Show()
    call Milestone_Button_Show()
    call Stat_Alloc_Button_Show()
endfunction

private function ESC_Close takes nothing returns nothing
    call InvenUpgrade_Upgrade_Box_Off()

    set isInven = false
    call DzFrameShow(inven_box, false)
    
    set inven_clicked_index = -1
    set wearing_clicked_index = -1
    call Inven_Sprite_Hide()
    
    set isStat = false
    call DzFrameShow(stat_box, false)
    
    call Stat_Alloc_Box_Off()
endfunction

function ESC_Init takes nothing returns nothing
    call DzTriggerRegisterKeyEventByCode(null, JN_OSKEY_ESCAPE, 0, false, function ESC_Close)
endfunction

function Fast_Timer_Base_Refresh takes nothing returns nothing
    call HpMpBar_Hp_Mp_Bar_Refresh()
    
endfunction

function Slow_Timer_Base_Refresh takes nothing returns nothing
    call BgmFrame_Volume_Control_Refresh()
    
endfunction

function Timer_Base_Refresh takes nothing returns nothing
    call TimerStart(CreateTimer(), 0.03125, true, function Fast_Timer_Base_Refresh)
    call TimerStart(CreateTimer(), 0.2    , true, function Slow_Timer_Base_Refresh)
endfunction

endlibrary