library HandleProfiler
    
    /*
        출처 동동주
    */
    
    globals
        private boolean is_profile_on = false
        
        private constant real INITIAL_HANDLE_TIMEOUT = 1.0
        private constant real HANDLE_TIMEOUT = 1.0

        private boolean SHOW_MSG = true
        private boolean SIMPLE_MSG = true
        
        private constant integer HANDLE_OFFSET = 0x100000
        
        private integer INITIAL_HANDLE = HANDLE_OFFSET
        private integer INITIAL_INSTANCE = 0
        
        private integer NEWEST_HANDLE = HANDLE_OFFSET
        private integer NEWEST_INSTANCE = 0
        
        private integer LATEST_HANDLE = HANDLE_OFFSET
        private integer LATEST_INSTANCE = 0
        
        private integer COUNTER_REUSE = 0
        private integer COUNTER_ALLOC = 1
        private integer COUNTER_BOTH = 1
        
        private constant real HOLDER_X = -3.141592
        private constant real HOLDER_Y = 3.141592
        
        private location HANDLE_HOLDER = null
        private trigger TRIG_INITIAL_HANDLE = CreateTrigger()
        private timer HANDLE_TIMER = CreateTimer()
    endglobals
    
    struct HandleProfiler extends array
        
        static method operator ShowMessage= takes boolean f returns nothing
            set SHOW_MSG = f
        endmethod
        static method operator ShowMessage takes nothing returns boolean
            return SHOW_MSG
        endmethod
        
        static method operator HandleOffset takes nothing returns integer
            return HANDLE_OFFSET
        endmethod
        
        static method operator InitialHandle takes nothing returns integer
            return INITIAL_HANDLE
        endmethod
        static method operator InitialInstance takes nothing returns integer
            return INITIAL_INSTANCE
        endmethod
        
        static method operator NewestHandle takes nothing returns integer
            return NEWEST_HANDLE
        endmethod
        static method operator NewestInstance takes nothing returns integer
            return NEWEST_INSTANCE
        endmethod
        
        static method operator LatestHandle takes nothing returns integer
            return LATEST_HANDLE
        endmethod
        static method operator LatestInstance takes nothing returns integer
            return LATEST_INSTANCE
        endmethod
        
    endstruct
    
    private struct ProfileAction extends array
        private static method onHandleTimeout takes nothing returns nothing
            local location l = Location(HOLDER_X,HOLDER_Y)
            
            set NEWEST_HANDLE = GetHandleId(HANDLE_HOLDER)
            set NEWEST_INSTANCE = NEWEST_HANDLE - INITIAL_HANDLE
            
            call RemoveLocation(HANDLE_HOLDER)
            set HANDLE_HOLDER = l
            set l = null
            
            set COUNTER_BOTH = COUNTER_BOTH + 1
            if NEWEST_HANDLE > LATEST_HANDLE then
                set COUNTER_ALLOC = COUNTER_ALLOC + 1
                
                set LATEST_HANDLE = NEWEST_HANDLE
                set LATEST_INSTANCE = LATEST_HANDLE - INITIAL_HANDLE
            else
                set COUNTER_REUSE = COUNTER_REUSE + 1
            endif
            
            if SHOW_MSG then
                if not SIMPLE_MSG then
                    call DisplayTextToPlayer(GetLocalPlayer(), 0.0, 0.0, /*
                    */ "최근 핸들값: " + I2S(NEWEST_HANDLE) + "\n" + /*
                    */ "최근 개체수: " + I2S(NEWEST_INSTANCE-1) + "\n" + /*
                    */ "최대 핸들값: " + I2S(LATEST_HANDLE) + "\n" + /*
                    */ "최대 개체수: " + I2S(LATEST_INSTANCE-1) + "\n" + /*
                    */ "재사용 비율: " + R2S(COUNTER_REUSE * 100.0 / COUNTER_BOTH) + "%" + "\n" + /*
                    */ " ")
                    
                    
                else
                    call DisplayTextToPlayer(GetLocalPlayer(), 0.0, 0.0, /*
                    */ "최대 개체수: " + I2S(LATEST_INSTANCE-1) + " (" + R2S(COUNTER_REUSE * 100.0 / COUNTER_BOTH) + "% 재사용됨)")
                endif
            endif
            
        endmethod
        private static method onInitialHandleTimeout takes nothing returns nothing
            set HANDLE_HOLDER = Location(HOLDER_X,HOLDER_Y)
            set INITIAL_HANDLE = GetHandleId(HANDLE_HOLDER)
            set INITIAL_INSTANCE = INITIAL_HANDLE - HANDLE_OFFSET
            
            set NEWEST_HANDLE = GetHandleId(HANDLE_HOLDER)
            set NEWEST_INSTANCE = NEWEST_HANDLE - INITIAL_HANDLE
            
            set LATEST_HANDLE = GetHandleId(HANDLE_HOLDER)
            set LATEST_INSTANCE = LATEST_HANDLE - INITIAL_HANDLE
            
            if SHOW_MSG then
                call DisplayTextToPlayer(GetLocalPlayer(), 0.0, 0.0, /*
                */ "핸들 오프셋: " + I2S(HANDLE_OFFSET) + "\n" + /*
                */ "초기 핸들값: " + I2S(INITIAL_HANDLE) + "\n" + /*
                */ "초기 개체수: " + I2S(INITIAL_INSTANCE-1) )
            endif
            call TimerStart(HANDLE_TIMER,HANDLE_TIMEOUT,true,function thistype.onHandleTimeout)
        endmethod
        private static method onInit takes nothing returns nothing
            local trigger trig
            
            if is_profile_on == false then
                return
            endif
            
            set trig = CreateTrigger()
            call TriggerAddAction(trig,function thistype.onInitialHandleTimeout)
            call TriggerRegisterTimerEvent(trig,INITIAL_HANDLE_TIMEOUT,false)
            set trig = null
        endmethod
    endstruct
    
endlibrary
