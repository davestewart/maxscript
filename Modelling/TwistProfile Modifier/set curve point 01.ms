p = roCC.cc1.curves[1].points[2]
v = p.outtangent * [1,0]
setproperty p #outtangent [p.outtangent.x,0]
p.outtangent = [135.408,0]

pVal = p1.value
pIn = p.inTangent * [1,0]
pOut = p.inTangent * [1,0]


p.value

p2 = ccPoint pVal pIn pOut bezier:true

setPoint roCC.cc1.curves[1] 1 p2


[bezier:<false>] [corner:<false>] [lock_x:<false>] \

[lock_y:<false>] \ [select:<false>] [end:<false>] \

[noXConstraint:<false>]


setPoint roCC.cc1.curves[1] 1 <ccpoint> [checkConstraints:<true>]

setSelectedPts roCC.cc1.curves[1] #{1..2} #select
