library Stat requires StatButtonAndBox, StatText, UnitProperty

globals
    private integer array property_to_index[16]
    private string array property_to_suffix[16]
endglobals

private function Preprocess takes nothing returns nothing
    set property_to_index[AD] = 0
    set property_to_index[AP] = 1
    set property_to_index[AS] = 2
    set property_to_index[MS] = 3
    set property_to_index[CRIT] = 4
    set property_to_index[CRIT_COEF] = 5
    set property_to_index[ENHANCE_AD] = 6
    set property_to_index[ENHANCE_AP] = 7
    set property_to_index[HP] = 8
    set property_to_index[MP] = 9
    set property_to_index[DEF_AD] = 10
    set property_to_index[DEF_AP] = 11
    set property_to_index[HP_REGEN] = 12
    set property_to_index[MP_REGEN] = 13
    set property_to_index[REDUCE_AD] = 14
    set property_to_index[REDUCE_AP] = 15
    
    set property_to_suffix[AD] = ""
    set property_to_suffix[AP] = ""
    set property_to_suffix[AS] = "%"
    set property_to_suffix[MS] = ""
    set property_to_suffix[CRIT] = "%"
    set property_to_suffix[CRIT_COEF] = "%"
    set property_to_suffix[ENHANCE_AD] = "%"
    set property_to_suffix[ENHANCE_AP] = "%"
    set property_to_suffix[HP] = ""
    set property_to_suffix[MP] = ""
    set property_to_suffix[DEF_AD] = ""
    set property_to_suffix[DEF_AP] = ""
    set property_to_suffix[HP_REGEN] = ""
    set property_to_suffix[MP_REGEN] = ""
    set property_to_suffix[REDUCE_AD] = "%"
    set property_to_suffix[REDUCE_AP] = "%"
endfunction

// 이 함수 실행하면 스탯창 생김
function Stat_Frame_Init takes nothing returns nothing
    call Stat_Button_And_Box_Init()
    call Stat_Text_Init()
    call Preprocess()
endfunction

function Stat_Refresh_Specific takes integer pid, integer property returns nothing
    if GetLocalPlayer() == Player(pid) then
        call DzFrameSetText( stat_values[property_to_index[property]], I2S(Get_Unit_Property(player_hero[pid].Get_Hero_Unit(), property)) + property_to_suffix[property] )
    endif
endfunction

// 히어로 객체 기반으로 스탯창 값 갱신하는 함수임
function Stat_Refresh takes integer pid returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    
    if GetLocalPlayer() == Player(pid) then
        call DzFrameSetText( stat_values[0], I2S(Get_Unit_Property(u, AD)) )
        call DzFrameSetText( stat_values[1], I2S(Get_Unit_Property(u, AP)) )
        call DzFrameSetText( stat_values[2], I2S(Get_Unit_Property(u, AS)) + "%")
        call DzFrameSetText( stat_values[3], I2S(Get_Unit_Property(u, MS)) )
        call DzFrameSetText( stat_values[4], I2S(Get_Unit_Property(u, CRIT)) + "%")
        call DzFrameSetText( stat_values[5], I2S(Get_Unit_Property(u, CRIT_COEF)) + "%")
        call DzFrameSetText( stat_values[6], I2S(Get_Unit_Property(u, ENHANCE_AD)) + "%")
        call DzFrameSetText( stat_values[7], I2S(Get_Unit_Property(u, ENHANCE_AP)) + "%")
        call DzFrameSetText( stat_values[8], I2S(Get_Unit_Property(u, HP)) )
        call DzFrameSetText( stat_values[9], I2S(Get_Unit_Property(u, MP)) )
        call DzFrameSetText( stat_values[10], I2S(Get_Unit_Property(u, DEF_AD)) )
        call DzFrameSetText( stat_values[11], I2S(Get_Unit_Property(u, DEF_AP)) )
        call DzFrameSetText( stat_values[12], I2S(Get_Unit_Property(u, HP_REGEN)) )
        call DzFrameSetText( stat_values[13], I2S(Get_Unit_Property(u, MP_REGEN)) )
        call DzFrameSetText( stat_values[14], I2S(Get_Unit_Property(u, REDUCE_AD)) + "%")
        call DzFrameSetText( stat_values[15], I2S(Get_Unit_Property(u, REDUCE_AP)) + "%")
        call DzFrameSetText( level_value, I2S(GetHeroLevel(u)) )
    endif
    
    set u = null
endfunction

endlibrary