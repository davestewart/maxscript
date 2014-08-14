test.tv2.SelectedItem.forecolor = (color 0 0 255)
test.tv2.SelectedItem.bold = true


pNode = test.tv2.SelectedItem
pNode.children
thisNode = pNode.child
for i = 1 to pNode.children do
(
	nextNode=thisNode.next
	format "%\n" nextNode.text
)

showMethods test.tv1.nodes

showMethods test.tv1.nodes[1].selectedItem




show test.tv1.selectedItem

test.tv1.nodes[1].child.next.text

test.tv1.nodes[1][3]



					/*
					MousePointerConstants(
						#ccDefault
						#ccArrow
						#ccCross
						#ccIBeam
						#ccIcon
						#ccSize
						#ccSizeNESW | #ccSizeNS | #ccSizeNWSE | #ccSizeEW
						#ccUpArrow
						#ccHourglass
						#ccNoDrop
						#ccArrowHourglass
						#ccArrowQuestion
						#ccSizeAll
						#ccCustom
					)
					*/