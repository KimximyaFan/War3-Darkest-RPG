library CourtyardMonsterTable requires UnitProperty, MonsterRegister

globals
    private integer SKEL_SWORD = 'n01I'
    private integer SKEL_WIZARD = 'u004'
    private integer GHOUL = 'u005'
    private integer CRYPT_FIEND = 'u006'
    private integer MUTENT = 'n01L'
    private integer VANSHEE = 'u007'
    private integer DARK_TROLL = 'n01N'
    private integer DARK_TROLL_PRIEST = 'n01O'
    private integer NECRO_MANSER = 'u008'
    private integer OPSYDIAN_STATUE = 'u009'
    private integer TRENT = 'n01J'
    private integer FURBOLG_TRACKER = 'n01M'
    private integer SPIRIT_WOLF = 'o001'
    private integer GIANT_SPYDER = 'n01K'
    private integer BROOD_MOTHER = 'n01R'
    private integer WILD_KIN = 'n01Q'
    private integer DEEP_LORD_REVERNANT = 'n01P'
    private integer MAGNATAUER_WARRIOR = 'n01S'
    private integer POWER_GRANITE_GOLEM = 'n015'

    private integer array p_count[6]
    private integer last_triggered_pid
    private trigger array monster_set_trg
    private integer array monster_set_count
    private string create_eff = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl"
endglobals

// ===========================================================================
// Logic
// ===========================================================================

private function P_Count takes integer pid returns integer
    set p_count[pid] = p_count[pid] + 1
    return p_count[pid]
endfunction

private function P_Count_Init takes integer pid returns nothing
    set p_count[pid] = -1
endfunction

private function Monster_Register_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    
    call ShowUnitShow(u)
    call DestroyEffect( AddSpecialEffect(create_eff, GetUnitX(u), GetUnitY(u)) )
    
    call Timer_Clear(t)
    
    set t = null
    set u = null
endfunction

private function Monster_Register takes integer unit_id, real x, real y, integer grade, integer ad, integer ap, integer as, integer ms, integer crit, integer crit_coef,/*
*/integer enhance_ad, integer enhance_ap, integer def_ad, integer def_ap, integer hp, integer mp, integer reduce_ad, integer reduce_ap, /*
*/integer level, integer class, integer region_value, integer difficulty_like, real model_size, integer count, integer pid returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local unit u
    
    set u = CreateUnit(p_enemy, unit_id, x, y, 225)
    call GroupAddUnit(courtyard_combat_monster_group[pid], u)
    call ShowUnitHide(u)
    
    call Set_Unit_Property( u, AD, ad )
    call Set_Unit_Property( u, AP, ap )
    call Set_Unit_Property( u, AS, as )
    call Set_Unit_Property( u, MS, ms )
    call Set_Unit_Property( u, CRIT, crit )
    call Set_Unit_Property( u, CRIT_COEF, crit_coef )
    call Set_Unit_Property( u, ENHANCE_AD, enhance_ad )
    call Set_Unit_Property( u, ENHANCE_AP, enhance_ap )
    call Set_Unit_Property( u, DEF_AD, def_ad )
    call Set_Unit_Property( u, DEF_AP, def_ap )
    call Set_Unit_Property( u, HP, hp )
    call Set_Unit_Property( u, MP, mp )
    call Set_Unit_Property( u, REDUCE_AD, reduce_ad )
    call Set_Unit_Property( u, REDUCE_AP, reduce_ap )
    call Set_Unit_Property( u, LEVEL, level )
    call Set_Unit_Property( u, CLASS, class )
    call Set_Unit_Property( u, REGION, region_value )
    call Set_Unit_Property( u, DIFFICULTY_LIKE, difficulty_like )
    call Set_Unit_Property( u, IN_COURTYARD, 1 )
    
    call SetUnitScalePercent(u, model_size + grade * 40, model_size + grade * 40, model_size + grade * 40)
    
    if grade > 3 then
        set grade = 3
    endif
    
    if grade > 0 then
        call Set_Monster_Grade(u, grade)
        call Grade_Property(u, false)
    endif
    
    call Apply_Monster_Property(u)
    
    call SaveUnitHandle(HT, id, 0, u)
    call TimerStart(t, 0.15 * count + 1.25, false, function Monster_Register_Func)
    
    set t = null
    set u = null
endfunction

// ===========================================================================
// Monster Table
// ===========================================================================

/*
    private function Monster_Register takes integer unit_id, real x, real y, integer grade, integer ad, integer ap, integer as, integer ms, integer crit, integer crit_coef,/*
*/integer enhance_ad, integer enhance_ap, integer def_ad, integer def_ap, integer hp, integer mp, integer reduce_ad, integer reduce_ap, /*
*/integer level, integer class, integer region_value, integer difficulty_like real model_size, integer count returns nothing
    
    constant integer NORMAL = 0
    constant integer UNCOMMON = 1
    constant integer RARE = 2
    constant integer LEGEND = 3
    
    constant integer PLANE = 0
    constant integer GRUNT = 1
    constant integer ELDER = 2
    constant integer MID_BOSS = 3
    constant integer BOSS = 4
*/

// ===========================================================================
// NIGHTMARE
// ===========================================================================

private function Courtyard_Moster_Set_20 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id

    call P_Count_Init(pid)

    set unit_id = MAGNATAUER_WARRIOR
    call Monster_Register(unit_id, x, y, RARE, 450, 0, 100, 350, 25, 75, 0, 0, 30, 30, 50000, 0, 25, 25, 125, ELDER, region_val, difficulty, 150.0, P_Count(pid), pid)
endfunction
    
private function Courtyard_Moster_Set_19 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id

    call P_Count_Init(pid)

    set unit_id = TRENT
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 275, 0, 50, 300, 15, 75, 0, 0, 20, 20, 6000, 0, 25, 25, 75, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 275, 0, 50, 300, 15, 75, 0, 0, 20, 20, 6000, 0, 25, 25, 75, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 275, 0, 50, 300, 15, 75, 0, 0, 20, 20, 6000, 0, 25, 25, 75, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 275, 0, 50, 300, 15, 75, 0, 0, 20, 20, 6000, 0, 25, 25, 75, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 275, 0, 50, 300, 15, 75, 0, 0, 20, 20, 6000, 0, 25, 25, 75, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 275, 0, 50, 300, 15, 75, 0, 0, 20, 20, 6000, 0, 25, 25, 75, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x, y, UNCOMMON, 300, 0, 100, 300, 15, 75, 0, 0, 20, 20, 20000, 0, 25, 25, 75, GRUNT, region_val, difficulty, 225.0, P_Count(pid), pid)

    set unit_id = POWER_GRANITE_GOLEM
    call Monster_Register(unit_id, x, y, UNCOMMON, 350, 0, 100, 300, 25, 75, 0, 0, 25, 25, 25000, 0, 25, 25, 90, GRUNT, region_val, difficulty, 220.0, P_Count(pid), pid)
endfunction    

private function Courtyard_Moster_Set_18 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NIGHTMARE
    local real pad = 450
    local integer unit_id

    call P_Count_Init(pid)

    set unit_id = GIANT_SPYDER
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 250, 0, 40, 300, 15, 75, 0, 0, 20, 20, 4000, 0, 25, 25, 75, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 250, 0, 40, 300, 15, 75, 0, 0, 20, 20, 4000, 0, 25, 25, 75, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 250, 0, 40, 300, 15, 75, 0, 0, 20, 20, 4000, 0, 25, 25, 75, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 250, 0, 40, 300, 15, 75, 0, 0, 20, 20, 4000, 0, 25, 25, 75, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 250, 0, 40, 300, 15, 75, 0, 0, 20, 20, 4000, 0, 25, 25, 75, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 250, 0, 40, 300, 15, 75, 0, 0, 20, 20, 4000, 0, 25, 25, 75, PLANE, region_val, difficulty, 200.0, P_Count(pid), pid)

    set unit_id = BROOD_MOTHER
    call Monster_Register(unit_id, x, y, UNCOMMON, 0, 250, 150, 300, 25, 75, 0, 0, 20, 20, 20000, 0, 20, 20, 100, GRUNT, region_val, difficulty, 300.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_17 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id

    call P_Count_Init(pid)

    set unit_id = SKEL_SWORD
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 300, 0, 150, 350, 20, 75, 0, 0, 20, 20, 10000, 0, 20, 20, 80, GRUNT, region_val, difficulty, 300.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 300, 0, 150, 350, 20, 75, 0, 0, 20, 20, 10000, 0, 20, 20, 80, GRUNT, region_val, difficulty, 300.0, P_Count(pid), pid)
    
    set unit_id = NECRO_MANSER
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 200, 20, 270, 20, 75, 0, 0, 20, 20, 1500, 0, 15, 15, 70, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 200, 20, 270, 20, 75, 0, 0, 20, 20, 1500, 0, 15, 15, 70, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)

    set unit_id = DEEP_LORD_REVERNANT
    call Monster_Register(unit_id, x, y, UNCOMMON, 0, 225, 100, 270, 20, 75, 0, 0, 20, 20, 10000, 0, 15, 15, 80, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y, UNCOMMON, 0, 225, 100, 270, 20, 75, 0, 0, 20, 20, 10000, 0, 15, 15, 80, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_16 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id

    call P_Count_Init(pid)
    
    set unit_id = FURBOLG_TRACKER
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 200, 0, 20, 270, 15, 75, 0, 0, 15, 15, 3000, 0, 15, 15, 70, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 200, 0, 20, 270, 15, 75, 0, 0, 15, 15, 3000, 0, 15, 15, 70, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 200, 0, 20, 270, 15, 75, 0, 0, 15, 15, 3000, 0, 15, 15, 70, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)

    set unit_id = DARK_TROLL
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 145, 0, 20, 280, 15, 75, 0, 0, 15, 15, 1000, 0, 15, 15, 60, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 145, 0, 20, 280, 15, 75, 0, 0, 15, 15, 1000, 0, 15, 15, 60, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 145, 0, 20, 280, 15, 75, 0, 0, 15, 15, 1000, 0, 15, 15, 60, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)

    set unit_id = DARK_TROLL_PRIEST
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 140, 20, 280, 20, 75, 0, 0, 20, 20, 800, 0, 15, 15, 60, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 140, 20, 280, 20, 75, 0, 0, 20, 20, 800, 0, 15, 15, 60, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)

    set unit_id = SPIRIT_WOLF
    call Monster_Register(unit_id, x, y, UNCOMMON, 250, 0, 150, 400, 40, 75, 0, 0, 20, 20, 2500, 0, 15, 15, 70, GRUNT, region_val, difficulty, 225.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_15 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 2
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)

    set unit_id = 'n01Q' /* 와일드킨 */
    call Monster_Register(unit_id, x, y, UNCOMMON, 250, 0, 100, 300, 25, 75, 0, 0, 30, 30, 15000, 0, 20, 20, 85, ELDER, region_val, difficulty, 175.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_14 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 2
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)
    
    set unit_id = 'u005' /* 구울 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 200, 0, 50, 300, 25, 75, 0, 0, 20, 20, 3500, 0, 15, 15, 60, GRUNT, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 200, 0, 50, 300, 25, 75, 0, 0, 20, 20, 3500, 0, 15, 15, 60, GRUNT, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 200, 0, 50, 300, 25, 75, 0, 0, 20, 20, 3500, 0, 15, 15, 60, GRUNT, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 200, 0, 50, 300, 25, 75, 0, 0, 20, 20, 3500, 0, 15, 15, 60, GRUNT, region_val, difficulty, 150.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_13 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 2
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)

    set unit_id = 'n01L' /* 뮤턴트 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 150, 0, 20, 300, 25, 75, 0, 0, 15, 15, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 20, 300, 25, 75, 0, 0, 15, 15, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 20, 300, 25, 75, 0, 0, 15, 15, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 20, 300, 25, 75, 0, 0, 15, 15, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 20, 300, 25, 75, 0, 0, 15, 15, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 160.0, P_Count(pid), pid)
    
    set unit_id = 'u007' /* 밴시 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 150, 100, 280, 20, 75, 0, 0, 15, 15, 1000, 0, 15, 15, 50, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 150, 100, 280, 20, 75, 0, 0, 15, 15, 1000, 0, 15, 15, 50, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 150, 100, 280, 20, 75, 0, 0, 15, 15, 1000, 0, 15, 15, 50, PLANE, region_val, difficulty, 150.0, P_Count(pid), pid)
    
    set unit_id = 'n01J' /* 트렌트 */
    call Monster_Register(unit_id, x, y, NORMAL, 225, 0, 50, 270, 20, 75, 0, 0, 20, 20, 5000, 0, 20, 20, 70, GRUNT, region_val, difficulty, 165.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_12 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 1
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id
    local integer i = -1
        
    call P_Count_Init(pid)
    
    set unit_id = 'n01K' /* 자이언트 스파이더 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 0, 290, 20, 75, 0, 0, 20, 20, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 0, 290, 20, 75, 0, 0, 20, 20, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 150, 0, 0, 290, 20, 75, 0, 0, 20, 20, 2000, 0, 15, 15, 50, PLANE, region_val, difficulty, 175.0, P_Count(pid), pid)
    
    set unit_id = 'u006' /* 크립트 핀드 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 100, 20, 260, 15, 75, 0, 0, 20, 20, 500, 0, 15, 15, 40, PLANE, region_val, difficulty, 110.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 100, 20, 260, 15, 75, 0, 0, 20, 20, 500, 0, 15, 15, 40, PLANE, region_val, difficulty, 110.0, P_Count(pid), pid)
    
    set unit_id = 'n01K' /* 자이언트 스파이더 */
    call Monster_Register(unit_id, x, y, UNCOMMON, 200, 0, 50, 300, 20, 75, 0, 0, 25, 25, 3000, 0, 20, 20, 70, GRUNT, region_val, difficulty, 250.0, P_Count(pid), pid)
endfunction

private function Courtyard_Moster_Set_11 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 1
    local integer difficulty = NIGHTMARE
    local real pad = 275
    local integer unit_id
    local integer i = -1
        
    call P_Count_Init(pid)
    
    set unit_id = 'n01I' /* 해골 칼 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 0, 280, 15, 75, 0, 0, 15, 15, 650, 0, 15, 15, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 0, 280, 15, 75, 0, 0, 15, 15, 650, 0, 15, 15, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 0, 280, 15, 75, 0, 0, 15, 15, 650, 0, 15, 15, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), UNCOMMON, 100, 0, 0, 280, 15, 75, 0, 0, 15, 15, 650, 0, 15, 15, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    set unit_id = 'u004' /* 해골 법 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 85, 0, 260, 15, 75, 0, 0, 10, 10, 500, 0, 10, 10, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 85, 0, 260, 15, 75, 0, 0, 10, 10, 500, 0, 10, 10, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 85, 0, 260, 15, 75, 0, 0, 10, 10, 500, 0, 10, 10, 40, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    
    set unit_id = 'u009' /* 옵시디언 스태추 */
    call Monster_Register(unit_id, x, y, NORMAL, 0, 150, 100, 260, 20, 75, 0, 0, 20, 20, 5000, 0, 15, 15, 70, GRUNT, region_val, difficulty, 120.0, P_Count(pid), pid)
endfunction

// ===========================================================================
// NORMAL
// ===========================================================================

// 노말 해안만 보스 급
private function Courtyard_Moster_Set_10 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 4
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)

    set unit_id = 'n01P' /* 안뜰 딥로드 레버넌트 */
    call Monster_Register(unit_id, x, y, NORMAL, 0, 175, 100, 270, 20, 50, 0, 0, 20, 20, 15000, 0, 20, 20, 80, ELDER, region_val, difficulty, 150.0, P_Count(pid), pid)
endfunction

// 노말 해안만 중간
private function Courtyard_Moster_Set_9 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 4
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)

    set unit_id = 'u008' /* 안뜰 네크로맨서 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 120, 50, 270, 20, 50, 0, 0, 10, 10, 1500, 0, 15, 15, 30, GRUNT, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 120, 50, 270, 20, 50, 0, 0, 10, 10, 1500, 0, 15, 15, 30, GRUNT, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 120, 50, 270, 20, 50, 0, 0, 10, 10, 1500, 0, 15, 15, 30, GRUNT, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 120, 50, 270, 20, 50, 0, 0, 10, 10, 1500, 0, 15, 15, 30, GRUNT, region_val, difficulty, 125.0, P_Count(pid), pid)

    set unit_id = 'u009' /* 안뜰 옵시디언 스태추 */
    call Monster_Register(unit_id, x, y, NORMAL, 0, 125, 100, 270, 20, 50, 0, 0, 15, 15, 6000, 0, 15, 15, 60, ELDER, region_val, difficulty, 150.0, P_Count(pid), pid)
endfunction

// 노말 해안만 초입
private function Courtyard_Moster_Set_8 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 4
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)
    
    set unit_id = 'n01N' /* 안뜰 다크 트롤 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 50, 300, 15, 50, 0, 0, 5, 5, 500, 0, 10, 10, 20, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 50, 300, 15, 50, 0, 0, 5, 5, 500, 0, 10, 10, 20, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)

    set unit_id = 'n01O' /* 안뜰 다크 트롤 프리스트 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 80, 0, 270, 10, 50, 0, 0, 10, 10, 500, 0, 10, 10, 20, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 80, 0, 270, 10, 50, 0, 0, 10, 10, 500, 0, 10, 10, 20, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    
    set unit_id = 'o001' /* 안뜰 스피릿 울프 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 50, 300, 20, 50, 0, 0, 15, 15, 2500, 0, 15, 15, 40, GRUNT, region_val, difficulty, 150.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 100, 0, 50, 300, 20, 50, 0, 0, 15, 15, 2500, 0, 15, 15, 40, GRUNT, region_val, difficulty, 150.0, P_Count(pid), pid)

    set unit_id = 'n01J' /* 안뜰 트렌트 */
    call Monster_Register(unit_id, x, y, NORMAL, 150, 0, 50, 250, 10, 50, 0, 0, 20, 20, 5000, 0, 20, 20, 40, ELDER, region_val, difficulty, 250.0, P_Count(pid), pid)
endfunction

// 노말 사육장 중후반
private function Courtyard_Moster_Set_7 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)

    set unit_id = 'u005' /* 안뜰 구울 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 85, 0, 100, 350, 15, 50, 0, 0, 10, 10, 600, 0, 10, 10, 20, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 85, 0, 100, 350, 15, 50, 0, 0, 10, 10, 600, 0, 10, 10, 20, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 85, 0, 100, 350, 15, 50, 0, 0, 10, 10, 600, 0, 10, 10, 20, PLANE, region_val, difficulty, 140.0, P_Count(pid), pid)

    set unit_id = 'u006' /* 안뜰 크립트 핀드 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 100, 25, 250, 15, 50, 0, 0, 15, 15, 1000, 0, 10, 10, 20, GRUNT, region_val, difficulty, 120.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 100, 25, 250, 15, 50, 0, 0, 15, 15, 1000, 0, 10, 10, 20, GRUNT, region_val, difficulty, 120.0, P_Count(pid), pid)

    set unit_id = 'n01M' /* 안뜰 펄볼그 트래커 */
    call Monster_Register(unit_id, x, y, NORMAL, 200, 0, 15, 300, 15, 50, 0, 0, 15, 15, 5000, 0, 15, 15, 30, ELDER, region_val, difficulty, 175.0, P_Count(pid), pid)
endfunction

// 노말 사육장 초반
private function Courtyard_Moster_Set_6 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 3
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    call P_Count_Init(pid)

    set unit_id = 'n01L' /* 안뜰 뮤턴트 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 60, 0, 20, 300, 10, 50, 0, 0, 5, 5, 300, 0, 15, 15, 8, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 60, 0, 20, 300, 10, 50, 0, 0, 5, 5, 300, 0, 15, 15, 8, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 60, 0, 20, 300, 10, 50, 0, 0, 5, 5, 300, 0, 15, 15, 8, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 60, 0, 20, 300, 10, 50, 0, 0, 5, 5, 300, 0, 15, 15, 8, PLANE, region_val, difficulty, 125.0, P_Count(pid), pid)

    set unit_id = 'u007' /* 안뜰 밴시 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 80, 70, 300, 20, 50, 0, 0, 5, 5, 250, 0, 10, 10, 15, PLANE, region_val, difficulty, 100.0, P_Count(pid), pid)
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+GRR(-pad, pad), NORMAL, 0, 80, 70, 300, 20, 50, 0, 0, 5, 5, 250, 0, 10, 10, 15, PLANE, region_val, difficulty, 100.0, P_Count(pid), pid)

    set unit_id = 'n01I' /* 안뜰 해골 칼 */
    call Monster_Register(unit_id, x, y, NORMAL, 100, 0, 50, 300, 15, 50, 0, 0, 10, 10, 1000, 0, 10, 10, 20, GRUNT, region_val, difficulty, 200.0, P_Count(pid), pid)
endfunction

// 노말 폐허 보스급
private function Courtyard_Moster_Set_5 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 2
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    set i = i + 1
    set unit_id = 'n01K' /* 안뜰 자이언트 스파이더 */
    call Monster_Register(unit_id, x+GRR(-pad, pad), y+ GRR(-pad, pad), NORMAL, 150, 0, 70, 300, 20, 50, 0, 0, 15, 15, 3000, 0, 5, 5, 20, ELDER, region_val, difficulty, 225.0, i, pid)
endfunction

// 노말 폐허 그런트와 엘더
private function Courtyard_Moster_Set_4 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 2
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    set i = i + 1
    set unit_id = 'n01I' /* 안뜰 해골 칼 */
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 100, 0, 20, 280, 20, 50, 0, 0, 15, 15, 500, 0, 5, 5, 10, GRUNT, region_val, difficulty, 200.0, i, pid)
    set i = i + 1
    set unit_id = 'u004' /* 안뜰 해골 법 */
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 0, 50, 100, 270, 20, 50, 0, 0, 15, 15, 300, 0, 5, 5, 10, GRUNT, region_val, difficulty, 200.0, i, pid)
endfunction

// 노말 폐허 초입 난이도
private function Courtyard_Moster_Set_3 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 2
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    set unit_id = 'u005' /* 안뜰 구울 */

    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 3
        call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 25, 0, 0, 270, 10, 50, 0, 0, 5, 5, 30, 0, 0, 0, 5, PLANE, region_val, difficulty, 90.0, i, pid)
    endloop
    
    set unit_id = 'u006' /* 안뜰 크립트 핀드 */
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 0, 25, 0, 250, 10, 50, 0, 0, 5, 5, 25, 0, 0, 0, 5, PLANE, region_val, difficulty, 90.0, i, pid)
    set i = i + 1
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 0, 25, 0, 250, 10, 50, 0, 0, 5, 5, 25, 0, 0, 0, 5, PLANE, region_val, difficulty, 90.0, i, pid)
    set unit_id = 'n01J' /* 안뜰 트렌트 */
    set i = i + 1
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 45, 0, 0, 300, 20, 50, 0, 0, 5, 5, 200, 0, 0, 0, 8, GRUNT, region_val, difficulty, 150.0, i, pid)
endfunction

// 노말 산림 동굴 난이도
private function Courtyard_Moster_Set_2 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 1
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    set unit_id = 'n01J' /* 안뜰 트렌트 */
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 3
        call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 10, 0, 0, 250, 5, 50, 0, 0, 5, 5, 25, 0, 0, 0, 5, PLANE, region_val, difficulty, 90.0, i, pid)
    endloop
    
    // 살짝 더 쎈 안뜰 트렌트
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 25, 0, 0, 250, 5, 50, 0, 0, 5, 5, 100, 0, 0, 0, 7, GRUNT, region_val, difficulty, 110.0, i, pid)
endfunction

// 노말 산림 밴딧 도끼, 창 난이도
private function Courtyard_Moster_Set_1 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 1
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    set unit_id = 'n01I' /* 안뜰 해골 칼 */
    
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= 4
        call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 4, 0, 0, 250, 0, 0, 0, 0, 1, 1, 5, 0, 0, 0, 1, PLANE, region_val, difficulty, 80.0, i, pid)
    endloop
    
    set unit_id = 'u004' /* 안뜰 해골 법 */
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 0, 6, 0, 250, 0, 0, 0, 0, 1, 1, 4, 0, 0, 0, 1, PLANE, region_val, difficulty, 80.0, i, pid)
endfunction

// 의미 없는 수준의 난이도 그냥 0 처리용
private function Courtyard_Moster_Set_0 takes nothing returns nothing
    local integer pid = last_triggered_pid
    local real x = GetLocationX(courtyard_mosnter_start_loc[pid])
    local real y = GetLocationY(courtyard_mosnter_start_loc[pid])
    local integer region_val = 1
    local integer difficulty = NORMAL
    local real pad = 275
    local integer unit_id
    local integer i = -1
    
    set i = i + 1
    set unit_id = 'n01I' /* 안뜰 해골 칼 */
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 4, 0, 0, 250, 0, 0, 0, 0, 1, 1, 5, 0, 0, 0, 1, PLANE, region_val, difficulty, 80.0, i, pid)
    set i = i + 1
    set unit_id = 'u004' /* 안뜰 해골 법 */
    call Monster_Register(unit_id, x + GRR(-pad, pad), y + GRR(-pad, pad), NORMAL, 0, 6, 0, 250, 0, 0, 0, 0, 1, 1, 4, 0, 0, 0, 1, PLANE, region_val, difficulty, 80.0, i, pid)
endfunction

// ===========================================================================
// Init
// ===========================================================================

private function Courtyard_Monster_Set_Count_Init takes nothing returns nothing
    set monster_set_count[0] = 5
    set monster_set_count[1] = 5
    set monster_set_count[2] = 4
    set monster_set_count[3] = 6
    set monster_set_count[4] = 2
    set monster_set_count[5] = 1
    set monster_set_count[6] = 7
    set monster_set_count[7] = 6
    set monster_set_count[8] = 7
    set monster_set_count[9] = 5
    set monster_set_count[10] = 1
    set monster_set_count[11] = 8
    set monster_set_count[12] = 6
    set monster_set_count[13] = 6
    set monster_set_count[14] = 4
    set monster_set_count[15] = 1
    set monster_set_count[16] = 9
    set monster_set_count[17] = 6
    set monster_set_count[18] = 7
    set monster_set_count[19] = 7
    set monster_set_count[20] = 1
    set monster_set_count[21] = 1
endfunction

private function Courtyard_Trigger_Init takes nothing returns nothing
    local integer i = -1
    
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_0)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_1)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_2)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_3)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_4)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_5)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_6)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_7)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_8)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_9)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_10)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_11)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_12)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_13)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_14)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_15)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_16)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_17)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_18)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_19)
    set i = i + 1
    set monster_set_trg[i] = CreateTrigger()
    call TriggerAddAction(monster_set_trg[i], function Courtyard_Moster_Set_20)
endfunction

function Courtyard_Monster_Table_Init takes nothing returns nothing
    call Courtyard_Monster_Set_Count_Init()
    call Courtyard_Trigger_Init()
endfunction

// ==============================================================================
// API
// ==============================================================================

// 걸리는 시간을 반환한다
function Courtyard_Set_Monsters takes integer pid, integer level_index returns real
    set last_triggered_pid = pid
    call TriggerExecute(monster_set_trg[level_index])
    return monster_set_count[level_index] * 0.15 + 1.0
endfunction

endlibrary