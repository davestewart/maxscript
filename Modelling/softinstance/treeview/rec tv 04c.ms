fileIn "bmpArr.ms"
fileIn "classArr.ms"

if (NOT isvalidnode b) OR $.count>0 then
(
	b=box()
	addModifier b (Bend ())
	addModifier b (Taper ())
	addModifier b (Twist ())
/*
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
*/
	select b
)
destroydialog test
	
--------------------------------------------------------


	rollout test "Copy Properties" width:512 height:584
	(

	-- user interface 
		ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:400 height:590
		--ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[405,5] width:400 height:590
		activeXControl il "MSComctlLib.ImageListCtrl.2" width:1 height:1 pos:[-50,-50]-- imagelist control
		label lbl1 "Label" pos:[5,615] width:400 height:15
	
		spinner spn1 "" pos:[5,630] range:[1,500,1] width:48 height:16 type:#integer
		label lbl2 "Label" pos:[64,630] width:264 height:16

-- declarations

		local addToTreeView
		local obj, replaceAll
		local addNode, obj, tv, tvNode, d, i, index
		
		local classArr=#(), bmpArr=#()
		
		local setUpTreeView, styleTreeView, recurseSubAnims


-- utility functions
		fn pad num padLength =
		(
			num=num as string
			while num.count < padLength do num = ("0"+num)
			return num
		)
	

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



-- advanced utility functions

		fn getSubAnimArray nodeArr =
		(
			local str=""
			for n in nodeArr do str+="["+n as string+"]"
			return str
		)


		fn nodeArrToSaArr arr=
		(
			local str="$"
			for n in arr do str+="["+n as string+"]"
			return str
		)

-- treeview functions

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


		fn styleTreeView tv singleSel=
		(
				messagebox "styule"
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

			-- bind imagelist 6o treeview
				tv.imagelist = il
		)


-- main recursive function

		fn recurseSubAnims obj tv tvNode d=
		(
			/*
			*/
			local iconIndex
			try(
				local class = (execute("classof "+exprformaxobject obj))
				
				iconIndex = findItem classArr (class as string)
				--iconIndex =localIcons [(findItem localIcons class)]
				format "%\n" iconIndex
			)
			catch()
			--iconIndex=50
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
					--iconIndex= 1
					newNode = tv.nodes.add tvNode.index 4 "" nodeText iconIndex
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




		-- SET UP NODE CLICKS
		local prevNode, curNode




-- rollout handlers
	
	on test open do
	(
	
	-- INSERT IMAGES
		-- set variables
			bmpRel ="icons\\final\\"
			bmpRoot= "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\final\\"
			j=0
		-- start the loop
			for i = 1 to libraryClassArr.count do
			(
				try (
				-- set the bitmap file
					local bmpFile = libraryBmpArr[i]
					bmpFile="E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\final\\"+bmpFile
					il.listimages.Add (j+=1) "" (LoadPicture bmpFile)
					--format "%\n" libraryClassArr[i]
					append classArr libraryClassArr[i]
				)
				catch(j-=1)
			)
				
			format "i:%\nj:%\n" i j
	
	-- TIMESTAMP
			t1=timestamp()
	
	
	-- STYLE TREE
			styleTreeView tv1 true
			--styleTreeView tv2 true
	
	
	-- POPULATE TREEVIEWS
	
			obj=$
			local newNode = tv1.nodes.add()
			newNode.text = obj.name as string
			newNode.expanded=true
			recurseSubAnims obj tv1 newNode 0
	/*		
	
			local newNode = tv2.nodes.add()
			newNode.text = obj.name as string
			newNode.expanded=true
			recurseSubAnims obj tv2 newNode 0
			recurseSubAnims obj tv1 tv1.nodes 1
	*/
	--		local newNode = tv1.nodes.add()
	
	

			prevNode=tv1.nodes[1]
			curNode=tv1.nodes[1]
	
	
	-- TIMESTAMP
	
			t2=timestamp()
			t=(t2-t1)/1000 as float
			format "Processing took % seconds\n" t
	
	
	-- END
	)

	fn getMaxObject Node =
	(
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


-- treeview handlers

	
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
	
	)

	
)

createdialog test 410 650 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
--show test.size

test.width