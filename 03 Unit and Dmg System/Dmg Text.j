library DmgText requires Base

globals
    private real text_dist = 70
endglobals

function Dmg_Text takes unit u, unit target, real dmg, attacktype dmg_type returns nothing
    local string str
    local string str2
    local integer strL
    local integer loopA = 0
    local real tempX
    local real tempY
    local real text_size = 1.0
    local real dist = 25
    //local real tempR
    local string type_str
    local string eff
    local effect text_eff = null
    local real angle = Angle(GetUnitX(target), GetUnitY(target), GetUnitX(u), GetUnitY(u))
    local real x
    local real y
    
    //call BJDebugMsg("Dmg_Text : " + R2S(dmg))
    
    if GetOwningPlayer(target) == p_enemy then
        set x = Polar_X(GetUnitX(target), text_dist, angle)
        set y = Polar_Y(GetUnitY(target), text_dist, angle)
    else
        set text_size = 0.68
        set dist = 16
        set x = Polar_X(GetUnitX(target), 10, GetRandomDirectionDeg())
        set y = Polar_Y(GetUnitY(target), 10, GetRandomDirectionDeg())
    endif
    
    if dmg_type == ConvertAttackType(AD_NO_CRIT) then
        set type_str = "White"
    elseif dmg_type == ConvertAttackType(AP_NO_CRIT) then
        set type_str = "Sky"
    elseif dmg_type == ConvertAttackType(AD_CRIT) then
        set type_str = "Red"
        set text_size = text_size + 0.05
    elseif dmg_type == ConvertAttackType(AP_CRIT) then
        set type_str = "Navy"
        set text_size = text_size + 0.05
    else
        // 평타임
        return
    endif
    
    set str = I2S(R2I(dmg + 1.0001))
    set strL = JNStringLength(str)
    
    // 문자열의 초기 위치를 지정해줍니다.
    //set tempR = (strL * -15)
    
    loop
    exitwhen loopA >= strL
        // 문자열 갯수만큼 루프문을 돌려서 문자열을 출력합니다.
        set loopA = loopA + 1
        set str2 = SubString(str,loopA-1,loopA)
        
        // 문자 길이 위치 조절해주기.
        set tempX = x - (dist * (loopA-1) * Cos( 180 * bj_DEGTORAD ))
        set tempY = y - (dist * (loopA-1) * Sin( 180 * bj_DEGTORAD ))
        
        set eff = "Dmg Text " + type_str + " " + str2 + ".mdx"
        
        set text_eff =  AddSpecialEffect(eff, tempX, tempY)
        call EXSetEffectSize(text_eff, text_size)
        call DestroyEffect( text_eff )
    endloop
    
    if type_str == "Red" or type_str == "Navy" then
        set loopA = loopA + 1
        // 문자 길이 위치 조절해주기.
        set tempX = x - (dist * (loopA-1) * Cos( 180 * bj_DEGTORAD ))
        set tempY = y - (dist * (loopA-1) * Sin( 180 * bj_DEGTORAD ))
        set eff = "Dmg Text " + type_str + " Cri.mdx"
        
        set text_eff =  AddSpecialEffect(eff, tempX, tempY)
        call EXSetEffectSize(text_eff, text_size)
        call DestroyEffect( text_eff )
    endif
    
    set text_eff = null
endfunction

endlibrary
