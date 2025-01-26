library MemoryLib requires /*
*/ MemoryLibBase, /*
*/ optional MemoryLibCommandButton, /*
*/ optional MemoryLibCommandButtonData, /*
*/ optional MemoryLibGameUI, /*
*/ optional MemoryLibMemoryBlock, /*
*/ optional MemoryLibPrimitiveType, /*
*/ MemoryLibEnd
endlibrary

library MemoryLibBase initializer Init requires JNMemory
globals
    integer pGameDll
endglobals

interface Ptr
endinterface

private function Init takes nothing returns nothing
    set pGameDll = JNGetModuleHandle("Game.dll")
endfunction
endlibrary

library MemoryLibEnd
endlibrary

// source: src/MemoryLibCommandButton.j
library MemoryLibCommandButton requires MemoryLibBase, MemoryLibPrimitiveType, MemoryLibCommandButtonData

struct CommandButton extends Ptr
    public static method getCommandBarButton takes integer x, integer y returns thistype
        return JNFrameGetCommandBarButton(x, y)
    endmethod

    public method operator data takes nothing returns CommandButtonData
        return PtrPtr[this + 0x190]
    endmethod
endstruct

endlibrary

// source: src/MemoryLibCommandButtonData.j
library MemoryLibCommandButtonData requires MemoryLibBase, MemoryLibPrimitiveType

struct CommandButtonData extends Ptr
    public method operator abilityId takes nothing returns integer
        return IntPtr[this + 0x4]
    endmethod
    public method operator orderId takes nothing returns integer
        return IntPtr[this + 0x8]
    endmethod
    public method operator targets takes nothing returns integer
        return IntPtr[this + 0x10]
    endmethod
    public method operator tip takes nothing returns string
        return JNMemoryGetString(this + 0x2C, 348)  // 348 is not sure
    endmethod
    public method operator ubertip takes nothing returns string
        return JNMemoryGetString(this + 0x18C, 1024)  // 1024 is not sure
    endmethod
    public method operator cost takes nothing returns integer
        return IntPtr[this + 0x594]
    endmethod
    public method operator buttonPosX takes nothing returns integer
        return IntPtr[this + 0x59C]
    endmethod
    public method operator buttonPosY takes nothing returns integer
        return IntPtr[this + 0x5A0]
    endmethod
    public method operator hotkey takes nothing returns integer
        return IntPtr[this + 0x5AC]
    endmethod
    public method operator art takes nothing returns string
        return JNMemoryGetString(this + 0x5C8, 200)  // 200 is not sure
    endmethod
    public method operator state takes nothing returns integer
        return IntPtr[this + 0x6D0]
    endmethod
endstruct

endlibrary

// source: src/MemoryLibGameUI.j
library MemoryLibGameUI requires MemoryLibBase, MemoryLibPrimitiveType

struct GameUI extends Ptr
    public static method getInstance takes nothing returns thistype
        return PtrPtr[pGameDll + 0xD0F600]
    endmethod

    public method operator cursorFrame takes nothing returns Ptr
        return PtrPtr[this + 0x16C]
    endmethod

    public method operator worldFrame takes nothing returns Ptr
        return PtrPtr[this + 0x3BC]
    endmethod

    public method operator currentMode takes nothing returns Ptr
        return PtrPtr[this + 0x1B4]
    endmethod
    public method operator targetMode takes nothing returns Ptr
        return PtrPtr[this + 0x210]
    endmethod
    public method operator selectMode takes nothing returns Ptr
        return PtrPtr[this + 0x214]
    endmethod
    public method operator dragSelectMode takes nothing returns Ptr
        return PtrPtr[this + 0x218]
    endmethod
    public method operator dragScrollMode takes nothing returns Ptr
        return PtrPtr[this + 0x21C]
    endmethod
    public method operator buildMode takes nothing returns Ptr
        return PtrPtr[this + 0x220]
    endmethod
    public method operator signalMode takes nothing returns Ptr
        return PtrPtr[this + 0x224]
    endmethod
    public method operator escMenu takes nothing returns Ptr
        return PtrPtr[this + 0x228]
    endmethod

    public method handleEvent takes Ptr pEvent returns integer
        local Ptr pFunc = pGameDll + 0x3A3190
        call SaveStr(JNProc_ht, JNProc_key, 0, "(II)I")
        call SaveInteger(JNProc_ht, JNProc_key, 1, this)
        call SaveInteger(JNProc_ht, JNProc_key, 2, pEvent)
        if (JNProcCall(JNProc__thiscall, pFunc, JNProc_ht)) then
            return LoadInteger(JNProc_ht, JNProc_key, 0)
        endif
        return 0
    endmethod
endstruct

endlibrary

// source: src/MemoryLibMemoryBlock.j
/*
* MemoryLibMemoryBlock
* 빈 메모리 공간을 할당합니다.
*/
library MemoryLibMemoryBlock requires MemoryLibBase, MemoryLibPrimitiveType

globals
    /* 최대 할당 크기 */
    constant integer MemoryLib_MAX_MEMORY_BLOCK_SIZE = JASS_MAX_ARRAY_SIZE * 4
endglobals

/*
    * //! runtextmacro MemoryLib_DefineGlobalMemoryBlock("accessor", "name", "id", "size")
    * `size`바이트 크기의 전역 메모리 블록을 `name`이라는 이름으로 생성합니다.
    * `accessor`는 접근자이며, {"", "public", "private"} 중 하나만 사용 가능합니다.
    * `id` 값은 유일해야하며, 다른 블록과 겹치면 안됩니다.
    *
    * 메모리 블록은 전역으로 생성되며, 다음과 같은 형태로 참조할 수 있습니다:
    * $name.pHead: 메모리 블록 포인터
    * $name.size : 메모리 블록 크기 (바이트)
    */
//! textmacro MemoryLib_DefineMemoryBlock takes ACCESSOR, NAME, ID, SIZE

globals
    integer $ID$_block
    integer array l__$ID$_block
endglobals

$ACCESSOR$ struct $NAME$ extends array
    readonly static Ptr pHead
    readonly static integer size

    private static method initSize takes nothing returns nothing
        local integer lastIndex = ($SIZE$ - 1) / 4
        set l__$ID$_block[lastIndex] = 0
    endmethod

    private static method typecast takes nothing returns nothing
        local integer $ID$_block
    endmethod

    //# +nosemanticerror
    private static method onInit takes nothing returns nothing
        call thistype.initSize()
        set thistype.pHead = PtrPtr(l__$ID$_block)[3]
        set thistype.size = $SIZE$
    endmethod
endstruct
//! endtextmacro

endlibrary

// source: src/MemoryLibPrimitiveType.j
library MemoryLibPrimitiveType requires MemoryLibBase

struct BytePtr extends Ptr
    public static method operator [] takes integer address returns integer
        return JNMemoryGetByte(address)
    endmethod

    public method operator value takes nothing returns integer
        return JNMemoryGetByte(this)
    endmethod

    public method operator value= takes integer value returns nothing
        call JNMemorySetByte(this, value)
    endmethod

    public method operator [] takes integer offset returns integer
        return JNMemoryGetInteger(this + offset)
    endmethod

    public method operator []= takes integer offset, integer value returns nothing
        call JNMemorySetByte(this + offset, value)
    endmethod
endstruct

struct IntPtr extends Ptr
    public static method operator [] takes integer address returns integer
        return JNMemoryGetInteger(address)
    endmethod

    public method operator value takes nothing returns integer
        return JNMemoryGetInteger(this)
    endmethod

    public method operator value= takes integer value returns nothing
        call JNMemorySetInteger(this, value)
    endmethod

    public method operator [] takes integer offset returns integer
        return JNMemoryGetInteger(this + (offset * 4))
    endmethod

    public method operator []= takes integer offset, integer value returns nothing
        call JNMemorySetInteger(this + (offset * 4), value)
    endmethod
endstruct

struct RealPtr extends Ptr
    public static method operator [] takes integer address returns real
        return JNMemoryGetReal(address)
    endmethod

    public method operator value takes nothing returns real
        return JNMemoryGetReal(this)
    endmethod

    public method operator value= takes real value returns nothing
        call JNMemorySetReal(this, value)
    endmethod

    public method operator [] takes integer offset returns real
        return JNMemoryGetReal(this + (offset * 4))
    endmethod

    public method operator []= takes integer offset, real value returns nothing
        call JNMemorySetReal(this + (offset * 4), value)
    endmethod
endstruct

struct PtrPtr extends Ptr
    public static method operator [] takes integer address returns Ptr
        return JNMemoryGetInteger(address)
    endmethod

    public method operator value takes nothing returns Ptr
        return JNMemoryGetInteger(this)
    endmethod

    public method operator value= takes Ptr value returns nothing
        call JNMemorySetInteger(this, value)
    endmethod

    public method operator [] takes integer offset returns Ptr
        return JNMemoryGetInteger(this + (offset * 4))
    endmethod

    public method operator []= takes integer offset, Ptr value returns nothing
        call JNMemorySetInteger(this + (offset * 4), value)
    endmethod
endstruct

endlibrary