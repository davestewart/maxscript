rollout roSpaceText "Text spacer" width:296 height:56
(
	-- interface
		editText edtText "" pos:[47,8] width:240 height:16 text:"This is some text..."
		spinner spnSpacing "Spacing " pos:[34,32] width:70 height:16 type:#float range:[0,1000,20]
		label lblText "Text" pos:[8,8] width:40 height:16
		button btnGo "Go..." pos:[112,32] width:176 height:16
	
	-- script
	
		fn pad n len=
		(
			n = n as string
			while n.count < len do n = "0" + n
			return n
		)
	
		on btnGo pressed do
		(
			-- start
				sel = (getCurrentSelection())[1]
				if classof sel != text then
				(
					messagebox "No text selected. Using default font, size and position..."
					sel = text()
				)
				txtObjects = #(sel)
				txtObjectsToDelete = #()

			-- vars
				str = edtText.text
				j=1
				txt1=sel
				txt1.text=str[1]
				txt1.name = "Char " + (pad j (str.count as string).count) + " - " + str[1]
	
			-- do it
				for i = 2 to str.count do
				(
					-- new object
						txt2=copy txt1
						
					-- text
						if str[i] != " " then
						(
							txt2.text = str[i]
							j+=1
						)
						 else txt2.text = "i"
						
					-- position
						w=txt2.max.x-txt2.min.x
						in coordsys txt1 txt2.pos.x = txt1.max.x+(w/2)+spnSpacing.value
						
					-- tidy
						txt2.wireColor=txt1.wireColor
						txt2.name = "Char " + (pad j (str.count as string).count) + " - " + str[i]
					-- next
						txt1=txt2
						if str[i] == " " then append txtObjectsToDelete txt2
						else append txtObjects txt2
				)
				-- finish
					delete txtObjectsToDelete 
					select txtObjects
		)

)


createdialog roSpaceText

