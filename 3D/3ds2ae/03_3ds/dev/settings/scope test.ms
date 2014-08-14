MacroScript test category:"After Effects" tooltip:"After Effects Bridge"-- silentErrors:true
	( 
	local ROOT=	"E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"
	local AFX=	"C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"

	rollout SETTINGS "Settings" width:360 height:64
	(
		editText edt1 "" pos:[8,6] width:344 height:18
		button btnSet "Set ROOT" pos:[8,32] width:72 height:24
		button btnGet "Get ROOT" pos:[80,32] width:72 height:24
		
		
		on SETTINGS open do
			(
			print ROOT
			edt1.text=ROOT
			)
			
		on btnGet pressed do 
			(
			format ">> %\n" ROOT
			edt1.text=ROOT
			)

		on btnSet pressed do ROOT = edt1.text

	)		
	createdialog SETTINGS
	)

macros.run "After Effects" "test"
