library RuinsMonster requires MonsterDispose, Base, RuinsGeneric

globals
    private real pad = 25.0
    private integer count = 0
    private integer normal_unit_regen_time = 60
endglobals

private function Count_Modulo takes nothing returns nothing
    // normal_unit_regen_time * (count / 2) 의 의미
    // count 값은 0 1 2 반복
    // 정수 연산이므로 count / 2 는 
    // 0 1 반복
    set count = Mod( count + 1, 2 )
endfunction

private function Arcane_Tower_Dispose takes real x, real y returns unit
    return Dispose( 'h008', x + GRR(-pad, pad), y + GRR(-pad, pad), false, 0 )
endfunction

private function Void_Walker_Dispose takes real x, real y returns unit
    return Dispose( 'n00P', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Revernant_Dispose takes real x, real y returns unit
    return Dispose( 'n00O', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Overlord_Dispose takes real x, real y returns unit
    return Dispose( 'n00N', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Lich_Dispose takes real x, real y returns unit
    return Dispose( 'u001', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Golem_Battle_Dispose takes real x, real y returns unit
    return Dispose( 'n00M', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Acolyte_Dispose takes real x, real y, integer counting, real gap, real angle returns nothing
    local integer i = 0
    
    if counting < 1 then
        set counting = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i > counting
        call Count_Modulo()
        call Dispose( 'n00L', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        set x = Polar_X(x, gap, angle)
        set y = Polar_Y(y, gap, angle)
    endloop
endfunction

private function Fanatic_Dispose takes real x, real y, integer counting, real gap, real angle returns nothing
    local integer i = 0
    
    if counting < 1 then
        set counting = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i > counting
        call Count_Modulo()
        call Dispose( 'h006', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        call Dispose( 'h007', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        set x = Polar_X(x, gap, angle)
        set y = Polar_Y(y, gap, angle)
    endloop
endfunction

private function Skeleton_Axe_Dispose takes real x, real y, integer counting, real gap, real angle returns nothing
    local integer i = 0
    
    if counting < 1 then
        set counting = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i > counting
        call Count_Modulo()
        call Dispose( 'n00K', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        set x = Polar_X(x, gap, angle)
        set y = Polar_Y(y, gap, angle)
    endloop
endfunction

private function Skeleton_Dispose takes real x, real y, integer counting, real gap, real angle returns nothing
    local integer i = 0
    
    if counting < 1 then
        set counting = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i > counting
        call Count_Modulo()
        call Dispose( 'n00J', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        call Dispose( 'n00J', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        call Dispose( 'u000', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        set x = Polar_X(x, gap, angle)
        set y = Polar_Y(y, gap, angle)
    endloop
endfunction

private function Monster_Dispose_3 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Skeleton_Dispose( -8767, -7364, 3, 610, 0 )
    call Skeleton_Dispose( -8768, -8000, 6, 660, 270 )
    call Skeleton_Dispose( -9406, -11195, 4, 610, 180 )
    call Skeleton_Dispose( -10098, -9938, 3, 610, 180 )
    call Skeleton_Dispose( -10047, -8626, 3, 610, 180 )
    call Skeleton_Dispose( -10054, -7310, 5, 610, 180 )
    call Skeleton_Dispose( -12610, -11168, 4, 610, 180 )
    
    call Fanatic_Dispose( -5581, -7400, 0, 0, 0 )
    call Fanatic_Dispose( -4304, -7372, 0, 0, 0 )
    call Fanatic_Dispose( -2350, -5472, 2, 660, 90 )
    call Fanatic_Dispose( -445, -5450, 4, 660, 90 )
    call Fanatic_Dispose( -1057, -6093, 2, 660, 270 )
    call Fanatic_Dispose( -4933, -8691, 0, 0, 0 )
    call Fanatic_Dispose( -3646, -8652, 0, 0, 0 )
    call Fanatic_Dispose( 216, -8691, 0, 0, 0 )
    call Fanatic_Dispose( -4951, -9906, 0, 0, 0 )
    call Fanatic_Dispose( -1068, -10550, 2, 610, 2 )
    
    call Arcane_Tower_Dispose( -15164, -8307 )
    call Arcane_Tower_Dispose( -13896, -8307 )
    
    call Skeleton_Dispose( -13906, -9910, 4, 660, 90 )
    call Skeleton_Dispose( -14534, -9910, 4, 660, 90 )
    call Skeleton_Dispose( -15166, -9907, 4, 660, 90 )
    
    call Fanatic_Dispose( -13906, -9910, 4, 660, 90 )
    call Fanatic_Dispose( -14534, -9910, 4, 660, 90 )
    call Fanatic_Dispose( -15166, -9907, 4, 660, 90 )
    
    call Golem_Battle_Dispose( -15164, -9599 )
    call Golem_Battle_Dispose( -14541, -9578 )
    call Golem_Battle_Dispose( -13913, -9592 )
    
    call Lich_Dispose( -14853, -9266 )

    call Overlord_Dispose( -14202, -9250 )
    
    call Revernant_Dispose( -14535, -8956 )
    
    set RuinsGeneric_region_boss = Void_Walker_Dispose( -14522, -7995 )
endfunction

private function Monster_Dispose_2 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Arcane_Tower_Dispose( -8771, -8634 )
    call Arcane_Tower_Dispose( -8764, -9271 )
    call Arcane_Tower_Dispose( -8769, -9910 )
    
    set RuinsGeneric_tower_group_2 = CreateGroup()
    call GroupAddUnit( RuinsGeneric_tower_group_2, Arcane_Tower_Dispose( -9940, -9795 ) )
    call GroupAddUnit( RuinsGeneric_tower_group_2, Arcane_Tower_Dispose( -9886, -11293 ) )
    call GroupAddUnit( RuinsGeneric_tower_group_2, Arcane_Tower_Dispose( -11455, -11289 ) )
    call GroupAddUnit( RuinsGeneric_tower_group_2, Arcane_Tower_Dispose( -11484, -9798 ) )
    
    set RuinsGeneric_tower_group_3 = CreateGroup()
    call GroupAddUnit( RuinsGeneric_tower_group_3, Arcane_Tower_Dispose( -11518, -7201 ) )
    call GroupAddUnit( RuinsGeneric_tower_group_3, Arcane_Tower_Dispose( -11456, -8748 ) )
    call GroupAddUnit( RuinsGeneric_tower_group_3, Arcane_Tower_Dispose( -9941, -7201 ) )
    call GroupAddUnit( RuinsGeneric_tower_group_3, Arcane_Tower_Dispose( -9924, -8711 ) )
    
    call Arcane_Tower_Dispose( -12607, -7997 )
    call Arcane_Tower_Dispose( -12609, -8644 )
    call Arcane_Tower_Dispose( -12600, -9277 )
    call Arcane_Tower_Dispose( -12604, -9926 )
    call Arcane_Tower_Dispose( -12597, -10566 )

    call Fanatic_Dispose( -10047, -10562, 0, 0, 0 )
    call Fanatic_Dispose( -11333, -10628, 0, 0, 0 )
    call Fanatic_Dispose( -10041, -7989, 0, 0, 0 )
    call Fanatic_Dispose( -11323, -8039, 0, 0, 0 )

    
    call Skeleton_Axe_Dispose( -8645, -7466, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -9028, -8624, 2, 610, 0 )
    call Skeleton_Axe_Dispose( -9026, -9766, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -10129, -11159, 2, 1320, 90 )
    call Skeleton_Axe_Dispose( -11253, -11204, 2, 1320, 90 )
    call Skeleton_Axe_Dispose( -10051, -8586, 2, 1320, 90 )
    call Skeleton_Axe_Dispose( -11309, -8634, 2, 1320, 90 )

    
    call Acolyte_Dispose( -8761, -7992, 0, 0, 0 )
    call Acolyte_Dispose( -9018, -9026, 2, 610, 0 )
    call Acolyte_Dispose( -8534, -9844, 0, 0, 0 )
    call Acolyte_Dispose( -10129, -11159, 2, 1320, 90 )
    call Acolyte_Dispose( -11253, -11204, 2, 1320, 90 )
    call Acolyte_Dispose( -10051, -8586, 2, 1320, 90 )
    call Acolyte_Dispose( -11309, -8634, 2, 1320, 90 )

    
    call Golem_Battle_Dispose( -10050, -10568 )
    call Golem_Battle_Dispose( -11325, -10557 )
    call Golem_Battle_Dispose( -10042, -7973 )
    call Golem_Battle_Dispose( -11332, -7980 )
    call Golem_Battle_Dispose( -9062, -9366 )
    call Golem_Battle_Dispose( -8480, -9412 )
    
    call Lich_Dispose( -10697, -7327 )
    call Lich_Dispose( -9041, -9661 )

    call Overlord_Dispose( -10682, -11202 )
    call Overlord_Dispose( -8450, -9688 )
    
    call Revernant_Dispose( -10696, -9276 )
    call Revernant_Dispose( -8800, -10016 )
endfunction

private function Monster_Dispose_1 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())

    call Skeleton_Dispose( -6210, -7948, 6, 610, 0 )
    call Skeleton_Dispose(-5578, -6660, 6, 610, 0 )
    call Skeleton_Dispose( -4947, -9229, 9, 610, 0)
    call Skeleton_Dispose(-2353, -5992, 5, 610, 0 )
    call Skeleton_Dispose(-4927, -10484, 5, 610, 0 )
    call Skeleton_Dispose( -2963, -11213, 4, 610, 0 )
    call Skeleton_Dispose( -1104, -11821, 3, 610, 0 )

    
    call Skeleton_Axe_Dispose( -5609, -7981, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -4307, -6687, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -3646, -7990, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -2345, -6077, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -440, -6054, 0, 0, 0 )
    call Skeleton_Axe_Dispose( -1098, -11191, 0, 0, 0 )
    
    call Acolyte_Dispose( -4934, -8027, 0, 0, 0 )
    call Acolyte_Dispose( -4963, -9292, 0, 0, 0 )
    call Acolyte_Dispose( -3659, -9236, 0, 0, 0 )
    call Acolyte_Dispose( -1095, -6110, 0, 0, 0 )
    call Acolyte_Dispose( -1083, -9252, 0, 0, 0 )
    call Acolyte_Dispose( -1110, -118445, 0, 0, 0 )
    
    call Lich_Dispose( -1107, -11197 )
    call Lich_Dispose( -1079, -9267 )
    
    call Golem_Battle_Dispose( -449, -4159 )
    call Golem_Battle_Dispose( 180, -4164 )
    call Golem_Battle_Dispose( 196, -11808 )
    call Golem_Battle_Dispose( -3093, -10562 )
    call Golem_Battle_Dispose( -3012, -11143 )
    call Golem_Battle_Dispose( 172, -9279 )
    call Golem_Battle_Dispose( -4302, -6654 )
    call Golem_Battle_Dispose( -3612, -9204 )
    call Golem_Battle_Dispose( -4906, -10518 )
    
    call Overlord_Dispose( 178, -9270 )
    call Overlord_Dispose( -419, -6001 )
    
    call Revernant_Dispose( -2687, -10867 )
    call Revernant_Dispose( -122, -3815 )
endfunction

private function Monster_Dispose_0 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Skeleton_Dispose(-961, -15314, 4, 330, 90)
    call Fanatic_Dispose(-708, -15204, 2, 660, 90)
    call Skeleton_Axe_Dispose(-1474, -14151, 1, 0, 0)
    call Acolyte_Dispose(-1474, -14151, 1, 0, 0)
    call Skeleton_Dispose(-2856, -13715, 3, 330, 270)
    call Skeleton_Dispose(-2428, -13693, 3, 330, 270)
    call Skeleton_Dispose(-2052, -13704, 3, 330, 270)
    call Acolyte_Dispose(-2677, -13850, 2, 330, 270)
    call Skeleton_Axe_Dispose(-2120, -13822, 2, 330, 270)
    call Golem_Battle_Dispose(-3304, -14190)
    call Golem_Battle_Dispose(-2429, -14961)
    set RuinsGeneric_region_unit[0] = Arcane_Tower_Dispose(-3402, -14190)
    set RuinsGeneric_region_unit[1] = Arcane_Tower_Dispose(-2429, -15142)
    
    call Skeleton_Dispose(-2474, -12937, 2, 500, 90)
    call Skeleton_Dispose(-3611, -12041, 3, 610, 180)
    call Skeleton_Dispose(-3587, -12482, 3, 610, 180)
    call Skeleton_Dispose(-3590, -12892, 3, 610, 180)
    call Skeleton_Dispose(-6215, -10546, 3, 660, 90)
    call Skeleton_Dispose(-7485, -10558, 3, 660, 90)
    
    call Skeleton_Axe_Dispose(-6203, -11507, 0, 0, 0)
    call Set_Unit_Property( Dispose( 'n00K', -6000 + GRR(-pad, pad), -1500 + GRR(-pad, pad), true, 0 ), CLASS, ELDER ) /* 이 놈은 보상 추가 */
    
    call Fanatic_Dispose(-2281, -12492, 2, 700, 180)
    call Fanatic_Dispose(-5593, -12480, 2, 610, 180)
    call Fanatic_Dispose(-6269, -11826, 2, 660, 90)
    call Fanatic_Dispose(-6269, -11826, 2, 660, 90)
    call Fanatic_Dispose(-6856, -10561, 0, 0, 0)
    call Fanatic_Dispose(-6850, -9283, 0, 0, 0)
    
    call Acolyte_Dispose(-4227, -12160, 2, 270, 660)
    call Acolyte_Dispose(-7168, -10543, 0, 0, 0)
    call Acolyte_Dispose(-6534, -9279, 0, 0, 0)
    
    call Lich_Dispose(-7486, -9296)
    
    call Golem_Battle_Dispose(-6204, -10537)
    
    call Overlord_Dispose(-4708, -12475)
    
    call Arcane_Tower_Dispose(-4285, -12469)
    set RuinsGeneric_region_unit[2] = Arcane_Tower_Dispose(-7670, -10693)
    set RuinsGeneric_region_unit[3] = Arcane_Tower_Dispose(-6049, -9095)
    
    call Skeleton_Dispose(-6957, -8610, 3, 660, 90)
    call Fanatic_Dispose(-6732, -8282, 1, 700, 90)
    call Skeleton_Axe_Dispose(-6832, -7916, 0, 0, 0)
    
    set RuinsGeneric_tower_group = CreateGroup()
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(-1729, -4805))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(-1092, -7366))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(192, -6735))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(-2371, -8005))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(-1087, -8645))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(191, -7997))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(193, -10546))
    call GroupAddUnit(RuinsGeneric_tower_group, Arcane_Tower_Dispose(-1094, -12470))
endfunction

function Ruins_Monster_Dipose_Init takes nothing returns nothing
    call TimerStart( CreateTimer(), 0.01, false, function Monster_Dispose_0 )
    call TimerStart( CreateTimer(), 0.02, false, function Monster_Dispose_1 )
    call TimerStart( CreateTimer(), 0.03, false, function Monster_Dispose_2 )
    call TimerStart( CreateTimer(), 0.04, false, function Monster_Dispose_3 )
endfunction

endlibrary