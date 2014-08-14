roAnimation.axObj.ListItems[1].Text=objects[1].name
roAnimation.axObj.ListItems[1].Ghosted=true
roAnimation.axObj.ListItems[1].Height=20.0
roAnimation.axObj.ListItems[1].Icon=undefined
roAnimation.axObj.ListItems[1].Index=5
roAnimation.axObj.ListItems[1].Key="my key"
roAnimation.axObj.ListItems[1].Left=30.0
roAnimation.axObj.ListItems[1].Selected=true
roAnimation.axObj.ListItems[1].SmallIcon=undefined
roAnimation.axObj.ListItems[1].Tag="My Tag"--=undefined
roAnimation.axObj.ListItems[1].Top=20
roAnimation.axObj.ListItems[1].Width=200
roAnimation.axObj.ListItems[1].SubItems[1]
roAnimation.axObj.ListItems[1].ListSubItems--=IListSubItems
roAnimation.axObj.ListItems[1].Checked=true
roAnimation.axObj.ListItems[1].ForeColor=(color 255 0 0)
roAnimation.axObj.ListItems[1].ToolTipText="This is a tooltiip"
roAnimation.axObj.ListItems[1].Bold=true


hProp = ch.Add index:"Sub 2"
roAnimation.axObj.ListItems[1].ListSubItems.Add index:"hi!" text:"hello"


showmethods roAnimation.axObj

show roAnimation.axObj