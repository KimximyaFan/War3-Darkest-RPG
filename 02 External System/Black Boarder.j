library BlackBoarder

function Black_Boarder_Init takes nothing returns nothing
    local real MAX_TARGET_DISTANCE = 100000.00   //목표와의 거리 최댓값(초기 값: 10000.000)
    local real MAX_TARGET_FAR = 100000.00        //블랙 박스 최댓값(초기 값: 10000.000)
    local integer offset = JNMemoryGetInteger(JNGetModuleHandle("Storm.dll")+0x58248)
    
    set offset = JNMemoryGetInteger(offset+0x90)
    set offset = JNMemoryGetInteger(offset+0x58)
    set offset = JNMemoryGetInteger(offset+0x4)
    set offset = JNMemoryGetInteger(offset+0x58)
    set offset = JNMemoryGetInteger(offset+0x5C)
    set offset = JNMemoryGetInteger(offset+0xC)
    call JNMemorySetReal(offset+0x84, MAX_TARGET_FAR)
    
    set offset = JNMemoryGetInteger(JNGetModuleHandle("Storm.dll")+0x58248)
    set offset = JNMemoryGetInteger(offset+0x90)
    set offset = JNMemoryGetInteger(offset+0x58)
    set offset = JNMemoryGetInteger(offset+0x4)
    set offset = JNMemoryGetInteger(offset+0x58)
    set offset = JNMemoryGetInteger(offset+0x5C)
    set offset = JNMemoryGetInteger(offset+0x8)
    call JNMemorySetReal(offset+0x84, MAX_TARGET_DISTANCE)
endfunction

endlibrary