rollout grassInfo "Info" width:162 height:300
(
	label lblinfo "Because the \"Clumps\" setting in Grass-O-Matic is not animateable, there is no way to adjust the amount of clumps as the blade count changes.\n\nThis utility will keep your blade-to-clump ratio consistent as blade count changes." pos:[8,8] width:144 height:124
)


rollout grassOptions "Options" width:162 height:197
(

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	pickbutton btnPick "Pick grass object" pos:[8,8] width:144 height:32 message:"" toolTip:""
	spinner spnBpC "Blades per Clump: " pos:[16,48] width:136 height:16 range:[1,100000,10] type:#integer enabled:false
	label lblBlades "Blades:" pos:[56,72] width:96 height:16 enabled:false
	label lblClumps "Clumps:" pos:[56,88] width:96 height:16 enabled:false
	button btnKill "Kill all links" pos:[8,120] width:72 height:16
	button btnClose "Close" pos:[80,120] width:72 height:16
	
	---------------------------------------------------------------------------------------------------
	-- Local Variables
	---------------------------------------------------------------------------------------------------

	local blades
	local clumps
	local BpC

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn updateGrass =
	(
		bpc =  spnBpC.value
		blades = grassObject.Blade_Count

		clumps = blades / bpc
		if clumps < 1 then clumps = 1
		lblClumps.text = "Clumps: " + clumps as String

		grassObject.Clumps_Count = clumps as Integer
		lblBlades.text = "Blades: " + grassObject.Blade_Count as String

	)
	

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------







	on btnPick picked obj do
(
	if classOf obj == Grass_O_matic then
	(
			global grassObject = obj
			btnPick.text = grassObject.name
	
			blades = grassObject.Blade_Count
			lblBlades.enabled = true
			lblBlades.text = "Blades: " + blades as String
	
			BpC =  blades / grassObject.Clumps_Count
			spnBpC.value = BpC
			spnBpC.enabled = true

			clumps = blades / BpC
			lblClumps.enabled = true
			lblClumps.text = "Clumps: " + clumps as String

			when parameters grassObject changes id:#grassUpdater do updateGrass()
	)
)
	on spnBpC changed val do updateGrass()

	on btnKill pressed do
	(


		lblBlades.text = 
		lblBlades.enabled = false

		lblClumps.text = 
		lblClumps.enabled = false

		deleteAllChangeHandlers  id:#grassUpdater
	)

	on btnClose pressed do closerolloutfloater grassFloater
)

if grassFloater != undefined then closerolloutfloater grassFloater
grassFloater = newRolloutFloater "Grass Auto-Clumper" 182 220 85 92
addRollout grassInfo grassFloater rolledUp: true
addRollout grassOptions grassFloater
