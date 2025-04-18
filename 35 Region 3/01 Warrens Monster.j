library WarrensMonster requires MonsterDispose, WarrensGeneric

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

private function Thorn_Tower_Dispose takes real x, real y returns unit
    return Dispose( 'h009', x + GRR(-pad, pad), y + GRR(-pad, pad), false, 0 )
endfunction

private function Doom_Guard_Dispose takes real x, real y returns unit
    return Dispose( 'n010', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Abomination_Dispose takes real x, real y returns unit
    return Dispose( 'u002', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Salamandar_Dispose takes real x, real y returns unit
    return Dispose( 'n00Z', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Satyros_Soulstealer_Dispose takes real x, real y returns unit
    return Dispose( 'n00Y', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Meat_Wagon_Dispose takes real x, real y returns unit
    return Dispose( 'u003', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Fel_Guard_and_Stalker_Dispose takes real x, real y returns nothing
    call Dispose( 'n00W', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
    call Dispose( 'n00X', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Quill_Beast_Dispose takes real x, real y returns unit
    return Dispose( 'n00T', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Razorman_Cheiftain_Dispose takes real x, real y returns unit
    return Dispose( 'n00S', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Razorman_Dispose takes real x, real y, real gap, real angle, integer counting returns nothing
    local integer i = 0
    
    if counting < 1 then
        set counting = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i > counting
        call Count_Modulo()
        call Dispose( 'n00R', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        call Dispose( 'n00Q', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        set x = Polar_X(x, gap, angle)
        set y = Polar_Y(y, gap, angle)
    endloop
endfunction

private function Zombie_and_Worm_Dispose takes real x, real y, real gap, real angle, integer counting returns nothing
    local integer i = 0
    
    if counting < 1 then
        set counting = 1
    endif
    
    loop
    set i = i + 1
    exitwhen i > counting
        call Count_Modulo()
        call Dispose( 'n00V', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        call Dispose( 'n00V', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        call Dispose( 'n00U', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
        set x = Polar_X(x, gap, angle)
        set y = Polar_Y(y, gap, angle)
    endloop
endfunction

private function Monster_Dispose_5 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Razorman_Dispose( 10968, -9008, 1320, 135, 2 )
    call Razorman_Dispose( 8268, -5401, 0, 0, 0 )
    call Razorman_Dispose( 7951, -14221, 0, 0, 0 )
    call Razorman_Dispose( 8039, -15091, 0, 0, 0 )
    call Razorman_Dispose( 9672, -15248, 0, 0, 0 )
    call Razorman_Dispose( 10529, -15305, 0, 0, 0 )
    call Razorman_Dispose( 12703, -15015, 1350, 135, 3 )
    call Razorman_Dispose( 10215, -11820, 0, 0, 0 )
    call Razorman_Dispose( 3969, -5483, 0, 0, 0 )
    call Razorman_Dispose( 6851, -7035, 0, 0, 0 )
    call Razorman_Dispose( 1508, -9130, 0, 0, 0 )
    call Razorman_Dispose( 2596, -13745, 0, 0, 0 )
    call Razorman_Dispose( 6806, -14085, 0, 0, 0 )
    
    call Razorman_Cheiftain_Dispose( 4119, -5337 )
    call Razorman_Cheiftain_Dispose( 6851, -7035 )
    call Razorman_Cheiftain_Dispose( 2740, -6511 )
    call Razorman_Cheiftain_Dispose( 1508, -9130 )
    call Razorman_Cheiftain_Dispose( 2567, -11209 )
    call Razorman_Cheiftain_Dispose( 2596, -13745 )
    call Razorman_Cheiftain_Dispose( 3042, -15431 )
    call Razorman_Cheiftain_Dispose( 3827, -12826 )
    call Razorman_Cheiftain_Dispose( 4709, -14066 )
    call Razorman_Cheiftain_Dispose( 1730, -14785 )
    call Razorman_Cheiftain_Dispose( 6806, -14085 )
    call Razorman_Cheiftain_Dispose( 6195, -12548 )
    call Razorman_Cheiftain_Dispose( 4606, -11038 )
    
    call Fel_Guard_and_Stalker_Dispose( 6365, -10663 )
    call Fel_Guard_and_Stalker_Dispose( 11588, -8397 )
    call Fel_Guard_and_Stalker_Dispose( 9557, -6386 )
    call Fel_Guard_and_Stalker_Dispose( 7992, -14187 )
    call Fel_Guard_and_Stalker_Dispose( 11983, -13876 )
    call Fel_Guard_and_Stalker_Dispose( 4351, -5556 )
    call Fel_Guard_and_Stalker_Dispose( 3288, -15254 )
    
    call Quill_Beast_Dispose( 3893, -5579 )
    call Quill_Beast_Dispose( 6556, -7348 )
    call Quill_Beast_Dispose( 4302, -7277 )
    call Quill_Beast_Dispose( 2525, -6180 )
    call Quill_Beast_Dispose( 1918, -6872 )
    call Quill_Beast_Dispose( 2920, -8906 )
    call Quill_Beast_Dispose( 1673, -9080 )
    call Quill_Beast_Dispose( 1910, -10569 )
endfunction

private function Monster_Dispose_4 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Zombie_and_Worm_Dispose( 6356, -13683, 660, 135, 7 )
    call Zombie_and_Worm_Dispose( 4039, -10094, 660, 45, 4 )
    call Zombie_and_Worm_Dispose( 5680, -9374, 660, 315, 6 )
    call Zombie_and_Worm_Dispose( 8726, -11262, 660, 45, 6 )
    call Zombie_and_Worm_Dispose( 8559, -9380, 660, 45, 4 )
    call Zombie_and_Worm_Dispose( 7545, -8424, 660, 45, 4 )
    call Zombie_and_Worm_Dispose( 8507, -6355, 660, 135, 2 )
    call Zombie_and_Worm_Dispose( 8713, -13450, 660, 315, 4 )
    call Zombie_and_Worm_Dispose( 8699, -14435, 660, 225, 2 )
    call Zombie_and_Worm_Dispose( 10674, -13550, 660, 315, 4 )
endfunction

private function Monster_Dispose_3 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    set WarrensGeneric_tower_group = CreateGroup()
    call GroupAddUnit( WarrensGeneric_tower_group, Thorn_Tower_Dispose( 3671, -12630 ) )
    call GroupAddUnit( WarrensGeneric_tower_group, Thorn_Tower_Dispose( 4670, -13881 ) )
    call GroupAddUnit( WarrensGeneric_tower_group, Thorn_Tower_Dispose( 1319, -14922 ) )
    
    set WarrensGeneric_tower_group2 = CreateGroup()
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 8449, -5197 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 9586, -6330 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 10637, -7361 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 11686, -8375 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 7916, -14122 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 7910, -15194 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 9595, -15275 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 10712, -15396 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 11107, -13040 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 12027, -13872 ) )
    call GroupAddUnit( WarrensGeneric_tower_group2, Thorn_Tower_Dispose( 12908, -14819 ) )
endfunction

private function Monster_Dispose_2 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Fel_Guard_and_Stalker_Dispose( 7045, -6702 )
    call Fel_Guard_and_Stalker_Dispose( 2503, -7056 )
    call Fel_Guard_and_Stalker_Dispose( 1329, -14877 )
    call Fel_Guard_and_Stalker_Dispose( 3736, -12479 )
    call Fel_Guard_and_Stalker_Dispose( 4734, -13698 )
    call Fel_Guard_and_Stalker_Dispose( 7073, -13209 )
    call Fel_Guard_and_Stalker_Dispose( 5881, -8243 )
    call Fel_Guard_and_Stalker_Dispose( 7004, -9944 )

    
    call Meat_Wagon_Dispose( 7948, -15180 )
    call Meat_Wagon_Dispose( 12414, -15328 )
    call Meat_Wagon_Dispose( 10582, -7386 )
    call Meat_Wagon_Dispose( 7406, -8461 )
    call Meat_Wagon_Dispose( 11741, -8439 )
    call Meat_Wagon_Dispose( 3409, -10562 )
    call Meat_Wagon_Dispose( 4840, -13644 )
    call Meat_Wagon_Dispose( 3793, -12466 )
    call Meat_Wagon_Dispose( 2408, -5967 )
    
    call Satyros_Soulstealer_Dispose( 9588, -15265 )
    call Satyros_Soulstealer_Dispose( 11075, -13017 )
    call Satyros_Soulstealer_Dispose( 9027, -8962 )
    call Satyros_Soulstealer_Dispose( 8550, -5297 )
    call Satyros_Soulstealer_Dispose( 7492, -10468 )
    call Satyros_Soulstealer_Dispose( 4468, -9615 )
    call Satyros_Soulstealer_Dispose( 4718, -11044 )
    call Satyros_Soulstealer_Dispose( 5028, -14910 )
    call Satyros_Soulstealer_Dispose( 1509, -9210 )
    call Satyros_Soulstealer_Dispose( 4230, -5075 )
    
    call Salamandar_Dispose( 10753, -15437 )
    call Salamandar_Dispose( 10286, -13909 )
    call Salamandar_Dispose( 10591, -9445 )
    call Salamandar_Dispose( 8649, -6392 )
    call Salamandar_Dispose( 6541, -10893 )
    call Salamandar_Dispose( 5555, -11649 )
    call Salamandar_Dispose( 6267, -12510 )
    call Salamandar_Dispose( 3774, -14946 )
    call Salamandar_Dispose( 2237, -6593 )
    call Salamandar_Dispose( 3008, -15537 )
    
    call Abomination_Dispose( 12954, -14859 )
    call Abomination_Dispose( 9568, -8410 )
    set quest_second_abomination = Abomination_Dispose( 6748, -10394 )
    set quest_first_abomination = Abomination_Dispose( 1278, -15027 )
    
    set WarrensGeneric_region_boss = Doom_Guard_Dispose( 13533, -10460 )
endfunction

private function Monster_Dispose_1 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Razorman_Dispose( 2678, -6370, 750, 225, 2 )
    call Razorman_Dispose( 2600, -8622, 0, 0, 0 )
    call Razorman_Dispose( 2034, -9672, 0, 0, 0 )
    call Razorman_Dispose( 2117, -10919, 0, 0, 0 )
    call Razorman_Dispose( 2085, -12149, 0, 0, 0 )
    call Razorman_Dispose( 1800, -13833, 0, 0, 0 )
    call Razorman_Dispose( 3135, -13260, 0, 0, 0 )
    call Razorman_Dispose( 4132, -14394, 0, 0, 0 )
    call Razorman_Dispose( 3208, -15327, 0, 0, 0 )
    call Razorman_Dispose( 1301, -14424, 660, 315, 2 )
    call Razorman_Dispose( 6812, -13493, 1000, 135, 5 )
    call Razorman_Dispose( 5646, -9347, 0, 0, 0 )
    call Razorman_Dispose( 5803, -10356, 600, 315, 3 )
    call Razorman_Dispose( 6686, -9553, 600, 315, 3 )
    call Razorman_Dispose( 9011, -9913, 1320, 135, 2 )
    call Razorman_Dispose( 10123, -8958, 1320, 135, 2 )

    call Razorman_Cheiftain_Dispose( 5122, -9070 )
    call Razorman_Cheiftain_Dispose( 6620, -9723 )
    call Razorman_Cheiftain_Dispose( 6024, -10213 )
    call Razorman_Cheiftain_Dispose( 10071, -9967 )
    call Razorman_Cheiftain_Dispose( 9084, -8899 )
    call Razorman_Cheiftain_Dispose( 8059, -7775 )
    call Razorman_Cheiftain_Dispose( 10975, -8973 )
    call Razorman_Cheiftain_Dispose( 10000, -7910 )
    call Razorman_Cheiftain_Dispose( 8956, -6844 )
    call Razorman_Cheiftain_Dispose( 8338, -14689 )
    call Razorman_Cheiftain_Dispose( 10100, -14832 )
    call Razorman_Cheiftain_Dispose( 11084, -14102 )
    call Razorman_Cheiftain_Dispose( 12005, -14908 )
    

    call Quill_Beast_Dispose( 1615, -10617 )
    call Quill_Beast_Dispose( 2455, -10053 )
    call Quill_Beast_Dispose( 2345, -12435 )
    call Quill_Beast_Dispose( 940, -14715 )
    call Quill_Beast_Dispose( 3922, -12817 )
    call Quill_Beast_Dispose( 4589, -13410 )
    call Quill_Beast_Dispose( 3204, -14218 )
    call Quill_Beast_Dispose( 4645, -15412 )
    call Quill_Beast_Dispose( 903, -14827 )
    call Quill_Beast_Dispose( 6043, -13302 )
    call Quill_Beast_Dispose( 4604, -11832 )
    call Quill_Beast_Dispose( 3608, -10801 )
    call Quill_Beast_Dispose( 4557, -9547 )
    call Quill_Beast_Dispose( 6181, -10608 )
    call Quill_Beast_Dispose( 6948, -9873 )
    call Quill_Beast_Dispose( 7579, -10465 )
    call Quill_Beast_Dispose( 6731, -11158 )
    call Quill_Beast_Dispose( 8991, -13105 )
    call Quill_Beast_Dispose( 10099, -9919 )
    call Quill_Beast_Dispose( 9659, -14274 )
    call Quill_Beast_Dispose( 8487, -14639 )
    call Quill_Beast_Dispose( 11343, -14231 )
    call Quill_Beast_Dispose( 8864, -9081 )
    call Quill_Beast_Dispose( 7891, -8048 )
    call Quill_Beast_Dispose( 10139, -8832 )
    call Quill_Beast_Dispose( 9069, -7825 )
    call Quill_Beast_Dispose( 8597, -6361 )
endfunction

private function Monster_Dispose_0 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Zombie_and_Worm_Dispose( 6654, -4930, 660, 225, 7 )
    call Zombie_and_Worm_Dispose( 3215, -6962, 660, 225, 3 )
    call Zombie_and_Worm_Dispose( 2588, -6312, 660, 225, 2 )
    call Zombie_and_Worm_Dispose( 2055, -8100, 660, 315, 3 )
    call Zombie_and_Worm_Dispose( 2776, -9634, 660, 225, 3 )
    call Zombie_and_Worm_Dispose( 2407, -11345, 660, 225, 2 )
    call Zombie_and_Worm_Dispose( 2276, -12465, 660, 225, 2 )
    call Zombie_and_Worm_Dispose( 2241, -13415, 660, 315, 5 )
    call Zombie_and_Worm_Dispose( 5573, -15375, 660, 45, 3 )
    
    call Razorman_Dispose( 4667, -5933, 0, 0, 0 )
    call Razorman_Dispose( 6134, -6366, 0, 0, 0 )
    call Razorman_Dispose( 3557, -7270, 0, 0, 0 )
endfunction

function Warrens_Monster_Dipose_Init takes nothing returns nothing
    call TimerStart( CreateTimer(), 0.00, false, function Monster_Dispose_0 )
    call TimerStart( CreateTimer(), 0.01, false, function Monster_Dispose_1 )
    call TimerStart( CreateTimer(), 0.02, false, function Monster_Dispose_2 )
    call TimerStart( CreateTimer(), 0.03, false, function Monster_Dispose_3 )
    call TimerStart( CreateTimer(), 0.04, false, function Monster_Dispose_4 )
    call TimerStart( CreateTimer(), 0.05, false, function Monster_Dispose_5 )
endfunction

endlibrary