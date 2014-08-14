plugin simpleMod pdeforms
name:"pathdeform bank"
classID:#(0x2728c9fd, 0x2b2d8d86)
	( 
	local dh=[0,0,0]
	local dm=matrix3 0 --matrix data
	
	parameters main rollout:params
	(
		amount type:#integer ui:amtSpin default:0
		tar type:#node
		tar2 type:#node
		b type:#floattab tabsizevariable:true
	)
	
	rollout params "path parameters"
	(
		spinner amtSpin "Amount: " type:#integer range:[0,1000,0]
		button node "path"
		button node2 "path2"
		on node pressed do(
			tar=pickobject()
			if tar!=undefined then(
				node.text=tar.name
				ze=(getknotpoint tar 1 1)-center
			)		
		)
		on node2 pressed do(
			tar2=pickobject()
			if tar2!=undefined then(
				node2.text=tar2.name
				--ze=(getknotpoint tar 1 1)-center
			)		
		)
	)
	on map i p do
		(
			if i == 1 then(
				b		= getseglengths tar 1
				dh.x	= b[b.count]
				dh.z	= 1/(dh.x)		
				)	
				
			p.x += amount
			
			case of(
				(p.x > dh.x):
						(
						dm.row4	= getknotpoint tar 1 (numknots tar 1)
						dm.row1	= getoutvec tar 1 1--lengthtangent tar 1 1--dh.z
						)
				(p.x < 0):
						(
						dm.row4	= getknotpoint tar 1 1
						dm.row1	= getinvec tar 1 1
						)
				default:
						(
						dm.row4	= (lengthinterp tar 1 (p.x*dh.z))
						dm.row1	= lengthtangent tar 1 (p.x*dh.z)
						)
				)
			p.x=0
			
			--if i==2 then $D1.pos=(lengthinterp tar 1 (100*dh.z))
			dm.row3		= normalize( (pathinterp tar2 1 (nearestpathparam tar2 dm.row4)) - dm.row4 )
			dm.row3		= normalize( dm.row3-((dot dm.row3 dm.row1)*dm.row1) )
			dm.row2		= cross dm.row3 dm.row1
			p*dm
	
			--(inverse(this.gizmo.transform))
			)
/*	try(
	catch(p)
	)
*/
p
	
	
	
	)