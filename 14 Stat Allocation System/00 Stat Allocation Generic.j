library StatAllocationGeneric

// =====================================================
// API
// =====================================================

function Stat_Alloc_Refresh_All takes integer pid returns nothing
    local Hero current_hero = player_hero[pid]
        
    if GetLocalPlayer() == Player(pid) then
        call DzFrameSetText(property_value_text[0], I2S( current_hero.Get_Stat_Alloc_Property(AD) ) )
        call DzFrameSetText(property_value_text[1], I2S( current_hero.Get_Stat_Alloc_Property(AP) ) )
        call DzFrameSetText(property_value_text[2], I2S( current_hero.Get_Stat_Alloc_Property(AS) ) )
        call DzFrameSetText(property_value_text[3], I2S( current_hero.Get_Stat_Alloc_Property(MS) ) )
        call DzFrameSetText(property_value_text[4], I2S( current_hero.Get_Stat_Alloc_Property(HP) ) )
        call DzFrameSetText(property_value_text[5], I2S( current_hero.Get_Stat_Alloc_Property(MP) ) )
        call DzFrameSetText(property_value_text[6], I2S( current_hero.Get_Stat_Alloc_Property(DEF_AD) ) )
        call DzFrameSetText(property_value_text[7], I2S( current_hero.Get_Stat_Alloc_Property(DEF_AP) ) )
        call DzFrameSetText(property_value_text[8], I2S( current_hero.Get_Stat_Alloc_Property(HP_REGEN) ) )
        call DzFrameSetText(property_value_text[9], I2S( current_hero.Get_Stat_Alloc_Property(MP_REGEN) ) )
        call DzFrameSetText(stat_point_value_text, I2S( current_hero.Get_Stat_Point() ) )
    endif
endfunction

function Stat_Alloc_Property_Value_Refresh takes integer pid, integer property returns nothing
    local Hero current_hero = player_hero[pid]
    local integer index
        
    if GetLocalPlayer() == Player(pid) then
        if property == AD then
            set index = 0
        elseif property == AP then
            set index = 1
        elseif property == AS then
            set index = 2
        elseif property == MS then
            set index = 3
        elseif property == HP then
            set index = 4
        elseif property == MP then
            set index = 5
        elseif property == DEF_AD then
            set index = 6
        elseif property == DEF_AP then
            set index = 7
        elseif property == HP_REGEN then
            set index = 8
        elseif property == MP_REGEN then
            set index = 9
        endif
        
        call DzFrameSetText(property_value_text[index], I2S( current_hero.Get_Stat_Alloc_Property(property) ) )
    endif
endfunction

function Stat_Alloc_Stat_Point_Refresh takes integer pid returns nothing
    local Hero current_hero = player_hero[pid]
    
    if GetLocalPlayer() == Player(pid) then
        call DzFrameSetText(stat_point_value_text, I2S( current_hero.Get_Stat_Point() ) )
    endif
endfunction

endlibrary