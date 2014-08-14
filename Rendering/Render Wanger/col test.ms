---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------
global RSro1 RSro2

rollout RSro1 "Render Presets" width:816 height:180
(
	ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[5,22] width:200 height:200

	on RSro1 open do
	(
	-- SET UP AX OBJECT
	--------------------------------------------------------
		ax.MousePointer = #ccArrow 
		ax.GridLines = true 
		ax.AllowColumnReorder = false 
		ax.BorderStyle = #ccFixedSingle 
		ax.view = #lvwReport -- ( #lvwIcon | #lvwSmallIcon | #lvwList | #lvwReport )
		ax.Checkboxes=false
		ax.FullRowSelect = true
		ax.MultiSelect = false
		ax.HideColumnHeaders =false
		
		chs = ax.columnHeaders
		
		--showProperties chs 
		--showMethods chs
		
	-- ADD COLUMN HEADERS
	--------------------------------------------------------
		colLabels = #(	"Fill","Number")
		
		for i = 1 to colLabels.count  do
		(
			tmp = chs.Add Width:200
			tmp.text=colLabels[i]
			--execute(colLabels[i] + ".text = " + colLabels[i] as string)
		)

		
	-- ADD ITEMS
	--------------------------------------------------------
		for i = 1 to 50 do
		(
		-- create color
			local c = (((random 0 255)*65300) + ((random 0 255)*255) + (random 240 255)) as Integer
			if c < 0 then c = -c
			c = 40170000 as Integer

		-- create cells
			local li = ax.listItems.Add text:"||||||||||||||||||||||||||||||||||"
			li.bold=true
			try
			(
				lsi = ax.ListItems[i].ListSubItems.add text:c
				li.forecolor=c
			)
			catch
			(
				li.text=""
				--ax.listItems.Remove (i)
			)
		)
)
		
	

	-- SET UP VARIABLES
	--------------------------------------------------------
	--on ax DblClick do (print (RSro2.index as string + " Double-clicked"))
)





if rndFloater != undefined then closerolloutfloater rndFloater
	rndFloater = newRolloutFloater "My Floater" 300 1200
	rndFloater.pos = [0,0]
addRollout RSro1 rndFloater
