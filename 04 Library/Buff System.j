globals
    hashtable BHT = InitHashtable() /* Buff Hash Table */
    
    // Buff ID
    constant integer ELF_KNIGHT_DASH = 0
    constant integer ELF_KNIGHT_AURA = 1
    constant integer BARBARIAN_ATTACK_SPEED_SLOW = 2
    constant integer BARBARIAN_MOVE_SPEED_SLOW = 3
    constant integer MARINE_STEAM_PACK = 4
    constant integer ENTERPRISE_MOVE_SPEED_SLOW = 5
    constant integer SABER_Z_BUFF = 6
    constant integer SABER_X_BUFF = 7
endglobals

struct Buff
    public unit u
    public integer buff_id
    public integer array property_arr[16]
    public integer array property_max_value[16]
    public Buff next_buff
    public effect buff_effect
    
    public static method create takes unit owner, integer b_id returns thistype
        local thistype this = thistype.allocate()
        local integer i = -1
        
        set u = owner
        set buff_id = b_id
        set next_buff = -1
        
        loop
        set i = i + 1
        exitwhen i > 15
            set property_arr[i] = 0
            set property_max_value[i] = 0
        endloop
        
        return this
    endmethod
    
    public method destroy takes nothing returns nothing
        call Apply_Max_Property_Value(false)
    
        set u = null
        set next_buff = -1
        set buff_effect = null
        call thistype.deallocate( this )
    endmethod
    
    public method Set_Buff_Property takes integer property, integer value returns nothing
        set property_arr[property] = value
    endmethod
    
    public method Apply_Max_Property_Value takes boolean is_add returns nothing
        local integer property
        local integer a = 1
        local integer pid = GetPlayerId(GetOwningPlayer(u))
        
        if is_add == false then
            set a = -1
        endif
        
        set property = -1
        loop
        set property = property + 1
        exitwhen property > 15
            call Set_Unit_Property(u, property, Get_Unit_Property(u, property) + a * property_max_value[property] )
        endloop
        
        if Player(pid) != p_enemy then
            call Stat_Refresh(pid)
        endif
    endmethod
    
    public method Apply_Buff_Value takes nothing returns nothing
        local integer property
        local Buff current_buff = this
        
        call Apply_Max_Property_Value(false)
        
        loop
        exitwhen current_buff == -1
        
            set property = -1
            loop
            set property = property + 1
            exitwhen property > 15
                if  IAbsBJ( current_buff.property_arr[property] ) > IAbsBJ( this.property_max_value[property] ) then
                    set this.property_max_value[property] = current_buff.property_arr[property]
                endif
            endloop
            
            set current_buff = current_buff.next_buff 
        endloop
        
        call Apply_Max_Property_Value(true)
    endmethod
    
    public method Register_Buff takes string eff, string attach_point returns nothing
        local Buff root_buff
        local Buff current_buff
        local boolean loop_end = false

        if HaveSavedInteger(BHT, GetHandleId(u), buff_id) == true then
            set root_buff = LoadInteger(BHT, GetHandleId(u), buff_id)
            set current_buff = root_buff

            loop
            exitwhen loop_end == true
                if current_buff.next_buff == -1 then
                    set current_buff.next_buff = this
                    set loop_end = true
                else
                    set current_buff = current_buff.next_buff
                endif
            endloop
        else

            set root_buff = this
            call SaveInteger(BHT, GetHandleId(u), buff_id, root_buff)
            
            set buff_effect = AddSpecialEffectTarget(eff, u, attach_point)
        endif
        
        call root_buff.Apply_Buff_Value()
    endmethod
    
    public method End_Buff takes nothing returns nothing
        if this.next_buff == -1 then
            call DestroyEffect(buff_effect)
            call RemoveSavedInteger(BHT, GetHandleId(u), buff_id)
        else
            call SaveInteger(BHT, GetHandleId(u), buff_id, this.next_buff)
            call this.next_buff.Apply_Buff_Value()
            set this.next_buff.buff_effect = buff_effect
        endif
        
        call this.destroy()
    endmethod
endstruct

library BuffSystem requires Base, Basic, UnitProperty, Stat, GenericUnitUniversal


private function Set_Unit_Buff_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Buff B = LoadInteger(HT, id, 2)
    
    call B.End_Buff()
    
    call Timer_Clear(t)
    
    set t = null
endfunction

private function Set_Unit_Buff_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local real duration = LoadReal(HT, id, 1)
    local Buff B = LoadInteger(HT, id, 2)
    local string eff = LoadStr(HT, id, 3)
    local string attach_point = LoadStr(HT, id, 4)
    
    call B.Register_Buff(eff, attach_point)
    
    call TimerStart(t, duration, false, function Set_Unit_Buff_Func2)
    
    set t = null
endfunction

function Set_Unit_Buff takes real duration, Buff B, string eff, string attach_point, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveReal(HT, id, 1, duration)
    call SaveInteger(HT, id, 2, B)
    call SaveStr(HT, id, 3, eff)
    call SaveStr(HT, id, 4, attach_point)
    call TimerStart(t, delay, false, function Set_Unit_Buff_Func)
    
    set t = null
endfunction

private function Unit_Area_Buff_Attached_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local integer buff_id = LoadInteger(HT, id, 1)
    local integer property = LoadInteger(HT, id, 2)
    local integer value = R2I( LoadReal(HT, id, 3) )
    local real duration = LoadReal(HT, id, 4)
    local real dist = LoadReal(HT, id, 5)
    local real angle = LoadReal(HT, id, 6)
    local real size = LoadReal(HT, id, 7)
    local string eff = LoadStr(HT, id, 8)
    local string attach_point = LoadStr(HT, id, 9)
    local boolean is_enemy_buff = LoadBoolean(HT, id, 10)
    local real x = Polar_X(GetUnitX(u), dist, angle)
    local real y = Polar_Y(GetUnitY(u), dist, angle)
    local Buff B
    local group g
    local unit c
    
    if is_enemy_buff == true then
        set g = Get_Group(u, x, y, size)
    else
        set g = Get_Ally_Group(u, x, y, size, null)
    endif
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        set B = Buff.create(c, buff_id)
        call B.Set_Buff_Property(property, value)
        call Set_Unit_Buff(duration, B, eff, attach_point, 0.00)
    endloop

    call Timer_Clear(t)

    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function Unit_Area_Buff_Attached takes unit u, integer buff_id, integer property, real value, real duration, /*
*/real dist, real angle, real size, string eff, string attach_point, boolean is_enemy_buff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveInteger(HT, id, 1, buff_id)
    call SaveInteger(HT, id, 2, property)
    call SaveReal(HT, id, 3, value)
    call SaveReal(HT, id, 4, duration)
    call SaveReal(HT, id, 5, dist)
    call SaveReal(HT, id, 6, angle)
    call SaveReal(HT, id, 7, size)
    call SaveStr(HT, id, 8, eff)
    call SaveStr(HT, id, 9, attach_point)
    call SaveBoolean(HT, id, 10, is_enemy_buff)
    call TimerStart(t, delay, false, function Unit_Area_Buff_Attached_Func)
    
    set t = null
endfunction

private function Unit_Area_Buff_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local unit u = LoadUnitHandle(HT, id, 0)
    local real x = LoadReal(HT, id, 1)
    local real y = LoadReal(HT, id, 2)
    local integer buff_id = LoadInteger(HT, id, 3)
    local integer property = LoadInteger(HT, id, 4)
    local integer value = R2I( LoadReal(HT, id, 5) )
    local real duration = LoadReal(HT, id, 6)
    local real size = LoadReal(HT, id, 7)
    local string eff = LoadStr(HT, id, 8)
    local string attach_point = LoadStr(HT, id, 9)
    local boolean is_enemy_buff = LoadBoolean(HT, id, 10)
    local Buff B
    local group g
    local unit c
    
    if is_enemy_buff == true then
        set g = Get_Group(u, x, y, size)
    else
        set g = Get_Ally_Group(u, x, y, size, null)
    endif
    
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        set B = Buff.create(c, buff_id)
        call B.Set_Buff_Property(property, value)
        call Set_Unit_Buff(duration, B, eff, attach_point, 0.00)
    endloop

    call Timer_Clear(t)

    set t = null
    set u = null
    set g = null
    set c = null
endfunction

function Unit_Area_Buff takes unit u, real x, real y, integer buff_id, integer property, real value, real duration, /*
*/ real size, string eff, string attach_point, boolean is_enemy_buff, real delay returns nothing
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    
    call SaveUnitHandle(HT, id, 0, u)
    call SaveReal(HT, id, 1, x)
    call SaveReal(HT, id, 2, y)
    call SaveInteger(HT, id, 3, buff_id)
    call SaveInteger(HT, id, 4, property)
    call SaveReal(HT, id, 5, value)
    call SaveReal(HT, id, 6, duration)
    call SaveReal(HT, id, 7, size)
    call SaveStr(HT, id, 8, eff)
    call SaveStr(HT, id, 9, attach_point)
    call SaveBoolean(HT, id, 10, is_enemy_buff)
    call TimerStart(t, delay, false, function Unit_Area_Buff_Func)
    
    set t = null
endfunction

endlibrary