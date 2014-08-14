HiddenDOSCommand "dir > %temp%\\hiddencmdout.tmp" startpath:"c:\\" 
cmd = "echo The time is " + localTime + " >> %temp%\\hiddencmdout.tmp"
HiddenDOSCommand cmd
HiddenDOSCommand "notepad %temp%\\hiddencmdout.tmp" prompt:"Waiting for Notepad to exit" donotwait:true
System
HiddenDOSCommand "del %temp%\\hiddencmd.tmp" donotwait:true
(
	local ae="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
	HiddenDOSCommand (ae as string) donotwait:true

)