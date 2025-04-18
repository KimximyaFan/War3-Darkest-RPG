library Serialization

/*

캐릭 타입
캐릭 레벨
캐릭 경험치
장착 9칸
인벤 25칸

아이템 정보
- grade
- type (투구, 무기, ...)
- special
- 아이템 스탯

/4#2#-1#0,100&2,33&.../

*/

private function Add_Item_Information takes string data, Equip E returns string
    set data = data + "/"
    set data = data + I2S( E.Get_Grade() )
    set data = data + "#"
    set data = data + I2S(E.Get_Upgrade_Count())
    set data = data + "#"
    set data = data + I2S(E.Get_Type())
    set data = data + "#"
    set data = data + I2S( E.Get_Special() )
    
    if E.Get_AD() != 0 then
        set data = data + "#"
        set data = data + I2S(AD)
        set data = data + ","
        set data = data + I2S( E.Get_AD() )
    endif
    if E.Get_AP() != 0 then
        set data = data + "#"
        set data = data + I2S(AP)
        set data = data + ","
        set data = data + I2S( E.Get_AP() )
    endif
    if E.Get_AS() != 0 then
        set data = data + "#"
        set data = data + I2S(AS)
        set data = data + ","
        set data = data + I2S( E.Get_AS() )
    endif
    if E.Get_MS() != 0 then
        set data = data + "#"
        set data = data + I2S(MS)
        set data = data + ","
        set data = data + I2S( E.Get_MS() )
    endif
    if E.Get_CRIT() != 0 then
        set data = data + "#"
        set data = data + I2S(CRIT)
        set data = data + ","
        set data = data + I2S( E.Get_CRIT() )
    endif
    if E.Get_CRIT_COEF() != 0 then
        set data = data + "#"
        set data = data + I2S(CRIT_COEF)
        set data = data + ","
        set data = data + I2S( E.Get_CRIT_COEF() )
    endif
    if E.Get_DEF_AD() != 0 then
        set data = data + "#"
        set data = data + I2S(DEF_AD)
        set data = data + ","
        set data = data + I2S( E.Get_DEF_AD() )
    endif
    if E.Get_DEF_AP() != 0 then
        set data = data + "#"
        set data = data + I2S(DEF_AP)
        set data = data + ","
        set data = data + I2S( E.Get_DEF_AP() )
    endif
    if E.Get_HP() != 0 then
        set data = data + "#"
        set data = data + I2S(HP)
        set data = data + ","
        set data = data + I2S( E.Get_HP() )
    endif
    if E.Get_MP() != 0 then
        set data = data + "#"
        set data = data + I2S(MP)
        set data = data + ","
        set data = data + I2S( E.Get_MP() )
    endif
    if E.Get_HP_REGEN() != 0 then
        set data = data + "#"
        set data = data + I2S(HP_REGEN)
        set data = data + ","
        set data = data + I2S( E.Get_HP_REGEN() )
    endif
    if E.Get_MP_REGEN() != 0 then
        set data = data + "#"
        set data = data + I2S(MP_REGEN)
        set data = data + ","
        set data = data + I2S( E.Get_MP_REGEN() )
    endif
    if E.Get_ENHANCE_AD() != 0 then
        set data = data + "#"
        set data = data + I2S(ENHANCE_AD)
        set data = data + ","
        set data = data + I2S( E.Get_ENHANCE_AD() )
    endif
    if E.Get_ENHANCE_AP() != 0 then
        set data = data + "#"
        set data = data + I2S(ENHANCE_AP)
        set data = data + ","
        set data = data + I2S( E.Get_ENHANCE_AP() )
    endif
    if E.Get_REDUCE_AD() != 0 then
        set data = data + "#"
        set data = data + I2S(REDUCE_AD)
        set data = data + ","
        set data = data + I2S( E.Get_REDUCE_AD() )
    endif
    if E.Get_REDUCE_AP() != 0 then
        set data = data + "#"
        set data = data + I2S(REDUCE_AP)
        set data = data + ","
        set data = data + I2S( E.Get_REDUCE_AP() )
    endif
    
    return data
endfunction

function Serialize takes integer pid returns string
    local string data
    local unit u = Hero(pid+1).Get_Hero_Unit()
    local string unit_type = I2S( GetUnitTypeId(u) )
    local string unit_gold = I2S( GetPlayerState(Player(pid), PLAYER_STATE_RESOURCE_GOLD) )
    local string unit_exp = I2S( GetHeroXP(u) )
    local integer i
    local Equip E
    
    // 저장체킹용, 유닛타입, 골드, 경험치
    set data = "808" + "/" + unit_type + "/" + unit_gold + "/" + unit_exp
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 9
        if Hero(pid+1).Check_Wearing_Item(i) == true then
            set E = Hero(pid+1).Get_Wearing_Item(i)
            set data = Add_Item_Information(data, E)
        else
            set data = data + "/" + "-1"
        endif
    endloop
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 24
        if Hero(pid+1).Check_Inven_Item(i) == true then
            set E = Hero(pid+1).Get_Inven_Item(i)
            set data = Add_Item_Information(data, E)
        else
            set data = data + "/" + "-1"
        endif
    endloop
    
    // 스탯 증가 프로퍼티
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(AD) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(AP) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(AS) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(MS) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(HP) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(MP) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(DEF_AD) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(DEF_AP) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(HP_REGEN) )
    set data = data + "/" + I2S( player_hero[pid].Get_Stat_Alloc_Property(MP_REGEN) )
    
    set u = null
    
    return data
endfunction

endlibrary