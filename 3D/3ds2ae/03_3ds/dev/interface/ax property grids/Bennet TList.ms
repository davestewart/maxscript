rollout ro1 "Untitled" width:432 height:296
(
	activeXControl ax "TList.TList.7" pos:[8,8] width:416 height:224
)
createdialog ro1

--showmethods ro1.ax
--show ro1.ax

igrid=ro1.ax
showmethods igrid
show igrid

igrid.additem "4"

show igrid

setindexedproperty igrid #itemcell #text "goodbye"

c.text="goodbye"
igrid.insertitem 1