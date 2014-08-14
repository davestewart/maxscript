		fn getControllerTimes ctrl &arr =
		(
			for i = 1 to ctrl.numSubs do
			(
				local c = ctrl[i].controller
				if iscontroller c do
				(
					local range = gettimeRange c
					if range.start - range.end != 0f then
					(
						append arr range.start
						append arr range.end
					)
					getControllerTimes c &arr
				)
			)
		)
		
		fn getControllerRange ctrl =
		(
			arr	= #()
			getControllerTimes ctrl &arr
			if arr.count > 0 then return interval (aMin arr) (aMax arr)
			else return undefined
		)
			