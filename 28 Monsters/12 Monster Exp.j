library MonsterExp requires UnitProperty

globals
    private real Range = 900 /* 경험치 나눠먹는 범위 */
endglobals

function Monster_Exp takes unit monster, unit killing_unit returns nothing
    local integer level = GetUnitLevel(monster)
    local real exp
    local integer value
    local group g = CreateGroup()
    local unit c
    local integer pid
    
    set exp = SquareRoot(Get_Unit_Property(monster, LEVEL)) * 5.0

    call GroupAddUnit(g, killing_unit)
    
    call GroupEnumUnitsInRange(g, GetUnitX(monster), GetUnitY(monster), Range, null)
    loop
    set c = FirstOfGroup(g)
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        
        if IsUnitType(c, UNIT_TYPE_HERO) == true and Get_Unit_Property(c, IS_MERCENARY) == 0 then
            set pid = GetPlayerId(GetOwningPlayer(c))
            
            // 안뜰 안에 있으면 경험치 25%
            if Get_Unit_Property(c, IN_COURTYARD) != 0 then
                set exp = exp / 4.0
            endif
            
            if c == killing_unit then
                set value = R2I(exp * ((100.0 + exp_rate[pid]) / 100.0) )
                call AddHeroXP(c, value, true)
            else
                set value = R2I( exp * ((100.0 + exp_rate[pid]) / 100.0 ) * 0.70 )
                call AddHeroXP(c, value, true)
            endif
        endif
    endloop
    
    call DestroyGroup(g)
    
    set g = null
    set c = null
endfunction

function Disable_Existing_Experience_System takes nothing returns nothing
    local integer i
    set i = -1
    loop
    set i = i + 1
    exitwhen i >= bj_MAX_PLAYERS
        call SetPlayerHandicapXP(Player(i), 0)
    endloop
endfunction

endlibrary