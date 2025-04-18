struct MonsterTextTag

private unit u                          /* 텍스트 태그 주인 유닛 */
private integer texttag_count           /* 텍스트 태그 몇개 있음? */
private texttag array texttag_set[4]    /* 텍스트 태그 집합 */
private string array texttag_name[4]
private integer array skill_set[4] 

// ==================================================================

public static method create takes unit monster returns thistype
    local thistype this = thistype.allocate()
    set u = monster
    set texttag_count = 0
    return this
endmethod

public method destroy takes nothing returns nothing
    local integer i= -1
    
    loop
    set i = i + 1
    exitwhen i >= texttag_count
        call DestroyTextTag(texttag_set[i])
        set texttag_set[i] = null
    endloop
    set u = null
    set texttag_count = 0
    call thistype.deallocate( this )
endmethod

public method Texttag_Position_Refresh takes nothing returns nothing
    local integer i= -1
    
    loop
    set i = i + 1
    exitwhen i >= texttag_count
        call SetTextTagPos( texttag_set[i], GetUnitX(u) + monster_texttag_x, GetUnitY(u), monster_texttag_height[i] )
    endloop
endmethod

public method Texttag_Register takes string s, integer skill returns nothing
    set texttag_name[texttag_count] = s
    set skill_set[texttag_count] = skill
    set texttag_count = texttag_count + 1
endmethod

public method Texttag_Refresh_Start takes nothing returns nothing
    local integer i= -1
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    local real texttag_size = 6.5
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= texttag_count
        set texttag_set[i] = Text_Tag(x + monster_texttag_x, y, 255, 255, 255, texttag_size, monster_texttag_height[i], 0, 0, 255, -1, -1, texttag_name[i], null, -1, 0.0)
    endloop
endmethod

endstruct