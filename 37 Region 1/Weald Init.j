library WealdInit requires MonsterDispose, Base

globals
    private real pad = 25.0
    private integer count = 0
    private integer normal_unit_regen_time = 60
    
    public unit region_boss
endglobals

private function Boss_Death takes nothing returns nothing
    local unit c
    
    call Trigger_Clear(GetTriggeringTrigger())
    
    set c = CreateUnit(Player(15), 'e000', -11942, 12, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")
    
    set c = CreateUnit(Player(15), 'e000', -831, -15677, 270)
    call SetUnitScale(c, 1.0, 1.0, 1.0)
    call DzSetUnitModel(c, "B_0013.mdx")
    
    call Simple_Potal_Create(-11942, 12, -836, -15477)
    call Simple_Potal_Create(-831, -15677, -11942, -200)
    
    set c = null
endfunction

private function Boss_Death_Con takes nothing returns boolean
    return GetTriggerUnit() == region_boss
endfunction

private function Count_Modulo takes nothing returns nothing
    // normal_unit_regen_time * (count / 2) 의 의미
    // count 값은 0 1 2 반복
    // 정수 연산이므로 count / 2 는 
    // 0 1 반복
    //set count = Mod( count + 1, 2 )
    set count = Mod( count + 1, 2 )
endfunction

private function Sasquatch_Dispose takes real x, real y returns unit
    return Dispose( 'n00F', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Tauren_Dispose takes real x, real y returns nothing
    call Dispose( 'o000', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Orge_Dispose takes real x, real y returns nothing
    call Dispose( 'n00E', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Golem_Granite_Dispose takes real x, real y returns unit
    return Dispose( 'n00I', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Bandit_Lord_Dispose takes real x, real y returns unit
    return Dispose( 'n009', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Gnoll_Brute_Dispose takes real x, real y returns nothing
    call Dispose( 'n00D', x + GRR(-pad, pad), y + GRR(-pad, pad), true, 0 )
endfunction

private function Golem_Rock_Dispose takes real x, real y returns nothing
    call Count_Modulo()
    call Dispose( 'n00H', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Golem_Mud_Dispose takes real x, real y returns nothing
    call Count_Modulo()
    call Dispose( 'n00G', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n00G', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Wolf_Dispose takes real x, real y returns nothing
    call Count_Modulo()
    call Dispose( 'n00A', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Gnoll_Dispose takes real x, real y returns nothing
    call Count_Modulo()
    call Dispose( 'n00B', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n00B', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n00C', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Bandit_Dispose takes real x, real y returns nothing
    call Count_Modulo()
    call Dispose( 'n007', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n007', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
    call Dispose( 'n008', x + GRR(-pad, pad), y + GRR(-pad, pad), true, normal_unit_regen_time * count )
endfunction

private function Monster_Dispose_4 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    
    call Bandit_Dispose( -8126, -736 )
    call Bandit_Dispose( -8371, -2751 )
    call Bandit_Dispose( -8442, -4015 )
    call Bandit_Dispose( -9284, -5070 )
    call Bandit_Dispose( -9528, -5719 )
    call Bandit_Dispose( -9974, -4558 )
    call Bandit_Dispose( -10098, -5530 )
    call Bandit_Dispose( -10888, -4449 )
    call Bandit_Dispose( -11053, -5421 )
    call Bandit_Dispose( -11637, -4549 )
    call Bandit_Dispose( -11806, -5545 )
    call Bandit_Dispose( -12468, -4572 )
    call Bandit_Dispose( -12552, -5545 )
    call Bandit_Dispose( -13306, -4535 )
    call Bandit_Dispose( -13389, -5640 )
    call Bandit_Dispose( -13853, -4596 )
    call Bandit_Dispose( -14164, -5508 )
    call Bandit_Dispose( -14489, -4742 )
    call Bandit_Dispose( -14671, -5500 )
    call Bandit_Dispose( -13250, 2500 )
    call Bandit_Dispose( -12931, 1563 )
    call Bandit_Dispose( -12344, 2473 )
    call Bandit_Dispose( -12153, 1509 )
    call Bandit_Dispose( -11460, 2473 )
    call Bandit_Dispose( -11483, 1294 )
    call Bandit_Dispose( -10592, 2405 )
    call Bandit_Dispose( -10655, 1120 )
    call Bandit_Dispose( -10520, 1560 )
    call Bandit_Dispose( -10807, 1952 )
    call Bandit_Dispose( -10167, 1753 )
endfunction

private function Monster_Dispose_3 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call Gnoll_Dispose( -15011, 1479 )
    call Gnoll_Dispose( -15150, 2100 )
    call Gnoll_Dispose( -13991, 1599 )
    call Gnoll_Dispose( -14708, 1914 )
    call Gnoll_Dispose( -14148, 1790 )
    call Gnoll_Dispose( -13147, 1988 )
    call Gnoll_Dispose( -12326, 1992 )
    call Gnoll_Dispose( -11592, 1912 )
    call Gnoll_Dispose( -10822, 1841 )
    call Gnoll_Dispose( -10139, 351 )
    call Gnoll_Dispose( -9495, -255 )
    call Gnoll_Dispose( -10101, -716 )
    call Gnoll_Dispose( -9332, -1306 )
    call Gnoll_Dispose( -10223, -1995 )
    call Gnoll_Dispose( -9331, -2420 )
    call Gnoll_Dispose( -10708, -3190 )
    call Gnoll_Dispose( -11140, -2262 )
    call Gnoll_Dispose( -11830, -3065 )
    call Gnoll_Dispose( -12771, -3074 )
    call Gnoll_Dispose( -12757, -2132 )
    call Gnoll_Dispose( -11325, -1753 )
    call Gnoll_Dispose( -12500, -1525 )
    call Gnoll_Dispose( -11371, -1211 )
    
    call Wolf_Dispose( -14269, -267 )
    call Wolf_Dispose( -14795, -58 )
    call Wolf_Dispose( -14226, 373 )
    call Wolf_Dispose( -14859, 792 )
    call Wolf_Dispose( -14251, 1078 )
    call Wolf_Dispose( -14713, 1163 )
    call Wolf_Dispose( -13984, 2036 )
    call Wolf_Dispose( -13008, 1944 )
    call Wolf_Dispose( -11129, 1940 )
    call Wolf_Dispose( -9601, 650 )
    call Wolf_Dispose( -9900, 200 )
    call Wolf_Dispose( -9900, -306 )
    call Wolf_Dispose( -9774, -800 )
    call Wolf_Dispose( -9774, -1300 )
    call Wolf_Dispose( -9842, -2359 )
    call Wolf_Dispose( -9610, -1857 )
endfunction

private function Monster_Dispose_2 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())

    call Wolf_Dispose( -2447, 1691 )
    call Wolf_Dispose( -4404, 1160 )
    call Wolf_Dispose( -4884, -1153 )
    call Wolf_Dispose( -2131, -1243 )
    call Wolf_Dispose( -4226, -4695 )
    call Wolf_Dispose( -4636, -3373 )
    call Wolf_Dispose( -7331, -4614 )
    call Wolf_Dispose( -6692, -1629 )
    call Wolf_Dispose( -8419, -705 )
    call Wolf_Dispose( -14682, -14455 )
    call Wolf_Dispose( -12314, -13973 )
    call Wolf_Dispose( -14168, -12468 )
    call Wolf_Dispose( -10954, -15514 )
    call Wolf_Dispose( -9671, -13457 )
    call Wolf_Dispose( -8346, -15135 )
    call Wolf_Dispose( -7438, -14640 )
    call Wolf_Dispose( -5789, -15282 )
    call Wolf_Dispose( -9961, -5189 )
    call Wolf_Dispose( -11186, -4969 )
    call Wolf_Dispose( -12079, -5032 )
    call Wolf_Dispose( -13530, -5124 )
    call Wolf_Dispose( -14223, -4136 )
    call Wolf_Dispose( -14744, -3758 )
    call Wolf_Dispose( -14329, -3360 )
    call Wolf_Dispose( -14817, -3068 )
    call Wolf_Dispose( -14419, -2709 )
    call Wolf_Dispose( -14818, -2416 )
    call Wolf_Dispose( -14360, -1959 )
    call Wolf_Dispose( -14874, -1590 )
    call Wolf_Dispose( -14342, -1089 )
    call Wolf_Dispose( -14819, -645 )

    call Golem_Mud_Dispose( -15241, -15239 )
    call Golem_Mud_Dispose( -15061, -14672 )
    call Golem_Mud_Dispose( -15133, -14177 )
    call Golem_Mud_Dispose( -14400, -14456 )
    call Golem_Mud_Dispose( -14379, -15191 )
    call Golem_Mud_Dispose( -13969, -15686 )
    call Golem_Mud_Dispose( -13602, -15031 )
    call Golem_Mud_Dispose( -12880, -15557 )
    call Golem_Mud_Dispose( -13242, -15240 )
    call Golem_Mud_Dispose( -11841, -14851 )
    call Golem_Mud_Dispose( -12654, -13525 )
    call Golem_Mud_Dispose( -14046, -12939 )
    call Golem_Mud_Dispose( -11253, -12636 )
    call Golem_Mud_Dispose( -10981, -14169 )
    call Golem_Mud_Dispose( -10505, -15589 )
    call Golem_Mud_Dispose( -10079, -14721 )
    call Golem_Mud_Dispose( -10001, -13435 )
    call Golem_Mud_Dispose( -8694, -13680 )
    call Golem_Mud_Dispose( -9156, -14992 )
    call Golem_Mud_Dispose( -8268, -14966 )
    call Golem_Mud_Dispose( -7456, -13088 )
    call Golem_Mud_Dispose( -7461, -14901 )
    call Golem_Mud_Dispose( -6741, -15655 )
    call Golem_Mud_Dispose( -6528, -14654 )
    call Golem_Mud_Dispose( -5655, -15597 )
    call Golem_Mud_Dispose( -6279, -15356 )
    call Golem_Mud_Dispose( -4515, -15084 )
    
    call Golem_Rock_Dispose( -14359, -15648 )
    call Golem_Rock_Dispose( -13383, -14541 )
    call Golem_Rock_Dispose( -12922, -14928 )
    call Golem_Rock_Dispose( -13111, -13087 )
    call Golem_Rock_Dispose( -14461, -12794 )
    call Golem_Rock_Dispose( -11078, -12828 )
    call Golem_Rock_Dispose( -10981, -15540 )
    call Golem_Rock_Dispose( -9743, -12864 )
    call Golem_Rock_Dispose( -8411, -12989 )
    call Golem_Rock_Dispose( -8744, -14376 )
    call Golem_Rock_Dispose( -7420, -13981 )
    call Golem_Rock_Dispose( -6350, -14925 )
    call Golem_Rock_Dispose( -5508, -15407 )
    
    call Gnoll_Brute_Dispose( -4970, -4301 )
    call Gnoll_Brute_Dispose( -9054, -12879 )
    call Gnoll_Brute_Dispose( -8889, -15284 )
    call Gnoll_Brute_Dispose( -14869, -4760 )
    call Gnoll_Brute_Dispose( -11784, -5103 )
    call Gnoll_Brute_Dispose( -9610, 25 )
    call Gnoll_Brute_Dispose( -9924, -1207 )
    
    set quest_bandit_lord = Bandit_Lord_Dispose( -7251, 2400 )
    call Bandit_Lord_Dispose( -15084, -5328 )
    call Bandit_Lord_Dispose( -9807, 2053 )
    call Bandit_Lord_Dispose( -9442, 1756 )
    
    call Golem_Granite_Dispose( -13173, -15044 )
    set quest_granite_golem = Golem_Granite_Dispose( -8856, -12951 )
    call Golem_Granite_Dispose( -5688, -14566 )
    call Golem_Granite_Dispose( -6435, -14397 )
    
    call Orge_Dispose( -14406, -4913 )
    call Orge_Dispose( -14587, -2098 )
    call Orge_Dispose( -14894, 1707 )
    call Orge_Dispose( -13967, 1569 )
    call Orge_Dispose( -12485, -2721 )
    call Orge_Dispose( -12551, -2259 )
    
    call Tauren_Dispose( -14560, -340 )
    call Tauren_Dispose( -14491, 2126 )
    call Tauren_Dispose( -9835, 1258 )
    call Tauren_Dispose( -10722, -2819 )

    set region_boss = Sasquatch_Dispose( -12028, -695 )
endfunction

private function Monster_Dispose_1 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call Gnoll_Dispose( -5212, -1624 )
    call Gnoll_Dispose( -5735, -1334 )
    call Gnoll_Dispose( -4491, -2242 )
    call Gnoll_Dispose( -3731, -1933 )
    call Gnoll_Dispose( -2407, -1513 )
    call Gnoll_Dispose( -1998, -2504 )
    call Gnoll_Dispose( -2937, -3279 )
    call Gnoll_Dispose( -3586, -3829 )
    call Gnoll_Dispose( -4301, -4666 )
    call Gnoll_Dispose( -4978, -3325 )
    call Gnoll_Dispose( -4723, -4091 )
    call Gnoll_Dispose( -6852, -4688 )
    call Gnoll_Dispose( -8335, 732 )
    call Gnoll_Dispose( -8012, -474 )
    call Gnoll_Dispose( -8384, -1684 )
    call Gnoll_Dispose( -7586, -2566 )
    call Gnoll_Dispose( -8748, -3382 )
    call Gnoll_Dispose( -11884, -15109 )
    call Gnoll_Dispose( -12267, -13939 )
    call Gnoll_Dispose( -13448, -13338 )
    call Gnoll_Dispose( -14374, -13124 )
    call Gnoll_Dispose( -14406, -12509 )
    call Gnoll_Dispose( -11717, -12664 )
    call Gnoll_Dispose( -10979, -13744 )
    call Gnoll_Dispose( -10956, -14978 )
    call Gnoll_Dispose( -10054, -14907 )
    call Gnoll_Dispose( -10040, -13833 )
    call Gnoll_Dispose( -8714, -14663 )
    call Gnoll_Dispose( -7455, -12965 )
    call Gnoll_Dispose( -7422, -14384 )
    call Gnoll_Dispose( -6861, -15645 )
    call Gnoll_Dispose( -9473, -5241 )
    call Gnoll_Dispose( -10395, -5205 )
    call Gnoll_Dispose( -11222, -4865 )
    call Gnoll_Dispose( -11983, -5347 )
    call Gnoll_Dispose( -13089, -4999 )
    call Gnoll_Dispose( -13743, -5265 )
    call Gnoll_Dispose( -14091, -4826 )
endfunction

private function Monster_Dispose_0 takes nothing returns nothing
    call DestroyTimer(GetExpiredTimer())
    call Bandit_Dispose( -2793, -230 )
    call Bandit_Dispose( -2282, 467 )
    call Bandit_Dispose( -2631, 1293 )
    call Bandit_Dispose( -2504, 2156 )
    call Bandit_Dispose( -3517, 3056 )
    call Bandit_Dispose( -4344, 2946 )
    call Bandit_Dispose( -4475, 2152 )
    call Bandit_Dispose( -3985, 1590 )
    call Bandit_Dispose( -3841, 970 )
    call Bandit_Dispose( -5073, 857 )
    call Bandit_Dispose( -4956, 198 )
    call Bandit_Dispose( -4415, -430 )
    call Bandit_Dispose( -7143, -3791 )
    call Bandit_Dispose( -6285, -3509 )
    call Bandit_Dispose( -6740, -2492 )
    call Bandit_Dispose( -5883, -2291 )
    call Bandit_Dispose( -6380, -1647 )
    call Bandit_Dispose( -6768, -819 )
    call Bandit_Dispose( -6598, 141 )
    call Bandit_Dispose( -6844, 866 )
    call Bandit_Dispose( -6096, 689 )
    call Bandit_Dispose( -6007, 1376 )
    call Bandit_Dispose( -7317, 1230 )
    call Bandit_Dispose( -6622, 1606 )
    call Bandit_Dispose( -7745, 1546 )
    call Bandit_Dispose( -7902, 2089 )
    call Bandit_Dispose( -6755, 2185 )
    call Bandit_Dispose( -7219, 1990 )
    call Bandit_Dispose( -7638, 543 )
    call Bandit_Dispose( -8270, 388 )
    
    call Gnoll_Dispose( -14627, -4633 )
    call Gnoll_Dispose( -13597, -4169 )
    call Gnoll_Dispose( -15120, -4005 )
    call Gnoll_Dispose( -14007, -3243 )
    call Gnoll_Dispose( -15095, -3108 )
    call Gnoll_Dispose( -14050, -2447 )
    call Gnoll_Dispose( -15139, -2244 )
    call Gnoll_Dispose( -14013, -1962 )
    call Gnoll_Dispose( -15168, -1786 )
    call Gnoll_Dispose( -14082, -1150 )
    call Gnoll_Dispose( -15109, -1044 )
    call Gnoll_Dispose( -14046, -316 )
    call Gnoll_Dispose( -15174, -292 )
    call Gnoll_Dispose( -13977, 261 )
    call Gnoll_Dispose( -15121, 296 )
    call Gnoll_Dispose( -13929, 947 )
    call Gnoll_Dispose( -15182, 1036 )
    call Gnoll_Dispose( -13715, 1379 )
endfunction

private function Monster_Dipose_Init takes nothing returns nothing
    call TimerStart( CreateTimer(), 0.01, false, function Monster_Dispose_0 )
    call TimerStart( CreateTimer(), 0.02, false, function Monster_Dispose_1 )
    call TimerStart( CreateTimer(), 0.03, false, function Monster_Dispose_2 )
    call TimerStart( CreateTimer(), 0.04, false, function Monster_Dispose_3 )
    call TimerStart( CreateTimer(), 0.05, false, function Monster_Dispose_4 )
endfunction

private function Potal_Init takes nothing returns nothing
    call Simple_Potal_Create(-1837, -79, -364, 6)
    call Simple_Potal_Create(-5860, -199, -15167, -15501)
    call Simple_Potal_Create(-15147, -15827, -5816, -466)
    call Simple_Potal_Create(-9211, -3479, -11889, -15500)
    call Simple_Potal_Create(-11887, -15818, -9014, -3662)
    call Simple_Potal_Create(-4533, -15833, -9003, -5293)
    call Simple_Potal_Create(-8712, -5306, -4548, -15472)
endfunction

function Weald_Init takes nothing returns nothing
    local trigger trg
    
    call Potal_Init()
    call Monster_Dipose_Init()
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p_enemy, EVENT_PLAYER_UNIT_DEATH, null)
    call TriggerAddCondition( trg, Condition( function Boss_Death_Con ) )
    call TriggerAddAction( trg, function Boss_Death )
    
    set trg = null
endfunction

endlibrary