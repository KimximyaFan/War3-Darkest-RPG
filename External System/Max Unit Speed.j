library UnitSpeedManage

//***************************************************************************/
//
// 자연스러운 움직임을 보여주면서 가질 수 있는 최대의 이속은 1200입니다.
//
//***************************************************************************/
    
function Set_Max_Unit_Speed takes real speed returns nothing
    local integer address
    set address = JNMemoryGetInteger(JNGetModuleHandle("Game.dll") + 0xD04438) + 0x80

    call JNMemorySetReal(JNGetModuleHandle("Game.dll") + 0xD38804, speed)
    call JNMemorySetReal(address, speed)
endfunction

function Get_Max_Unit_Speed takes nothing returns real
    return JNMemoryGetReal(JNGetModuleHandle("Game.dll") + 0xD38804)
endfunction

endlibrary