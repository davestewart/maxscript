rollout ro1 "Rotation tester" width:160 height:56
(
	timer tmr1 "Timer" pos:[8,24] width:24 height:24 interval:50
	label lbl1 "Label" width:144 height:16
	label lbl2 "Label" width:144 height:16
	
	on tmr1 tick  do
(
		if (sel = getCurrentSelection()).count > 0 then
		(
			obj = sel[1]
			lbl1.text = classof obj.rotation as string + ":" + obj.rotation.z as string
			lbl2.text =  "Angle:" + (obj.rotation as eulerangles).z as string
		)
	)
)
createdialog ro1