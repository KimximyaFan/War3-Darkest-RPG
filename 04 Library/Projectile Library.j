struct Projectile

    public effect projectile_eff
    public unit owner
    public unit target
    public real eff_x
    public real eff_y
    public real eff_z
    public real dmg
    public real coll_size
    public boolean dmg_type
    public real time
    public real dist
    public real unit_dist /* 0.02초당 가야할 거리 */
    public real angle
    public real height
    public string eff
    public real eff_size
    public real eff_height
    public boolean is_penetrate
    public boolean is_pathable
    public string eff_on_target /* 적에게 터지는 이펙 */
    public trigger trg
    public group filter_group
    
    // 추가됨
    public string eff_after /* 땅에 떨어졌을 때 터지는 이펙 */
    public real velocity
    public real z_velocity
    public real eff_after_size
    public real gravity
    public real front
    public real back
    public real side
    public real vertical
    public real x_accel
    public real y_accel
    public real z_accel
    public real elapsed_time
    public boolean is_facing
    public real origin_x
    public real origin_y
    public real origin_z
    public real pitch
    public real array M0[3]
    public real array M1[3]
    public real array M2[3]
    public real radius
    public real standard_angle
    public integer count
    public boolean flag
    public real old_x
    public real old_y
    public real old_z
    public real bezier_x
    public real bezier_y
    public real bezier_z
    public string attach_point

    public static method create takes nothing returns thistype
        local thistype this = thistype.allocate()
        return this
    endmethod
    
    public method destroy takes nothing returns nothing
        if filter_group != null then
            call Group_Clear(filter_group)
        endif
        set owner = null
        set target = null
        set filter_group = null
        set is_penetrate = false
        set is_pathable = false
        set is_facing = false
        set projectile_eff = null
        set trg = null
        set eff_on_target = null
        set eff_after = null
        set attach_point = null
        call thistype.deallocate( this )
    endmethod
    
    public method Area_Dmg takes nothing returns boolean
        local group g = CreateGroup()
        local unit c
        local boolean is_exist = false
        local effect effect2
        
        call GroupEnumUnitsInRange( g, EXGetEffectX(projectile_eff), EXGetEffectY(projectile_eff), coll_size, null )
        
        // 땅에 쳐박힐 때 이펙트 터지는거
        if eff_after != null then
            set effect2 = AddSpecialEffect(eff_after, eff_x, eff_y)
            call EXSetEffectSize(effect2, eff_after_size/100)
            call DestroyEffect( effect2 )
        endif
        
        loop
        set c = FirstOfGroup(g) 
        exitwhen c == null
            call GroupRemoveUnit(g, c)
            if IsUnitAliveBJ(c) == true and IsPlayerEnemy(GetOwningPlayer(c), GetOwningPlayer(owner)) == true then
                if is_penetrate == true then
                    if IsUnitInGroup(c, filter_group) == false then
                        call GroupAddUnit(filter_group, c)
                        set is_exist = true
                        
                        call Unit_Dmg_Target( owner, c, dmg, dmg_type)
                        if eff_on_target != null then
                            call Effect_On_Unit(c, 0.0, 100, attach_point, eff_on_target, 0.0)
                        endif
                    endif
                else
                    set is_exist = true
                    call Unit_Dmg_Target( owner, c, dmg, dmg_type)
                    if eff_on_target != null then
                        call Effect_On_Unit(c, 0.0, 100, attach_point, eff_on_target, 0.0)
                    endif
                endif
            endif
        endloop
        
        call Group_Clear(g)
        
        set g = null
        set c = null
        set effect2 = null
        return is_exist
    endmethod
    
    public method Save_Old_Position takes nothing returns nothing
        set old_x = eff_x
        set old_y = eff_y
        set old_z = eff_z
    endmethod
    
    public method Facing_Direction_Vector takes nothing returns nothing
        local real d_vec_x = eff_x - old_x
        local real d_vec_y = eff_y - old_y
        local real d_vec_z = eff_z - old_z
        local real yaw = Atan2BJ(d_vec_y, d_vec_x)
        local real pitch = -Atan2BJ(d_vec_z, SquareRoot(d_vec_x*d_vec_x + d_vec_y*d_vec_y))

        call EXEffectMatReset(projectile_eff)
        call EXEffectMatRotateY(projectile_eff, pitch)
        call EXEffectMatRotateZ(projectile_eff, yaw)
        
        call Save_Old_Position()
    endmethod
endstruct


library ProjectileLibrary requires Base, Basic

globals
    Projectile last_triggering_projectile
endglobals

function Set_Effect_Euler_Angle takes effect e, real pitch, real roll, real yaw returns nothing
    call EXEffectMatReset(e)
    call EXEffectMatRotateY(e, pitch)
    call EXEffectMatRotateX(e, roll)
    call EXEffectMatRotateZ(e, yaw)
endfunction

private function Perpendicular_Projectile_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local boolean is_end = false
    local location loc
    local effect effect2
    local real x_position_value
    local real y_position_value
    local real z_position_value

    set P.elapsed_time = P.elapsed_time + 0.02
    
    set x_position_value = P.elapsed_time * ( -P.back + 0.5 * P.x_accel * P.elapsed_time )
    set y_position_value = P.elapsed_time * ( P.side - 0.5 * P.y_accel * P.elapsed_time )
    set z_position_value = P.elapsed_time * ( P.vertical - 0.5 * P.z_accel * P.elapsed_time )
    
    set P.eff_x = P.M0[0] * x_position_value + P.M0[1] * y_position_value + P.M0[2] * z_position_value + P.origin_x
    set P.eff_y = P.M1[0] * x_position_value + P.M1[1] * y_position_value + P.M1[2] * z_position_value + P.origin_y
    set P.eff_z = P.M2[0] * x_position_value + P.M2[1] * y_position_value + P.M2[2] * z_position_value + P.origin_z
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )

    set loc = Location(P.eff_x, P.eff_y)
    
    if P.eff_z <= GetLocationZ(loc) then
        set P.eff_z = GetLocationZ(loc)
        set is_end = true
    endif

    if P.is_pathable == false and IsTerrainPathable(EXGetEffectX(P.projectile_eff), EXGetEffectY(P.projectile_eff), PATHING_TYPE_WALKABILITY) == true then
        set is_end = true
        set P.eff_z = GetLocationZ(loc)
    endif
    
    call EXSetEffectZ(P.projectile_eff, P.eff_z)
    
    call P.Facing_Direction_Vector()

    if is_end == true then
        call P.Area_Dmg()
        call Timer_Clear(t)
        call DestroyEffect(P.projectile_eff)
        
        if P.trg == null then
            call P.destroy()
        else
            set last_triggering_projectile = P
            call TriggerExecute(P.trg)
        endif
    else
        call TimerStart(t, 0.02, false, function Perpendicular_Projectile_Func2)
    endif
    
    call RemoveLocation(loc)
    
    set t = null
    set loc = null
    set effect2 = null
endfunction

private function Perpendicular_Projectile_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local effect e = AddSpecialEffect(P.eff, P.eff_x, P.eff_y)
    local real end_x
    local real end_y
    local real end_z
    local real dz 
    local location loc
    
    set P.eff_z = EXGetEffectZ(e) + P.eff_height
    
    call P.Save_Old_Position()
    
    call EXSetEffectSize(e, P.eff_size/100)
    call EXEffectMatRotateZ(e, P.angle)
    call EXSetEffectZ(e, P.eff_z)
    
    set P.projectile_eff = e

    set P.origin_x = P.eff_x
    set P.origin_y = P.eff_y
    set P.origin_z = EXGetEffectZ(e)
    set end_x = Polar_X(P.origin_x, P.dist, P.angle)
    set end_y = Polar_Y(P.origin_y, P.dist, P.angle)
    
    set loc = Location(end_x, end_y)
    
    set end_z = GetLocationZ(loc)
    
    set dz = P.origin_z - end_z
    
    set P.pitch = -AtanBJ( dz/P.dist )
    
    set P.dist = SquareRoot( P.dist * P.dist + dz * dz )
    
    set P.x_accel = 2 * (P.dist + P.back * P.time) / (P.time * P.time)
    set P.y_accel = 2 * P.side / P.time
    set P.z_accel = 2 * P.vertical / P.time
    
    set P.M0[0] = CosBJ(-P.angle)*CosBJ(P.pitch)
    set P.M0[1] = SinBJ(-P.angle)
    set P.M0[2] = -CosBJ(-P.angle)*SinBJ(P.pitch)
    
    set P.M1[0] = -SinBJ(-P.angle)*CosBJ(P.pitch)
    set P.M1[1] = CosBJ(-P.angle)
    set P.M1[2] = SinBJ(-P.angle)*SinBJ(P.pitch)
    
    set P.M2[0] = SinBJ(P.pitch)
    set P.M2[1] = 0.0
    set P.M2[2] = CosBJ(P.pitch)
    
    call TimerStart(t, 0.02, false, function Perpendicular_Projectile_Func2)
    
    call RemoveLocation(loc)
    
    set t = null
    set e = null
    set loc = null
endfunction

private function Bezier_Like_Projectile_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local boolean is_end = false
    local location loc
    local effect effect2
    local real x_unit_dist
    local real y_unit_dist

    set P.elapsed_time = P.elapsed_time + 0.02
    
    set x_unit_dist = -P.back / 50 + P.x_accel * P.elapsed_time / 50
    set y_unit_dist = P.side / 50 - P.y_accel * P.elapsed_time / 50
    
    set P.eff_x = Polar_X(EXGetEffectX(P.projectile_eff), x_unit_dist, P.angle)
    set P.eff_y = Polar_Y(EXGetEffectY(P.projectile_eff), x_unit_dist, P.angle)
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )
    
    set P.eff_x = Polar_X(EXGetEffectX(P.projectile_eff), y_unit_dist, P.angle + 90)
    set P.eff_y = Polar_Y(EXGetEffectY(P.projectile_eff), y_unit_dist, P.angle + 90)
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )
    
    set loc = Location(P.eff_x, P.eff_y)
    
    set P.eff_z = P.eff_height + P.elapsed_time * ( P.vertical - 0.5 * P.z_accel * P.elapsed_time )
    
    if P.eff_z <= GetLocationZ(loc) then
        set P.eff_z = GetLocationZ(loc)
        set is_end = true
    endif

    if P.is_pathable == false and IsTerrainPathable(EXGetEffectX(P.projectile_eff), EXGetEffectY(P.projectile_eff), PATHING_TYPE_WALKABILITY) == true then
        set is_end = true
        set P.eff_z = GetLocationZ(loc)
    endif
    
    call EXSetEffectZ(P.projectile_eff, P.eff_z)
    
    call P.Facing_Direction_Vector()

    if is_end == true then
        call P.Area_Dmg()
        call Timer_Clear(t)
        call DestroyEffect(P.projectile_eff)
        
        if P.trg == null then
            call P.destroy()
        else
            set last_triggering_projectile = P
            call TriggerExecute(P.trg)
        endif
    else
        call TimerStart(t, 0.02, false, function Bezier_Like_Projectile_Func2)
    endif
    
    call RemoveLocation(loc)
    
    set t = null
    set loc = null
    set effect2 = null
endfunction

private function Bezier_Like_Projectile_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local effect e = AddSpecialEffect(P.eff, P.eff_x, P.eff_y)
    
    set P.eff_z = EXGetEffectZ(e) + P.eff_height
    
    call P.Save_Old_Position()
    
    call EXSetEffectSize(e, P.eff_size/100)
    call EXEffectMatRotateZ(e, P.angle)
    call EXSetEffectZ(e, P.eff_z)
    
    set P.projectile_eff = e
    set P.x_accel = 2 * (P.dist + P.back * P.time) / (P.time * P.time)
    set P.y_accel = 2 * P.side / P.time
    set P.z_accel = 2 * (P.eff_height + P.vertical * P.time) / (P.time * P.time)
    
    call TimerStart(t, 0.02, false, function Bezier_Like_Projectile_Func2)
    
    set t = null
    set e = null
endfunction

private function Generic_Parabolic_Projectile_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local boolean is_end = false
    local location loc

    set P.time = P.time + 0.02
    set P.eff_x = Polar_X(EXGetEffectX(P.projectile_eff), P.unit_dist, P.angle)
    set P.eff_y = Polar_Y(EXGetEffectY(P.projectile_eff), P.unit_dist, P.angle)
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )
    
    set loc = Location(P.eff_x, P.eff_y)
    
    set P.eff_z = P.eff_height + P.time * ( P.z_velocity - 0.5 * P.gravity * P.time )
    
    if P.eff_z <= GetLocationZ(loc) then
        set P.eff_z = GetLocationZ(loc)
        set is_end = true
    endif

    if P.is_pathable == false and IsTerrainPathable(EXGetEffectX(P.projectile_eff), EXGetEffectY(P.projectile_eff), PATHING_TYPE_WALKABILITY) == true then
        set is_end = true
        set P.eff_z = GetLocationZ(loc)
    endif
    
    call EXSetEffectZ(P.projectile_eff, P.eff_z)
    
    call P.Facing_Direction_Vector()

    if is_end == true then
        call P.Area_Dmg()
        call Timer_Clear(t)
        call DestroyEffect(P.projectile_eff)
        
        if P.trg == null then
            call P.destroy()
        else
            set last_triggering_projectile = P
            call TriggerExecute(P.trg)
        endif
    else
        call TimerStart(t, 0.02, false, function Generic_Parabolic_Projectile_Func2)
    endif
    
    call RemoveLocation(loc)
    
    set t = null
    set loc = null
endfunction

private function Generic_Parabolic_Projectile_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local effect e = AddSpecialEffect(P.eff, P.eff_x, P.eff_y)
    
    set P.eff_z = EXGetEffectZ(e) + P.eff_height
    
    call P.Save_Old_Position()
    
    call EXSetEffectSize(e, P.eff_size/100)
    call EXEffectMatRotateZ(e, P.angle)
    call EXSetEffectZ(e, P.eff_z)

    set P.projectile_eff = e
    
    call TimerStart(t, 0.02, false, function Generic_Parabolic_Projectile_Func2)
    
    set t = null
    set e = null
endfunction

private function Simple_Projectile_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local boolean is_end = false
    local boolean is_exist = false
    
    set P.time = P.time - 0.02
    set P.eff_x = Polar_X(EXGetEffectX(P.projectile_eff), P.unit_dist, P.angle)
    set P.eff_y = Polar_Y(EXGetEffectY(P.projectile_eff), P.unit_dist, P.angle)
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )

    set is_exist = P.Area_Dmg()
    
    if P.time <= 0.0001 then
        set is_end = true
    endif
    
    if P.is_penetrate == false and is_exist == true then
        set is_end = true
    endif
    
    if P.is_pathable == false and IsTerrainPathable(EXGetEffectX(P.projectile_eff), EXGetEffectY(P.projectile_eff), PATHING_TYPE_WALKABILITY) == true then
        set is_end = true
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call DestroyEffect(P.projectile_eff)
        
        if P.trg == null then
            call P.destroy()
        else
            set last_triggering_projectile = P
            call TriggerExecute(P.trg)
        endif
    else
        call TimerStart(t, 0.02, false, function Simple_Projectile_Func2)
    endif
    
    set t = null
endfunction

private function Simple_Projectile_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local effect e = AddSpecialEffect(P.eff, P.eff_x, P.eff_y)
    
    if P.is_facing == true then
        set P.angle = GetUnitFacing(P.owner) + P.angle
    endif
    
    call EXSetEffectSize(e, P.eff_size/100)
    call EXEffectMatRotateZ(e, P.angle)
    call EXSetEffectZ(e, EXGetEffectZ(e) + P.eff_height)

    set P.projectile_eff = e
    
    call TimerStart(t, 0.02, false, function Simple_Projectile_Func2)
    
    set t = null
    set e = null
endfunction

private function Guided_Projectile_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local boolean is_end = false
    local real r
    local location loc
    
    if P.flag == true and RAbsBJ(P.angle) >= 90 then
        set P.count = P.count - 1
        set P.flag = not P.flag
        set P.angle = 270
        call P.Area_Dmg()
    elseif P.flag == false and RAbsBJ(P.angle) <= 180 then
        set P.count = P.count - 1
        set P.flag = not P.flag
        set P.angle = 0
        call P.Area_Dmg()
    endif

    if P.flag == true then
        set P.angle = P.angle + 90.0/(50.0 * P.time)
        set r = P.radius * SinBJ(2 * P.angle)
    else
        set P.angle = P.angle - 90.0/(50.0 * P.time)
        set r = P.radius * SinBJ(2 * P.angle)
    endif
    
    set P.eff_x = Polar_X(GetUnitX(P.target), r, P.angle + P.standard_angle)
    set P.eff_y = Polar_Y(GetUnitY(P.target), r, P.angle + P.standard_angle)
    
    set loc = Location(P.eff_x, P.eff_y)
    
    set P.eff_z = P.height * RAbsBJ( SinBJ(2 * P.angle) ) + P.eff_height + GetLocationZ(loc)
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )
    call EXSetEffectZ(P.projectile_eff, P.eff_z)
    
    call P.Facing_Direction_Vector()

    //set is_exist = P.Area_Dmg()
    
    if P.count <= 0 then
        set is_end = true
    endif
    
    if IsUnitAliveBJ(P.target) == false then
        set is_end = true
    endif
    
    if P.is_pathable == false and IsTerrainPathable(EXGetEffectX(P.projectile_eff), EXGetEffectY(P.projectile_eff), PATHING_TYPE_WALKABILITY) == true then
        set is_end = true
    endif
    
    if is_end == true then
        call Timer_Clear(t)
        call DestroyEffect(P.projectile_eff)
        
        if P.trg == null then
            call P.destroy()
        else
            set last_triggering_projectile = P
            call TriggerExecute(P.trg)
        endif
    else
        call TimerStart(t, 0.02, false, function Guided_Projectile_Func2)
    endif
    
    call RemoveLocation(loc)
    
    set t = null
    set loc = null
endfunction

private function Guided_Projectile_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local effect e = AddSpecialEffect(P.eff, P.eff_x, P.eff_y)
    
    set P.eff_z = EXGetEffectZ(e) + P.eff_height
    
    call P.Save_Old_Position()
    
    call EXSetEffectSize(e, P.eff_size/100)
    call EXEffectMatRotateZ(e, P.angle)
    call EXSetEffectZ(e, P.eff_z)
    
    set P.projectile_eff = e
    
    call TimerStart(t, 0.02, false, function Guided_Projectile_Func2)
    
    set t = null
    set e = null
endfunction

private function Bezier_Guided_Projectile_Func2 takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local boolean is_end = false
    local location loc
    local real normalized_t


    set P.elapsed_time = P.elapsed_time + 0.02
    
    set normalized_t = P.elapsed_time / P.time
    
    set loc = Location(GetUnitX(P.target), GetUnitY(P.target))
    
    set P.eff_x = (1 - normalized_t)*(1 - normalized_t)*P.origin_x + 2*(1 - normalized_t)*normalized_t*P.bezier_x + normalized_t*normalized_t*GetUnitX(P.target)
    set P.eff_y = (1 - normalized_t)*(1 - normalized_t)*P.origin_y + 2*(1 - normalized_t)*normalized_t*P.bezier_y + normalized_t*normalized_t*GetUnitY(P.target)
    set P.eff_z = (1 - normalized_t)*(1 - normalized_t)*P.origin_z + 2*(1 - normalized_t)*normalized_t*P.bezier_z + normalized_t*normalized_t*GetLocationZ(loc)
    
    call EXSetEffectXY(P.projectile_eff, P.eff_x, P.eff_y )
    
    call RemoveLocation(loc)
    
    set loc = Location(P.eff_x, P.eff_y)
    
    if P.eff_z <= GetLocationZ(loc) then
        set P.eff_z = GetLocationZ(loc)
        set is_end = true
    endif

    if P.is_pathable == false and IsTerrainPathable(EXGetEffectX(P.projectile_eff), EXGetEffectY(P.projectile_eff), PATHING_TYPE_WALKABILITY) == true then
        set is_end = true
        set P.eff_z = GetLocationZ(loc)
    endif
    
    call EXSetEffectZ(P.projectile_eff, P.eff_z)
    
    call P.Facing_Direction_Vector()

    if is_end == true then
        call P.Area_Dmg()
        call Timer_Clear(t)
        call DestroyEffect(P.projectile_eff)
        
        if P.trg == null then
            call P.destroy()
        else
            set last_triggering_projectile = P
            call TriggerExecute(P.trg)
        endif
    else
        call TimerStart(t, 0.02, false, function Bezier_Guided_Projectile_Func2)
    endif
    
    call RemoveLocation(loc)
    
    set t = null
    set loc = null
endfunction

private function Bezier_Guided_Projectile_Func takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local integer id = GetHandleId(t)
    local Projectile P = LoadInteger(HT, id, 0)
    local effect e = AddSpecialEffect(P.eff, P.eff_x, P.eff_y)
    local real vec_x
    local real vec_y
    local real vec2_x
    local real vec2_y
    local real normalize
    
    set P.eff_z = EXGetEffectZ(e) + P.eff_height
    
    call P.Save_Old_Position()
    
    call EXSetEffectSize(e, P.eff_size/100)
    call EXEffectMatRotateZ(e, P.angle)
    call EXSetEffectZ(e, P.eff_z)
    
    set P.origin_x = P.eff_x
    set P.origin_y = P.eff_y
    set P.origin_z = P.eff_z
    
    set vec_x = GetUnitX(P.target) - P.origin_x
    set vec_y = GetUnitY(P.target) - P.origin_y

    set normalize = SquareRoot( (vec_x * vec_x) + (vec_y * vec_y) ) 
    
    set vec_x = vec_x / normalize
    set vec_y = vec_y / normalize
    
    set vec2_x = vec_y
    set vec2_y = -vec_x
    
    set P.bezier_x = P.origin_x + P.front * vec_x + P.side * vec2_x
    set P.bezier_y = P.origin_y + P.front * vec_y + P.side * vec2_y
    set P.bezier_z = P.origin_z + P.vertical
    
    set P.projectile_eff = e
    
    call TimerStart(t, 0.02, false, function Bezier_Guided_Projectile_Func2)
    
    set t = null
    set e = null
endfunction

// =============================================================================
// API
// =============================================================================

function Bezier_Guided_Projectile takes unit u, unit target, real x, real y, real dmg, real coll_size, boolean dmg_type, real time, real front, real side, real vertical, /*
*/string eff, real eff_size, real eff_height, boolean is_pathable, string eff_after, real eff_after_size, trigger trg, real delay returns Projectile
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local Projectile P = Projectile.create()

    set P.owner = u
    set P.target = target
    set P.eff_x = x
    set P.eff_y = y
    set P.dmg = dmg
    set P.coll_size = coll_size
    set P.dmg_type = dmg_type
    set P.time = time
    set P.front = front
    set P.side = side
    set P.vertical = vertical
    set P.eff = eff
    set P.eff_size = eff_size
    set P.eff_height = eff_height
    set P.is_pathable = is_pathable
    set P.eff_after = eff_after
    set P.eff_after_size = eff_after_size
    set P.trg = trg
    set P.elapsed_time = 0
    
    if time <= 0.0001 then
        set P.time = 0.01
    endif
    
    call SaveInteger(HT, id, 0, P)
    call TimerStart(t, delay, false, function Bezier_Guided_Projectile_Func)
    
    set t = null
    
    return P
endfunction


function Guided_Projectile takes unit u, unit target, real x, real y, real dmg, real coll_size, real time, real radius, real height, real angle, integer count,/*
*/ string eff, real eff_size, real eff_height, boolean is_pathable, string eff_after, real eff_after_size, trigger trg, real delay returns Projectile
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local Projectile P = Projectile.create()

    set P.owner = u
    set P.target = target
    set P.eff_x = x
    set P.eff_y = y
    set P.dmg = dmg
    set P.coll_size = coll_size
    set P.time = time
    set P.radius = radius
    set P.height = height
    set P.standard_angle = angle
    set P.count = count
    set P.eff = eff
    set P.eff_size = eff_size
    set P.eff_height = eff_height
    set P.is_pathable = is_pathable
    set P.eff_after = eff_after
    set P.eff_after_size = eff_after_size
    set P.trg = trg
    set P.elapsed_time = 0
    set P.flag = false
    set P.is_penetrate = false
    
    if time <= 0.0001 then
        set P.time = 0.01
    endif
    
    call SaveInteger(HT, id, 0, P)
    call TimerStart(t, delay, false, function Guided_Projectile_Func)
    
    set t = null
    
    return P
endfunction

function Perpendicular_Projectile takes unit u, real x, real y, real dmg, real coll_size, boolean dmg_type, real time, real back, real side, real vertical, /*
*/real dist, real angle, string eff, real eff_size, real eff_height, boolean is_pathable, string eff_after, real eff_after_size, trigger trg, real delay returns Projectile
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local Projectile P = Projectile.create()

    set P.owner = u
    set P.eff_x = x
    set P.eff_y = y
    set P.dmg = dmg
    set P.coll_size = coll_size
    set P.dmg_type = dmg_type
    set P.time = time
    set P.back = back
    set P.side = side
    set P.vertical = vertical
    set P.dist = dist
    set P.angle = angle
    set P.eff = eff
    set P.eff_size = eff_size
    set P.eff_height = eff_height
    set P.is_pathable = is_pathable
    set P.eff_after = eff_after
    set P.eff_after_size = eff_after_size
    set P.trg = trg
    set P.elapsed_time = 0
    
    if time <= 0.0001 then
        set P.time = 0.01
    endif
    
    call SaveInteger(HT, id, 0, P)
    call TimerStart(t, delay, false, function Perpendicular_Projectile_Func)
    
    set t = null
    
    return P
endfunction

function Bezier_Like_Projectile takes unit u, real x, real y, real dmg, real coll_size, boolean dmg_type, real time, real back, real side, real vertical, /*
*/real dist, real angle, string eff, real eff_size, real eff_height, boolean is_pathable, string eff_after, real eff_after_size, trigger trg, real delay returns Projectile
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local Projectile P = Projectile.create()

    set P.owner = u
    set P.eff_x = x
    set P.eff_y = y
    set P.dmg = dmg
    set P.coll_size = coll_size
    set P.dmg_type = dmg_type
    set P.time = time
    set P.back = back
    set P.side = side
    set P.vertical = vertical
    set P.dist = dist
    set P.angle = angle
    set P.eff = eff
    set P.eff_size = eff_size
    set P.eff_height = eff_height
    set P.is_pathable = is_pathable
    set P.eff_after = eff_after
    set P.eff_after_size = eff_after_size
    set P.trg = trg
    set P.elapsed_time = 0
    
    if time <= 0.0001 then
        set P.time = 0.01
    endif
    
    call SaveInteger(HT, id, 0, P)
    call TimerStart(t, delay, false, function Bezier_Like_Projectile_Func)
    
    set t = null
    
    return P
endfunction

// z0 을 다룬다, 좀더 제너릭한 함수, 직선으로 내리 꽂히는 투사체도 표현 가능
// 포물선 투사체
// 속력은 1초당 가는 거리로 정의
// is_pathable -> true이면 심연 뚫고감, false 면 못 건너가고 터짐
// eff_after -> 투사체 땅에서 터졌을 때 추가로 더할 이펙트, 안쓸꺼면 null (중요)
// trg -> 투사체 땅에 터졌을 때 실행시킬 트리거, 안쓸꺼면 null (중요)
function Generic_Parabolic_Projectile takes unit u, real x, real y, real dmg, real coll_size, boolean dmg_type, real velocity, real dist, real angle, /*
*/real gravity, string eff, real eff_size, real eff_height, boolean is_pathable, string eff_after, real eff_after_size, trigger trg, real delay returns Projectile
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local Projectile P = Projectile.create()

    set P.owner = u
    set P.eff_x = x
    set P.eff_y = y
    set P.dmg = dmg
    set P.coll_size = coll_size
    set P.dmg_type = dmg_type
    set P.velocity = velocity
    set P.dist = dist
    set P.unit_dist = velocity / 50
    set P.angle = angle
    set P.eff = eff
    set P.eff_size = eff_size
    set P.eff_height = eff_height
    set P.is_pathable = is_pathable
    set P.eff_after = eff_after
    set P.trg = trg
    set P.time = 0.0
    set P.z_velocity = 0.5 * gravity * (dist/velocity) - ( eff_height / (dist/velocity) )
    set P.eff_after_size = eff_after_size
    set P.gravity = gravity
    
    call SaveInteger(HT, id, 0, P)
    call TimerStart(t, delay, false, function Generic_Parabolic_Projectile_Func)
    
    set t = null
    
    return P
endfunction

// dist / time -> dist/s, 이걸 50으로 또 나누면 0.02초마다 얼마나 가야하는지 나옴
// is_penetrate -> 적 관통하는지 아니면 그냥 단발로 끝날건지
// is_pathable -> true이면 심연 뚫고감, false 면 못 건너가고 터짐
// eff_on_target -> 데미지 줄때 chest부분에 추가 이펙 넣을건지?, 안쓸꺼면 null
// trg -> 충돌 판정시 실행시킬 트리거, 안쓸꺼면 null (중요)
// is_facing == true 이면 angle 은 add angle 로 작동
function Generic_Projectile takes unit u, real x, real y, real dmg, real coll_size, boolean dmg_type, real time, real velocity, real angle, /*
*/ string eff, real eff_size, real eff_height, boolean is_penetrate, boolean is_pathable, boolean is_facing, string eff_on_target, string attach_point, trigger trg, real delay returns Projectile
    local timer t = CreateTimer()
    local integer id = GetHandleId(t)
    local Projectile P = Projectile.create()

    set P.owner = u
    set P.eff_x = x
    set P.eff_y = y
    set P.dmg = dmg
    set P.coll_size = coll_size
    set P.dmg_type = dmg_type
    set P.time = time
    set P.velocity = velocity
    set P.unit_dist = velocity / 50
    set P.angle = angle
    set P.eff = eff
    set P.eff_size = eff_size
    set P.eff_height = eff_height
    set P.is_penetrate = is_penetrate
    set P.is_pathable = is_pathable
    set P.eff_on_target = eff_on_target
    set P.trg = trg
    set P.is_facing = is_facing
    set P.attach_point = attach_point
    
    if P.is_penetrate == true then
        set P.filter_group = CreateGroup()
    endif
    
    call SaveInteger(HT, id, 0, P)
    call TimerStart(t, delay, false, function Simple_Projectile_Func)
    
    set t = null
    
    return P
endfunction

endlibrary