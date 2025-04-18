library Milestone requires MilestoneSprite, MilestoneGeneric, MilestoneEvent

globals
    integer milestone_button
    integer milestone_box
    integer milestone_frame_text
    private integer the_sprite
    private boolean is_box_on = false
    
    private integer title_text
    private integer reward_title_text
    integer milestone_reward_text_frame

    string array milestone_text
endglobals



function Milestone_Button_Show takes nothing returns nothing
    call DzFrameShow(milestone_button, true)
endfunction

// 껐다 켰다 
private function Button_Clicked takes nothing returns nothing
    local integer pid = GetPlayerId(DzGetTriggerUIEventPlayer())
    call Milestone_Sprite_Hide(pid)
    if is_box_on == true then
        set is_box_on = false
        call DzFrameShow(milestone_box, false)
    else
        set is_box_on = true
        call DzFrameShow(milestone_box, true)
    endif
endfunction



private function Box_And_Inner_Frame takes nothing returns nothing
    local real x = 0.025
    local real y = -0.025
    
    set milestone_box = DzCreateFrameByTagName("BACKDROP", "", milestone_button, "EscMenuBackdrop", 0)
    call DzFrameSetPoint(milestone_box, JN_FRAMEPOINT_TOPRIGHT, milestone_button, JN_FRAMEPOINT_TOPLEFT, 0.0, 0.0)
    call DzFrameSetSize(milestone_box, 0.20, 0.20)
    call DzFrameShow(milestone_box, false)
    
    set title_text = DzCreateFrameByTagName("TEXT", "", milestone_box, "TeamLabelTextTemplate", 0)
    call DzFrameSetPoint(title_text, JN_FRAMEPOINT_TOPLEFT, milestone_box, JN_FRAMEPOINT_TOPLEFT, x, y)
    call DzFrameSetText(title_text, "내용" )
    
    set milestone_frame_text = DzCreateFrameByTagName("TEXT", "", milestone_box, "", 0)
    call DzFrameSetPoint(milestone_frame_text, JN_FRAMEPOINT_TOPLEFT, milestone_box, JN_FRAMEPOINT_TOPLEFT, x, y - 0.02)
    call DzFrameSetText(milestone_frame_text, milestone_text[0] )
    
    set reward_title_text = DzCreateFrameByTagName("TEXT", "", milestone_box, "TeamLabelTextTemplate", 0)
    call DzFrameSetPoint(reward_title_text, JN_FRAMEPOINT_TOPLEFT, milestone_box, JN_FRAMEPOINT_TOPLEFT, x, y - 0.07)
    call DzFrameSetText(reward_title_text, "보상" )
    
    set milestone_reward_text_frame = DzCreateFrameByTagName("TEXT", "", milestone_box, "", 0)
    call DzFrameSetPoint(milestone_reward_text_frame, JN_FRAMEPOINT_TOPLEFT, milestone_box, JN_FRAMEPOINT_TOPLEFT, x, y - 0.09)
    call DzFrameSetText(milestone_reward_text_frame, milestone_reward_text[0] )
endfunction

private function Button_Frame takes nothing returns nothing
    set milestone_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(milestone_button, JN_FRAMEPOINT_TOPRIGHT, DzGetGameUI(), JN_FRAMEPOINT_TOPRIGHT, -0.015, -0.03)
    call DzFrameSetSize(milestone_button, 0.048, 0.048)
    call DzFrameSetText(milestone_button, "메인\n퀘스트")
    call DzFrameSetScriptByCode(milestone_button, JN_FRAMEEVENT_CONTROL_CLICK, function Button_Clicked, false)
    call DzFrameShow(milestone_button, false)
endfunction

function Milestone_Frame_Init takes nothing returns nothing
    call Milestone_Reward_Text_Init()
    call Milestone_Text_Init()
    call Button_Frame()
    call Box_And_Inner_Frame()
    call Milestone_Sprite_Init()
    call Milestone_Event_Init()
endfunction

endlibrary