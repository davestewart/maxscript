--------------------------------------------------------- 
-- creates an IE browser control in a rollout and registers it as extended 
-- viewport. Pick "Web Page" from the Extended Views 
-- menu to display the rollout in the webpage. Also click various hypertext links 
-- to see the text change in the viewports 
--------------------------------------------------------- 
rollout rWebpage "Web page" 
( 
	--activeXControl ax "www.yahoo.com" height:100 width:100 align:#center 
	--"<html><head><meta http-equiv=refresh content=0;URL=VMSTidy.html></head><body></body></html>"
	--activeXControl ax "file://E:/03_Scripting/3ds2ae/03_3ds/interface/rollout reorder/VMSTidy.html" pos:[4,4 ]height:600 width:400

activeXControl ax "MSHTML:<HTML><BODY>This is a line of text</BODY></HTML>" pos:[4,4 ]height:600 width:400


) 
fWebPage = newRolloutFloater "Web page" 425 650 10 10
addRollout rWebPage fWebPage 
showProperties rWebpage.ax 





f=(openfile "VMSTidy.html")
str=f as string
str = substring str 7 (str.count-7)
while (i=findstring str "\\") != undefined do str=replace str i 1 "/"

execute("rollout roVMSTidyHelp \"VMS Tidy Help\"(activeXControl ax \"file://"+str+"\" pos:[4,6] width:400 height:600)")

createdialog roVMSTidyHelp 410 612
flush f
close f
