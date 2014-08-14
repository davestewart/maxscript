for i = 1 to (numKnots $) do
(
	p = getInVec $ 1 i
	setInVec $ 1 i (p - [0,0,10])
	p = getOutVec $ 1 i
	setOutVec $ 1 i (p - [0,0,10])
)
updateShape $