library DifficultyFrame requires Base

globals
    private trigger sync_trg

    private integer box
    private integer explain_text
    private integer normal_button
    private integer nightmare_button
    private integer hell_button
endglobals

function Difficulty_Frame_Hide takes nothing returns nothing
    call DzFrameShow(box, false)
endfunction

function Difficulty_Frame_Show takes nothing returns nothing
    call DzFrameShow(box, true)
endfunction

private function Difficulty_Sync takes nothing returns nothing
    local integer selected_difficulty = S2I(DzGetTriggerSyncData())
    
    if selected_difficulty == NORMAL then
        set MAP_DIFFICULTY = NORMAL
        call Msg("노말 난이도 선택됨", 0.0)
    elseif selected_difficulty == NIGHTMARE then
        set MAP_DIFFICULTY = NIGHTMARE
        call Msg("나이트메어 난이도 선택됨", 0.0)
    elseif selected_difficulty == HELL then
        set MAP_DIFFICULTY = HELL
        call Msg("헬 난이도 선택됨", 0.0)
    endif
    
    call PlaySoundBJ(gg_snd_PhaseShift1)
    
    set is_difficulty_choosen = true
    call TriggerExecute(next_step_trg)
endfunction

private function Hell_Clicked takes nothing returns nothing
    call Difficulty_Frame_Hide()
    call DzSyncData("diff", I2S(HELL))
endfunction

private function Nightmare_Clicked takes nothing returns nothing
    call Difficulty_Frame_Hide()
    call DzSyncData("diff", I2S(NIGHTMARE))
endfunction

private function Normal_Clicked takes nothing returns nothing
    call Difficulty_Frame_Hide()
    call DzSyncData("diff", I2S(NORMAL))
endfunction

private function Frame_Init takes nothing returns nothing
    local real y_padding = -0.025
    local real y_padding2 = 0.01
    
    set box = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuBackdrop", 0)
    call DzFrameSetPoint(box, JN_FRAMEPOINT_CENTER, DzGetGameUI(), JN_FRAMEPOINT_CENTER, 0.0, 0.025)
    call DzFrameSetSize(box, 0.20, 0.25)
    call DzFrameShow(box, false)
    
    set explain_text = DzCreateFrameByTagName("TEXT", "", box, "ScoreScreenTabTextSelectedTemplate", 0)
    call DzFrameSetPoint(explain_text, JN_FRAMEPOINT_CENTER, box, JN_FRAMEPOINT_CENTER, 0.0, 0.105 + y_padding)
    call DzFrameSetText(explain_text, "난이도 선택" )
    
    set normal_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(normal_button, JN_FRAMEPOINT_CENTER, box, JN_FRAMEPOINT_CENTER, 0.0, 0.05 + y_padding + y_padding2)
    call DzFrameSetSize(normal_button, 0.1, 0.040)
    call DzFrameSetText(normal_button, "노말")
    call DzFrameSetScriptByCode(normal_button, JN_FRAMEEVENT_CONTROL_CLICK, function Normal_Clicked, false)
    
    set nightmare_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(nightmare_button, JN_FRAMEPOINT_CENTER, box, JN_FRAMEPOINT_CENTER, 0.0, 0.00 + y_padding + y_padding2)
    call DzFrameSetSize(nightmare_button, 0.1, 0.04)
    call DzFrameSetText(nightmare_button, "나이트메어")
    call DzFrameSetScriptByCode(nightmare_button, JN_FRAMEEVENT_CONTROL_CLICK, function Nightmare_Clicked, false)
    call DzFrameShow(nightmare_button, true)
    
    set hell_button = DzCreateFrameByTagName("GLUETEXTBUTTON", "", box, "ScriptDialogButton", 0)
    call DzFrameSetPoint(hell_button, JN_FRAMEPOINT_CENTER, box, JN_FRAMEPOINT_CENTER, 0.0, -0.05 + y_padding + y_padding2)
    call DzFrameSetSize(hell_button, 0.1, 0.04)
    call DzFrameSetText(hell_button, "헬")
    call DzFrameSetScriptByCode(hell_button, JN_FRAMEEVENT_CONTROL_CLICK, function Hell_Clicked, false)
    call DzFrameShow(hell_button, true)
endfunction

private function Sync_Trigger_Init takes nothing returns nothing
    // 난이도 선택 동기화
    set sync_trg = CreateTrigger()
    call DzTriggerRegisterSyncData(sync_trg, "diff", false)
    call TriggerAddAction( sync_trg, function Difficulty_Sync )
endfunction

function Difficulty_Frame_Init takes nothing returns nothing
    call Sync_Trigger_Init()
    call Frame_Init()
endfunction

endlibrary