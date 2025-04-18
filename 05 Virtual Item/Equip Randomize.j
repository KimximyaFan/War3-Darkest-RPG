library EquipRandomize requires EquipNameAndImg, EquipPropertyPreprocess

private function Set_Random_Property takes Equip E, integer num returns nothing
    local integer grade = E.Get_Grade()
    if num == 0 then
        call E.Set_AD( Get_Random_Property_Value(AD, grade) )
    elseif num == 1 then
        call E.Set_AP( Get_Random_Property_Value(AP, grade) )
    elseif num == 2 then
        call E.Set_AS( Get_Random_Property_Value(AS, grade) )
    elseif num == 3 then
        call E.Set_MS( Get_Random_Property_Value(MS, grade) )
    elseif num == 4 then
        call E.Set_CRIT( Get_Random_Property_Value(CRIT, grade) )
    elseif num == 5 then
        call E.Set_CRIT_COEF( Get_Random_Property_Value(CRIT_COEF, grade) )
    elseif num == 6 then
        call E.Set_DEF_AD( Get_Random_Property_Value(DEF_AD, grade) )
    elseif num == 7 then
        call E.Set_DEF_AP( Get_Random_Property_Value(DEF_AP, grade) )
    elseif num == 8 then
        call E.Set_HP( Get_Random_Property_Value(HP, grade) )
    elseif num == 9 then
        call E.Set_MP( Get_Random_Property_Value(MP, grade) )
    elseif num == 10 then
        call E.Set_HP_REGEN( Get_Random_Property_Value(HP_REGEN, grade) )
    elseif num == 11 then
        call E.Set_MP_REGEN( Get_Random_Property_Value(MP_REGEN, grade) )
    elseif num == 12 then
        call E.Set_ENHANCE_AD( Get_Random_Property_Value(ENHANCE_AD, grade) )
    elseif num == 13 then
        call E.Set_ENHANCE_AP( Get_Random_Property_Value(ENHANCE_AP, grade) )
    elseif num == 14 then
        call E.Set_REDUCE_AD( Get_Random_Property_Value(REDUCE_AD, grade) )
    elseif num == 15 then
        call E.Set_REDUCE_AP( Get_Random_Property_Value(REDUCE_AP, grade) )
    endif
endfunction

private function Property_Setting takes Equip E returns nothing
    if E.Get_Grade() >= 1 then
        call Set_Random_Property( E, E.ran_arr[0] )
    endif
    if E.Get_Grade() >= 2 then
        call Set_Random_Property( E, E.ran_arr[1] )
    endif
    if E.Get_Grade() >= 3 then
        call Set_Random_Property( E, E.ran_arr[2] )
    endif
    if E.Get_Grade() >= 4 then
        call Set_Random_Property( E, E.ran_arr[3] )
    endif
endfunction

private function Ran_Array_Shuffle takes Equip E, integer size returns nothing
    local integer i
    local integer ran
    local integer temp
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= size
        set ran = GetRandomInt(i, size-1)
        set temp = E.ran_arr[ran]
        set E.ran_arr[ran] = E.ran_arr[i]
        set E.ran_arr[i] = temp
    endloop
endfunction

private function Ran_Helmet takes Equip E returns nothing
    local integer size = 10
    
    call E.Set_Type( HELMET )
    call Set_Random_Property( E, DEF_AD )
    
    call Set_Helmet_Name_and_Img(E)
    
    set E.ran_arr[0] = 0
    set E.ran_arr[1] = 1
    set E.ran_arr[2] = 2
    set E.ran_arr[3] = 4
    set E.ran_arr[4] = 5
    set E.ran_arr[5] = 7
    set E.ran_arr[6] = 8
    set E.ran_arr[7] = 9
    set E.ran_arr[8] = 10
    set E.ran_arr[9] = 11
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

private function Ran_Weapon takes Equip E returns nothing
    local integer size = 9
    local integer ran = GetRandomInt(1, 100)
    
    call E.Set_Type( WEAPON )
    
    if ran >= 50 then
        call Set_Random_Property( E, AD )
    else
        call Set_Random_Property( E, AP )
    endif
    
    call Set_Weapon_Name_and_Img(E)

    set E.ran_arr[0] = 2
    set E.ran_arr[1] = 4
    set E.ran_arr[2] = 5
    set E.ran_arr[3] = 6
    set E.ran_arr[4] = 7
    set E.ran_arr[5] = 8
    set E.ran_arr[6] = 9
    set E.ran_arr[7] = 10
    set E.ran_arr[8] = 11
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

private function Ran_Armor takes Equip E returns nothing
    local integer size = 9
    
    call E.Set_Type( ARMOR )
    call Set_Random_Property( E, HP )
    
    call Set_Armor_Name_and_Img(E)

    set E.ran_arr[0] = 4
    set E.ran_arr[1] = 5
    set E.ran_arr[2] = 6
    set E.ran_arr[3] = 7
    set E.ran_arr[4] = 9
    set E.ran_arr[5] = 10
    set E.ran_arr[6] = 11
    set E.ran_arr[7] = 14
    set E.ran_arr[8] = 15
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

private function Ran_Shield takes Equip E returns nothing
    local integer size = 9
    
    call E.Set_Type( SHIELD )
    call Set_Random_Property( E, DEF_AD )
    
    call Set_Shield_Name_and_Img(E)

    set E.ran_arr[0] = 4
    set E.ran_arr[1] = 5
    set E.ran_arr[2] = 7
    set E.ran_arr[3] = 8
    set E.ran_arr[4] = 9
    set E.ran_arr[5] = 10
    set E.ran_arr[6] = 11
    set E.ran_arr[7] = 14
    set E.ran_arr[8] = 15
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

private function Ran_Necklace takes Equip E returns nothing
    local integer size = 16
    local integer i
    
    call E.Set_Type( NECKLACE )
    
    call Set_Necklace_Name_and_Img(E)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 15
        set E.ran_arr[i] = i
    endloop
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
    call Set_Random_Property( E, E.ran_arr[4] )
endfunction

private function Ran_Ring takes Equip E returns nothing
    local integer size = 16
    local integer i 
    
    call E.Set_Type( RING )
    
    call Set_Ring_Name_and_Img(E)
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i > 15
        set E.ran_arr[i] = i
    endloop
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
    call Set_Random_Property( E, E.ran_arr[4] )
endfunction

private function Ran_Belt takes Equip E returns nothing
    local integer size = 11
    
    call E.Set_Type( BELT )
    call Set_Random_Property( E, DEF_AP )
    
    call Set_Belt_Name_and_Img(E)

    set E.ran_arr[0] = 0
    set E.ran_arr[1] = 1
    set E.ran_arr[2] = 2
    set E.ran_arr[3] = 3
    set E.ran_arr[4] = 4
    set E.ran_arr[5] = 5
    set E.ran_arr[6] = 6
    set E.ran_arr[7] = 8
    set E.ran_arr[8] = 9
    set E.ran_arr[9] = 10
    set E.ran_arr[10] = 11
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

private function Ran_Glove takes Equip E returns nothing
    local integer size = 11
    
    call E.Set_Type( GLOVE )
    call Set_Random_Property( E, AS )
    
    call Set_Glove_Name_and_Img(E)

    set E.ran_arr[0] = 0
    set E.ran_arr[1] = 1
    set E.ran_arr[2] = 3
    set E.ran_arr[3] = 4
    set E.ran_arr[4] = 5
    set E.ran_arr[5] = 6
    set E.ran_arr[6] = 7
    set E.ran_arr[7] = 8
    set E.ran_arr[8] = 9
    set E.ran_arr[9] = 10
    set E.ran_arr[10] = 11
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

private function Ran_Boots takes Equip E returns nothing
    local integer size = 11

    call E.Set_Type( BOOTS )
    call Set_Random_Property( E, MS )
    
    call Set_Boots_Name_and_Img(E)

    set E.ran_arr[0] = 0
    set E.ran_arr[1] = 1
    set E.ran_arr[2] = 2
    set E.ran_arr[3] = 4
    set E.ran_arr[4] = 5
    set E.ran_arr[5] = 6
    set E.ran_arr[6] = 7
    set E.ran_arr[7] = 8
    set E.ran_arr[8] = 9
    set E.ran_arr[9] = 10
    set E.ran_arr[10] = 11
    call Ran_Array_Shuffle(E, size)
    call Property_Setting(E)
endfunction

// 랜덤 등급, 랜덤 부위 뽑기
// w는 가중치 weight를 의미한다
// w0 ... Grade 0 (일반) 의 가중치
// w1 ... Grade 1 (희귀) 의 가중치
// w2 ... Grade 2 (영웅) 의 가중치
// w3 ... Grade 3 (전설) 의 가중치
// w4 ... Grade 4 (신화) 의 가중치
// total_weight = w0 + w1 + w2 + w3 + w4
// 정수를 1 ~ total_weight 사이의 값을 뽑은다음 확률 비교
// 그리고 isRandom 값은 1~9 값이 아니면 랜덤 부위가 된다
function Equip_Randomize takes Equip E, integer w0, integer w1, integer w2, integer w3, integer w4, integer isRandom returns nothing
    local integer total_weight = w0 + w1 + w2 + w3 + w4
    local integer ran1 = GetRandomInt(1, total_weight)
    
    if isRandom < 1 or isRandom > 9 then
        set isRandom = GetRandomInt(1, 100)
        
        if isRandom <= 12 then
            set isRandom = 1
        elseif isRandom <= 23 then
            set isRandom = 2
        elseif isRandom <= 34 then
            set isRandom = 3
        elseif isRandom <= 45 then
            set isRandom = 4
        elseif isRandom <= 56 then
            set isRandom = 5
        elseif isRandom <= 67 then
            set isRandom = 6
        elseif isRandom <= 78 then
            set isRandom = 7
        elseif isRandom <= 89 then
            set isRandom = 8
        elseif isRandom <= 100 then
            set isRandom = 9
        endif
    endif
    
    // 랜덤 등급
    if ran1 <= w0 then
        call E.Set_Grade( 0 )
    elseif ran1 <= w0 + w1 then
        call E.Set_Grade( 1 )
    elseif ran1 <= w0 + w1 + w2 then
        call E.Set_Grade( 2 )
    elseif ran1 <= w0 + w1 + w2 + w3 then
        call E.Set_Grade( 3 )
    elseif ran1 <= w0 + w1 + w2 + w3 + w4 then
        call E.Set_Grade( 4 )
    endif
    
    /*
        헬멧
        무기
        갑옷
        방패
        목걸이
        반지
        벨트
        장갑
        부츠
    */
    
    // 랜덤 부위
    if isRandom == 1 then
        call Ran_Helmet(E)
    elseif isRandom == 2 then
        call Ran_Weapon(E)
    elseif isRandom == 3 then
        call Ran_Armor(E)
    elseif isRandom == 4 then
        call Ran_Shield(E)
    elseif isRandom == 5 then
        call Ran_Necklace(E)
    elseif isRandom == 6 then
        call Ran_Ring(E)
    elseif isRandom == 7 then
        call Ran_Belt(E)
    elseif isRandom == 8 then
        call Ran_Glove(E)
    elseif isRandom == 9 then
        call Ran_Boots(E)
    endif
    
endfunction


endlibrary