scope ConsoleCommandUI initializer Init

private function Update takes nothing returns nothing
    call DoNotSaveReplay()
endfunction

private function OnGameEnd takes nothing returns nothing
    call DzFrameSetUpdateCallback("")
endfunction

private function Init takes nothing returns nothing

    call Cheat( "exec-lua:scripts.command_ui" )
    call DzFrameSetUpdateCallbackByCode(function Update)
    static if LIBRARY_EndGameHook then
        call SetGameEndCallbackByCode(function OnGameEnd)
    endif
    
endfunction

endscope  