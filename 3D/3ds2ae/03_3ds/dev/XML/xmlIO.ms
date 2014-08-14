-------------------------------------------------------------------------------
--   
--  File:			rolloutCreator.ms
--  Description:	Helper struct and routines for loading/saving xml data into Max
--  By:				Ravi Karra [Discreet] 			ravi.karra@discreet.com
--	
-- Version:			1.3
-- Note:			DO NOT LOCALIZE
-------------------------------------------------------------------------------
global ___obj = ""
rollout rxmlIO "XML" silenterrors:true
( 
	local init = true
	activeXControl axXMLCreate "MSXML.DOMDocument" setupEvents:false releaseOnClose:false
	activeXControl axXMLRead "MSXML.DOMDocument" setupEvents:false releaseOnClose:false
	on rxmlIO open do init = false
)
struct sxmlIO
(
	xmlCtrlDocName, 
	xmlDoc,
	xmlCtrlDoc,
	world,
	subAnims2xml_fn,
	xml2subAnims_fn,
	exec_time,
	create_time,
	animatedOnly,
	is_ik_ctrl,
	tmc_class,
	class_of = "classOf",
	sclass_of = "superClassOf",		
	wireParams = #(#numWires, #isMaster, #isSlave, #isTwoWay, #slaveAnimation),
	no_key_frames = false,
	------------------------------------------------------------------------------------
	-- general purpose functions
	------------------------------------------------------------------------------------
	fn exec str = 
	(
		local st = timeStamp()
		local val = execute str
		exec_time += timeStamp() - st
		val
	),
	fn getAttribute xmlNode attr = 
	(
		local attr_node = xmlNode.attributes.getNamedItem (attr as string)
		if attr_node != undefined then attr_node.nodevalue else ""
	),
	fn isAnimated subAnim =
 	(
		local animated = false
		try 
		( 
			animated = subAnim.isAnimated
			if animated then return true
			for i = 1 to (custAttributes.count subAnim) do
			(
				local ca = custAttributes.get subAnim i
				for s = 1 to ca.numSubs do
					if ca[s].isAnimated then return true				
			)
			local bobj = subAnim.baseobject
			for i = 1 to bobj.numSubs do
				if bobj[i].isAnimated then return true
		)
		catch 
		( 
			try (
				if subAnim.controller != undefined do
					animated = subAnim.controller.isAnimated
				) catch()
		)
		animated
	),
	fn string2value str xmlElem: = 
	(
		if xmlElem == unsupplied then
			exec str
		else
		(
			local cls = (getAttribute xmlElem class_of) as name
			case cls of
			(
				#undefinedClass: undefined
				#booleanClass: 	str == "true"
				#float:			str as float
				#integer:		str as float
				#point3: 		( local a = filterString str "[,]"; [a[1] as float , a[2] as float, a[3] as float])
				#string:		str
				#name:			str
				default: 		exec str
			) 
		)			
	),
	-- tempObjs temporary array of objects filled by this function and ***MUST*** be freed by caller
	fn create xmlElem hide:true tempObjs:(#()) tmElem:undefined = 
	(	
		local st = timeStamp()
		local cls = getAttribute xmlElem class_of
		local name = getAttribute xmlElem #name
		local ins
--		try
		(
			if cls == "DummyChannel" or cls == "On_Off" do return undefined
			if cls == "Circle" then ins = Circle hidden:true
			else if cls == "Point" then ins = Point hidden:true
			else if cls == "line" then ins = Line hidden:true
			else case cls of
			(
				"SplineShape":
				(
					ins = circle isHidden:hide
					convertTo ins SplineShape
				)
				"Editable_mesh":
				(
					ins = box isHidden:hide
					convertTo ins Editable_mesh
				)
				"Editable_Patch":
				(
					ins = box isHidden:hide
					convertTo ins Editable_Patch
				)
				"Editable_Poly":
				(
					ins = box isHidden:hide
					convertTo ins Editable_Poly	
				)
				"NURBSSurf":
				(
					ins = box isHidden:hide
					convertTo ins NURBSSurf
				)
				"BoneGeometry":
				(
					ins = boneSys.createBone [0,0,0] [10,10,10] z_axis
					ins.isHidden = hide
				)
				"IK_Chain_Object":
				(
					local boneC = boneSys.createBone [0,0,0] [10,10,10] z_axis
					local boneP = boneSys.createBone [10,10,10] [20,20,20] z_axis
					boneC.parent = boneP
					ins = ikSys.ikchain boneP boneC "IKLimb"
					ins.isHidden = hide
					append tempObjs boneC; append tempObjs boneP
				)
				"Sunlight_Daylight_Slave_Controller":
				(
				)				
				default:
				(
--					ins = createInstance (string2value cls xmlElem:xmlElem)
					try(
						ins = execute (cls + "()")
					) catch(format "Not Creatable: %\n" cls; return undefined)
				)
			)
			if name != undefined and name != "" do ins.name = name
			if tmc_class == "IKControl" then
			(
				local boneP = boneSys.createBone [10,10,10] [20,20,20] z_axis					
				ins.parent = boneP
				local ikC = ikSys.ikchain boneP ins "IKLimb"					
				append tempObjs boneP; append tempObjs ikC
			)
			create_time += timeStamp() - st
			ins
		)
		/*catch 
		(
			--format "  Cannot successfully create % of type %\n" name cls
			undefined
		)*/
	),	
	-- creates a new element in the addons element category
	fn newAddOn parentElem tagName =
	(
		local addonElem = parentElem.selectSingleNode "addons"
		if addonElem == undefined then
		(
			addonElem = xmlDoc.createElement "addons"
			parentElem.appendChild addonElem
		)
		local newElem = xmlDoc.createElement tagName
		addonElem.appendChild newElem
		newElem
	),
	fn getAddon parentElem tagName =
	(
		parentElem.selectSingleNode ("addons/" + tagName)
	),
	------------------------------------------------------------------------------------
	-- max 2 xml functions
	------------------------------------------------------------------------------------	
	fn array2xml arr arrElem =
	(
		local str
		if isValidNode arr[1] then
		(
			arrElem.setAttribute "type" "object"
			str = "#("
			for i=1 to (arr.count-1) do str += "$" + arr[i].name + ","
			if arr.count > 0 then str += "$" + arr[arr.count].name
			str += ")"
		)
		else
		(
			if arr.count > 20 then
			(
				str = "#("
				for i=1 to (arr.count-1) do str += arr[i] as string + ","
				if arr.count > 0 then str += arr[arr.count] as string
				str += ")"				
			)
			else
				str = arr as string
		)
		arrElem.text = str
	),
	-- TODO: support param wiring 
	fn wire2xml ctrl ctrlElem = 
	(
		wireParams
	),
	fn cas2xml fromAnim animElem =
	(
		local casElem =  xmlDoc.createElement "customAttributes"
		animElem.appendChild casElem
		for c = 1 to (custAttributes.count fromAnim) do
		(
			local def = custAttributes.getDef fromAnim c
			local fca = custAttributes.get fromAnim c
			
			local caElem = xmlDoc.createElement "customAttribute"
			local defElem = xmlDoc.createElement "definition"
			casElem.appendChild caElem
			caElem.appendChild defElem
			
			-- add the definition source			
			defElem.text = (custAttributes.getDefSource def)
			
			-- now output the property values
			subAnims2xml_fn fca caElem
		)
	),
	fn ctrl2xml ctrl animElem =
	(
		-- create an element for the controller
		local ctrlElem =  xmlDoc.createElement "controller"
		ctrlElem.setAttribute "classOf" ((classOf ctrl) as string)
		animElem.appendChild ctrlElem
		
		subAnims2xml_fn ctrl ctrlElem
		if not no_key_frames and ctrl.keys.count > 0 then 
		(
			-- read keyproperties from "controller.xml"
			xmlCtrlDoc.load xmlCtrlDocName -- hack! to reset the iterator
			local kpElem = xmlCtrlDoc.selectSingleNode ("//controller[@classOf='" + (classOf ctrl) as string + "']/key")
			
			if kpElem != undefined then
			( 
				local keyMap = kpElem.attributes
				local keysElem = xmlDoc.createElement "keys"
				ctrlElem.appendChild keysElem
				for ky in ctrl.keys do
				(
					for k=0 to (keyMap.length-1) do 
					( 
						local pp = (getProperty ky keyMap[k].nodename)						
						keyMap[k].text = if (classof pp) ==  Name then ("#" + pp as string) else (pp as string)
					) 
					keysElem.appendChild (kpElem.cloneNode true)
				)
			)
--			else format "node controller info for :%\n" (classof ctrl)
		)
		else
		(
			local valueElem =  newAddOn ctrlElem "value"
			valueElem.setAttribute class_of ((classOf ctrl.value) as string)
			valueElem.text = ctrl.value as string
		)
		
	),
	fn subAnims2xml anim animElem =
	(
		local subanims
		try(
		 subanims = getPropNames anim --getSubAnimNames anim
		 )catch ( return() )
		local propsElem = xmlDoc.createElement "properties"
		animElem.appendChild propsElem
		
		for i = 1 to subanims.count do
		(
			local prop
			try ( prop = getProperty anim subAnims[i] ) catch ( continue )
			
			if subAnims[i] == undefined do continue
			local saElem = xmlDoc.createElement (subAnims[i] as string)
			propsElem.appendChild saElem
			saElem.setAttribute class_of ((classOf prop) as string)
			local ctrl = getPropertyController anim subAnims[i]
			if ctrl == undefined then
			(
				local cls = classof prop
				local sc = superClassOf prop
				if cls == Array or cls == ArrayParameter then
					array2xml prop saElem				
				else if sc == Value or sc == Number then
					saElem.text = prop as string -- set the property value
				else
				(
					saElem.setAttribute sclass_of (sc as string)
					subAnims2xml prop saElem -- incase of a reference target
				)
			)
			else
			(
				ctrl2xml ctrl saElem
			)
		)
	),
	fn obj2xml obj parentElem postCallback:undefined recurse:true chkTransform:true chkBaseObject:true chkModifiers:true chkCustAttrib:true =
	(
		local nodeElem = xmlDoc.createElement "object"
		parentElem.appendChild nodeElem
		nodeElem.setAttribute "name" obj.name
		nodeElem.setAttribute class_of ((classOf obj.baseobject) as string)
		nodeElem.setAttribute sclass_of ((superclassOf obj.baseobject) as string)
		nodeElem.setAttribute "isAnimated" ((isAnimated obj) as string)
		nodeElem.setAttribute "id" (obj.inode.handle as string)

		-- <transform>
			if chkTransform then
			(
				local tmElem = xmlDoc.createElement "transform"
				nodeElem.appendChild tmElem
				local tmc = obj.controller
				tmElem.setAttribute class_of ((classOf tmc) as string)			
				subAnims2xml tmc tmElem
			)
		-- </transform>
	
		-- <baseObject>	support for animated base object sub-anims based on sub-anim name
			if chkBaseObject do
			(
				local objElem = xmlDoc.createElement "baseObject"
				nodeElem.appendChild objElem
				objElem.setAttribute class_of ((classOf obj.baseobject) as string)
				subAnims2xml obj.baseObject objElem
			)			
			-- <customAttributes>
				if chkCustAttrib then cas2xml obj.baseObject objElem				
			-- </customAttributes>
		-- </baseObject>
		
		-- <modifiers> support for animated modifier sub-anims based on modifier name
			if chkModifiers do
			(
				local modsElem = xmlDoc.createElement "modifiers"
				nodeElem.appendChild modsElem
				for mod in obj.modifiers do
				(
					-- <modifier>			
						local modElem = xmlDoc.createElement "modifier"
						local sc = superclassOf mod
						modsElem.appendChild modElem
						modElem.setAttribute "name" mod.name
						modElem.setAttribute class_of ((classOf mod) as string)						
						modElem.setAttribute sclass_of (sc as string)
						if sc == SpacewarpModifier then 
							modElem.setAttribute "bindTo" (refs.dependson mod)[1].name
						subAnims2xml mod modElem
						-- <customAttributes>
							if chkCustAttrib then cas2xml mod modElem
						-- </customAttributes>
					-- </modifier>
					
				)
			)
		if postCallback != undefined then postCallback obj -- notify back the calling function
		gc()
		-- <children>
		if recurse and obj.children.count > 0 then
		(
			local chldElem = xmlDoc.createElement "children"
				nodeElem.appendChild chldElem
			for c in obj.children do 
				obj2xml c chldElem  postCallback:postCallback recurse:recurse	
		)
		-- </children>
	),
	
	------------------------------------------------------------------------------------
	-- xml 2 max functions
	------------------------------------------------------------------------------------
	fn xml2cas animElem toAnim = 
	(	
		local caElems =  animElem.selectNodes "customAttributes/customAttribute"
		if caElems == undefined then return()
		
		for c = 0 to (caElems.length-1) do
		(
			local caElem = caElems[c]
			local def = (caElem.selectSingleNode "definition").text
			
			-- add the definition
			custAttributes.add toAnim (exec def)
			local tca = custAttributes.get toAnim (custAttributes.count toAnim)			
						
			-- now read the property values
			xml2subAnims_fn caElem tca
		)
	),
	fn xml2ctrl animElem ctrl =
	(
		if ctrl == undefined then return()
		local keysElem = animElem.selectSingleNode "keys"
		if not no_key_frames and keysElem != undefined then
		(
			local ckeys = keysElem.childNodes
			local swi_ang = (is_ik_ctrl and animElem.parentNode.nodeName == "Swivel_Angle")
			local exec_string = ""
			___obj = ctrl.keys
			for k=0 to (ckeys.length-1) do
			(
				local kyp = ckeys[k].attributes				
				local time = kyp[0].text as float
				local ky = addNewKey ctrl time
				local ks = ";___obj[" + (k+1) as string + "]."
				for i=1 to (kyp.length-1) do --for each key property
				(
					exec_string += ks + kyp[i].nodeName + "=" + kyp[i].text					
					-- hack to fix swivel angle wackiness
					if swi_ang and kyp[i].nodeName == "value" then exec_string += "*pi/180"
				)
			)
			exec exec_string
			___obj = ""
		)
		xml2subAnims_fn animElem ctrl
	),
	fn xml2subAnims animElem anim =
	(
		if anim == undefined then return()
		if animatedOnly and ((getAttribute animElem "isAnimated") == "false") do return()
		
		local subAnimElems = (animElem.selectSingleNode "properties").childNodes
		local count = subAnimElems.length
		for i = 0 to (count-1) do
		(
			local subAnimElem = subAnimElems[i]
			local ctrlElem = subAnimElem.selectSingleNode "controller"
			local cls = getAttribute subAnimElem class_of
	
			if ctrlElem == undefined then
			(
--				format "  % - %\n" subAnimElem.nodeName subAnimElem.text
				if not animatedOnly then
				(
					local sc = getAttribute subAnimElem sclass_of
					local prop = getProperty anim subAnimElem.nodeName
					if cls == "Array" or cls == "ArrayParameter" then
					(
						try (
							local arr = exec subAnimElem.text
							format "%\n" arr
							try ( setProperty anim subAnimElem.nodeName arr )
							catch( for i=1 to arr.count do prop[i] = arr[i] )
						)catch ( /*format "  Cannot set the array property %.%\n" (getAttribute animElem class_of) subAnimElem.nodeName;*/  continue )
					)					else if sc == "" then								-- a value type
					(
						local val = string2Value subAnimElem.text xmlElem:subAnimElem
						try ( if val != undefined then setProperty anim subAnimElem.nodeName val )
						catch ( format "  Cannot set the property % of % to %\n" subAnimElem.nodeName (getAttribute animElem class_of) val;  continue )
					)
					else
					(
						-- incase of a reference target like the shadowMap of a light						
						if sc != "MAXObject" and cls != (classof prop) then
						(
							prop = create subAnimElem
							try ( setProperty anim subAnimElem.nodeName prop )
							catch ( format "  Cannot set the property % of % to %\n" subAnimElem.nodeName (getAttribute animElem class_of) val; continue )
						)
						xml2subAnims subAnimElem prop
					)
				)
			)			
			else			
			(
				local ctrl = getPropertyController anim subAnimElem.nodeName
				local prop = subAnimElem.nodeName
				if ((classof ctrl) as string) != cls then 
				(
					ctrl = create ctrlElem
					if ctrl == undefined then continue
					try (
						if i > 0 and subAnimElems[count-1].nodeName == "available" then
							prop = #available -- in case of a lookat controller
						if (setPropertyController anim prop ctrl) == undefined then				
							throw ""
					) catch ( format "  Cannot set %.%.controller = %\n" (getAttribute animElem class_of) prop (classof ctrl);  continue )
				)
--				format "  % - % - %\n" subAnimElem.nodeName subAnimElem.xml cls
				xml2ctrl ctrlElem ctrl
				
				-- get the value of the controller
				local vElem = getAddon ctrlElem "value"
				if vElem != undefined then setProperty ctrl "value" (string2value vElem.text xmlElem:vElem)	
			)
		)
	),	
	fn xml2obj nodeElem obj:undefined hide:true chkTransform:true chkBaseObject:true chkModifiers:true chkCustAttrib:true =
	(
		local tempObjs = #()
		local tmElem = nodeElem.selectSingleNode "transform"
		local tmc_class = getAttribute tmElem class_of

		if obj == undefined then
		(
			obj = create nodeElem hide:hide tempObjs:tempObjs tmElem:tmElem
			if obj == undefined then return undefined		
			obj.name = getAttribute nodeElem #name
		)		
		
		-- <transform>
			if chkTransform and tmElem != undefined do
			(
				local tmc = obj.controller
				if ((classof tmc) as string) != tmc_class then
				(
					if (gEnableDebug == true ) do
						format "xml2obj->chkTransform: % -- % %\n" tmc obj tmc_class
					tmc = create tmElem
					if tmc != undefined then
						obj.controller = tmc
				)
				is_ik_ctrl = (classof tmc == IKChainControl)
				tmc_class = ""
				if (tmc != undefined ) then
					xml2subAnims tmElem tmc
			)
		-- </transform>
	
		-- <baseObject> support for animated base object sub-anims based on sub-anim name
			if chkBaseObject do
			(
				local objElem = nodeElem.selectSingleNode "baseObject"
				xml2subAnims objElem obj.baseObject
				-- <customAttributes>
					if chkCustAttrib then xml2cas objElem obj.baseObject
				-- </customAttributes>
			)			
		-- </baseObject>
		
		-- <modifiers> Support for animated modifier sub-anims based on modifier name
			if chkModifiers do
			(
				local modsElem = (nodeElem.selectSingleNode "modifiers").childNodes
				if modsElem != undefined then
				(
					for m= 0 to (modsElem.length-1) by 1 do
					(
						-- <modifier>			
							local modElem = modsElem[m]
							if (getAttribute modElem sclass_of) == "SpacewarpModifier" then
							(
								local bindTo = getNodeByName (getAttribute modElem "bindTo")
								if bindTo != undefined then
									bindSpaceWarp obj bindTo
							)
							else
							(
								local mod = create modElem
								if mod != undefined then
								(
--									print mod.name
									addModifier obj mod
									xml2subAnims modElem mod
									-- <customAttributes>
										if chkCustAttrib then xml2cas modElem mod
									-- </customAttributes>
								)
							)							
						-- </modifier>						
					)
				)
			)
		-- </modifiers>
		
		-- free any temporary objects created by create function
		delete tempObjs
		gc()
		obj
	),

	-- call this before you start any I/O operations 
	fn init force:false = 
	(
		if rxmlIO.init or force then
		(
			createDialog rxmlIO
			destroyDialog rxmlIO			
		)
		exec_time = create_time = 0
		node_id = 0		
		xmlDoc = rxmlIO.axXMLCreate
		xmlCtrlDoc = rxmlIO.axXMLRead
		xmlDoc.async = xmlCtrlDoc.async = false
		-- if using MSXML 4.0 parser 
--		xmlDoc.setProperty "NewParser" true; xmlCtrlDoc.setProperty "NewParser" true
		local root = xmlDoc.childNodes[0]
		try
		(
			if root != undefined and root.hasChildNodes() do
				root.removeChild world
		) catch()
--		local dpi = (xmlDoc.createProcessingInstruction "xml" "version=\"1.0\" encoding = \"Windows-1252\"")
--		xmlDoc.appendChild dpi

		xmlDoc.documentElement = xmlDoc.createElement "scene"
		world = xmlDoc.createElement "world"
		xmlDoc.documentElement.appendChild world
		subAnims2xml_fn = subAnims2xml
		xml2subAnims_fn = xml2subAnims
		animatedOnly = false
	),
	
	-- loads an xml document into memory
	fn load xmlDocName =
	(
		xmlDoc.load xmlDocName
	),
	
	-- save the in-memory xml document to file 
	fn save xmlDocName =
	(
		xmlDoc.save xmlDocName
	)	
)
-- declare a global instance 
gXmlIO = sxmlIO ((getDir #maxRoot) + "stdplugs\\stdscripts\\baseLib\\controllers.xml")

-- clearListener() // LAM - 8/13/02 - defect 486694


/*( -- save example
	gXmlIO.init()	
	local objsElem = gXmlIO.xmlDoc.createElement "objects"
	gXmlIO.world.appendChild objsElem
	for o in rootNode.children do gXmlIO.obj2xml o objsElem
	gXmlIO.save "c:/Luna//MaxScript/mergeAnim/scene1.xml"
)

( -- load example
	resetMaxFile #noPrompt
	local st = timeStamp()
	gXmlIO.init()
	gXmlIO.load "D:/MaxScript/MergeAnim/birdSource.xml"
	local objs = gXmlIO.xmlDoc.selectNodes "//object"
 	for i=0 to (objs.length-1) do
		gXmlIO.xml2obj objs[i]
	format "Execute Time:%\%\n" ((100*gXmlIO.exec_time)/(timeStamp()-st))
)
*/
