/*

FAMILY
.Child : INode
.Children : integer
.FirstSibling : INode
.LastSibling : INode
.Next : INode
.Parent : INode
.Previous : INode
.Root : INode

STATE
.Expanded : boolean
.Selected : boolean
.Visible : boolean

Property
.ExpandedImage : undefined
.Image : undefined
.Index : integer
.SelectedImage : undefined
.Sorted : boolean

INFO
.FullPath : string
.Key : string
.Tag : undefined
.Text : string

VISUAL
.Bold : boolean
.Checked : boolean
.BackColor : OLE_COLOR
.ForeColor : OLE_COLOR
*/
fn recurseTVNodes tvNode =
	(
	n = obj.numSubs
	for i = 1 to n do
		(
		newNode = tv.nodes.add tvNode.index 4 "" ((getSubAnimName obj i) as string)
		--(((getSubAnimName obj i) as string) +" ("+classof obj.controller as string+")")
		newNode.expanded=true
		newNode.tag=i as string
		recurseSubAnims obj[i] tv newNode
		)
	)
(
tviNode = test.tv1.selectedItem
for i = 1 to tviNode.Children do
	(
	print tviNode.child[i]
	)

)
test.tv1.scroll=true