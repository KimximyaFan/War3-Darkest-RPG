library MonsterTextTag requires UnitProperty

globals
    private group texttag_monster_group = CreateGroup()
    private real time_interval = 0.02
endglobals

private function Refresh_Text_Tag takes nothing returns nothing
    local group g = Group_Copy(texttag_monster_group, null)
    local unit c
    local MonsterTextTag MTT
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        set MTT = Get_Unit_Property(c, TEXT_TAG)
        call MTT.Texttag_Position_Refresh()
    endloop
    
    call Group_Clear(g)
    
    set g = null
    set c = null
endfunction

function Refresh_Text_Tag_Init takes nothing returns nothing
    call TimerStart(CreateTimer(), time_interval, true, function Refresh_Text_Tag)
endfunction

function Grade_Text_Tag_Unregister takes unit u returns nothing
    local MonsterTextTag MTT
    
    if Get_Unit_Property(u, TEXT_TAG) == 0 then
        return
    endif
    
    call GroupRemoveUnit( texttag_monster_group, u )
    
    set MTT = Get_Unit_Property(u, TEXT_TAG)
    call MTT.destroy()
    call Set_Unit_Property(u, TEXT_TAG, 0)
endfunction

function Grade_Text_Tag_Register takes unit u returns nothing
    local MonsterTextTag MTT
    
    set MTT = Get_Unit_Property(u, TEXT_TAG)
    call MTT.Texttag_Refresh_Start()
    call GroupAddUnit( texttag_monster_group, u )
endfunction

endlibrary