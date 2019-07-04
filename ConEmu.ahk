
;##################################################################
;#### Guake style console.
;##################################################################

$F7::
    Process, Exist, ConEmu.exe
    {
        If ! errorLevel
        {
            Run, "C:\Program Files\ConEmu\ConEmu.exe"
        }
        else
        {
            Send {F7}
        }
    }

    Return

;## CTRL + y : Show Youtube TubePlayer
^y::
WinActivate, ahk_exe TubePlayer.exe
return

;## CTRL + t : Minimize Youtube TubePlayer
^t::
WinMinimize, ahk_exe TubePlayer.exe
return

;## CTRL + j : Write text
^j::
Send, My First Script
return

;## Alt + z
!z::run D:\Users\fpaut\AppData\Local\Microsoft\WindowsApps\ubuntu.exe run cd /mnt/c/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware && pause && zmake.sh

;## ~RButton::MsgBox [AUTOHOTKEY] You clicked the right mouse button.

;## ~RButton & C::MsgBox [AUTOHOTKEY] You pressed C while holding down the right mouse button.
~LButton & Z::run D:\WINDOWS\system32\wsl.exe 
<^>!m::MsgBox [AUTOHOTKEY] You pressed AltGr+m.
<^<!m::MsgBox [AUTOHOTKEY] You pressed LeftControl+LeftAlt+m.

;## Left Mouse Button + 'A' : Show ASCII table
~LButton & A::run D:\Users\fpaut\Documents\Ascii-codes-table.png

;## Left Mouse Button + 'K' : Show Virtual Keyboard
~LButton & K::run D:\Windows\System32\osk.exe

;## Left Mouse Button + 'W' : Show how to fix WSL problem Lxssmanager service
~LButton & W::run D:\Users\fpaut\Documents\dev\PB_Windows\WslUnableToStart.jpg

;## holding Menu will show the ToolTip and will not trigger a context menu
AppsKey::ToolTip [AUTOHOTKEY] Press < or > to cycle through windows.
AppsKey Up::ToolTip
~AppsKey & <::Send !+{Esc}
~AppsKey & >::Send !{Esc}


^Numpad0::
^Numpad1::
MsgBox  [AUTOHOTKEY] Pressing either Control+Numpad0 or Control+Numpad1 will display this message.
return

;## hotstring
;## the abbreviation btw will be automatically replaced with "by the way"
::btw::by the way

