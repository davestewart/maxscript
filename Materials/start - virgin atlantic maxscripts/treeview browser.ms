rollout treeview_rollout "TreeView Scene Browser"
	(
	fn initTreeView tv ilTv=
		(
		tv.Indentation = 28*15
		tv.LineStyle = #tvwRootLines 
		)
	fn addChildren tv theNode theChildren =
		(
		for c in theChildren do
			(
			newNode = tv.Nodes.add theNode.index 4 "" c.name 0
			addChildren tv newNode c.children
			)
		)
	fn fillInTreeView tv =
		(
		theRoot = tv.Nodes.add()
		theRoot.text = "WORLD ROOT"
		rootNodes = for o in objects where o.parent == undefined collect o
		addChildren tv theRoot rootNodes 
		)
	activeXControl tv "{C74190B6-8589-11D1-B16A-00C0F0283628}"  width:190 height:290 align:#center 
	spinner spn_indent "Indentation" range:[0,100,28] type:#integer fieldwidth:40
	 
	on tv nodeClick theNode do try(select (getNodeByName theNode.text))catch()
	on spn_indent changed val do tv.indentation = val*15
	on treeview_rollout open do 
		(
		initTreeView tv ilTv
		fillInTreeView tv
		)
	)
try(destroyDialog treeview_rollout)catch()
createDialog treeview_rollout 200 300
)

/*
"MSPropertyTreeCtl Class" "MSPropertyTree.Ctl.1" "{40710C26-4BC7-11D1-8B6F-080036B11A03}" 
"Microsoft TreeView Control 6.0 (SP4)" "MSComctlLib.TreeCtrl.2" "{C74190B6-8589-11D1-B16A-00C0F0283628}" 

*/