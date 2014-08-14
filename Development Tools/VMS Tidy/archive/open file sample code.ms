--s=newScript()

--s as string

str="rollout roTest \"Untitled\" width:100 height:100
(
"+s as string+"
)"

execute str

createDialog roTest


s=openFile 

openFile <filename_string> [ mode:<mode_string> ] 
s = getOpenFileName caption:"Open files" types:"MaxScript Files|*.ms"

getOpenFileName [ caption:<title> ] \ 
[ filename:<seed_filename_string> ] \ 
[ types:<description1>|<pattern1>|<description2>|<pattern2>|...| ] 
print s
uiTidyTestRo=undefined