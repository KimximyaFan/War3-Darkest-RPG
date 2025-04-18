library Base


/*
Create_Rect
Timer_Clear
Trigger_Clear
Group_Clear
Set_Unit_Duration
Get_Mana
Set_Mana
Get_HP
Set_HP
GRR
Dist
Angle
Polar_Y
Polar_X
Mod
Hero_Check
*/

function Is_Terrain_Pathable takes real x, real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
endfunction

function Get_Random_Location_In_Range takes real x, real y, real range returns location
    local real theta = 2 * bj_PI * GetRandomReal(0.0, 1.0)
    local real r_random = range * SquareRoot(GetRandomReal(0.0, 1.0))
    return Location(x + r_random * Cos(theta), y + r_random * Sin(theta))
endfunction

// 뒤쪽 c는 null 기입
function Group_Copy takes group g, group c returns group
    set c = CreateGroup()
    call GroupAddGroup(g, c)
    return c
endfunction

function Create_Rect takes real x, real y, real width, real height returns rect
    local real a = width/2
    local real b = height/2
    return Rect( x-a, y-b, x+a, y+b)
endfunction

function Timer_Clear takes timer t returns nothing
    call FlushChildHashtable(HT, GetHandleId(t))
    call PauseTimer(t)
    call DestroyTimer(t)
endfunction

function Trigger_Clear takes trigger trg returns nothing
    call TriggerClearConditions(trg)
    call TriggerClearActions(trg)
    call DestroyTrigger(trg)
endfunction

function Group_Clear takes group g returns nothing
    call GroupClear(g)
    call DestroyGroup(g)
endfunction

function Set_Unit_Duration takes unit u, real time returns nothing
    call UnitApplyTimedLifeBJ( time, 'BHwe', u )
endfunction

function Get_Max_MP takes unit u returns real
    return GetUnitStateSwap(UNIT_STATE_MAX_MANA, u)
endfunction

function Get_Max_HP takes unit u returns real
    return GetUnitStateSwap(UNIT_STATE_MAX_LIFE, u)
endfunction

function Get_MP takes unit u returns real
    return GetUnitStateSwap( UNIT_STATE_MANA, u )
endfunction

function Set_MP takes unit u, real mana returns nothing
    call SetUnitManaBJ( u, mana )
endfunction

function Get_HP takes unit u returns integer
    return R2I( GetUnitStateSwap(UNIT_STATE_LIFE, u) )
endfunction

function Set_HP takes unit u, real hp returns nothing
    call SetUnitLifeBJ( u, hp )
endfunction

function GRR takes real lower, real upper returns real
    return GetRandomReal(lower, upper)
endfunction

function Dist takes real x, real y, real end_x, real end_y returns real
    return SquareRoot( (end_x - x)*(end_x - x) + (end_y - y)*(end_y - y) )
endfunction

function Angle takes real x, real y, real end_x, real end_y returns real
    return bj_RADTODEG * Atan2( end_y - y, end_x - x )
endfunction

function Polar_Y takes real y, real dist, real angle returns real
    return y + dist * Sin(angle * bj_DEGTORAD)
endfunction

function Polar_X takes real x, real dist, real angle returns real
    return x + dist * Cos(angle * bj_DEGTORAD)
endfunction

function Mod takes integer dividend, integer divisor returns integer
    local integer modulus = dividend - (dividend / divisor) * divisor

    if (modulus < 0) then
        set modulus = modulus + divisor
    endif

    return modulus
endfunction

function Hero_Check takes nothing returns boolean
    return IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true
endfunction

function Player_Playing_Check takes player p returns boolean
    return GetPlayerController(p) == MAP_CONTROL_USER and GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING
endfunction

endlibrary