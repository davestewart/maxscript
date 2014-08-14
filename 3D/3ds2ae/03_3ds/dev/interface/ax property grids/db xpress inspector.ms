try(destroydialog ro1);catch()
rollout ro1 "Untitled" width:432 height:296
(
	activeXControl ax "dxDBInsp.dxDBInspector.1" pos:[8,8] width:416 height:224
)
createdialog ro1

--showmethods ro1.ax
--show ro1.ax

list=ro1.ax
showproperties list
showmethods list

list.add #iedCheckEdit
list.add #iedPickEdit	
list.rows[1]

c=getIndexedProperty list #items 0

show c

r=getIndexedProperty c #row 0
show r

r.caption="hello"

show list
list.flat=true
list.PaintStyle=#ipsSimple
