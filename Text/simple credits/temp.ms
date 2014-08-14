k = addNewKey c 0f -- add a key at frame 0 
k.value = [10,0,0] -- set value there 
k.outTangentType = #slow 

c = bezier_position () -- create and assign new controller 
$bar.pos.controller = c 
