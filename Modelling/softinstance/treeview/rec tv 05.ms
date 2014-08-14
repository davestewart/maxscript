fileIn "bmpArr.ms"
fileIn "classArr.ms"

if  (getCurrentSelection()).count==0 then
	(
	if (NOT isvalidnode b) then
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
	/*
	*/
		select b
		)
	)
if test!=undefined then destroydialog test
	
--------------------------------------------------------


	rollout test "Copy Properties" width:512 height:584
		(

-- declarations

		local obj, replaceAll
--		local tvNode, d, i, index
		
		local classArr=#(), bmpArr=#()
		
		local initTreeView, initImageList
		local recurseSubAnims
		
		local getSAStringFromNode


	-- user interface 
		ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:400 height:590
		--activeXControl axImgList "MSComctlLib.ImageListCtrl.2" width:1 height:1 pos:[-50,-50]

		activeXControl axImgList "{2C247F23-8591-11D1-B16A-00C0F0283628}" height:0 width:0 pos:[-50,-50]

		label lbl1 "Label" pos:[5,615] width:400 height:15
	
		spinner spn1 "" pos:[5,630] range:[1,500,1] width:48 height:16 type:#integer
		label lbl2 "Label" pos:[64,630] width:264 height:16
		button btn1 "Init" width:32 height:32

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




-- treeview functions

		fn initImageList=
			(
			--messageBox "initImageList()"
			-- set variables
				local bmpRel ="icons\\final\\"
				local j=0
				local iconStr=""
			-- start the loop
				for i = 1 to libraryClassArr.count do
					(
					try (
					-- get and load the bitmap file
						local bmpFile =bmpRel + libraryBmpArr[i]
						axImgList.listimages.Add (j+=1) "" (LoadPicture bmpFile)

					-- update local array with classname
						append classArr libraryClassArr[i]

					-- update ebug info
						iconStr+=(pad j 3) +" | "+ libraryClassArr[i] +" | "+ libraryBmpArr[i] +"\n"
						)
					catch(j-=1)
					)
			-- write debug info
				--format "%" iconStr to:(win=newScript())
				--format "libraryClassArr.count:%\nj:%\n" libraryClassArr.count j to:win
			)


		fn initTreeView tv singleSel=
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
				tv.font="Tahoma"
				tv.font.size=7

			-- associate imagelist with treeview
			--format ">>>>>>>%\n" imageList.count
				--tv.ImageList=axImgList

			)



-- utility functions when adding nodes



	fn getClassFromSAString SAStr =
		(
		local maxobj = execute("exprformaxobject " +saStr)
		local class =  classof (execute(maxObj)) as string
		return class
		)


	fn getSAStringFromNode tvNode =
		(
		-- set up variables
			local nodeArr=#()
			local saStr="$"

		-- work up tree and add index to array
			while tvNode.parent!=undefined do
				(
				append nodeArr (tvNode.tag as Integer)
				tvNode=tvNode.parent
				)
		
		-- reverse, convert and return Array

			--deleteItem nodeArr 1
			nodeArr= reverseArray nodeArr
			for n in nodeArr do saStr+="["+n as string+"]"
			format"%\n" saStr
			return saStr

		)


	fn getIconIndex tvNode =
		(
		--format ">>%\n" obj
		local iconIndex=axImgList.ListImages.Count
		local class=""
		local saStr = getSAStringFromNode tvNode
		try(
			--local sa = (getSAStringFromNode tvNode)
			--local class = (getSubAimName sa i) as string
			--local class = execute ("classof "+execute("exprformaxobject " +saStr))
			class = getClassFromSAString saStr
			--format"%\n" class
			iconIndex= findItem classArr class
			)
		catch()
		--format"%\n" saStr
		return iconIndex
		)


	fn getIconIndex2 sa i=
		(
		local iconIndex, lastIcon, class
		lastIcon = axImgList.ListImages.Count
		iconIndex=lastIcon 
/*		local class=
		local saStr = getSAStringFromNode tvNode
		try(
			--local sa = (getSAStringFromNode tvNode)
			--local class = (getSubAimName sa i) as string
			--local class = execute ("classof "+execute("exprformaxobject " +saStr))
			class = getClassFromSAString saStr
			--format"%\n" class
			iconIndex= findItem classArr class
			)
		catch()
		--format"%\n" saStr
*/
		try	(
			class=(classof (getSubAnim sa i).object) as string
			format "%\n" sa as string
			iconIndex= findItem classArr class
			if iconIndex==0 then iconIndex=lastIcon 
			return iconIndex
			)
		catch(
			return iconIndex
			)
		)





-- main recursive function

		fn recurseSubAnims sa tv tvNode d=
			(
			d+=1
			for i = 1 to sa.numSubs do
				(

			 -- flag if not visibility, transform, modified object or material
				local oktoBuild=true
				if d==1 AND (i<3 OR i>5) then oktobuild=false

			-- build the nodes
				if oktobuild == true then
					(
				-- build the node
					newNode = tv.nodes.add tvNode.index 4 ""

				-- update node properties
					-- text
						local nodeText = (getSubAnimName sa i) as string
						nodeText=replaceAll nodeText "_" " "
						newNode.text = nodeText

					-- expanded
						if d!=2 then newNode.expanded=true
						
					-- tag
						-- important to set this before creating the image!
						-- as the tag holds the depth, and therefore, path info
						newNode.tag=i as string

					-- icon
						--local nodeIcon = getIconIndex newNode
						local nodeIcon = getIconIndex2 sa i
						newNode.image=nodeIcon 
					
					-- reupdate text
						--newNode.text = nodeText + " ("+classArr[nodeIcon]+")"

				-- do children
					recurseSubAnims sa[i] tv newNode d
					)
				)
			)

/*
	.Add
		Relative:undefined 
		Relationship:undefined 
		Key:undefined 
		Text:undefined 
		Image:undefined 
		SelectedImage:undefined
*/




	function populate tv obj =
		(
		-- clear
			tv.nodes.clear()
		
		-- get node and set up tv
			local newNode = tv.nodes.add()
			newNode.text = obj.name as string
			newNode.tag=1
			local class = (classof $.baseobject) as string
			local iconIndex=(findItem classArr class)
			newNode.Image=iconIndex
			newNode.expanded=true

		-- do the rest
			recurseSubAnims obj tv1 newNode 0
		)


-- rollout handlers
	
	on test open do
		(

		-- TIMESTAMP
			t1=timestamp()
	
		-- DO ICONS
			--messagebox "Calling initImageList()"
			initImageList()
			--messagebox "tv1.ImageList=axImgList"
			tv1.ImageList=axImgList
	
		-- STYLE TREE
			initTreeView tv1 true
	
		-- POPULATE TREEVIEWS
			populate tv1 $
	
		-- TIMESTAMP
			t2=timestamp()
			t=(t2-t1)/1000 as float
			format "Processing took % seconds\n" t
	
	-- END
		)


	
	on tv1 NodeClick tvNode do
		(
		-- update the label
			lbl1.text = tvNode.fullpath

		-- get the max object
			local sa = getSAStringFromNode tvNode
			--local class = (getClassFromSAString(sa))
			--local iconIndex= findItem classArr (class as string)
			format "% %\n" (pad iconIndex 3) sa
--			tvNode.image = iconIndex
		
		)

	
	)

createdialog test 410 650 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
