library EquipPropertyPreprocess

function Equip_Property_Preprocessing takes nothing returns nothing
    call SaveInteger(HT_ITEM, AD, BASE, 10)
    call SaveInteger(HT_ITEM, AD, LENGTH, 5)
    call SaveInteger(HT_ITEM, AD, PAD, 2)
    call SaveInteger(HT_ITEM, AD, GRADE_GAP, 15)
    
    call SaveInteger(HT_ITEM, AP, BASE, 20)
    call SaveInteger(HT_ITEM, AP, LENGTH, 5)
    call SaveInteger(HT_ITEM, AP, PAD, 4)
    call SaveInteger(HT_ITEM, AP, GRADE_GAP, 30)
    
    call SaveInteger(HT_ITEM, AS, BASE, 10)
    call SaveInteger(HT_ITEM, AS, LENGTH, 5)
    call SaveInteger(HT_ITEM, AS, PAD, 1)
    call SaveInteger(HT_ITEM, AS, GRADE_GAP, 6)
    
    call SaveInteger(HT_ITEM, MS, BASE, 10)
    call SaveInteger(HT_ITEM, MS, LENGTH, 3)
    call SaveInteger(HT_ITEM, MS, PAD, 1)
    call SaveInteger(HT_ITEM, MS, GRADE_GAP, 3)
    
    call SaveInteger(HT_ITEM, CRIT, BASE, 1)
    call SaveInteger(HT_ITEM, CRIT, LENGTH, 3)
    call SaveInteger(HT_ITEM, CRIT, PAD, 1)
    call SaveInteger(HT_ITEM, CRIT, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, CRIT_COEF, BASE, 10)
    call SaveInteger(HT_ITEM, CRIT_COEF, LENGTH, 5)
    call SaveInteger(HT_ITEM, CRIT_COEF, PAD, 1)
    call SaveInteger(HT_ITEM, CRIT_COEF, GRADE_GAP, 6)
    
    call SaveInteger(HT_ITEM, DEF_AD, BASE, 10)
    call SaveInteger(HT_ITEM, DEF_AD, LENGTH, 5)
    call SaveInteger(HT_ITEM, DEF_AD, PAD, 1)
    call SaveInteger(HT_ITEM, DEF_AD, GRADE_GAP, 6)
    
    call SaveInteger(HT_ITEM, DEF_AP, BASE, 10)
    call SaveInteger(HT_ITEM, DEF_AP, LENGTH, 5)
    call SaveInteger(HT_ITEM, DEF_AP, PAD, 1)
    call SaveInteger(HT_ITEM, DEF_AP, GRADE_GAP, 6)
    
    call SaveInteger(HT_ITEM, HP, BASE, 200)
    call SaveInteger(HT_ITEM, HP, LENGTH, 5)
    call SaveInteger(HT_ITEM, HP, PAD, 30)
    call SaveInteger(HT_ITEM, HP, GRADE_GAP, 150)
    
    call SaveInteger(HT_ITEM, MP, BASE, 20)
    call SaveInteger(HT_ITEM, MP, LENGTH, 3)
    call SaveInteger(HT_ITEM, MP, PAD, 5)
    call SaveInteger(HT_ITEM, MP, GRADE_GAP, 20)
    
    call SaveInteger(HT_ITEM, HP_REGEN, BASE, 3)
    call SaveInteger(HT_ITEM, HP_REGEN, LENGTH, 3)
    call SaveInteger(HT_ITEM, HP_REGEN, PAD, 1)
    call SaveInteger(HT_ITEM, HP_REGEN, GRADE_GAP, 2)
    
    call SaveInteger(HT_ITEM, MP_REGEN, BASE, 1)
    call SaveInteger(HT_ITEM, MP_REGEN, LENGTH, 2)
    call SaveInteger(HT_ITEM, MP_REGEN, PAD, 1)
    call SaveInteger(HT_ITEM, MP_REGEN, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, ENHANCE_AD, BASE, 1)
    call SaveInteger(HT_ITEM, ENHANCE_AD, LENGTH, 3)
    call SaveInteger(HT_ITEM, ENHANCE_AD, PAD, 1)
    call SaveInteger(HT_ITEM, ENHANCE_AD, GRADE_GAP, 2)
    
    call SaveInteger(HT_ITEM, ENHANCE_AP, BASE, 1)
    call SaveInteger(HT_ITEM, ENHANCE_AP, LENGTH, 3)
    call SaveInteger(HT_ITEM, ENHANCE_AP, PAD, 1)
    call SaveInteger(HT_ITEM, ENHANCE_AP, GRADE_GAP, 2)
    
    call SaveInteger(HT_ITEM, REDUCE_AD, BASE, 1)
    call SaveInteger(HT_ITEM, REDUCE_AD, LENGTH, 2)
    call SaveInteger(HT_ITEM, REDUCE_AD, PAD, 1)
    call SaveInteger(HT_ITEM, REDUCE_AD, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, REDUCE_AP, BASE, 1)
    call SaveInteger(HT_ITEM, REDUCE_AP, LENGTH, 2)
    call SaveInteger(HT_ITEM, REDUCE_AP, PAD, 1)
    call SaveInteger(HT_ITEM, REDUCE_AP, GRADE_GAP, 1)
    
    
    
    
    call SaveInteger(HT_ITEM, AD + UPGRADE_PADDING, BASE, 5)
    call SaveInteger(HT_ITEM, AD + UPGRADE_PADDING, LENGTH, 5)
    call SaveInteger(HT_ITEM, AD + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, AD + UPGRADE_PADDING, GRADE_GAP, 5)
    
    call SaveInteger(HT_ITEM, AP + UPGRADE_PADDING, BASE, 10)
    call SaveInteger(HT_ITEM, AP + UPGRADE_PADDING, LENGTH, 5)
    call SaveInteger(HT_ITEM, AP + UPGRADE_PADDING, PAD, 2)
    call SaveInteger(HT_ITEM, AP + UPGRADE_PADDING, GRADE_GAP, 10)
    
    call SaveInteger(HT_ITEM, AS + UPGRADE_PADDING, BASE, 4)
    call SaveInteger(HT_ITEM, AS + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, AS + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, AS + UPGRADE_PADDING, GRADE_GAP, 3)
    
    call SaveInteger(HT_ITEM, MS + UPGRADE_PADDING, BASE, 4)
    call SaveInteger(HT_ITEM, MS + UPGRADE_PADDING, LENGTH, 3)
    call SaveInteger(HT_ITEM, MS + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, MS + UPGRADE_PADDING, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, CRIT + UPGRADE_PADDING, BASE, 0)
    call SaveInteger(HT_ITEM, CRIT + UPGRADE_PADDING, LENGTH, 2)
    call SaveInteger(HT_ITEM, CRIT + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, CRIT + UPGRADE_PADDING, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, CRIT_COEF + UPGRADE_PADDING, BASE, 4)
    call SaveInteger(HT_ITEM, CRIT_COEF + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, CRIT_COEF + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, CRIT_COEF + UPGRADE_PADDING, GRADE_GAP, 3)
    
    call SaveInteger(HT_ITEM, DEF_AD + UPGRADE_PADDING, BASE, 4)
    call SaveInteger(HT_ITEM, DEF_AD + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, DEF_AD + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, DEF_AD + UPGRADE_PADDING, GRADE_GAP, 3)
    
    call SaveInteger(HT_ITEM, DEF_AP + UPGRADE_PADDING, BASE, 4)
    call SaveInteger(HT_ITEM, DEF_AP + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, DEF_AP + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, DEF_AP + UPGRADE_PADDING, GRADE_GAP, 3)
    
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, BASE, 100)
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, PAD, 20)
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, GRADE_GAP, 25)
    
    call SaveInteger(HT_ITEM, MP + UPGRADE_PADDING, BASE, 10)
    call SaveInteger(HT_ITEM, MP + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, MP + UPGRADE_PADDING, PAD, 5)
    call SaveInteger(HT_ITEM, MP + UPGRADE_PADDING, GRADE_GAP, 5)
    
    call SaveInteger(HT_ITEM, HP_REGEN + UPGRADE_PADDING, BASE, 1)
    call SaveInteger(HT_ITEM, HP_REGEN + UPGRADE_PADDING, LENGTH, 3)
    call SaveInteger(HT_ITEM, HP_REGEN + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, HP_REGEN + UPGRADE_PADDING, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, MP_REGEN + UPGRADE_PADDING, BASE, 1)
    call SaveInteger(HT_ITEM, MP_REGEN + UPGRADE_PADDING, LENGTH, 2)
    call SaveInteger(HT_ITEM, MP_REGEN + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, MP_REGEN + UPGRADE_PADDING, GRADE_GAP, 0)
    
    call SaveInteger(HT_ITEM, ENHANCE_AD + UPGRADE_PADDING, BASE, 0)
    call SaveInteger(HT_ITEM, ENHANCE_AD + UPGRADE_PADDING, LENGTH, 2)
    call SaveInteger(HT_ITEM, ENHANCE_AD + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, ENHANCE_AD + UPGRADE_PADDING, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, ENHANCE_AP + UPGRADE_PADDING, BASE, 0)
    call SaveInteger(HT_ITEM, ENHANCE_AP + UPGRADE_PADDING, LENGTH, 2)
    call SaveInteger(HT_ITEM, ENHANCE_AP + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, ENHANCE_AP + UPGRADE_PADDING, GRADE_GAP, 1)
    
    call SaveInteger(HT_ITEM, REDUCE_AD + UPGRADE_PADDING, BASE, 1)
    call SaveInteger(HT_ITEM, REDUCE_AD + UPGRADE_PADDING, LENGTH, 3)
    call SaveInteger(HT_ITEM, REDUCE_AD + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, REDUCE_AD + UPGRADE_PADDING, GRADE_GAP, 0)
    
    call SaveInteger(HT_ITEM, REDUCE_AP + UPGRADE_PADDING, BASE, 1)
    call SaveInteger(HT_ITEM, REDUCE_AP + UPGRADE_PADDING, LENGTH, 3)
    call SaveInteger(HT_ITEM, REDUCE_AP + UPGRADE_PADDING, PAD, 1)
    call SaveInteger(HT_ITEM, REDUCE_AP + UPGRADE_PADDING, GRADE_GAP, 0)
endfunction

function Get_Random_Property_Value takes integer property, integer grade returns integer
    local integer base = LoadInteger(HT_ITEM, property, BASE)
    local integer length = LoadInteger(HT_ITEM, property, LENGTH)
    local integer pad = LoadInteger(HT_ITEM, property, PAD)
    local integer grade_gap = LoadInteger(HT_ITEM, property, GRADE_GAP)
    local integer ran = GetRandomInt(0, length-1)
    
    return base + (grade * grade_gap) + (pad * ran)
endfunction

function Get_Random_Upgrade_Value takes integer property, integer grade returns integer
    local integer base = LoadInteger(HT_ITEM, property + UPGRADE_PADDING, BASE)
    local integer length = LoadInteger(HT_ITEM, property + UPGRADE_PADDING, LENGTH)
    local integer pad = LoadInteger(HT_ITEM, property + UPGRADE_PADDING, PAD)
    local integer grade_gap = LoadInteger(HT_ITEM, property + UPGRADE_PADDING, GRADE_GAP)
    local integer ran = GetRandomInt(0, length-1)
    local integer value
    
    set value = base + (grade * grade_gap) + (pad * ran)
    
    if value <= 0 then
        set value = 1
    endif
    
    return value
endfunction

endlibrary

/*

----------------
AD
10 12 14 16 18
25 27 29 31 33
40 42 44 47 49
55 57 59 61 63
70 72 74 76 78

5 6 7 8 9
10 11 12 13 14
15 16 17 18 19
20 21 22 23 24
25 26 27 28 29
-----------------
AP
20 24 28 32 36
50 54 58 62 66
80 84 88 92 96
110 114 118 122 126
140 144 148 152 156

10 12 14 16 18
20 22 24 26 28
30 32 34 36 38
40 42 44 46 48
50 52 54 56 58
-----------------
AS
10 11 12 13 14
16 17 18 19 20
22 23 24 25 26
28 29 30 31 32
34 35 36 37 38

4 5 6 7
7 8 9 10
10 11 12 13
13 14 15 16
16 17 18 19
-----------------
MS
10 11 12
13 14 15
16 17 18
19 20 21
22 23 24

4 5 6
5 6 7
6 7 8
7 8 9
8 9 10
9 10 11
-----------------
CRIT
1 2 3
2 3 4
3 4 5
4 5 6
5 6 7

0 1
1 2
2 3
3 4
4 5
-----------------
CRIT_COEF
10 11 12 13 14
16 17 18 19 20
22 23 24 25 26
28 29 30 31 32
34 35 36 37 38

4 5 6 7
7 8 9 10
10 11 12 13
13 14 15 16
16 17 18 19
------------------
DEF_AD
10 11 12 13 14
16 17 18 19 20
22 23 24 25 26
28 29 30 31 32
34 35 36 37 38

4 5 6 7
7 8 9 10
10 11 12 13
13 14 15 16
16 17 18 19
------------------
DEF_AP
10 11 12 13 14
16 17 18 19 20
22 23 24 25 26
28 29 30 31 32
34 35 36 37 38

4 5 6 7
7 8 9 10
10 11 12 13
13 14 15 16
16 17 18 19
------------------
HP
40 45 50 55 60
60 65 70 75 80
80 85 90 95 100
100 105 110 115 120
120 125 130 135 140

call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, BASE, 60)
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, LENGTH, 4)
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, PAD, 20)
    call SaveInteger(HT_ITEM, HP + UPGRADE_PADDING, GRADE_GAP, 60)

15 20 25 30
25 30 35 40
35 40 45 50
45 50 55 60
55 60 65 70
------------------
MP
10 15 20
20 25 30
30 35 40
40 45 50
50 55 60

0 5 10
5 10 15
10 15 20
15 20 25
20 25 30
------------------
hp_regen
3 4 5
5 6 7
7 8 9
9 10 11
11 12 13

1 2 3
2 3 4
3 4 5
4 5 6
5 6 7
------------------
mp_regen
1 2
2 3
3 4
4 5
5 6

1 2 3
1 2 3
1 2 3
1 2 3
1 2 3
------------------
enhance_ad
1 2 3
3 4 5
5 6 7
7 8 9
9 10 11

0 1
1 2
2 3
3 4
4 5
------------------
enhance_ap
1 2 3
3 4 5
5 6 7
7 8 9
9 10 11

0 1
1 2
2 3
3 4
4 5
------------------
reduce_ad
1 2
2 3
3 4
4 5
5 6

1 2 3
1 2 3
1 2 3
1 2 3
1 2 3
------------------
reduce_ap
1 2
2 3
3 4
4 5
5 6

1 2 3
1 2 3
1 2 3
1 2 3
1 2 3
*/