; AutoHotKey script

#SingleInstance force

; Right-button on trackpad is broken! Use RightCtrl+LeftClick instead.
RCtrl & LButton::Send {RButton}

; Just for Pycon:
;Volume_Up::k
;Volume_Down::j
;PgDn::Right
;PgUp::Left

; Generally a good thing for my hands:
;RAlt & CapsLock::ShiftAltTab
;RAlt & Tab::AltTab
LAlt & Tab::MsgBox Boo!
LAlt & F4::MsgBox Boo!

; HP laptop:
AppsKey::Delete

; These were for the old Toshiba:
;Ins::Ctrl

; Fix the escape key in Trillian (doesn't work, but keeps the escape key from closing the window at least).
#IfWinActive ahk_class icoAIM
Escape::SendInput ^A{Delete}
#IfWinActive

; These are hotkey sequences to save me typing:
::pdbxx::import pdb;pdb.set_trace()
::idk::I don't know
::+bpjobs::http://meetup.bostonpython.com/pages/Job_Posting_requirements/
::+bpsponsor::http://meetup.bostonpython.com/pages/How_sponsorship_works/

; For the presentation remote, in Bruce:
;#IfWinActive Presentation: Slide
;PgDn::Right
;PgUp::Left
;Volume_Up::Right
;Volume_Down::Left
;#IfWinActive

; For watching Netflix with the prez remote.
#IfWinActive Netflix: Netflix Movie Viewer
PgDn::Space
#IfWinActive

; ############## iTunes ##############
; from http://www.switchonthecode.com/tutorials/controlling-itunes-with-autohotkey

; ctrl+win+right -> next song
; ctrl+win+left  -> previous song
; ctrl+win+space -> play/pause

^#right::
DetectHiddenWindows, On
ControlSend, ahk_parent, ^{right}, iTunes ahk_class iTunes
DetectHiddenWindows, Off
return

^#left::
DetectHiddenWindows, On
ControlSend, ahk_parent, ^{left}, iTunes ahk_class iTunes
DetectHiddenWindows, Off
return

^#space::
DetectHiddenWindows, On
ControlSend, ahk_parent, {space}, iTunes ahk_class iTunes
DetectHiddenWindows, Off
return

^#up:: Send {Volume_Up}
^#down:: Send {Volume_Down}
^#.:: Send {Volume_Mute}

; end iTunes
