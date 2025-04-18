
library MonsterDrop requires EquipAPI, PotionItem, UnitProperty, DroppedItem

/*

    난이도에 드랍률이랑 드랍템들 영향 받음

*/

globals
    private real array portion_drop_probability
endglobals

function Monster_Potion_Drop takes unit monster, unit killing_unit returns nothing
    local integer monster_class = Get_Unit_Property(monster, CLASS)
    local integer monster_grade = Get_Unit_Property(monster, GRADE)
    local real x = GetUnitX(monster)
    local real y = GetUnitY(monster)
    local real probability = 0.0
    local integer count = monster_class + monster_grade + 1
    local integer i = 0
    local boolean is_direct = false /* 안뜰일 때, 유닛에게 다이렉트로 템 넣어주기위한 */
    local item the_item = null
    
    if Get_Unit_Property(monster, IN_COURTYARD) != 0 then
        set is_direct = true
    endif
    
    loop
    set i = i + 1
    exitwhen i > count
        set the_item = Potion_Drop(x, y, portion_drop_probability[monster_class + monster_grade], null)
        
        if is_direct == true and the_item != null then
            call UnitAddItem(killing_unit, the_item)
            call Msg_One(GetOwningPlayer(killing_unit), 6.0, "포션 획득!", 0.0)
        endif
    endloop
    
    set the_item = null
endfunction

function Monster_Equip_Drop takes unit monster, unit killing_unit returns nothing
    local integer pid = GetPlayerId(GetOwningPlayer(killing_unit))
    local integer monster_class = Get_Unit_Property(monster, CLASS)
    local integer monster_grade = Get_Unit_Property(monster, GRADE)
    local integer monster_region = Get_Unit_Property(monster, REGION)
    local real rate = ( item_drop_rate[pid] + 100.0 ) / 100.0
    local boolean is_direct = false /* 안뜰일 때, 유닛에게 다이렉트로 템 넣어주기위한 */
    local unit direct = null
    
    if monster_region <= 0 then
        set monster_region = 1
    endif
    
    if Get_Unit_Property(monster, IN_COURTYARD) != 0 then
        if GetRandomInt(1, 100) <= 85 then
            return
        else
            set is_direct = true
            set direct = killing_unit
        endif
    endif
    
    // is_direct 가 true 이면 안뜰 몬스터이고, 분기 판별 달라짐, 직접 전달
    if is_direct == true then
        if Get_Unit_Property(monster, DIFFICULTY_LIKE) == NORMAL then
            if monster_region == 1 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 95, 5, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 95, 5, 0, 0, 0, 10.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 95, 5, 0, 0, 0, 15.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 20.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 85, 15, 0, 0, 0, 25.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 85, 15, 0, 0, 0, 25.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 85, 15, 0, 0, 0, 25.0 * rate, 4)
                endif
            elseif monster_region == 2 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 94, 6, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 94, 6, 0, 0, 0, 10.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 94, 6, 0, 0, 0, 15.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 9, 0, 0, 0, 21.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 83, 17, 0, 0, 0, 26.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 83, 17, 0, 0, 0, 26.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 83, 17, 0, 0, 0, 26.0 * rate, 4)
                endif
            elseif monster_region == 3 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 11.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 15.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 9, 1, 0, 0, 22.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 82, 17, 2, 0, 0, 27.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 82, 17, 2, 0, 0, 27.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 82, 17, 2, 0, 0, 27.0 * rate, 4)
                endif
            elseif monster_region == 4 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 92, 8, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 90, 10, 1, 0, 0, 12.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 2, 0, 0, 16.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 3, 0, 0, 23.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 4, 0, 0, 28.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 4, 0, 0, 28.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 4, 0, 0, 28.0 * rate, 4)
                endif
            endif
            
            
            
            
        elseif Get_Unit_Property(monster, DIFFICULTY_LIKE) == NIGHTMARE then
            if monster_region == 1 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 35, 5, 0, 0, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 35, 5, 1, 0, 13.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 35, 5, 1, 0, 17.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 33, 7, 1, 0, 24.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 4)
                endif
            elseif monster_region == 2 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 34, 6, 1, 0, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 34, 6, 1, 0, 13.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 32, 6, 2, 0, 17.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 31, 7, 2, 0, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 4)
                endif
            elseif monster_region == 3 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 34, 6, 0, 0, 7.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 34, 8, 1, 0, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 32, 10, 3, 0, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 32, 10, 3, 1, 26.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 4)
                endif
            elseif monster_region == 4 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 33, 6, 1, 0, 8.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 33, 8, 2, 1, 15.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 3, 26.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 4)
                endif
            endif
            
            
            
            
            
        elseif Get_Unit_Property(monster, DIFFICULTY_LIKE) == HELL then
            if monster_region == 1 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 13.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 17.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 24.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 4)
                endif
            elseif monster_region == 2 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                endif
            elseif monster_region == 3 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                endif
            elseif monster_region == 4 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                endif
            endif
        endif
    else
        if MAP_DIFFICULTY == NORMAL then
            if monster_region == 1 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 95, 5, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 95, 5, 0, 0, 0, 10.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 95, 5, 0, 0, 0, 15.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 20.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 85, 15, 0, 0, 0, 25.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 85, 15, 0, 0, 0, 25.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 85, 15, 0, 0, 0, 25.0 * rate, 4)
                endif
            elseif monster_region == 2 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 94, 6, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 94, 6, 0, 0, 0, 10.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 94, 6, 0, 0, 0, 15.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 9, 0, 0, 0, 21.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 83, 17, 0, 0, 0, 26.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 83, 17, 0, 0, 0, 26.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 83, 17, 0, 0, 0, 26.0 * rate, 4)
                endif
            elseif monster_region == 3 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 11.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 7, 0, 0, 0, 15.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 93, 9, 1, 0, 0, 22.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 82, 17, 2, 0, 0, 27.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 82, 17, 2, 0, 0, 27.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 82, 17, 2, 0, 0, 27.0 * rate, 4)
                endif
            elseif monster_region == 4 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 92, 8, 0, 0, 0, 5.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 90, 10, 1, 0, 0, 12.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 2, 0, 0, 16.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 3, 0, 0, 23.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 4, 0, 0, 28.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 4, 0, 0, 28.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 80, 20, 4, 0, 0, 28.0 * rate, 4)
                endif
            endif
            
            
            
            
        elseif MAP_DIFFICULTY == NIGHTMARE then
            if monster_region == 1 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 35, 5, 0, 0, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 35, 5, 1, 0, 13.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 35, 5, 1, 0, 17.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 33, 7, 1, 0, 24.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 30, 10, 2, 0, 29.0 * rate, 4)
                endif
            elseif monster_region == 2 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 34, 6, 1, 0, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 34, 6, 1, 0, 13.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 32, 6, 2, 0, 17.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 31, 7, 2, 0, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 30, 10, 3, 0, 29.0 * rate, 4)
                endif
            elseif monster_region == 3 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 34, 6, 0, 0, 7.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 34, 8, 1, 0, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 32, 10, 3, 0, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 32, 10, 3, 1, 26.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 1, 30.0 * rate, 4)
                endif
            elseif monster_region == 4 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 60, 33, 6, 1, 0, 8.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 57, 33, 8, 2, 1, 15.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 31, 10, 4, 3, 26.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 55, 30, 10, 5, 3, 30.0 * rate, 4)
                endif
            endif
            
            
            
            
            
        elseif MAP_DIFFICULTY == HELL then
            if monster_region == 1 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 13.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 17.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 24.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 16, 4, 29.0 * rate, 4)
                endif
            elseif monster_region == 2 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                endif
            elseif monster_region == 3 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                endif
            elseif monster_region == 4 then
                if monster_class + monster_grade == 0 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 6.0 * rate, 1)
                elseif monster_class + monster_grade == 1 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 14.0 * rate, 1)
                elseif monster_class + monster_grade == 2 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 35, 15, 18, 2, 18.0 * rate, 2)
                elseif monster_class + monster_grade == 3 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 25.0 * rate, 2)
                elseif monster_class + monster_grade == 4 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 5 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 3)
                elseif monster_class + monster_grade == 6 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 7 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                elseif monster_class + monster_grade == 8 then
                    call Random_Equip_Item_Drop(direct, GetUnitX(monster), GetUnitY(monster), 30, 30, 20, 15, 5, 30.0 * rate, 4)
                endif
            endif
        endif
    endif

    set direct = null
endfunction

/*
난이도에 따라서
지역에 따라서
grade + class 에 따라서
드랍확률과 가중치들이 달라진다
드랍 카운트도 달라짐


NORMAL
        
    grade+class     1   2   3   4   5   6  7
region 1    
region 2
region 3
region 4

*/

function Monster_Drop_Init takes nothing returns nothing
    set portion_drop_probability[PLANE] = 4.0
    set portion_drop_probability[GRUNT] = 25.0
    set portion_drop_probability[ELDER] = 55.0
    set portion_drop_probability[MID_BOSS] = 75.0
    set portion_drop_probability[BOSS] = 100.0
    // class 랑 grade 합한 값에 대한 고려
    set portion_drop_probability[5] = 100.0
    set portion_drop_probability[6] = 100.0
    set portion_drop_probability[7] = 100.0
    set portion_drop_probability[8] = 100.0
endfunction

endlibrary
