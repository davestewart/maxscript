format "str is %\n" str
fileIn "testFileIn.ms" quiet:true

include "testFileIn.ms"
setListenerSel #(0,-1)
global ListenerText -- declare variable so its scope is higher 
	(
	setListenerSel #(0,-1) -- select all the text 
	ListenerText=getListenerSelText() -- get selected text 
	setListenerSel #(-1,-1) -- set insertion point at 
	) 
clearListener()

setListenerSelText ListenerText 
