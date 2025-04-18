library LoadCharacterDeserialize requires InvenGeneric, Stat, EquipNameAndImg, StatAllocationGeneric

/*

JNStringSplit "/"

index 0 : 유닛 타입
index 1 : 유닛 레벨
index 2 : 유닛 경험치

index 3 : 유닛 0번칸 장착 아이템
.
.
.
index 12 : 유닛 9번칸 장착 아이템

index 13 : 유닛 0번칸 인벤 아이템
.
.
.
index 37 : 유닛 24번칸 인벤 아이템



아이템 정보

JNStringSplit "#"

index 0 : 아이템 등급
index 1 : 아이템 타입
index 2 : 아이템 스페셜인가 ( 0 이면 보통템, 1 이상이면 특정 스페셜 아이템)

index 3 부터 grade 만큼 loop 

JNStringSplit ","

index 0 : 스탯 타입
index 1 : 스탯 수치


*/

private function Set_Equip_Name_and_Img takes Equip E returns nothing
    local integer Type = E.Get_Type()
            
    if Type == HELMET then
        call Set_Helmet_Name_and_Img(E)
    elseif Type == WEAPON then
        call Set_Weapon_Name_and_Img(E)
    elseif Type == ARMOR then
        call Set_Armor_Name_and_Img(E)
    elseif Type == SHIELD then
        call Set_Shield_Name_and_Img(E)
    elseif Type == NECKLACE then
        call Set_Necklace_Name_and_Img(E)
    elseif Type == RING then
        call Set_Ring_Name_and_Img(E)
    elseif Type == BELT then
        call Set_Belt_Name_and_Img(E)
    elseif Type == GLOVE then
        call Set_Glove_Name_and_Img(E)
    elseif Type == BOOTS then
        call Set_Boots_Name_and_Img(E)
    endif

endfunction

private function Set_Equip_Stat takes Equip E, integer stat, integer value returns nothing
    if stat == AD then
        call E.Set_AD( value )
    elseif stat == AP then
        call E.Set_AP( value )
    elseif stat == AS then
        call E.Set_AS( value )
    elseif stat == MS then
        call E.Set_MS( value )
    elseif stat == CRIT then
        call E.Set_CRIT( value )
    elseif stat == CRIT_COEF then
        call E.Set_CRIT_COEF( value )
    elseif stat == DEF_AD then
        call E.Set_DEF_AD( value )
    elseif stat == DEF_AP then
        call E.Set_DEF_AP( value )
    elseif stat == HP then
        call E.Set_HP( value )
    elseif stat == MP then
        call E.Set_MP( value )
    elseif stat == HP_REGEN then
        call E.Set_HP_REGEN( value )
    elseif stat == MP_REGEN then
        call E.Set_MP_REGEN( value )
    elseif stat == ENHANCE_AD then
        call E.Set_ENHANCE_AD( value )
    elseif stat == ENHANCE_AP then
        call E.Set_ENHANCE_AP( value )
    elseif stat == REDUCE_AD then
        call E.Set_REDUCE_AD( value )
    elseif stat == REDUCE_AP then
        call E.Set_REDUCE_AP( value )
    endif
endfunction

private function Create_Equip takes integer grade, integer upgrade_count, integer Type, integer special returns Equip
    local Equip E = Equip.create()
    
    call E.Set_Grade( grade )
    call E.Set_Upgrade_Count( upgrade_count )
    call E.Set_Type( Type )
    call E.Set_Special( special )
    
    return E
endfunction

private function Set_Inven_Equip takes integer pid, integer inven_index, Equip E, Hero the_hero returns nothing
    call the_hero.Set_Inven_Item( inven_index, E )
    call Inven_Set_Img(pid, inven_index, Hero(pid+1).Get_Inven_Item(inven_index))
endfunction

private function Set_Wearing_Equip takes integer pid, integer wearing_index, Equip E, Hero the_hero, boolean is_mercenary returns nothing
    call the_hero.Set_Wearing_Item( wearing_index, E ) /* 동기화 필요 */
    
    if is_mercenary == false then
        call Wearing_Set_Img( pid, wearing_index, E )
        call Stat_Refresh(pid)
    endif
endfunction

// =================================================================
// For Courtyard Register
// =================================================================

function Mercenary_Deserialize takes integer pid, integer index, string data returns nothing
    local unit u
    local string str
    local string str2
    local integer i
    local integer j
    local integer grade
    local integer upgrade_count
    local integer Type
    local integer special
    local Equip E
    
    // 유닛 타입
    set str = JNStringSplit(data, "/", 1)
    
    set registered_character[pid][index] = Hero.create()
    set u = CreateUnit(Player(pid), S2I(str), GetRectCenterX(courtyard_rect[pid]), GetRectCenterY(courtyard_rect[pid]), 270)
    call registered_character[pid][index].Set_Hero_Unit( u )
    
    call Set_Unit_Property(u, LOAD_CHARACTER_INDEX, loaded_character_count[pid])
    set loaded_character_count[pid] = loaded_character_count[pid] + 1
    
    // 경험치
    set str = JNStringSplit(data, "/", 3)
    call SetHeroXP(u, S2I(str), true)
    
    // 장비 10칸 
    set i = 3
    loop
    set i = i + 1
    exitwhen i > 13
        set str = JNStringSplit(data, "/", i)
        
        if str != "-1" then
            // 등급(integer), 타입(string), 스페셜(integer) 스페셜은 -1 이면 그냥 보통 랜덤템임
            set grade = S2I(JNStringSplit(str, "#", 0))
            set upgrade_count = S2I(JNStringSplit(str, "#", 1))
            set Type = S2I(JNStringSplit(str, "#", 2))
            set special = S2I(JNStringSplit(str, "#", 3))
            set E = Create_Equip( grade, upgrade_count, Type, special )
            
            set j = 3
            loop
            set j = j + 1
            exitwhen j > 4 + grade /* 아무튼 4 + grade임, 이거 하면 grade 수치만큼 루프 돌음 */
                set str2 = JNStringSplit(str, "#", j)
                // 스탯(string) 수치(integer)
                call Set_Equip_Stat(E, S2I(JNStringSplit(str2, ",", 0)), S2I(JNStringSplit(str2, ",", 1)))
            endloop
            
            // i loop 가 4부터 시작하므로 4을 뺀다
            call Set_Wearing_Equip(pid, i-4, E, registered_character[pid][index], true)
        endif
    endloop
    
    call registered_character[pid][index].Set_Stat_Alloc_Property(AD, S2I(JNStringSplit(data, "/", 39)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(AP, S2I(JNStringSplit(data, "/", 40)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(AS, S2I(JNStringSplit(data, "/", 41)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(MS, S2I(JNStringSplit(data, "/", 42)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(HP, S2I(JNStringSplit(data, "/", 43)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(MP, S2I(JNStringSplit(data, "/", 44)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(DEF_AD, S2I(JNStringSplit(data, "/", 45)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(DEF_AP, S2I(JNStringSplit(data, "/", 46)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(HP_REGEN, S2I(JNStringSplit(data, "/", 47)))
    call registered_character[pid][index].Set_Stat_Alloc_Property(MP_REGEN, S2I(JNStringSplit(data, "/", 48)))
    
    call SetUnitLifePercentBJ( u, 100 )
    call SetUnitManaPercentBJ( u, 100 )
    
    set u = null
endfunction

// ===================
// Existing Function
// ===================

function Deserialize takes integer pid, string data returns nothing
    local unit u
    local string str
    local string str2
    local integer i
    local integer j
    local integer grade
    local integer upgrade_count
    local integer Type
    local integer special
    local Equip E
    local Hero current_hero = player_hero[pid]
    
    // 유닛 타입
    set str = JNStringSplit(data, "/", 1)
    
    set u = CreateUnit(Player(pid), S2I(str), map_center_x, map_center_y, 270)
    call current_hero.Set_Hero_Unit( u )
    
    call Set_Unit_Property(u, LOAD_CHARACTER_INDEX, loaded_character_count[pid])
    set loaded_character_count[pid] = loaded_character_count[pid] + 1
    
    // 골드
    set str = JNStringSplit(data, "/", 2)
    call AdjustPlayerStateBJ( S2I(str), Player(pid), PLAYER_STATE_RESOURCE_GOLD )
    
    // 경험치
    set str = JNStringSplit(data, "/", 3)
    call SetHeroXP(u, S2I(str), true)
    
    // 장비 10칸 
    set i = 3
    loop
    set i = i + 1
    exitwhen i > 13
        set str = JNStringSplit(data, "/", i)
        
        if str != "-1" then
            // 등급(integer), 타입(string), 스페셜(integer) 스페셜은 -1 이면 그냥 보통 랜덤템임
            set grade = S2I(JNStringSplit(str, "#", 0))
            set upgrade_count = S2I(JNStringSplit(str, "#", 1))
            set Type = S2I(JNStringSplit(str, "#", 2))
            set special = S2I(JNStringSplit(str, "#", 3))
            set E = Create_Equip( grade, upgrade_count, Type, special )
            
            set j = 3
            loop
            set j = j + 1
            exitwhen j > 4 + grade /* 아무튼 4 + grade임, 이거 하면 grade 수치만큼 루프 돌음 */
                set str2 = JNStringSplit(str, "#", j)
                // 스탯(string) 수치(integer)
                call Set_Equip_Stat(E, S2I(JNStringSplit(str2, ",", 0)), S2I(JNStringSplit(str2, ",", 1)))
            endloop
            
            call Set_Equip_Name_and_Img(E)
            
            // i loop 가 4부터 시작하므로 4을 뺀다
            call Set_Wearing_Equip(pid, i-4, E, current_hero, false)
        endif
    endloop
    
    // 인벤 25칸
    set i = 13
    loop
    set i = i + 1
    exitwhen i > 38
        set str = JNStringSplit(data, "/", i)
        
        if str != "-1" then
            // 등급(integer), 타입(string), 스페셜(integer) 스페셜은 -1 이면 그냥 보통 랜덤템임
            set grade = S2I(JNStringSplit(str, "#", 0))
            set upgrade_count = S2I(JNStringSplit(str, "#", 1))
            set Type = S2I(JNStringSplit(str, "#", 2))
            set special = S2I(JNStringSplit(str, "#", 3))
            set E = Create_Equip( grade, upgrade_count, Type, special )
            
            set j = 3
            loop
            set j = j + 1
            exitwhen j > 4 + grade /* 아무튼 4 + grade임, 이거 하면 grade 수치만큼 루프 돌음 */
                set str2 = JNStringSplit(str, "#", j)
                // 스탯(string) 수치(integer)
                call Set_Equip_Stat(E, S2I(JNStringSplit(str2, ",", 0)), S2I(JNStringSplit(str2, ",", 1)))
            endloop
            
            call Set_Equip_Name_and_Img(E)
            
            // i loop 가 14부터 시작하므로 14을 뺀다
            call Set_Inven_Equip(pid, i-14, E, current_hero)
        endif
    endloop
    
    call current_hero.Set_Stat_Alloc_Property(AD, S2I(JNStringSplit(data, "/", 39)))
    call current_hero.Set_Stat_Alloc_Property(AP, S2I(JNStringSplit(data, "/", 40)))
    call current_hero.Set_Stat_Alloc_Property(AS, S2I(JNStringSplit(data, "/", 41)))
    call current_hero.Set_Stat_Alloc_Property(MS, S2I(JNStringSplit(data, "/", 42)))
    call current_hero.Set_Stat_Alloc_Property(HP, S2I(JNStringSplit(data, "/", 43)))
    call current_hero.Set_Stat_Alloc_Property(MP, S2I(JNStringSplit(data, "/", 44)))
    call current_hero.Set_Stat_Alloc_Property(DEF_AD, S2I(JNStringSplit(data, "/", 45)))
    call current_hero.Set_Stat_Alloc_Property(DEF_AP, S2I(JNStringSplit(data, "/", 46)))
    call current_hero.Set_Stat_Alloc_Property(HP_REGEN, S2I(JNStringSplit(data, "/", 47)))
    call current_hero.Set_Stat_Alloc_Property(MP_REGEN, S2I(JNStringSplit(data, "/", 48)))
    call current_hero.Stat_Point_Calculate()
    
    call Stat_Alloc_Refresh_All(pid)
    
    call SetUnitLifePercentBJ( u, 100 )
    call SetUnitManaPercentBJ( u, 100 )
    
    set u = null
endfunction

endlibrary