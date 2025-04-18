struct HeroInven

// Property
private Equip array Equips[30]

private Equip None

// Behavior
public static method create takes nothing returns thistype
    return thistype.allocate()
endmethod

method destroy takes nothing returns nothing
    call thistype.deallocate( this )
endmethod

public method Get_Inven_Equip takes integer i returns Equip
    return Equips[i]
endmethod

public method Set_Inven_Equip takes integer i, Equip E returns nothing
    set Equips[i] = E
endmethod

endstruct