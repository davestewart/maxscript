refsArray  = (refs.dependents this) 
local obj
for i in refsArray where isvalidnode i do obj = i.name
path=(getNodeByName obj).position.controller[2].path
pathLength= amax (getSegLengths path 1)
dist=(getNodeByName obj).position.controller[2].path
print
0.0 
