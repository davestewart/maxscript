function safeCollapse duplicate:true name:#prompt deleteOriginal:false moveTo:unsupplied moveBy:unsupplied replaceNode:unsupplied =
	(
	undo "Safe-collpase to mesh" on
		(
		with redraw off
			(
			-- variables
				local sel = getcurrentselection()
				local arr = #()
				local objSrc, objTrg, objNew
				
			-- copy objects
				for objTrg in sel do
					(
					objNew = copy objTrg
					append arr objNew
					)
					
			-- move / delete
				if moveTo != unsupplied then if classof moveTo == Point3 then arr.pos = moveTo
				if moveBy != unsupplied then if classof moveBy == Point3 then move arr moveBy
				if deleteOriginal do delete sel
				select arr
				
			-- setup objects for collapsing
				convertToMesh arr
				objSrc = arr[arr.count]
				arr.count = arr.count - 1
				objSrc.material = copy objSrc.material
			
			-- do the collapse
				for objTrg in arr do
					(
					meshop.attach objSrc objTrg attachMat:#MatToID condenseMat:true
					)
					
			-- select / replace
				if isValidNode replaceNode == true then
					(
					replaceNode.baseObject = objSrc
					delete objSrc
					)
				else
					(
					select objSrc
					)
			)
		)
	)



/*
safeCollapse replaceNode:$sphere01

obj = $
for i = 1 to obj.modifiers.count do
	(
	local theMod = obj.modifiers[i]
	if (classof theMod) == MaterialModifier do
		(
		obj.material = obj.material[theMod.materialID]
		break
		)
	)
	$.pos =  [10,0,0]
classof $.material

$.material = copy $.material
objSrc	= pickObject()
objSrc	= $

objTrg	= $box02
objTrg2	= $box03

converttomesh $

meshop.attach objSrc (pickobject()) attachMat:#MatToID condenseMat:true
*/