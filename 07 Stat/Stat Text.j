library StatText

globals
    integer level_back_drop
    integer level_texts
    integer level_value_back_drop
    integer level_value

    private integer array stat_back_drop
    private integer array stat_texts
    private real text_box_width = 0.082
    private real box_height = 0.026
    
    private integer array stat_value_back_drop
    integer array stat_values
    private real value_box_width = 0.048
endglobals

private function Stat_Text takes nothing returns nothing
    local integer i
    local real x = 0.02
    local real y = -0.08
    local real a
    local real b
    local string array the_stat
    
    set the_stat[0] = "공격력"
    set the_stat[1] = "주문력"
    set the_stat[2] = "공격속도"
    set the_stat[3] = "이동속도"
    set the_stat[4] = "치명확률"
    set the_stat[5] = "치명피해"
    set the_stat[6] = "물리피해강화"
    set the_stat[7] = "마법피해강화"
    set the_stat[8] = "체력"
    set the_stat[9] = "마나"
    set the_stat[10] = "물리방어력"
    set the_stat[11] = "마법방어력"
    set the_stat[12] = "체력회복"
    set the_stat[13] = "마나회복"
    set the_stat[14] = "물리받피감"
    set the_stat[15] = "마법받피감"

    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 15
        set a = (i / 8)
        set b = ModuloInteger(i, 8)
        set stat_back_drop[i] = DzCreateFrameByTagName("BACKDROP", "", stat_box, "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(stat_back_drop[i], JN_FRAMEPOINT_TOPLEFT, stat_box, JN_FRAMEPOINT_TOPLEFT, x + (a * 0.14), y - (b * 0.025))
        call DzFrameSetSize(stat_back_drop[i], text_box_width, box_height)
        
        set stat_texts[i] = DzCreateFrameByTagName("TEXT", "", stat_back_drop[i], "", 0)
        call DzFrameSetPoint(stat_texts[i], JN_FRAMEPOINT_CENTER, stat_back_drop[i], JN_FRAMEPOINT_CENTER, 0, 0 )
        call DzFrameSetText(stat_texts[i], "|cffffcc00" + the_stat[i] + "|r")
        
        set stat_value_back_drop[i] = DzCreateFrameByTagName("BACKDROP", "", stat_back_drop[i], "ScoreScreenButtonBackdropTemplate", 0)
        call DzFrameSetPoint(stat_value_back_drop[i], JN_FRAMEPOINT_LEFT, stat_back_drop[i], JN_FRAMEPOINT_RIGHT, 0.0, 0.0)
        call DzFrameSetSize(stat_value_back_drop[i], value_box_width, box_height)
        
        set stat_values[i] = DzCreateFrameByTagName("TEXT", "", stat_value_back_drop[i], "", 0)
        call DzFrameSetPoint(stat_values[i], JN_FRAMEPOINT_CENTER, stat_value_back_drop[i], JN_FRAMEPOINT_CENTER, 0, 0 )
        call DzFrameSetText(stat_values[i], "0")
    endloop
    
endfunction

private function Level_Text takes nothing returns nothing
    local real x = 0.035
    local real y = -0.03
    
    set level_back_drop = DzCreateFrameByTagName("BACKDROP", "", stat_box, "QuestButtonDisabledBackdropTemplate", 0)
    call DzFrameSetPoint(level_back_drop, JN_FRAMEPOINT_TOPLEFT, stat_box, JN_FRAMEPOINT_TOPLEFT, x, y)
    call DzFrameSetSize(level_back_drop, 0.041, 0.031)
    
    set level_texts = DzCreateFrameByTagName("TEXT", "", level_back_drop, "", 0)
    call DzFrameSetPoint(level_texts, JN_FRAMEPOINT_CENTER, level_back_drop, JN_FRAMEPOINT_CENTER, 0, 0 )
    call DzFrameSetText(level_texts, "레벨")
    
    set level_value_back_drop = DzCreateFrameByTagName("BACKDROP", "", level_back_drop, "QuestButtonDisabledBackdropTemplate", 0)
    call DzFrameSetPoint(level_value_back_drop, JN_FRAMEPOINT_LEFT, level_back_drop, JN_FRAMEPOINT_RIGHT, 0.01, 0.0)
    call DzFrameSetSize(level_value_back_drop, 0.046, 0.031)
    
    set level_value = DzCreateFrameByTagName("TEXT", "", level_value_back_drop, "", 0)
    call DzFrameSetPoint(level_value, JN_FRAMEPOINT_CENTER, level_value_back_drop, JN_FRAMEPOINT_CENTER, 0, 0 )
    call DzFrameSetText(level_value, "0")
endfunction

function Stat_Text_Init takes nothing returns nothing
    call Level_Text()
    call Stat_Text()
endfunction

endlibrary