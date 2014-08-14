fn flt_objects = (srcObj != undefined) -- objects filter 


srcObj =pickObject()

sep=0

	menuStr=""
	menuStr= stringStream ""

	format "rcmenu NewRCmenu(\n" to:menuStr


		format "subMenu \"Transform\"\n	(\n" to:menuStr
			format "	menuItem mi_TransP \"Position\"\n" mStr to:menuStr
			format "	menuItem mi_TransR \"Rotation\"\n" mStr to:menuStr
			format "	menuItem mi_TransS \"Scale\"\n" mStr to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			format "	menuItem mi_TransPR \"Pos, Rot\"\n" mStr to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			format "	menuItem mi_TransPRS \"Pos, Rot, Scale\"\n" mStr to:menuStr
		format "\n	)\n" to:menuStr


		format "subMenu \"Transform And Parent\"\n	(\n" to:menuStr
			format "	menuItem mi_TransParP \"Position\"\n" mStr to:menuStr
			format "	menuItem mi_TransParR \"Rotation\"\n" mStr to:menuStr
			format "	menuItem mi_TransParS \"Scale\"\n" mStr to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			format "	menuItem mi_TransParPR \"Pos, Rot\"\n" mStr to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			format "	menuItem mi_TransParPRS \"Pos, Rot, Scale\"\n" mStr to:menuStr
		format "\n	)\n" to:menuStr


		format "menuItem mi_Title \"Select property to replace...\" enabled:false\n" to:menuStr
		format "separator sep%\n" sep to:menuStr

		format "subMenu \"Modified Object\"\n	(\n" to:menuStr
			for n = srcObj.modifiers.count to 1 by -1 do
			(
				mStr=classof srcObj.modifiers[n] as string
				mStr=srcObj.modifiers[n].name as string
				format "	menuItem mi_Stack% \"%\"\n" n mStr to:menuStr
			)
			format "	separator sep%\n" (sep+=1) to:menuStr
			mStr= srcObj.baseObject as string
			format "	menuItem mi_Stack0 \"%\"\n" mStr to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			format "	menuItem mi_StackAll \"All\"" to:menuStr
		format "\n	)\n" to:menuStr


		format "subMenu \"Material\"\n	(\n" to:menuStr
			matArr =#("Ambient","Diffuse","Specular / Glossiness","Shader","Opacity","Bump","Self Illumination","Reflection")
			for n = 1 to matArr.count do
			(
				format "	menuItem mi_Mat% \"%\"\n" n matArr[n] to:menuStr
			)
		format "\n	)\n" to:menuStr


	format "\n)" to:menuStr
close menuStr
--menuStr

unRegisterRightClickMenu NewRCmenu
execute(menuStr as string)
registerRightClickMenu NewRCmenu
popUpMenu NewRCmenu
