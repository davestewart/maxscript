rollout roPVExporter "PaperVision3D Exporter" width:224 height:296
(
	-------------------------------------------------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------------------------------------------------
	
	GroupBox grpObjects "Objects" pos:[8,8] width:208 height:72
	dropdownList ddlParticles "" pos:[64,24] width:128 height:21
	button btnUpdateParticles "<" pos:[192,24] width:18 height:20
	label lblParticles "Particles" pos:[16,27] width:48 height:16
	dropdownList ddlCamera "" pos:[65,48] width:128 height:21
	button btnUpdateCameras "<" pos:[192,48] width:18 height:20
	label lblCamera "Camera" pos:[16,51] width:48 height:16
	
	GroupBox grpVisualise "Visualize" pos:[8,88] width:208 height:104
	dropdownList ddlVisParticles "" pos:[64,104] width:128 height:21 items:#("Single", "Selected", "Every Nth", "All")
	label lblVisParticles "Particle(s)" pos:[16,106] width:48 height:16
	label lblVisParticleNum "Particle(s)" pos:[64,128] width:48 height:16
	spinner spnVisParticleNum "" pos:[128,128] width:64 height:16 range:[1,9999,10] type:#integer
	button btnCreateSplines "Create Splines" pos:[16,152] width:120 height:24
	button btnDeleteSplines "Delete Old" pos:[136,152] width:72 height:24
	progressBar pbCreateSplines "ProgressBar" pos:[16,178] width:192 height:8 value:0 color:(color 30 10 190)
	
	GroupBox grpExport "Export Options" pos:[8,200] width:208 height:88
	edittext edtPath "" pos:[12,216] width:180 height:20
	button btnPath "<" pos:[192,216] width:18 height:20
	button btnExportParticles "Export particles" pos:[16,248] width:96 height:24
	button btnExportCamera "Export camera" pos:[112,248] width:96 height:24
	progressBar pbExport "ProgressBar" pos:[16,274] width:192 height:8
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- functions
	-------------------------------------------------------------------------------------------------------------------------------
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------------------------------------------
	
)

createdialog roPVExporter