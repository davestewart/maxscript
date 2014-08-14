-- create the custom attribute definition that does nothing but store a single node
reference

nodeStoreCA = attributes nodeStore attribID:#(0x5df52ec4, 0x76fcba8b) (
parameters main rollout:params
( node type:#node ui:pNode)
-- here comes the new stuff: the UI definiton
rollout params "Pick Node" (
pickbutton pNode ""
on pNode picked obj do pNode.text = obj .name
on params open do pNode.text = if isValidNode node then node.name
else "<<none>>"
)
-- we also include a function for displaying that UI, otherwise we won’t see it
fn openDialog = createdialog params
)


-- create some objects for testing
s1 = sphere()
t1 = teapot pos:[-50,50,0]
-- create and assign a position script controller
sc = s1.pos.controller = Position_Script()
-- add the custom attribute to the controller and store the reference to the sphere
inside the CA
custAttributes.add sc nodeStoreCA
sc.nodeStore.node = t1
-- assign the script text to the controller
sc.script = "local target = this.custAttributes[#nodeStore].node; if
isValidNode target then target.transform.pos/2 else [0,0,0]"
-- the script controller will look up the referenced node in it’s custom attribute and,
if there is a valid node, use that node’s position


sc.nodeStore.node
s1.pos.controller.nodeStore.openDialog()
