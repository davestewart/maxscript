struct myMod (position, name, props) 

curMod = 1
curModName = $.modifiers[position]
curModProps = getPropNames $.modifiers[position]

myModTest = myMod position:curMod name:curModName props:curModProps 