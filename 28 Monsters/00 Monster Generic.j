library MonsterGeneric

globals
    // 강화 속성들
    constant integer AD_RESISTANCE = 1
    constant integer AP_RESISTANCE = 2
    constant integer ACCEL = 3
    constant integer CRITICAL = 4
    constant integer TANK = 5
    constant integer ARCANE = 6
    constant integer EXPLOSION = 7
    constant integer AURA = 8
    constant integer MANA_BURN = 9
    constant integer AD_STRONG = 10
    constant integer AP_STRONG = 11
    constant integer STUN = 12
    constant integer SWAMP = 13
    constant integer KNOCKBACK = 14
    constant integer VORTEX = 15
    constant integer TOWER = 16
    constant integer REGENERATION = 17
    constant integer REFLECTION = 18
    constant integer THUNDER = 19
    constant integer EARTH_QUAKE = 20
    constant integer POISON = 21
    constant integer PLAGUE = 22
    constant integer FROZEN = 23
    constant integer DIVINE = 24
    
    string array GRADE_SKILL_STRING
    
    constant integer GRADE_SKILL_COUNT = 6
    
    real monster_texttag_x
    real array monster_texttag_height
endglobals

function Monster_Variable_Init takes nothing returns nothing
    set monster_texttag_x = 30
    set monster_texttag_height[0] = 175
    set monster_texttag_height[1] = 135
    set monster_texttag_height[2] = 95
    set monster_texttag_height[3] = 55
    
    set GRADE_SKILL_STRING[AD_RESISTANCE] = "AD_RESISTANCE"
    set GRADE_SKILL_STRING[AP_RESISTANCE] = "AP_RESISTANCE"
    set GRADE_SKILL_STRING[ACCEL] = "ACCEL"
    set GRADE_SKILL_STRING[CRITICAL] = "CRITICAL"
    set GRADE_SKILL_STRING[TANK] = "TANK"
    set GRADE_SKILL_STRING[ARCANE] = "ARCANE"
endfunction

endlibrary