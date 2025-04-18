library MilestoneReward requires Basic

globals
    string array milestone_reward_text
endglobals

private function Add_Equip takes integer pid, integer grade returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    local integer item_id
    
    if grade == 0 then
        set item_id = 'I000'
    elseif grade == 1 then
        set item_id = 'I001'
    elseif grade == 2 then
        set item_id = 'I002'
    elseif grade == 3 then
        set item_id = 'I003'
    elseif grade == 4 then
        set item_id = 'I004'
    else
        set item_id = 'I000'
    endif
    
    call UnitAddItem(u, CreateItem(item_id, GetUnitX(u), GetUnitY(u)) )
    
    set u = null
endfunction

private function Add_Potion takes integer pid, integer count, boolean is_health_potion returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    local integer i
    local integer item_id
    
    if is_health_potion == true then
        set item_id = 'I009'
    else
        set item_id = 'I00A'
    endif
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= count
        call UnitAddItem(u, CreateItem(item_id, GetUnitX(u), GetUnitY(u)) )
    endloop
    
    set u = null
endfunction

private function Add_Gold takes integer pid, integer value returns nothing
    call AdjustPlayerStateBJ( value, Player(pid), PLAYER_STATE_RESOURCE_GOLD )
endfunction

private function Add_Exp takes integer pid, integer value returns nothing
    call AddHeroXP(player_hero[pid].Get_Hero_Unit(), value, true)
endfunction

private function Milestone_Text_Hell takes nothing returns nothing
    set milestone_reward_text[0] = "3000 경험치\n10000 골드"
    set milestone_reward_text[1] = "랜덤 전설템 1개\n5000 경험치\n5000 골드"
    set milestone_reward_text[2] = "3000 경험치\n10000 골드"
    set milestone_reward_text[3] = "랜덤 전설템 1개\n3000 경험치\n5000 골드"
    set milestone_reward_text[4] = "3000 경험치\n10000 골드"
    set milestone_reward_text[5] = "랜덤 신화템 1개\n3000 경험치\n5000 골드"
    
    set milestone_reward_text[6] = "3500 경험치\n7000 골드"
    set milestone_reward_text[7] = "3500 경험치\n10000 골드"
    set milestone_reward_text[8] = "랜덤 신화템 1개\n3500 경험치\n10000 골드"
    set milestone_reward_text[9] = "랜덤 신화템 1개\n3500 경험치\n10000 골드"
    
    set milestone_reward_text[10] = "4000 경험치\n10000 골드"
    set milestone_reward_text[11] = "랜덤 신화템 1개\n4000 경험치\n10000 골드"
    set milestone_reward_text[12] = "4000 경험치\n10000 골드"
    set milestone_reward_text[13] = "랜덤 신화템 1개\n4000 경험치\n10000 골드"
    set milestone_reward_text[14] = "4000 경험치\n10000 골드"
    set milestone_reward_text[15] = "4000 경험치\n10000 골드"
    set milestone_reward_text[16] = "랜덤 신화템 1개\n4000 경험치\n10000 골드"
    
    set milestone_reward_text[17] = "5000 경험치\n15000 골드"
    set milestone_reward_text[18] = "랜덤 신화템 1개\n10000 경험치\n20000 골드"
    
    set milestone_reward_text[19] = "랜덤 신화템 2개\n10000 경험치\n20000 골드"
    set milestone_reward_text[20] = "다음 난이도로 이동하세요"
endfunction

private function Reward_Table_Hell takes integer pid returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()

    if milestone[pid] == 0 then
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 1 then
        call Add_Equip(pid, 3)
        call Add_Exp(pid, 5000)
        call Add_Gold(pid, 5000)
    elseif milestone[pid] == 2 then
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 3 then
        call Add_Equip(pid, 3)
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 4 then
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 5 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 10000)
        

    elseif milestone[pid] == 6 then
        call Add_Exp(pid, 3500)
        call Add_Gold(pid, 7000)
    elseif milestone[pid] == 7 then
        call Add_Exp(pid, 3500)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 8 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 3500)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 9 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 3500)
        call Add_Gold(pid, 10000)

    elseif milestone[pid] == 10 then
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 11 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 12 then
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 13 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 14 then
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 15 then
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)
    elseif milestone[pid] == 16 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 10000)

    elseif milestone[pid] == 17 then
        call Add_Exp(pid, 5000)
        call Add_Gold(pid, 15000)
    elseif milestone[pid] == 18 then
        call Add_Equip(pid, 4)
        call Add_Exp(pid, 10000)
        call Add_Gold(pid, 20000)
    endif
    
    set u = null
endfunction

private function Milestone_Text_Nightmare takes nothing returns nothing
    set milestone_reward_text[0] = "500 경험치\n300 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[1] = "랜덤 영웅템 1개\n1000 경험치\n500 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[2] = "500 경험치\n300 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[3] = "랜덤 영웅템 1개\n1000 경험치\n500 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[4] = "500 경험치\n300 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[5] = "랜덤 영웅템 1개\n2000 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[6] = "1000 경험치\n400 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[7] = "1000 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[8] = "랜덤 영웅템 1개\n2500 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[9] = "랜덤 영웅템 1개\n3000 경험치\n1500 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[10] = "1500 경험치\n500 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[11] = "랜덤 영웅템 1개\n3500 경험치\n2000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[12] = "1500 경험치\n500 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[13] = "랜덤 전설템 1개\n3500 경험치\n2000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[14] = "1500 경험치\n500 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[15] = "3000 경험치\n1500 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[16] = "랜덤 전설템 1개\n4000 경험치\n2500 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[17] = "2000 경험치\n600 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[18] = "랜덤 전설템 1개\n8000 경험치\n5000 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[20] = "랜덤 전설템 2개\n10000 경험치\n7000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[19] = ""
endfunction

private function Reward_Table_Nightmare takes integer pid returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    
    call Msg_One(Player(pid), 10.0, "퀘스트보상!\n\n" + milestone_reward_text[ milestone[pid] ], 0.0)
    
    if milestone[pid] == 0 then
        call Add_Exp(pid, 500)
        call Add_Gold(pid, 300)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 1 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 1000)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 2 then
        call Add_Exp(pid, 500)
        call Add_Gold(pid, 300)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 3 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 1000)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 4 then
        call Add_Exp(pid, 500)
        call Add_Gold(pid, 300)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 5 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 2000)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
        
        
    elseif milestone[pid] == 6 then
        call Add_Exp(pid, 1000)
        call Add_Gold(pid, 400)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 7 then
        call Add_Exp(pid, 1000)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 8 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 2500)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 9 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 1500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    
    elseif milestone[pid] == 10 then
        call Add_Exp(pid, 1500)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 11 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 3500)
        call Add_Gold(pid, 2000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 12 then
        call Add_Exp(pid, 1500)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 13 then
        call Add_Equip(pid, 3)
        call Add_Exp(pid, 3500)
        call Add_Gold(pid, 2000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 14 then
        call Add_Exp(pid, 1500)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 15 then
        call Add_Exp(pid, 3000)
        call Add_Gold(pid, 1500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 16 then
        call Add_Equip(pid, 3)
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 2500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)

    elseif milestone[pid] == 17 then
        call Add_Exp(pid, 2000)
        call Add_Gold(pid, 600)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 18 then
        call Add_Equip(pid, 3)
        call Add_Exp(pid, 8000)
        call Add_Gold(pid, 5000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    endif

    set u = null
endfunction

private function Milestone_Text_Normal takes nothing returns nothing
    set milestone_reward_text[0] = "100 경험치\n50 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[1] = "랜덤 일반템 1개\n300 경험치\n300 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[2] = "100 경험치\n50 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[3] = "랜덤 희귀템 1개\n300 경험치\n300 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[4] = "100 경험치\n50 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[5] = "랜덤 희귀템 1개\n1000 경험치\n500 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[6] = "200 경험치\n100 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[7] = "500 경험치\n500 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[8] = "랜덤 희귀템 1개\n1000 경험치\n500 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[9] = "랜덤 희귀템 1개\n2000 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[10] = "300 경험치\n150 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[11] = "랜덤 희귀템 1개\n1500 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[12] = "300 경험치\n150 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[13] = "랜덤 영웅템 1개\n1500 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[14] = "300 경험치\n150 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[15] = "1500 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[16] = "랜덤 영웅템 1개\n2000 경험치\n1000 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[17] = "500 경험치\n200 골드\n힐링포션 2개\n마나포션 2개"
    set milestone_reward_text[18] = "랜덤 영웅템 1개\n4000 경험치\n3000 골드\n힐링포션 3개\n마나포션 3개"
    
    set milestone_reward_text[19] = "랜덤 영웅템 2개\n6000 경험치\n5000 골드\n힐링포션 3개\n마나포션 3개"
    set milestone_reward_text[20] = "다음 난이도로 이동하세요"
endfunction

private function Reward_Table_Normal takes integer pid returns nothing
    local unit u = player_hero[pid].Get_Hero_Unit()
    
    call Msg_One(Player(pid), 20.0, "퀘스트보상!\n\n" + milestone_reward_text[ milestone[pid] ], 0.0)
    
    if milestone[pid] == 0 then
        call Add_Exp(pid, 100)
        call Add_Gold(pid, 50)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 1 then
        call Add_Equip(pid, 0)
        call Add_Exp(pid, 300)
        call Add_Gold(pid, 300)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 2 then
        call Add_Exp(pid, 100)
        call Add_Gold(pid, 50)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 3 then
        call Add_Equip(pid, 1)
        call Add_Exp(pid, 300)
        call Add_Gold(pid, 300)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 4 then
        call Add_Exp(pid, 100)
        call Add_Gold(pid, 50)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 5 then
        call Add_Equip(pid, 1)
        call Add_Exp(pid, 1000)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 6 then
        call Add_Exp(pid, 200)
        call Add_Gold(pid, 100)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 7 then
        call Add_Exp(pid, 500)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 8 then
        call Add_Equip(pid, 1)
        call Add_Exp(pid, 1000)
        call Add_Gold(pid, 500)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 9 then
        call Add_Equip(pid, 1)
        call Add_Exp(pid, 2000)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 10 then
        call Add_Exp(pid, 300)
        call Add_Gold(pid, 150)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 11 then
        call Add_Equip(pid, 1)
        call Add_Exp(pid, 1500)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 12 then
        call Add_Exp(pid, 300)
        call Add_Gold(pid, 150)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 13 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 1500)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 14 then
        call Add_Exp(pid, 300)
        call Add_Gold(pid, 150)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 15 then
        call Add_Exp(pid, 1500)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 16 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 2000)
        call Add_Gold(pid, 1000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    elseif milestone[pid] == 17 then
        call Add_Exp(pid, 500)
        call Add_Gold(pid, 200)
        call Add_Potion(pid, 2, true)
        call Add_Potion(pid, 2, false)
    elseif milestone[pid] == 18 then
        call Add_Equip(pid, 2)
        call Add_Exp(pid, 4000)
        call Add_Gold(pid, 3000)
        call Add_Potion(pid, 3, true)
        call Add_Potion(pid, 3, false)
    endif

    set u = null
endfunction

function Give_Milestone_Reward takes integer pid returns nothing
    if MAP_DIFFICULTY == NORMAL then
        call Reward_Table_Normal(pid)
    elseif MAP_DIFFICULTY == NIGHTMARE then
        call Reward_Table_Nightmare(pid)
    elseif MAP_DIFFICULTY == HELL then
        call Reward_Table_Hell(pid)
    endif
    
    if GetLocalPlayer() == Player(pid) then
        call PlaySoundBJ( gg_snd_ClanInvitation )
    endif
    
    set milestone[pid] = milestone[pid] + 1
    
    call Milestone_Frame_Refresh(pid)
endfunction

function Milestone_Reward_Text_Init takes nothing returns nothing
    if MAP_DIFFICULTY == NORMAL then
        call Milestone_Text_Normal()
    elseif MAP_DIFFICULTY == NIGHTMARE then
        call Milestone_Text_Nightmare()
    elseif MAP_DIFFICULTY == HELL then
        call Milestone_Text_Hell()
    endif
endfunction

endlibrary