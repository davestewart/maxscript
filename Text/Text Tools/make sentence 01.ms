rollout roMakeSentence "Create Words" width:150 height:210
(

	-----------------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------------

	group "Settings"
	(
		button btnGet "Acquire" width:128 height:16
		
		spinner spnLength "Words:" width:72 height:16 range:[5,200,30] type:#integer fieldwidth:30 align:#right
		spinner spnWrap "Wrap at char:" width:103 height:16 range:[0,100,5] type:#integer fieldwidth:30 align:#right
		spinner spnFontSize "Font size:" width:80 height:16 range:[1,100,10] type:#integer fieldwidth:30 align:#right
		spinner spnLeading "Leading:" width:80 height:16 range:[-10,50,1] type:#integer fieldwidth:30 align:#right
	
	)
	
	group "Create"
	(
		editText edtPrefix "Prefix:" width:128 height:16
		button btnSet "Create / Edit" width:128 height:16
	)
	
--)createdialog roMakeSentence
	-----------------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------------

		local obj
		local namePrefix = "Bg text "
		
		function wrapText str maxLength hyphenate:false=
		(
			
			if NOT hyphenate then
			(
				local para = ""
				local line = ""
				local word = ""
				local str = str as stringstream
				while peekToken str != undefined do
				(
					word = readToken str
					line += word + " "
					if line.count > maxLength then (
						para += line + "\r"
						line = ""
					)
				)
				return para
			)
			else(
				para = ""
				
				local arr = filterstring str "\r"
				local str = ""
				for a in arr do str += a + " "
				
				for i = 1 to str.count by maxLength do
				(
					para += substring str i maxLength
					if substring para (para.count) 1 != " " then para += "-"
					para += "\r"
				)
				return para
			)
		)
			
		fn uppercase instring = -- beginning of function definition
		(
			local upper, lower, outstring
			upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			lower = "abcdefghijklmnopqrstuvwxyz"
			outstring = copy instring
			for i = 1 to outstring.count do
			(
				j = findString lower outstring[i]
				if ( j != undefined) do outstring[i] = upper[j]
			)
			outstring
		)
			
		fn makeSentence length =
		(
			local str = "qui sic curas unumquemque nostrum tamquam solum cures et sic omnes tamquam singulos unde illud etiam quod cum mihi narrasset ipsum visum et ego ad id detrahere conarer ut illa se potius non desperaret futuram esse quod eram continuo sine aliqua haesitatione non inquit non enim mihi dictum est ubi ille ibi et tu sed ubi tu ibi et ille confiteor tibi domine recordationem meam quantum recolo quod saepe non tacui amplius me isto per matrem responso tuo quod tam vicina interpretationis falsitate turbata non est et tam cito vidit quod videndum fuit quod ego certe antequam dixisset non videram etiam tum fuisse commotum quam ipso somnio quo feminae piae gaudium tanto post futurum ad consolationem tunc praesentis sollicitudinis tanto ante praedictum est nam novem ferme anni secuti sunt quibus ego in illo limo profundi ac tenebris falsitatis cum saepe surgere conarer et gravius alliderer volutatus sum cum tamen illa vidua casta pia et sobria quales amas iam quidem spe alacrior sed fletu et gemitu non segnior non desineret horis omnibus orationum suarum de me plangere ad te et intrabant in conspectum tuum preces eius et tamen dimittebas adhuc volvi et involvi illa caligine haec ego nesciens inridebam illos sanctos servos et prophetas tuos et quid agebam cum inridebam eos nisi ut inriderer abs te sensim atque paulatim perductus ad eas nugas ut crederem ficum plorare cum decerpitur et matrem eius arborem lacrimis lacteis quam tamen"
			local arrWords = filterstring str " "
			
			sentence = ""
			for i = 1 to length do
			(
				sentence += arrWords [random 1 arrWords .count]
				if random 1 15 == 1 then sentence += ", "
				else sentence += " "
			)
			
			local cap = uppercase (substring sentence 1 1)
			sentence = cap + substring sentence 2 -1
			return sentence
		)


	-----------------------------------------------------------------------------------------------
	-- handlers
	-----------------------------------------------------------------------------------------------
	
		on btnSet pressed do
		(
			local strPrefix	= edtPrefix.text
			local str		= wrapText (makeSentence spnLength.value) spnWrap.value
			local tx		= matrix3 [1,0,0] [0,0,1] [0,-1,0] [39.2996,2.2451e-006,-51.3619]
			
			local sel = getcurrentselection()
			
			if sel.count > 0 then (
				obj = sel[1]
				if classof obj.baseobject == text then
				(
					obj.baseObject.text	= str
					obj.baseObject.size	= spnFontSize.value
					obj.baseObject.leading	= spnLeading.value
				)
			)
			else
			(
				obj = text text:str font:"Times New Roman" transform:tx size:spnFontSize.value leading:spnLeading.value
				obj.name		= uniquename strPrefix
				obj.steps		= 1
				obj.material	= meditmaterials["black trans"]
				addmodifier obj (MaterialModifier())
				obj.modifiers[1].enabledInViews = false
				select obj
			)
			centerpivot obj

		)
			
		on btnGet pressed do
		(
			local sel = getcurrentselection()
			if sel.count > 0 then (
				try(
					obj					= sel[1]
					local str = $.baseobject.text
	
					-- length
						local arr = filterstring str " \r"
						spnLength.value	= arr.count
	
	
					-- wrap				
						local arr = filterstring str "\r"
						local wrap = 0
						for a in arr do if a.count > wrap then wrap = a.count
						spnWrap.value	= wrap
	
					-- text props				
						spnFontSize.value	= obj.size
						spnLeading.value	= obj.leading
				)
				catch()
			)
		)
			
		on roMakeSentence open do
		(
			edtPrefix.text = namePrefix
		)
			
)
	
	/*
	try (destroydialog createWords);catch()
	createdialog roMakeSentence
	*/
	
	
	