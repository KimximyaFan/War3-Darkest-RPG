library InvenToolTip requires InvenGeneric

globals
    private integer tool_tip_back_drop
    private integer tool_tip_img
    private integer tool_tip_name
    private integer tool_tip_grade
    private integer tool_tip_type
    private integer array tool_tip_stats
endglobals

// 아이템에 커서 빠져나올 때 실행됨
function Inven_Tool_Tip_Leave takes nothing returns nothing
    local integer i
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        call DzFrameShow(tool_tip_stats[i], false)
    endloop
    
    call DzFrameShow(tool_tip_back_drop, false)
endfunction

// 아이템에 커서 갔다 놨을 때 실행됨
function Inven_Tool_Tip_Enter takes nothing returns nothing
    local integer pid = GetPlayerId( DzGetTriggerUIEventPlayer() )
    local string frame = DzFrameGetName(DzGetTriggerUIEventFrame())
    local integer index = S2I( SubString( frame, 0, 2) )
    local string the_entered_frame = SubString( frame, StringLength(frame)-4, StringLength(frame))
    local real tool_tip_width = 0.125
    local real tool_tip_height = 0.015
    local integer count = 0
    local integer saved_index = -1
    local string saved_string
    local Equip E
    
    if isUpgrade == true then
        return
    endif
    
    if the_entered_frame == "item" then
        set E = Hero(pid+1).Get_Inven_Item(index)
        call DzFrameSetPoint(tool_tip_back_drop, JN_FRAMEPOINT_CENTER, item_buttons[index], JN_FRAMEPOINT_CENTER, -0.08, 0.04)
    else
        set E = Hero(pid+1).Get_Wearing_Item(index)
        call DzFrameSetPoint(tool_tip_back_drop, JN_FRAMEPOINT_CENTER, wearing_buttons[index], JN_FRAMEPOINT_CENTER, -0.08, 0.04)
    endif
    
    call DzFrameSetTexture(tool_tip_img, E.Get_Img(), 0)
    
    if E.Get_Upgrade_Count() > 0 then
        call DzFrameSetText(tool_tip_name, E.Get_Name() + " +" + I2S(E.Get_Upgrade_Count()) )
    else
        call DzFrameSetText(tool_tip_name, E.Get_Name() )
    endif
    
    call DzFrameSetText(tool_tip_grade, item_grade[ E.Get_Grade() ])
    call DzFrameSetText(tool_tip_type, "|cff9E9E9E " + E.Integer_To_Type() + " |r")
    
    if E.Get_AD() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "공격력 " + I2S(E.Get_AD()))
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_AP() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "주문력 " + I2S(E.Get_AP()))
        call DzFrameShow(tool_tip_stats[count], true)

        set count = count + 1
    endif
    if E.Get_AS() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "공격속도 " + I2S(E.Get_AS()) + "%" )
        call DzFrameShow(tool_tip_stats[count], true)
        
        if E.Get_Type() == GLOVE then
            set saved_index = count
            set saved_string = DzFrameGetText(tool_tip_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_MS() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "이동속도 " + I2S(E.Get_MS()))
        call DzFrameShow(tool_tip_stats[count], true)
        
        if E.Get_Type() == BOOTS then
            set saved_index = count
            set saved_string = DzFrameGetText(tool_tip_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_CRIT() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "치명확률 " + I2S(E.Get_CRIT()) + "%")
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_CRIT_COEF() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "치명피해 " + I2S(E.Get_CRIT_COEF()) + "%")
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_DEF_AD() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "물리방어 " + I2S(E.Get_DEF_AD()))
        call DzFrameShow(tool_tip_stats[count], true)
        
        if E.Get_Type() == HELMET or E.Get_Type() == SHIELD then
            set saved_index = count
            set saved_string = DzFrameGetText(tool_tip_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_DEF_AP() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "마법방어 " + I2S(E.Get_DEF_AP()))
        call DzFrameShow(tool_tip_stats[count], true)
        
        if E.Get_Type() == BELT then
            set saved_index = count
            set saved_string = DzFrameGetText(tool_tip_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_HP() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "체력 " + I2S(E.Get_HP()))
        call DzFrameShow(tool_tip_stats[count], true)
        
        if E.Get_Type() == ARMOR then
            set saved_index = count
            set saved_string = DzFrameGetText(tool_tip_stats[count])
        endif
        
        set count = count + 1
    endif
    if E.Get_MP() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "마나 " + I2S(E.Get_MP()))
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_HP_REGEN() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "체력회복 " + I2S(E.Get_HP_REGEN()))
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_MP_REGEN() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "마나회복 " + I2S(E.Get_MP_REGEN()))
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_ENHANCE_AD() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "물리피해강화 " + I2S(E.Get_ENHANCE_AD()) + "%")
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_ENHANCE_AP() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "마법피해강화 " + I2S(E.Get_ENHANCE_AP()) + "%")
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_REDUCE_AD() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "물리피해감소 " + I2S(E.Get_REDUCE_AD()) + "%")
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    if E.Get_REDUCE_AP() != 0 then
        call DzFrameSetText(tool_tip_stats[count], "마법피해감소 " + I2S(E.Get_REDUCE_AP()) + "%")
        call DzFrameShow(tool_tip_stats[count], true)
        set count = count + 1
    endif
    
    // 주스탯 있는 장비들 위한 코드
    if saved_index != -1 then
        call DzFrameSetText(tool_tip_stats[saved_index], DzFrameGetText(tool_tip_stats[0]))
        call DzFrameSetText(tool_tip_stats[0], saved_string)
    endif

    call DzFrameSetSize(tool_tip_back_drop, tool_tip_width, (inven_item_size + 0.07) + tool_tip_height * count)
    call DzFrameShow(tool_tip_back_drop, true)
    
endfunction

// 아이템에 커서 갔다놨을 때의 툴팁나오는거, 백드롭과 이미지 그리고 텍스트들 일단 초기화
private function Inven_Tool_Tip_Frame takes nothing returns nothing
    local integer i
    
    set tool_tip_back_drop = DzCreateFrameByTagName("BACKDROP", "", inven_box, "QuestButtonBaseTemplate", 0)
    
    set tool_tip_img = DzCreateFrameByTagName("BACKDROP", "", tool_tip_back_drop, "QuestButtonBaseTemplate", 0)
    call DzFrameSetPoint(tool_tip_img, JN_FRAMEPOINT_CENTER, tool_tip_back_drop, JN_FRAMEPOINT_TOP, 0, -0.01 - (inven_item_size/2) )
    call DzFrameSetSize(tool_tip_img, inven_item_size, inven_item_size)
    
    set tool_tip_name = DzCreateFrameByTagName("TEXT", "", tool_tip_back_drop, "", 0)
    call DzFrameSetPoint(tool_tip_name, JN_FRAMEPOINT_CENTER, tool_tip_back_drop, JN_FRAMEPOINT_TOP, 0.0, -(inven_item_size + 0.020))
    
    set tool_tip_grade = DzCreateFrameByTagName("TEXT", "", tool_tip_back_drop, "", 0)
    call DzFrameSetPoint(tool_tip_grade, JN_FRAMEPOINT_CENTER, tool_tip_back_drop, JN_FRAMEPOINT_TOP, 0.0, -(inven_item_size + 0.035))
    
    set tool_tip_type = DzCreateFrameByTagName("TEXT", "", tool_tip_back_drop, "", 0)
    call DzFrameSetPoint(tool_tip_type, JN_FRAMEPOINT_CENTER, tool_tip_back_drop, JN_FRAMEPOINT_TOP, 0.0, -(inven_item_size + 0.050))
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 4
        set tool_tip_stats[i] = DzCreateFrameByTagName("TEXT", "", tool_tip_back_drop, "", 0)
        call DzFrameSetPoint(tool_tip_stats[i], JN_FRAMEPOINT_CENTER, tool_tip_back_drop, JN_FRAMEPOINT_TOP, 0.0, -(inven_item_size + 0.07) -i * 0.015)
        call DzFrameShow(tool_tip_stats[i], false)
    endloop

    call DzFrameShow(tool_tip_back_drop, false)
endfunction

function Inven_Tool_Tip_Init takes nothing returns nothing
    call Inven_Tool_Tip_Frame()
endfunction

endlibrary