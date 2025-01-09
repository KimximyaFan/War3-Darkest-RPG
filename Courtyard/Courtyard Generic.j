library CourtyardGeneric

globals
    region courtyard_region
    rect array courtyard_rect[6]
    fogmodifier array courtyard_fogmodifier[6]
    location array courtyard_user_start_loc[6]
    location array courtyard_mosnter_start_loc[6]
    
    group array courtyard_combat_user_group
    group array courtyard_combat_monster_group
    
    boolean array courtyard_auto_check[6]
    boolean array courtyard_loop_check[6]
    boolean array courtyard_end_check[6]
    
    integer courtyard_max_level = 0 /* Local, Save Load 되는 값 */
    integer courtyard_level_index = 0 /* local */
    integer courtyard_is_auto = 0 /* Local */
    integer courtyard_is_loop = 0 /* Local */
endglobals

function Courtyard_Variable_Init takes nothing returns nothing
    local real x
    local real y
    local integer pid
    
    if is_Test == true then
        set courtyard_max_level = 20
    endif
    
    set courtyard_rect[0] = gg_rct_Courtyard0
    set courtyard_rect[1] = gg_rct_Courtyard1
    set courtyard_rect[2] = gg_rct_Courtyard2
    set courtyard_rect[3] = gg_rct_Courtyard3
    set courtyard_rect[4] = gg_rct_Courtyard4
    set courtyard_rect[5] = gg_rct_Courtyard5
    
    set courtyard_region = CreateRegion()
    
    set pid = -1
    loop
    set pid = pid + 1
    exitwhen pid > 5
        // 확장구역
        call RegionAddRect(courtyard_region, courtyard_rect[pid])
        // 시야
        set courtyard_fogmodifier[pid] = CreateFogModifierRect(Player(pid), FOG_OF_WAR_VISIBLE, courtyard_rect[pid], true, false)
        // 유닛 그룹
        set courtyard_combat_user_group[pid] = CreateGroup()
        set courtyard_combat_monster_group[pid] = CreateGroup()
        // 배치 지점
        set x = Polar_X(GetRectCenterX(courtyard_rect[pid]), 850, 225)
        set y = Polar_Y(GetRectCenterY(courtyard_rect[pid]), 850, 225)
        set courtyard_user_start_loc[pid] = Location(x, y)
        set x = Polar_X(GetRectCenterX(courtyard_rect[pid]), 550, 45)
        set y = Polar_Y(GetRectCenterY(courtyard_rect[pid]), 550, 45)
        set courtyard_mosnter_start_loc[pid] = Location(x, y)
        // Auto Loop End
        set courtyard_auto_check[pid] = false
        set courtyard_loop_check[pid] = false
        set courtyard_end_check[pid] = false
    endloop
endfunction

endlibrary