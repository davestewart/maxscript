str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
arr = for i = 1 to str.count collect substring str i 1


for a in arr do 
(
	t = text text:a font:"Times New Roman" name:("text-" + a)
)


select $text*
modPanel.addModToSelection (Extrude amount:1) ui:on

for i = 1 to $.count do
(
	obj = $[i]
	obj.baseobject.size = 50
	obj.baseobject.steps = 1
	obj.pos.z = i * 1
)
	
group $ name:"Text Group"
