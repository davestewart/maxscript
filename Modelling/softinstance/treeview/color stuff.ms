rollout roCol "Colours" width:162 height:322
(
	listBox lbx1 "Colours" pos:[8,8] width:144 height:19 items:#(#background,#text,#activeCommand,#hilight,#shadow,#window,#activeCaption,#toolTipBackground,#toolTipText,#hilightText,#windowText,#itemHilight,#subObjectColor,#3dDarkShadow,#3dLight,#appWorkspace,#trackbarBg,#trackbarBgSel,#trackbarText,#trackbarTicks,#trackbarKeys,#trackbarSelKeys,#trackbarCursor,#pressedButton,#timeSliderBg,#viewportBorder,#activeViewportBorder,#rollupTitleFace,#rollupTitleText,#rollupTitleHilight,#rollupTitleShadow,#selectionRubberBand,#stackViewSelection)
	colorPicker cp1 "" pos:[8,288] width:120 height:24
	checkbox cb1 "" pos:[136,292]
	
	on lbx1 selected item do
		(
		c = (lbx1.selected as name)
		cp1.color= (colorman.getColor (c as name)*255)
		)
	on cb1 changed state do colorman.setUseStandardWindowsColors state
	on cp1 changed col do format "%\n" col
)
createDialog roCol