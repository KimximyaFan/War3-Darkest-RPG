struct Hero
    // Property
    private integer ad /* 공격력 */
    private integer ap /* 주문력 */
    private integer as /* 공격속도 */
    private integer ms /* 이동속도 */
    private integer crit /* 치확 */
    private integer crit_coef /* 치피 */
    private integer def_ad /* 물리 방어력 */
    private integer def_ap /* 마법 방어력 */ 
    private integer hp /* 체력 */
    private integer mp /* 마나 */
    private integer hp_regen /* 체력회복 */
    private integer mp_regen /* 마나회복 */
    private integer enhance_ad /* 물리 피해 강화 */
    private integer enhance_ap /* 마법 피해 강화 */
    private integer reduce_ad /* 물리 받피감 */
    private integer reduce_ap /* 마법 받피감 */
    private integer level /* 영웅 레벨 */
    private integer level_up_value /* ad ap 증가용 */
    
    private integer increase_ad
    private integer increase_ap
    private integer increase_as
    private integer increase_ms
    private integer increase_hp
    private integer increase_mp
    private integer increase_def_ad
    private integer increase_def_ap
    private integer increase_hp_regen
    private integer increase_mp_regen
    
    private integer stat_point
    
    private boolean array wearing_exist[10]
    private boolean array inven_exist[25]
    
    private unit hero_unit
    private real unit_base_as
    private real unit_base_ms
    
    public HeroWearing wearings
    public HeroInven inventory
    
    // Behavior
    public static method create takes nothing returns thistype
        local integer i
        local thistype this = thistype.allocate()
        
        set i = -1
        loop
        set i = i + 1
        exitwhen i > 9
            set wearing_exist[i] = false
        endloop
        
        set i = -1
        loop
        set i = i + 1
        exitwhen i > 24
            set inven_exist[i] = false
        endloop
        
        set this.wearings = HeroWearing.create()
        set this.inventory = HeroInven.create()
        set this.level = 1
        return this
    endmethod
        
    method destroy takes nothing returns nothing
        call thistype.deallocate( this )
    endmethod
    
    public method Get_Hero_Unit takes nothing returns unit
        return this.hero_unit
    endmethod
    
    public method Get_AD takes nothing returns integer
        return Get_Unit_Property(hero_unit, AD)
    endmethod
    
    public method Get_AP takes nothing returns integer
        return Get_Unit_Property(hero_unit, AP)
    endmethod
    
    public method Get_AS takes nothing returns integer
        return Get_Unit_Property(hero_unit, AS)
    endmethod
    
    public method Get_MS takes nothing returns integer
        return Get_Unit_Property(hero_unit, MS)
    endmethod
    
    public method Get_CRIT takes nothing returns integer
        return Get_Unit_Property(hero_unit, CRIT)
    endmethod
    
    public method Get_CRIT_COEF takes nothing returns integer
        return Get_Unit_Property(hero_unit, CRIT_COEF)
    endmethod
    
    public method Get_DEF_AD takes nothing returns integer
        return Get_Unit_Property(hero_unit, DEF_AD)
    endmethod
    
    public method Get_DEF_AP takes nothing returns integer
        return Get_Unit_Property(hero_unit, DEF_AP)
    endmethod
    
    public method Get_HP takes nothing returns integer
        return Get_Unit_Property(hero_unit, HP)
    endmethod
    
    public method Get_MP takes nothing returns integer
        return Get_Unit_Property(hero_unit, MP)
    endmethod
    
    public method Get_HP_REGEN takes nothing returns integer
        return Get_Unit_Property(hero_unit, HP_REGEN)
    endmethod
    
    public method Get_MP_REGEN takes nothing returns integer
        return Get_Unit_Property(hero_unit, MP_REGEN)
    endmethod
    
    public method Get_ENHANCE_AD takes nothing returns integer
        return Get_Unit_Property(hero_unit, ENHANCE_AD)
    endmethod
    
    public method Get_ENHANCE_AP takes nothing returns integer
        return Get_Unit_Property(hero_unit, ENHANCE_AP)
    endmethod
    
    public method Get_REDUCE_AD takes nothing returns integer
        return Get_Unit_Property(hero_unit, REDUCE_AD)
    endmethod
    
    public method Get_REDUCE_AP takes nothing returns integer
        return Get_Unit_Property(hero_unit, REDUCE_AP)
    endmethod
    
    public method Get_Level takes nothing returns integer
        return this.level
    endmethod
    
    public method Get_Level_Up_Value takes nothing returns integer
        return this.level_up_value
    endmethod
    
    // ===================================================================
    
    public method Set_Hero_Unit takes unit u returns nothing
        call SaveReal( HT, GetHandleId(u), ATTACK_COOLDOWN, JNGetUnitAttackCooldown(u, 1) )
        call Set_Unit_Property( u, AD, 0 )
        call Set_Unit_Property( u, AP, 0 )
        call Set_Unit_Property( u, AS, 0 )
        call Set_Unit_Property( u, MS, R2I(GetUnitMoveSpeed(u) + 0.001) )
        call Set_Unit_Property( u, CRIT, 0 )
        call Set_Unit_Property( u, CRIT_COEF, 0 )
        call Set_Unit_Property( u, ENHANCE_AD, 0 )
        call Set_Unit_Property( u, ENHANCE_AP, 0 )
        call Set_Unit_Property( u, DEF_AD, 0 )
        call Set_Unit_Property( u, DEF_AP, 0 )
        call Set_Unit_Property( u, HP, R2I(JNGetUnitHP(u) + 0.001) )
        call Set_Unit_Property( u, MP, R2I(JNGetUnitMana(u) + 0.001) )
        call Set_Unit_Property( u, HP_REGEN, 1 )
        call Set_Unit_Property( u, MP_REGEN, 1 )
        call Set_Unit_Property( u, REDUCE_AD, 0 )
        call Set_Unit_Property( u, REDUCE_AP, 0 )
        set this.hero_unit = u
        set this.unit_base_as = JNGetUnitAttackCooldown(u, 1)
        set this.ms = Get_Unit_Property(u, MS)
        set this.hp = Get_Unit_Property(u, HP)
        set this.mp = Get_Unit_Property(u, MP)
        set this.hp_regen = 1
        set this.mp_regen = 1
        set increase_ad = 0
        set increase_ap = 0
        set increase_as = 0
        set increase_ms = 0
        set increase_hp = 0
        set increase_mp = 0
        set increase_def_ad = 0
        set increase_def_ap = 0
        set increase_hp_regen = 0
        set increase_mp_regen = 0
        call SaveInteger(HT, GetHandleId(u), HERO, this)
    endmethod
    
    public method Set_AD takes integer a returns nothing
        call Set_Unit_Property( hero_unit, AD, a )
    endmethod
    
    public method Set_AP takes integer a returns nothing
        call Set_Unit_Property( hero_unit, AP, a )
    endmethod
    
    public method Set_AS takes integer a returns nothing
        call Set_Unit_Property( hero_unit, AS, a )
    endmethod
    
    public method Set_MS takes integer a returns nothing
        call Set_Unit_Property( hero_unit, MS, a )
    endmethod

    public method Set_CRIT takes integer a returns nothing
        call Set_Unit_Property( hero_unit, CRIT, a )
    endmethod
    
    public method Set_CRIT_COEF takes integer a returns nothing
        call Set_Unit_Property( hero_unit, CRIT_COEF, a )
    endmethod
    
    public method Set_DEF_AD takes integer a returns nothing
        call Set_Unit_Property( hero_unit, DEF_AD, a )
    endmethod
    
    public method Set_DEF_AP takes integer a returns nothing
        call Set_Unit_Property( hero_unit, DEF_AP, a)
    endmethod
    
    public method Set_HP takes integer a returns nothing
        call Set_Unit_Property( hero_unit, HP, a )
    endmethod
    
    public method Set_MP takes integer a returns nothing
        call Set_Unit_Property( hero_unit, MP, a )
    endmethod
    
    public method Set_HP_REGEN takes integer a returns nothing
        call Set_Unit_Property( hero_unit, HP_REGEN, a )
    endmethod
    
    public method Set_MP_REGEN takes integer a returns nothing
        call Set_Unit_Property( hero_unit, MP_REGEN, a )
    endmethod

    public method Set_ENHANCE_AD takes integer a returns nothing
        call Set_Unit_Property( hero_unit, ENHANCE_AD, a )
    endmethod
    
    public method Set_ENHANCE_AP takes integer a returns nothing
        call Set_Unit_Property( hero_unit, ENHANCE_AP, a )
    endmethod
    
    public method Set_REDUCE_AD takes integer a returns nothing
        call Set_Unit_Property( hero_unit, REDUCE_AD, a )
    endmethod
    
    public method Set_REDUCE_AP takes integer a returns nothing
        call Set_Unit_Property( hero_unit, REDUCE_AP, a )
    endmethod
    
    public method Set_Level takes integer value returns nothing
        set this.level = value
    endmethod
    
    public method Set_Level_Up_Value takes integer value returns nothing
        set this.level_up_value = value
    endmethod
    
    // ====================================================================
    
    private method Item_Unequiped takes Equip E returns nothing
        local unit u = this.Get_Hero_Unit()
        
        if E.Get_AD() != 0 then
            call Set_AD( Get_Unit_Property(u, AD) - E.Get_AD() )
        endif
        if E.Get_AP() != 0 then
            call Set_AP( Get_Unit_Property(u, AP) - E.Get_AP() )
        endif
        if E.Get_AS() != 0 then
            call Set_AS( Get_Unit_Property(u, AS) - E.Get_AS() )
        endif
        if E.Get_MS() != 0 then
            call Set_MS( Get_Unit_Property(u, MS) - E.Get_MS() )
        endif
        if E.Get_CRIT() != 0 then
            call Set_CRIT( Get_Unit_Property(u, CRIT) - E.Get_CRIT() )
        endif
        if E.Get_CRIT_COEF() != 0 then
            call Set_CRIT_COEF( Get_Unit_Property(u, CRIT_COEF) - E.Get_CRIT_COEF() )
        endif
        if E.Get_DEF_AD() != 0 then
            call Set_DEF_AD( Get_Unit_Property(u, DEF_AD) - E.Get_DEF_AD() )
        endif
        if E.Get_DEF_AP() != 0 then
            call Set_DEF_AP( Get_Unit_Property(u, DEF_AP) - E.Get_DEF_AP() )
        endif
        if E.Get_HP() != 0 then
            call Set_HP( Get_Unit_Property(u, HP) - E.Get_HP() )
        endif
        if E.Get_MP() != 0 then
            call Set_MP( Get_Unit_Property(u, MP) - E.Get_MP() )
        endif
        if E.Get_HP_REGEN() != 0 then
            call Set_HP_REGEN( Get_Unit_Property(u, HP_REGEN) - E.Get_HP_REGEN() )
        endif
        if E.Get_MP_REGEN() != 0 then
            call Set_MP_REGEN( Get_Unit_Property(u, MP_REGEN) - E.Get_MP_REGEN() )
        endif
        if E.Get_ENHANCE_AD() != 0 then
            call Set_ENHANCE_AD( Get_Unit_Property(u, ENHANCE_AD) - E.Get_ENHANCE_AD() )
        endif
        if E.Get_ENHANCE_AP() != 0 then
            call Set_ENHANCE_AP( Get_Unit_Property(u, ENHANCE_AP) - E.Get_ENHANCE_AP() )
        endif
        if E.Get_REDUCE_AD() != 0 then
            call Set_REDUCE_AD( Get_Unit_Property(u, REDUCE_AD) - E.Get_REDUCE_AD() )
        endif
        if E.Get_REDUCE_AP() != 0 then
            call Set_REDUCE_AP( Get_Unit_Property(u, REDUCE_AP) - E.Get_REDUCE_AP() )
        endif
        
        set u = null
    endmethod
    
    private method Item_Equiped takes Equip E returns nothing
        local unit u = this.Get_Hero_Unit()
        
        if E.Get_AD() != 0 then
            call Set_AD( Get_Unit_Property(u, AD) + E.Get_AD() )
        endif
        if E.Get_AP() != 0 then
            call Set_AP( Get_Unit_Property(u, AP) + E.Get_AP() )
        endif
        if E.Get_AS() != 0 then
            call Set_AS( Get_Unit_Property(u, AS) + E.Get_AS() )
        endif
        if E.Get_MS() != 0 then
            call Set_MS( Get_Unit_Property(u, MS) + E.Get_MS() )
        endif
        if E.Get_CRIT() != 0 then
            call Set_CRIT( Get_Unit_Property(u, CRIT) + E.Get_CRIT() )
        endif
        if E.Get_CRIT_COEF() != 0 then
            call Set_CRIT_COEF( Get_Unit_Property(u, CRIT_COEF) + E.Get_CRIT_COEF() )
        endif
        if E.Get_DEF_AD() != 0 then
            call Set_DEF_AD( Get_Unit_Property(u, DEF_AD) + E.Get_DEF_AD() )
        endif
        if E.Get_DEF_AP() != 0 then
            call Set_DEF_AP( Get_Unit_Property(u, DEF_AP) + E.Get_DEF_AP() )
        endif
        if E.Get_HP() != 0 then
            call Set_HP( Get_Unit_Property(u, HP) + E.Get_HP() )
        endif
        if E.Get_MP() != 0 then
            call Set_MP( Get_Unit_Property(u, MP) + E.Get_MP() )
        endif
        if E.Get_HP_REGEN() != 0 then
            call Set_HP_REGEN( Get_Unit_Property(u, HP_REGEN) + E.Get_HP_REGEN() )
        endif
        if E.Get_MP_REGEN() != 0 then
            call Set_MP_REGEN( Get_Unit_Property(u, MP_REGEN) + E.Get_MP_REGEN() )
        endif
        if E.Get_ENHANCE_AD() != 0 then
            call Set_ENHANCE_AD( Get_Unit_Property(u, ENHANCE_AD) + E.Get_ENHANCE_AD() )
        endif
        if E.Get_ENHANCE_AP() != 0 then
            call Set_ENHANCE_AP( Get_Unit_Property(u, ENHANCE_AP) + E.Get_ENHANCE_AP() )
        endif
        if E.Get_REDUCE_AD() != 0 then
            call Set_REDUCE_AD( Get_Unit_Property(u, REDUCE_AD) + E.Get_REDUCE_AD() )
        endif
        if E.Get_REDUCE_AP() != 0 then
            call Set_REDUCE_AP( Get_Unit_Property(u, REDUCE_AP) + E.Get_REDUCE_AP() )
        endif
        
        set u = null
    endmethod
    
    public method Type_To_Index takes integer item_type returns integer
        local integer index = -1
        
        if item_type == HELMET then
            set index = 0
        elseif item_type == NECKLACE then
            set index = 1
        elseif item_type == WEAPON then
            set index = 2
        elseif item_type == ARMOR then
            set index = 3
        elseif item_type == SHIELD then
            set index = 4
        elseif item_type == RING then
            if wearing_exist[5] == false then
                set index = 5
            else 
                set index = 7
            endif
        elseif item_type == BELT then
            set index = 6
        elseif item_type == GLOVE then
            set index = 8
        elseif item_type == BOOTS then
            set index = 9
        endif
        
        return index
    endmethod

    public method Check_Wearing takes integer item_type returns integer
        local integer find_index = -1
        
        if item_type == HELMET then
            if wearing_exist[0] == false then
                set find_index = 0
            endif
        elseif item_type == NECKLACE then
            if wearing_exist[1] == false then
                set find_index = 1
            endif
        elseif item_type == WEAPON then
            if wearing_exist[2] == false then
                set find_index = 2
            endif
        elseif item_type == ARMOR then
            if wearing_exist[3] == false then
                set find_index = 3
            endif
        elseif item_type == SHIELD then
            if wearing_exist[4] == false then
                set find_index = 4
            endif
        elseif item_type == RING then
            if wearing_exist[5] == false then
                set find_index = 5
            elseif wearing_exist[7] == false then
                set find_index = 7
            endif
        elseif item_type == BELT then
            if wearing_exist[6] == false then
                set find_index = 6
            endif
        elseif item_type == GLOVE then
            if wearing_exist[8] == false then
                set find_index = 8
            endif
        elseif item_type == BOOTS then
            if wearing_exist[9] == false then
                set find_index = 9
            endif
        endif
        
        return find_index
    endmethod
    
    public method Get_Inven_Item takes integer i returns Equip
        return this.inventory.Get_Inven_Equip(i)
    endmethod
    
    public method Get_Wearing_Item takes integer i returns Equip
        return this.wearings.Get_Wearing_Equip(i)
    endmethod
    
    public method Set_Inven_Item takes integer i, Equip E returns nothing
        set inven_exist[i] = true
        call this.inventory.Set_Inven_Equip(i, E)
    endmethod
    
    public method Set_Wearing_Item takes integer i, Equip E returns nothing
        set wearing_exist[i] = true
        call this.wearings.Set_Wearing_Equip(i, E)
        call this.Item_Equiped(E)
    endmethod
    
    public method Remove_Inven_Item takes integer i returns nothing
        set inven_exist[i] = false
    endmethod
    
    public method Remove_Wearing_Item takes integer i returns nothing
        set wearing_exist[i] = false
        call this.Item_Unequiped(this.Get_Wearing_Item(i))
    endmethod

    public method Delete_Inven_Item takes integer i returns nothing
        local integer item_grade = this.inventory.Get_Inven_Equip(i).Get_Grade()
        local integer value
        
        if item_grade == 0 then
            set value = 4
        elseif item_grade == 1 then
            set value = 20
        elseif item_grade == 2 then
            set value = 100
        elseif item_grade == 3 then
            set value = 500
        elseif item_grade == 4 then
            set value = 2500
        else
            set value = 5
        endif
        
        set inven_exist[i] = false
        call AdjustPlayerStateBJ( value, GetOwningPlayer(Get_Hero_Unit()), PLAYER_STATE_RESOURCE_GOLD )
        call this.inventory.Get_Inven_Equip(i).destroy()
        call this.inventory.Set_Inven_Equip(i, 0)
    endmethod
    
    public method Check_Inven_Item takes integer i returns boolean
        return inven_exist[i]
    endmethod
    
    public method Check_Wearing_Item takes integer i returns boolean
        return wearing_exist[i]
    endmethod
    
    // 가능한 공간이 없으면 -1을 반환
    public method Check_Inven_Possible takes nothing returns integer
        local integer i
        local integer find_index
        local boolean isFind = false
        
        set i = -1
        loop
        set i = i + 1
        exitwhen i > 24 or isFind == true
            if inven_exist[i] == false then
                set isFind = true
                set find_index = i
            endif
        endloop
        
        if isFind == true then
            return find_index
        else
            return -1
        endif
    endmethod
    
    public method Exist_Show takes nothing returns nothing
        local integer i = -1
        local string str = ""
        local string str2 = "플레이어번호 : " + I2S(GetPlayerId(GetOwningPlayer(hero_unit))) + " / "
        local string str3 = ""
        local Equip E
        
        loop
        set i = i + 1
        exitwhen i > 24
            if inven_exist[i] == true then
                set str = str + "1 "
                set E = Get_Inven_Item(i)
                set str3 = str3 + E.Get_Name() + "   "
            else
                set str = str + "0 "
            endif
        endloop
        
        call BJDebugMsg(str2 + str)
        call BJDebugMsg(str3)
    endmethod
    
    // Legacy
    public method Level_Up_Property_Apply takes nothing returns nothing
        local integer new_level = GetUnitLevel( Get_Hero_Unit() )
        local integer level_gap = new_level - Get_Level()
        local integer new_level_up_value = (new_level/10)
        local integer level_up_value_gap = new_level_up_value - Get_Level_Up_Value()
        
        call Set_HP( Get_HP() + level_gap )
        
        if level_up_value_gap > 0 then
            call Set_AD( Get_AD() + level_up_value_gap )
            call Set_AP( Get_AP() + level_up_value_gap )
            call Set_Level_Up_Value( new_level_up_value )
        endif
        
        call Set_Level(new_level)
    endmethod
    
    public method Set_Stat_Alloc_Property takes integer property, integer value returns nothing

        if property == AD then
            call Set_AD( Get_AD() - increase_ad/2 )
            set increase_ad = value
            call Set_AD( Get_AD() + increase_ad/2 )
            
        elseif property == AP then
            call Set_AP( Get_AP() - increase_ap )
            set increase_ap = value
            call Set_AP( Get_AP() + increase_ap )
            
        elseif property == AS then
            call Set_AS( Get_AS() - increase_as/3 )
            set increase_as = value
            call Set_AS( Get_AS() + increase_as/3 )
            
        elseif property == MS then
            call Set_MS( Get_MS() - increase_ms/4 )
            set increase_ms = value
            call Set_MS( Get_MS() + increase_ms/4 )
            
        elseif property == HP then
            call Set_HP( Get_HP() - increase_hp*15 )
            set increase_hp = value
            call Set_HP( Get_HP() + increase_hp*15 )
            
        elseif property == MP then
            call Set_MP( Get_MP() - increase_mp*3 )
            set increase_mp = value
            call Set_MP( Get_MP() + increase_mp*3 )
            
        elseif property == DEF_AD then
            call Set_DEF_AD( Get_DEF_AD() - increase_def_ad/2 )
            set increase_def_ad = value
            call Set_DEF_AD( Get_DEF_AD() + increase_def_ad/2 )
            
        elseif property == DEF_AP then
            call Set_DEF_AP( Get_DEF_AP() - increase_def_ap/2 )
            set increase_def_ap = value
            call Set_DEF_AP( Get_DEF_AP() + increase_def_ap/2 )
            
        elseif property == HP_REGEN then
            call Set_HP_REGEN( Get_HP_REGEN() - increase_hp_regen/2 )
            set increase_hp_regen = value
            call Set_HP_REGEN( Get_HP_REGEN() + increase_hp_regen/2 )
            
        elseif property == MP_REGEN then
            call Set_MP_REGEN( Get_MP_REGEN() - increase_mp_regen/5 )
            set increase_mp_regen = value
            call Set_MP_REGEN( Get_MP_REGEN() + increase_mp_regen/5 )
        else
            call BJDebugMsg("There is Error Exist")
            return
        endif
    endmethod
    
    public method Get_Stat_Alloc_Property takes integer property returns integer
        local integer add = 0

        if property == AD then
            return increase_ad
        elseif property == AP then
            return increase_ap
        elseif property == AS then
            return increase_as
        elseif property == MS then
            return increase_ms
        elseif property == HP then
            return increase_hp
        elseif property == MP then
            return increase_mp
        elseif property == DEF_AD then
            return increase_def_ad
        elseif property == DEF_AP then
            return increase_def_ap
        elseif property == HP_REGEN then
            return increase_hp_regen
        elseif property == MP_REGEN then
            return increase_mp_regen
        else
            call BJDebugMsg("There is Error Exist")
            return 0
        endif
    endmethod
    
    public method Set_Stat_Point takes integer value returns nothing
        set stat_point = value
    endmethod
    
    public method Get_Stat_Point takes nothing returns integer
        return stat_point
    endmethod
    
    public method Stat_Point_Calculate takes nothing returns nothing
        local integer remain = GetUnitLevel( Get_Hero_Unit() ) - 1
        
        set remain = remain - increase_ad
        set remain = remain - increase_ap
        set remain = remain - increase_as
        set remain = remain - increase_ms
        set remain = remain - increase_hp
        set remain = remain - increase_mp
        set remain = remain - increase_def_ad
        set remain = remain - increase_def_ap
        set remain = remain - increase_hp_regen
        set remain = remain - increase_mp_regen
        
        if remain < 0 then
            call BJDebugMsg("error exist")
        endif
        
        set stat_point = remain
    endmethod

endstruct