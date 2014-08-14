(
pArr=$plane*
bArr=$bone*
for t = 0 to 75  by 5 do at time t
	(
	for i = 1 to pArr.count do
		(
		p=pArr[i]
		b=bArr[i]
		p.rotation.controller[1].value = b.rotation.controller[1].value
		p.rotation.controller[2].value = b.rotation.controller[2].value
		p.rotation.controller[3].value = b.rotation.controller[3].value
		)
	)
)

$.controller