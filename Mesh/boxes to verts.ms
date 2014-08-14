delete objects

s = sphere radius:500
m = snapshotasmesh s

for i = 1 to getnumverts m do
(
	pos = getvert m i
	rot = getnormal m i

	mx	= matrixfromnormal rot
	translate mx pos
	
	b	= box transform:mx
)


pf = $'PF Source 01'

pf.particleIndex = 20
pf.particleOrientation

pf.particlePosition

mx = matrixfromnormal pf.particleOrientation
translate mx pf.particlePosition

b = box transform:mx