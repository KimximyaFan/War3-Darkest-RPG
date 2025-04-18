library OpLimit initializer Init

function SetOpLimit takes integer opLimit returns nothing
    local integer pGameDll = JNGetModuleHandle("game.dll")
    call JNMemorySetInteger(pGameDll + 0x2100B9, opLimit)
    call JNMemorySetInteger(pGameDll + 0x239C1F, opLimit)
    call JNMemorySetInteger(pGameDll + 0x23F941, opLimit)
    call JNMemorySetInteger(pGameDll + 0x24255A, opLimit)
    call JNMemorySetInteger(pGameDll + 0x8D0303, opLimit)
    call JNMemorySetInteger(pGameDll + 0x8D133A, opLimit)
    call JNMemorySetInteger(pGameDll + 0x970A85, opLimit)
    call JNMemorySetInteger(pGameDll + 0x970A95, opLimit)
    call JNMemorySetInteger(pGameDll + 0x972134, opLimit)
endfunction

private function Init takes nothing returns nothing
    call SetOpLimit(700000)
endfunction

endlibrary