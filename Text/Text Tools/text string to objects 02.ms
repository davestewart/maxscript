-- string to array
	str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	arr = for i = 1 to str.count collect substring str i 1
	

-- create text objects
	for i = 1 to arr.count do 
	(
		t = text text:(arr[i] as string)font:"Times New Roman" name:("text-" + arr[i] as string)
		t.size = 50
		t.steps = 1
		t.pos.z = i * 1
	)
	
-- group and extrude
	select $text*
	modPanel.addModToSelection (Extrude amount:1) ui:on
	group $ name:"Text Group"
	