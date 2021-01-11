MyHelp = "Help:"
MyHelp = MyHelp "`n CTRL + y : Show Youtube TubePlayer{s}"



MyHelp = MyHelp "`n CTRL + t : Minimize Youtube TubePlayer"
;## Left Mouse Button + t : Minimize Youtube TubePlayer
~LButton & t::
WinMinimize, ahk_exe E:\Tools\SMPlayer\smplayer.exe
return

;## Left Mouse Button + y : Show Youtube TubePlayer
~LButton & y::run E:\Tools\SMPlayer\smplayer.exe

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
LButton_ToolTip = "'A' : Show ASCII table"
~LButton & A::run E:\Documents\Ascii-codes-table.png

;## Left Mouse Button + 'D' : Show Combo Devices ID
~LButton & D::run E:\dev\STM32_Toolchain\doc\DeviceID.PNG

;## Left Mouse Button + 'K' : Show Virtual Keyboard
~LButton & K::run C:\Windows\System32\osk.exe

;## Left Mouse Button + 'M' : Active magnifyc
~LButton & M::run %windir%\system32\magnify.exe

;## Left Mouse Button + 'R' : COMBO with ARMS
~LButton & R::run E:\dev\STM32_Toolchain\doc\COMBO_ARMS.png

;## AltGr + 'Y' : Launch Youtube Player
~LButton::ToolTip % LButton_ToolTip
<^>!Y::run E:\Tools\SMPlayer\smplayer.exe


;## Left Mouse Button + 'W' : Show how to fix WSL problem Lxssmanager service
~LButton & W::run D:\Users\fpaut\Documents\dev\PB_Windows\WslUnableToStart.jpg

;## holding touch 'Menu' will show the ToolTip and will not trigger a context menu
AppsKey::ToolTip [AUTOHOTKEY] Press < or > to cycle through windows.
AppsKey Up::ToolTip
~AppsKey & <::Send !+{Esc}
~AppsKey & >::Send !{Esc}

;## ALTGR+SPACE: Make a Window Always-on-Top
<^>!SPACE::  Winset, Alwaysontop, , A

;## Alt + H
!H::MsgBox % "MyHelp Var is " . MyHelp . "." 

^Numpad0::
^Numpad1::
MsgBox  [AUTOHOTKEY] Pressing either Control+Numpad0 or Control+Numpad1 will display this message.
return

;## hotstring
;## the abbreviation btw will be automatically replaced with "by the way"
::btw::by the way

;##################################################################
;#### Guake style console.
;##################################################################

$F7::
    Process, Exist, ConEmu64.exe
    {
        If ! errorLevel
        {
            Run, "C:\Program Files\ConEmu\ConEmu64.exe"
        }
        else
        {
            Send {F7}
        }
    }

    Return