

		-------------
		-- node click
		-------------
		function tvNodeClick tv tvNode =
		(
			-- interface
				-- update variables
					prevNode=curNode
					curNode = tv.SelectedItem
				
				-- color/text change
					prevNode.bold=false
					curNode.bold=true
		
				-- update the label
					lbl1.text = tvNode.fullpath
		
			-- code
				-- print node / maxobject properties
					try(
						local saStr = getSAStringFromNode tvNode
						local sa = getSAFromNode tvNode
						--clearListener()
						format "\n-- object --------------------------\n"
						format "  %\n" (exprformaxobject sa)
						format "\n-- subanim -------------------------\n"
						format "  sa string :      %\n" saStr
						format "  sa subanim:      %\n" sa
						format "  sa object:       %\n" sa.object
						format "  sa class:        %\n" (classof sa.object)
						format "  sa superclass:   %\n" (superclassof sa.object)
						format "\n-- controller  ---------------------\n"
						format "  ctrl             %\n" sa.controller
						format "  ctrl class:      %\n" (classof sa.controller)
						format "  ctrl superclass: %\n\n" (superclassof sa.controller)
					)
					catch()
					if superclassof sa.object == modifier then
					(
						format "IS MODIFIER!\n"
						modPanel.setCurrentObject sa.object
					)
					else format "%\n" (superclassof sa.object)
		)




---------------------------------------------------------------------------------------------------------------------------
-- dragging functions
---------------------------------------------------------------------------------------------------------------------------


		------------
		-- key press
		------------
/*
		on tv1 keyPress keyCode do
		(
			format "%\n" keyCode
			if keyCode == kSpace then
			(
				if dropNode.expanded==true then dropNode.expanded=false
				else dropNode.expanded=true
			)
		)	
*/

		-------------
		-- mouse down
		-------------
		fn tvMouseDown tv btn shift x y =
		(
			if btn == 1 then
			(
				try(
					tv.selectedItem=tvGetHitNode tv
				)
				catch()
			)
		)

/*
		fn tvMouseMove tv btn shift x y =
		(

		--If Button = vbLeftButton Then ' Signal a Drag operation. indrag = True ' Set the flag to true. 

			enableAccelerators = false			
			
			if btn == 1 then
			(
				dragging= true
				--dragImage=tv.createdragimage()
			)
			format "%\n" dragging
			--dragNode = 
			--tv.selectedItem.createdragimage()

			
		--	TreeView1.DragIcon = TreeView1.SelectedItem.CreateDragImage 
		--	TreeView1.Drag vbBeginDrag ' Drag operation. 

		)
*/




		-------------
		-- mouse move
		-------------
		fn tvMouseMove tv btn shift x y =
		(
			if btn == 1 then
			(
				try(
					dragging= true
					lastNode.backColor= colOver
					lastNode = dropNode 

	
					dropNode = tvGetHitNode tv
					dropNode.backColor= colOver
	
					format "% | %\n" lastNode.index dropNode.index
				)
				catch()
			)
		)

		------------
		-- mouse up
		------------
		fn tvMouseUp tv btn shift x y =
		(
			enableAccelerators = false			
			selNode = tvGetHitNode tv
			if btn == 2 and selNode != undefined do
			(
				popupmenu nodeMenu pop:[x, y] rollout:test 			)
		)

		-------------
		-- start drag
		-------------
			fn tvStartDrag tv data effects =
			(
				--dragNode = tvGetHitNode tv
				dragNode = tv.selectedItem
				if dragNode == undefined or dragNode.parent == undefined then return()
				else
				(
					dragNode.bold=true
					--tv.dropHighlight = 
					--tv.selectedItem.createdragimage()
				)
			)
	
		------------
		-- drag over
		------------
			fn tvDragOver tv data Effect Button Shift x y State = 			(

				try
				(
/*
					lastNode = dropNode 
					lastNode.backcolor = colOff

					dropNode = tvGetHitNode tv
					dropNode.backColor= colOver
						-- this needs finishing!
					format "% | %\n" lastNode.index dropNode.index
*/
/*
					if dropNode.index != lastNode.index then
					(
						format "% | different%\n" dropNode.index
						if dropNode != undefined then
						(
							-- color stuff
								try lastNode.backcolor = colOff
								catch()
								
							local dragNodeSuperclass = superclassof((getSAFromNode dragNode).object)
							local dropNodeSuperclass = superclassof((getSAFromNode dropNode).object)
							if dragNodeClass == dropNodeClass then
							(
								dropNode.backcolor = colOver
								lastNode=dropNode
								okToCopy=true
							)
							else
							(
							-- dont allow copy
								okToCopy=false
							-- autoexpand if closed
								if dropNode.expanded==false then dropNode.expanded=true
	  						)
						)
					)
					else format "% | SAME\n" dropNode.index
*/
				)
				catch()
				--try format "% | %\n" lastNode.index dropNode.index
				--catch()
			)

		-------
		-- drop
		-------

			fn tvDragDrop tv data Effect btn key x y =
			(
				local cPos=mouse.screenpos
				if dropNode != undefined AND okToCopy==true then popupmenu copyMenu pop:[cPos.x, (cPos.y-30)] rollout:test
				dragNode.bold=false
			)


---------------------------------------------------------------------------------------------------------------------------
-- mouse handlers
---------------------------------------------------------------------------------------------------------------------------

		on tv1 NodeClick tvNode do 									tvNodeClick tv1 tvNode
		on tv2 NodeClick tvNode do 									tvNodeClick tv2 tvNode

		on tv1 MouseDown btn shift x y do 							tvMouseDown tv1 btn shift x y
		on tv2 MouseDown btn shift x y do 							tvMouseDown tv2 btn shift x y

		on tv1 MouseMove btn shift x y do 							tvMouseMove tv1 btn shift x y
		on tv2 MouseMove btn shift x y do 							tvMouseMove tv2 btn shift x y

		on tv1 MouseUp btn shift x y do 							tvMouseUp tv1 btn shift x y
		on tv2 MouseUp btn shift x y do 							tvMouseUp tv2 btn shift x y

		on tv1 OLEStartDrag data effects do 						tvStartDrag tv1 data effects
		on tv2 OLEStartDrag data effects do 						tvStartDrag tv2 data effects

		on tv1 OLEDragOver data Effect Button Shift x y State do 	tvDragOver tv1 data Effect Button Shift x y State
		on tv2 OLEDragOver data Effect Button Shift x y State do 	tvDragOver tv2 data Effect Button Shift x y State

		on tv1 OLEDragDrop data Effect btn key x y do 				tvDragDrop tv1 data Effect btn key x y
		on tv2 OLEDragDrop data Effect btn key x y do 				tvDragDrop tv2 data Effect btn key x y
