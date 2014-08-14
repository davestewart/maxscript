	-- set spnDuration limit (can't let focus time go higher or lower than the total animation time)
		if rdoScope.state == 1 then
			(
			durLimit = ro1.spnTotalEnd.value - spnFocus.value
			)
		
		if spnDuration.value > durLimit then spnDuration.value = durLimit

		val = spnDuration.value
		spnFocus.range = [10,max,val]