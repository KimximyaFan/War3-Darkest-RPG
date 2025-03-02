struct Shield
    
    /*
        유닛
        지속시간
        쉴드량
        텍스트태그 (쉴드 총량)
        쉴드총량 갱신 
        지속시간 끝날 시 쉴드 파괴
        쉴드 소모시 기왕이면 remaining time 제일 낮은 쉴드
        데미지 시스템과 연계
        쉴드 이펙트, 부착포인트
    */
    private static real shield_texttag_x = 30
    private static real shield_texttag_y = 15
    private static real texttag_size = 6.5
    private static real timer_interval = 0.02
    
    private unit u
    private real duration
    private real remaining_time
    private real shield_value
    private texttag text_tag
    private effect e
    private string eff
    private string attach_point
    private Shield before_shield
    private Shield next_shield
    private boolean is_broken
    
    // =======================================================
    // Private
    // =======================================================

    private static method create takes nothing returns thistype
        local thistype this = thistype.allocate()
        return this
    endmethod
    
    private method destroy takes nothing returns nothing
        local Shield root_shield = Get_Unit_Property(u, SHIELD_SYSTEM)
        
        if before_shield != -1 then
            set before_shield.next_shield = next_shield
        endif
        
        if next_shield != -1 then
            set next_shield.before_shield = before_shield
        endif
        
        if this == root_shield then
            call End_Text_Tag()
            call End_Effect()
            
            if next_shield == -1 then
                call RemoveSavedInteger(HT, GetHandleId(u), SHIELD_SYSTEM)
            else
                call Set_Unit_Property(u, SHIELD_SYSTEM, next_shield)
                call next_shield.Start_Text_Tag()
                call next_shield.Start_Effect()
            endif
        endif
        
        set u = null
        set e = null
        set eff = null
        set attach_point = null
        set text_tag = null
        set before_shield = -1
        set next_shield = -1
        call thistype.deallocate( this )
    endmethod
    
    private method Get_Total_Shield_Value takes nothing returns real
        local Shield root_shield = Get_Unit_Property(u, SHIELD_SYSTEM)
        local Shield current_shield = root_shield
        local real total_shield_value = 0.0
        
        loop
        exitwhen current_shield == -1
            if current_shield.is_broken == false then
                set total_shield_value = total_shield_value + current_shield.shield_value
            endif
            set current_shield = current_shield.next_shield
        endloop
        
        return total_shield_value
    endmethod
    
    private method Get_Min_Remaining_Time_Shield takes nothing returns Shield
        local Shield root_shield = Get_Unit_Property(u, SHIELD_SYSTEM)
        local Shield current_shield = root_shield
        local Shield min_remaining_time_shield = -1
        local real min_remaining_time = 1000000.0

        loop
        exitwhen current_shield == -1
            if current_shield.remaining_time < min_remaining_time and current_shield.is_broken == false then
                set min_remaining_time_shield = current_shield
            endif
            
            set current_shield = current_shield.next_shield
        endloop
        
        return min_remaining_time_shield
    endmethod
    
    private method Text_Tag_Refresh takes nothing returns nothing
        if text_tag == null then
            return
        endif

        call SetTextTagText(text_tag, R2S(Get_Total_Shield_Value()), TextTagSize2Height(texttag_size))
        call SetTextTagPos(text_tag, GetUnitX(u) + shield_texttag_x, GetUnitY(u), shield_texttag_y)
    endmethod

    private method Start_Text_Tag takes nothing returns nothing
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        set text_tag = Text_Tag(x + shield_texttag_x, y, 200, 200, 255, texttag_size, shield_texttag_y, 0, 0, 255, -1, -1, R2S(Get_Total_Shield_Value()), null, -1, 0.0)
    endmethod
    
    private method End_Text_Tag takes nothing returns nothing
        call DestroyTextTag(text_tag)
        set text_tag = null
    endmethod
    
    private method Start_Effect takes nothing returns nothing
        set e = AddSpecialEffectTarget(eff, u, attach_point)
    endmethod
    
    private method End_Effect takes nothing returns nothing
        call DestroyEffect(e)
    endmethod
    
    private method Shield_Broken takes nothing returns nothing
        set is_broken = true
    endmethod
    
    private method Shield_Damage_Process takes real dmg returns real
        local Shield current_shield
        
        loop
        set current_shield = Get_Min_Remaining_Time_Shield()
        exitwhen dmg <= 0.0 or current_shield == -1
            if dmg >= current_shield.shield_value then
                set dmg = dmg - current_shield.shield_value
                set current_shield.shield_value = 0.0
                call current_shield.Shield_Broken()
            else
                set current_shield.shield_value = current_shield.shield_value - dmg
                set dmg = 0.0
            endif
        endloop

        return dmg
    endmethod
    
    private static method Shield_State_Check takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local Shield current_shield = LoadInteger(HT, id, 0)
        
        set current_shield.remaining_time = current_shield.remaining_time - timer_interval
        
        call current_shield.Text_Tag_Refresh()
        
        if current_shield.remaining_time <= 0.0 then
            set current_shield.is_broken = true
        endif
        
        if current_shield.is_broken == true then
            call Timer_Clear(t)
            call current_shield.destroy()
        else
            call TimerStart(t, timer_interval, false, function Shield.Shield_State_Check)
        endif
        
        set t = null
    endmethod
    
    private method Apply_Shield takes nothing returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        local Shield current_shield = this
        
        call current_shield.Start_Text_Tag()
        call current_shield.Start_Effect()
        
        call SaveInteger(HT, id, 0, current_shield)
        call TimerStart(t, timer_interval, false, function Shield.Shield_State_Check)
        
        set t = null
    endmethod
    
    // ==================================
    // Public
    // ==================================
    
    public static method Damage_Occured takes unit u, real dmg returns real
        local Shield root_shield
        local real remaining_dmg
        
        if HaveSavedInteger(HT, GetHandleId(u), SHIELD_SYSTEM) == false then
            return dmg
        endif
        
        set root_shield = Get_Unit_Property(u, SHIELD_SYSTEM)
        set remaining_dmg = root_shield.Shield_Damage_Process(dmg)
        return remaining_dmg
    endmethod
    
    public static method Register_Shield takes unit u, real duration, real shield_value, string eff, string attach_point returns nothing
        local Shield current_shield = thistype.create()
        local Shield root_shield
        
        if shield_value <= 0.0 then
            set shield_value = 0.1
        endif
        
        set current_shield.u = u
        set current_shield.duration = duration
        set current_shield.remaining_time = duration
        set current_shield.shield_value = shield_value
        set current_shield.eff = eff
        set current_shield.attach_point = attach_point
        set current_shield.before_shield = -1
        set current_shield.next_shield = -1
        set current_shield.is_broken = false
        
        if HaveSavedInteger(HT, GetHandleId(u), SHIELD_SYSTEM) == true then
            set root_shield = Get_Unit_Property(u, SHIELD_SYSTEM)
            set current_shield.next_shield = root_shield
            set root_shield.before_shield = current_shield
            call root_shield.End_Text_Tag()
            call root_shield.End_Effect()
        endif
        
        call Set_Unit_Property(u, SHIELD_SYSTEM, current_shield)
        
        call current_shield.Apply_Shield()
    endmethod
endstruct


library ShieldSystem

function Unit_Add_Shield takes unit target, real duration, real shield_value, string eff, string attach_point returns nothing
    call Shield.Register_Shield(target, duration, shield_value, eff, attach_point)
endfunction

function Unit_Add_Shield_Area takes unit u, real x, real y, real size, real duration, real shield_value, string eff, string attach_point returns nothing
    local group g = CreateGroup()
    local unit c = null
    
    call GroupEnumUnitsInRange(g, x, y, size, null)
    loop
    set c = FirstOfGroup(g) 
    exitwhen c == null
        call GroupRemoveUnit(g, c)
        if IsUnitAliveBJ(c) == true and IsPlayerAlly(GetOwningPlayer(c), GetOwningPlayer(u)) == true then
            call Shield.Register_Shield(c, duration, shield_value, eff, attach_point)
        endif
    endloop

    call GroupClear(g)
    call DestroyGroup(g)
    set g = null
    set c = null
endfunction

endlibrary