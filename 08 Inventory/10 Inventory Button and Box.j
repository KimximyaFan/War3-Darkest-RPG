library InvenButtonAndBox requires InvenSprite

globals
    boolean isInven = false
    
    integer inven_button
    private integer x_button
    integer inven_box
endglobals

function Inven_Button_Show takes nothing returns nothing
    call DzFrameShow(inven_button, true)
endfunction

// 인벤 박스 껐다 켰다 
private function Inventory_Button_Clicked takes nothing returns nothing
    if isInven == true then
        set isInven = false
        call DzFrameShow(inven_box, false)
        
        set inven_clicked_index = -1
        set wearing_clicked_index = -1
        call Inven_Sprite_Hide()
    else
        set isInven = true
        call DzFrameShow(inven_box, true)
    endif
endfunction

// 끄기 버튼
private function Inven_X_Button takes nothing returns nothing
    set x_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", inven_box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(x_button, JN_FRAMEPOINT_TOPLEFT, inven_box, JN_FRAMEPOINT_TOPLEFT, 0, 0)
    call DzFrameSetSize(x_button, 0.032, 0.032)
    call DzFrameSetText(x_button, "X")
    call DzFrameSetScriptByCode(x_button, JN_FRAMEEVENT_CONTROL_CLICK, function Inventory_Button_Clicked, false)
endfunction

// 인벤 백드롭
private function Inven_Box takes nothing returns nothing
    set inven_box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(inven_box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.16, 0.07)
    call DzFrameSetSize(inven_box, 0.47, 0.30)
    call DzFrameShow(inven_box, false)
endfunction

// 인벤 버튼
private function Inven_Button takes nothing returns nothing
    set inven_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", DzGetGameUI(), "ScriptDialogButton", 0)
    call DzFrameSetPoint(inven_button, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, -0.24, -0.26)
    call DzFrameSetSize(inven_button, 0.06, 0.04)
    call DzFrameSetText(inven_button, "인벤")
    call DzFrameSetScriptByCode(inven_button, JN_FRAMEEVENT_CONTROL_CLICK, function Inventory_Button_Clicked, false)
    call DzFrameShow(inven_button, false)
endfunction

function Inven_Button_And_Box_Init takes nothing returns nothing
    call Inven_Button()
    call Inven_Box()
    call Inven_X_Button()
endfunction

endlibrary