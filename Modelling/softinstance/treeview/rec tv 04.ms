/*
*/
if (NOT isvalidnode b) OR $.count>0 then
(
	b=box()
	addModifier b (Bend ())
	addModifier b (Taper ())
	addModifier b (Twist ())
	addModifier b (Noisemodifier ())
	addModifier b (Stretch ())
	addModifier b (Squeeze ())
	addModifier b (Push ())
	addModifier b (Relax ())
	addModifier b (Ripple ())
	addModifier b (Wave ())
	addModifier b (Skew ())
	addModifier b (SliceModifier ())
	addModifier b (Spherify ())
	addModifier b (Affect_Region ())
	addModifier b (Lattice ())
	addModifier b (Mirror ())
	addModifier b (Displace ())
	addModifier b (XForm ())
	addModifier b (Preserve ())
	b.material = meditmaterials[1]
	select b
)
destroydialog test
	
--------------------------------------------------------


	rollout test "Copy Properties" width:512 height:584
	(
		local addToTreeView
		local obj, replaceAll
		local addNode, obj, tv, tvNode, d, i, index


		fn replaceAll str outStr inStr =
		(
			-- str the original string
			-- the string/character to replace
			-- the replacement string/character
			
			origStr=str
			while ((n=findstring str outStr) != undefined) do str = replace str n inStr.count inStr
			if str != undefined then return str
			else return origStr
		)

		fn setUpTreeView tv obj=
		(
			tv.nodes.Clear()
			addToTreeView tv obj false
			local n = tv.nodes[1].LastSibling.index
			tv.selectedItem = tv.nodes[n]
		)


		fn addNode obj tv tvNode d i =
		(
		)
	
		fn recurseSubAnims obj tv tvNode d=
		(
			n = obj.numSubs
			d+=1
			for i = 1 to n do
			(
			 -- flag if not visibility, transform, modified object or material
				local oktoBuild=true
--				if d==1 AND ((i>1 AND i<3) OR i>5) then
				if d==1 AND (i<3 OR i>5) then
				(
					oktobuild=false
					--format " stopping on %\n" (getSubAnimName obj i)
				)
			-- build the nodes
				if oktobuild == true then
				(
--					addNode obj tv tvNode d i

					--format "%\n" tvNode.text
					local nodeText = ((getSubAnimName obj i) as string)
					nodeText=replaceAll nodeText "_" " "
					local imageIndex = 1	--random 1 37
					newNode = tv.nodes.add tvNode.index 4 "" nodeText 1	--(random 1 37)
				  	/*
						.Add
							Relative:undefined 
							Relationship:undefined 
							Key:undefined 
							Text:undefined 
							Image:undefined 
							SelectedImage:undefined
					*/

					if d!=2 then newNode.expanded=true
					newNode.tag=i as string
					--newNode.image= random 1 37

					recurseSubAnims obj[i] tv newNode d
				)
			)
		)



		fn reverseArray inArr =
		(
			local outArr = #()
			while inArr.count > 0 do
			(
				append outArr inArr[inArr.count]
				deleteItem inArr inArr.count
			)
			return outArr
		)

		fn getSubAnimArray nodeArr =
		(
			local str=""
			for n in nodeArr do str+="["+n as string+"]"
			return str
		)


	ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:400 height:590
	ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[405,5] width:400 height:590
	activeXControl il "MSComctlLib.ImageListCtrl.2" width:1 height:1 pos:[-50,-50]-- imagelist control
	label lbl1 "Label" pos:[5,615] width:400 height:15

	spinner spn1 "" pos:[5,630] range:[1,500,1] width:48 height:16 type:#integer
	label lbl2 "Label" pos:[64,630] width:264 height:16
	

		--local bmproot = (getdir #scripts + "\\_blurScripts\\Scene_Explorer\\")
		local bmproot = ("E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\final\\")

		fn styleTreeView tv singleSel=
		(
			-- linestyles
				tv.lineStyle = #tvwRootLines
				tv.lineStyle = #tvwTreeLines
				--tv.Checkboxes= true
				tv.BorderStyle=#ccFixedSingle
				tv.Appearance=#ccFlat
				tv.LabelEdit=#tvwManual
				tv.style = #tvwTreelinesPlusMinusText
				tv.style = #tvwTreelinesPlusMinusPictureText
				tv.SingleSel=false--singleSel
				tv.PathSeparator = "\\"
				tv.indentation=0
				tv.fullrowselect=false


			-- images
			/*
				il.listimages.Add 1 "" (LoadPicture ( bmproot + "FldrClosed.BMP"))
				il.listimages.Add 2 "" (LoadPicture ( bmproot + "FldrOpen.BMP"))
				il.listimages.Add 3 "" (LoadPicture ( bmproot + "Drive.BMP"))
				il.listimages.Add 4 "" (LoadPicture ( bmproot + "sound.BMP"))
				il.listimages.Add 5 "" (LoadPicture ( bmproot + "Obj_Geom.BMP"))
				il.listimages.Add 6 "" (LoadPicture ( bmproot + "Obj_Shape.BMP"))
				il.listimages.Add 7 "" (LoadPicture ( bmproot + "Obj_Light.BMP"))
				il.listimages.Add 8 "" (LoadPicture ( bmproot + "Obj_Camera.BMP"))
				il.listimages.Add 9 "" (LoadPicture ( bmproot + "Obj_Helper.BMP"))
				il.listimages.Add 10 "" (LoadPicture ( bmproot + "Materials.BMP"))
				il.listimages.Add 11 "" (LoadPicture ( bmproot + "Layer.BMP"))
				il.listimages.Add 12 "" (LoadPicture ( bmproot + "world.BMP"))
				il.listimages.Add 13 "" (LoadPicture ( bmproot + "lines.BMP"))
				il.listimages.Add 14 "" (LoadPicture ( bmproot + "maxfile.BMP"))
				il.listimages.Add 15 "" (LoadPicture ( bmproot + "maxcube.BMP"))
				il.listimages.Add 16 "" (LoadPicture ( bmproot + "Obj_Bip.BMP"))
				il.listimages.Add 1 "" (LoadPicture ( bmproot + "Standard_Modifiers_01.bmp"))
				il.listimages.Add 2 "" (LoadPicture ( bmproot + "Standard_Modifiers_01.bmp"))
				il.listimages.Add 3 "" (LoadPicture ( bmproot + "Standard_Modifiers_02.bmp"))
				il.listimages.Add 4 "" (LoadPicture ( bmproot + "Standard_Modifiers_03.bmp"))
				il.listimages.Add 5 "" (LoadPicture ( bmproot + "Standard_Modifiers_04.bmp"))
				il.listimages.Add 6 "" (LoadPicture ( bmproot + "Standard_Modifiers_05.bmp"))
				il.listimages.Add 7 "" (LoadPicture ( bmproot + "Standard_Modifiers_06.bmp"))
				il.listimages.Add 8 "" (LoadPicture ( bmproot + "Standard_Modifiers_07.bmp"))
				il.listimages.Add 9 "" (LoadPicture ( bmproot + "Standard_Modifiers_08.bmp"))
				il.listimages.Add 10 "" (LoadPicture ( bmproot + "Standard_Modifiers_09.bmp"))
				il.listimages.Add 11 "" (LoadPicture ( bmproot + "Standard_Modifiers_10.bmp"))
				il.listimages.Add 12 "" (LoadPicture ( bmproot + "Standard_Modifiers_11.bmp"))
				il.listimages.Add 13 "" (LoadPicture ( bmproot + "Standard_Modifiers_12.bmp"))
				il.listimages.Add 14 "" (LoadPicture ( bmproot + "Standard_Modifiers_13.bmp"))
				il.listimages.Add 15 "" (LoadPicture ( bmproot + "Standard_Modifiers_14.bmp"))
				il.listimages.Add 16 "" (LoadPicture ( bmproot + "Standard_Modifiers_15.bmp"))
				il.listimages.Add 17 "" (LoadPicture ( bmproot + "Standard_Modifiers_16.bmp"))
				il.listimages.Add 18 "" (LoadPicture ( bmproot + "Standard_Modifiers_17.bmp"))
				il.listimages.Add 19 "" (LoadPicture ( bmproot + "Standard_Modifiers_18.bmp"))
				il.listimages.Add 20 "" (LoadPicture ( bmproot + "Standard_Modifiers_19.bmp"))
				il.listimages.Add 21 "" (LoadPicture ( bmproot + "Standard_Modifiers_20.bmp"))
				il.listimages.Add 22 "" (LoadPicture ( bmproot + "Standard_Modifiers_21.bmp"))
				il.listimages.Add 23 "" (LoadPicture ( bmproot + "Standard_Modifiers_22.bmp"))
				il.listimages.Add 24 "" (LoadPicture ( bmproot + "Standard_Modifiers_23.bmp"))
				il.listimages.Add 25 "" (LoadPicture ( bmproot + "Standard_Modifiers_24.bmp"))
				il.listimages.Add 26 "" (LoadPicture ( bmproot + "Standard_Modifiers_25.bmp"))
				il.listimages.Add 27 "" (LoadPicture ( bmproot + "Standard_Modifiers_26.bmp"))
				il.listimages.Add 28 "" (LoadPicture ( bmproot + "Standard_Modifiers_27.bmp"))
				il.listimages.Add 29 "" (LoadPicture ( bmproot + "Standard_Modifiers_28.bmp"))
				il.listimages.Add 30 "" (LoadPicture ( bmproot + "Standard_Modifiers_29.bmp"))
				il.listimages.Add 31 "" (LoadPicture ( bmproot + "Standard_Modifiers_30.bmp"))
				il.listimages.Add 32 "" (LoadPicture ( bmproot + "Standard_Modifiers_31.bmp"))
				il.listimages.Add 33 "" (LoadPicture ( bmproot + "Standard_Modifiers_32.bmp"))
				il.listimages.Add 34 "" (LoadPicture ( bmproot + "Standard_Modifiers_33.bmp"))
				il.listimages.Add 35 "" (LoadPicture ( bmproot + "Standard_Modifiers_34.bmp"))
				il.listimages.Add 36 "" (LoadPicture ( bmproot + "Standard_Modifiers_35.bmp"))
				il.listimages.Add 37 "" (LoadPicture ( bmproot + "Standard_Modifiers_36.bmp"))
			*/
/*
*/
			-- bind imagelist 6o treeview
				tv.imagelist = il


		)


	local prevNode, curNode

	fn nodeArrToSaArr arr=
	(
		local str="$"
		for n in arr do str+="["+n as string+"]"
		return str
	)
	
	on tv1 NodeClick Node do
	(
			prevNode=curNode
			curNode = tv1.selectedItem
			
			prevNode.bold=false
			curNode.bold=true
			--curNode.backcolor = (color 200 200 200)
		-- update the label
			lbl1.text = Node.fullpath

		-- get the max object
			local inode = Node
			local nodeArr=#()
			
			while inode.parent!=undefined do
			(
				append nodeArr (inode.tag as Integer)
				inode=inode.parent
			)
			
			nodeArr= reverseArray nodeArr
			format "%\n" (nodeArrToSaArr nodeArr)
	
			local subAnimArr = getSubAnimArray nodeArr
			local subAnimObj = execute("$"+subAnimArr)
	
			format "%\n" (exprformaxobject subAnimObj)
		
	)
	
	on test open do
	(


	fn pad num padLength =
	(
		num=num as string
		while num.count < padLength do num = ("0"+num)
		return num
	)

-- INSERT IMAGES
	il.listimages.Add 1 "" (LoadPicture ( bmproot + "Standard_Modifiers_01.bmp"))

	include "icons\\iconLibraryDiscreet.ms"
	bmpRel ="icons\\final\\"
	bmpRoot= "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\final\\"

	local localIcons=#()

	j=0
	for i = 1 to iconLibrary.count do
	(
		try (
			local iconData=iconLibrary[i]
			local bmpFile = bmproot + iconData[2] + "_" + (pad iconData[3] 2)+ ".bmp"
			format "%\n" bmpFile
			--bmpFile="E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\final\\"
			il.listimages.Add (j+=1) "" (LoadPicture bmpFile)
			append localIcons libraryIcons[i]
		)
		catch(j-=1)
	)
		
	format "i:%\nj:%\n" i j







		t1=timestamp()
		styleTreeView tv1 true
		styleTreeView tv2 true

		obj=$
		local newNode = tv1.nodes.add()
		newNode.text = obj.name as string
		newNode.expanded=true
		recurseSubAnims obj tv1 newNode 0

		local newNode = tv2.nodes.add()
		newNode.text = obj.name as string
		newNode.expanded=true
		recurseSubAnims obj tv2 newNode 0
/*		
		recurseSubAnims obj tv1 tv1.nodes 1
*/
--		local newNode = tv1.nodes.add()

		prevNode=tv1.nodes[1]
		curNode=tv1.nodes[1]
		t2=timestamp()
		t=(t2-t1)/1000 as float
		format "Processing took % seconds\n" t
		test.tv2.font=""
		test.tv2.font.italic=false
		test.tv2.font.size=8
		test.tv2.font.bold=false


		test.tv1.selectedItem
		test.tv1.font="Tahoma"
		test.tv1.font.italic=false
		test.tv1.font.size=7.5
		test.tv1.font.bold=false


	)


		on test resized size do
		(
			tv1.size.x = size.x/2 - 4
			tv1.size.y = size.y - 50

			tv2.size.x = size.x/2 - 4
			tv2.size.y = size.y - 50
			tv2.pos.x  = size.x/2 +4

		)
			
		on spn1 changed val do
		(
			if val <= il.ListImages.count then
			(
				tv1.nodes[1].image=val
				lbl2.text = localIcons[val][1]
			)
			else spn1.value=il.ListImages.count
		)
	
)

createdialog test 810 660 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
--show test.size

test.width