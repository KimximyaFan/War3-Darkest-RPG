library CoveMonster requires MonsterDispose, CoveGeneric

globals
    private real pad = 25.0
    private integer count = 0
    private integer normal_unit_regen_time = 180
endglobals

private function Tide_Guardian_Dispose takes real x, real y returns unit
    return Dispose( 'n002', x + GRR(-pad, pad), y + GRR(-pad, pad), false, 0 )
endfunction

function Forgotten_One_Dispose takes real x, real y returns unit
    return Dispose( 'n01G', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

function Hydra_Dispose takes real x, real y returns nothing
    call Dispose( 'n01F', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Sea_Elemental_Dispose takes real x, real y returns nothing
    call Dispose( 'n01E', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

function Depth_Revernant_Dispose takes real x, real y returns nothing
    call Dispose( 'n01D', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Power_Granite_Golem_Dispose takes real x, real y returns nothing
    call Dispose( 'n015', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Naga_Myrmidon_Dispose takes real x, real y returns nothing
    call Dispose( 'n016', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Turtle_Dispose takes real x, real y returns nothing
    call Dispose( 'n01B', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n01B', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n01C', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Sea_Giant_Dispose takes real x, real y returns nothing
    call Dispose( 'n019', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n019', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n01A', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Naga_Siren_Dispose takes real x, real y returns nothing
    call Dispose( 'n017', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n017', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n018', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Makrura_Dispose takes real x, real y returns nothing
    call Dispose( 'n013', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n014', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Muloc_Dispose takes real x, real y returns nothing
    call Dispose( 'n000', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n011', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n012', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Monster_Dispose_2 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Power_Granite_Golem_Dispose( 15082, -4082 )
    
    set CoveGeneric_tower_group = CreateGroup()
    call GroupAddUnit( CoveGeneric_tower_group, Tide_Guardian_Dispose( 12776, -6591 ) )
    call GroupAddUnit( CoveGeneric_tower_group, Tide_Guardian_Dispose( 14938, 10 ) )
    call GroupAddUnit( CoveGeneric_tower_group, Tide_Guardian_Dispose( 3603, 328 ) )
    call GroupAddUnit( CoveGeneric_tower_group, Tide_Guardian_Dispose( 2175, -3967 ) )
    
    call Muloc_Dispose( 14802, -8280 )
    call Muloc_Dispose( 14562, -7420 )
    call Muloc_Dispose( 14833, -6502 )
    call Muloc_Dispose( 13487, -6822 )
    call Muloc_Dispose( 12607, -5926 )
    call Muloc_Dispose( 13605, -5888 )
    call Muloc_Dispose( 15121, -4261 )
    call Muloc_Dispose( 14261, -3537 )
    call Muloc_Dispose( 13100, -4011 )
    call Muloc_Dispose( 12520, -4224 )
    call Muloc_Dispose( 11043, -5011 )
    call Muloc_Dispose( 10529, -4374 )
    
    call Makrura_Dispose( 14197, -7783 )
    call Makrura_Dispose( 15334, -6221 )
    call Makrura_Dispose( 14755, -5011 )
    call Makrura_Dispose( 13684, -3726 )
    call Makrura_Dispose( 11711, -4675 )
    call Makrura_Dispose( 10010, -4028 )
    call Makrura_Dispose( 12271, -2649 )
    call Makrura_Dispose( 14701, -1991 )
    call Makrura_Dispose( 12909, -1808 )
    call Makrura_Dispose( 15453, -911 )
    call Makrura_Dispose( 12946, 758 )
    
    call Naga_Myrmidon_Dispose( 15359, -4852 )
    call Naga_Myrmidon_Dispose( 15283, -3241 )
    call Naga_Myrmidon_Dispose( 13340, -1765 )
    call Naga_Myrmidon_Dispose( 14800, -113 )
    call Naga_Myrmidon_Dispose( 12905, 355 )
    call Naga_Myrmidon_Dispose( 10292, -2284 )
endfunction

private function Monster_Dispose_1 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    

    call Makrura_Dispose( 11607, -450 )
    call Makrura_Dispose( 9773, -556 )
    call Makrura_Dispose( 9027, 149 )
    call Makrura_Dispose( 8467, -2606 )
    call Makrura_Dispose( 7870, -781 )
    call Makrura_Dispose( 6280, 547 )
    call Makrura_Dispose( 5968, -2085 )
    call Makrura_Dispose( 5730, -1285 )
    call Makrura_Dispose( 5834, -244 )
    call Makrura_Dispose( 4982, -930 )
    call Makrura_Dispose( 3225, -951 )
    call Makrura_Dispose( 1892, -3190 )
    call Makrura_Dispose( 1804, -609 )
    
    call Naga_Siren_Dispose( 13226, -6549 )
    call Naga_Siren_Dispose( 12848, -6144 )
    call Naga_Siren_Dispose( 14756, -3174 )
    call Naga_Siren_Dispose( 10364, -4075 )
    call Naga_Siren_Dispose( 13979, -1230 )
    call Naga_Siren_Dispose( 14784, 324 )
    call Naga_Siren_Dispose( 10312, -1427 )
    call Naga_Siren_Dispose( 10474, -404 )
    call Naga_Siren_Dispose( 8709, -1686 )
    call Naga_Siren_Dispose( 7998, 633 )
    call Naga_Siren_Dispose( 5407, -735 )
    call Naga_Siren_Dispose( 5238, 579 )
    call Naga_Siren_Dispose( 3176, -1854 )
    call Naga_Siren_Dispose( 3934, -1190 )
    call Naga_Siren_Dispose( 2145, -4250 )
    call Naga_Siren_Dispose( 2127, -3816 )
    call Naga_Siren_Dispose( 3900, 10 )

    call Sea_Giant_Dispose( 15269, -1716 )
    call Sea_Giant_Dispose( 7596, -1597 )
    call Sea_Giant_Dispose( 3989, -2141 )
    call Sea_Giant_Dispose( 2964, -3150 )
    
    call Turtle_Dispose( 12578, -826 )
    call Turtle_Dispose( 13872, 455 )
    call Turtle_Dispose( 6690, -545 )
    call Turtle_Dispose( 2719, -1428 )
    call Turtle_Dispose( 2054, 231 )
    

    call Naga_Myrmidon_Dispose( 7242, -2620 )
    call Naga_Myrmidon_Dispose( 6362, -1427 )
    call Naga_Myrmidon_Dispose( 6344, -2472 )
    call Naga_Myrmidon_Dispose( 4093, -2799 )
    
    call Power_Granite_Golem_Dispose( 13417, -5384 )
    call Power_Granite_Golem_Dispose( 10600, -5108 )
    call Power_Granite_Golem_Dispose( 11266, -1315 )
    call Power_Granite_Golem_Dispose( 14519, -1150 )
    call Power_Granite_Golem_Dispose( 8324, -433 )
    call Power_Granite_Golem_Dispose( 5295, -2537 )
    call Power_Granite_Golem_Dispose( 2016, -2597 )
    
    call Sea_Elemental_Dispose( 10319, -3545 )
    call Sea_Elemental_Dispose( 14289, -96 )
    call Sea_Elemental_Dispose( 3916, -394 )
endfunction

private function Monster_Dispose_0 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    

    call Muloc_Dispose( 9717, -3952 )
    call Muloc_Dispose( 10916, -3890 )
    call Muloc_Dispose( 11683, -1664 )
    call Muloc_Dispose( 11452, -2151 )
    call Muloc_Dispose( 12005, -3130 )
    call Muloc_Dispose( 11906, -596 )
    call Muloc_Dispose( 13142, -1279 )
    call Muloc_Dispose( 14046, -2197 )
    call Muloc_Dispose( 13416, -2457 )
    call Muloc_Dispose( 15112, -1103 )
    call Muloc_Dispose( 13064, -4 )
    call Muloc_Dispose( 13926, -792 )
    call Muloc_Dispose( 14646, -374 )
    call Muloc_Dispose( 14260, 287 )
    call Muloc_Dispose( 14668, 706 )
    call Muloc_Dispose( 12336, 480 )
    call Muloc_Dispose( 11810, 336 )
    call Muloc_Dispose( 11030, -540 )
    call Muloc_Dispose( 9494, -2330 )
    call Muloc_Dispose( 9399, -777 )
    call Muloc_Dispose( 9463, -1457 )
    call Muloc_Dispose( 8662, 626 )
    call Muloc_Dispose( 9139, -3600 )
    call Muloc_Dispose( 7913, -2894 )
    call Muloc_Dispose( 8144, -1086 )
    call Muloc_Dispose( 6920, -2140 )
    call Muloc_Dispose( 8207, 291 )
    call Muloc_Dispose( 7349, -716 )
    call Muloc_Dispose( 7166, 506 )
    call Muloc_Dispose( 6492, -2851 )
    call Muloc_Dispose( 5112, -1837 )
    call Muloc_Dispose( 5952, -2136 )
    call Muloc_Dispose( 6051, 478 )
    call Muloc_Dispose( 4650, 537 )
    call Muloc_Dispose( 5142, -1491 )
    call Muloc_Dispose( 4473, -1305 )
    call Muloc_Dispose( 4676, -2159 )
    call Muloc_Dispose( 4714, -3055 )
    call Muloc_Dispose( 3727, -3510 )
    call Muloc_Dispose( 2691, -3830 )
    call Muloc_Dispose( 2770, -197 )
    call Muloc_Dispose( 1971, -1585 )
    call Muloc_Dispose( 3512, -176 )
    
endfunction

function Cove_Monster_Dipose_Init takes nothing returns nothing
    call TimerStart( CreateTimer(), 0.00, false, function Monster_Dispose_0 )
    call TimerStart( CreateTimer(), 0.01, false, function Monster_Dispose_1 )
    call TimerStart( CreateTimer(), 0.02, false, function Monster_Dispose_2 )
endfunction

endlibrary