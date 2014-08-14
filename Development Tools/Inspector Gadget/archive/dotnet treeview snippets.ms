
n1 = roProps.tv.nodes.item[0].tag.value
n2 = roProps.tv.nodes.item[0].nodes.item[0].tag.value
i  = roProps.getIteratorObjects n2

roProps.getIteratorObjects n

i = PropertyIterator n

fn traceObj obj = print obj
fn showObj obj= show obj

i.iterate trace



n1 = roProps.tv.nodes.item[0].nodes.item[0].nodes.item[0]
n2 = roProps.tv.nodes.item[0].nodes.item[0]

n3 = n1.parent
n1.tag

show n2

exprformaxobject n3.tag.value


roProps.add roMD2Exporter.lvAnimations

getPropNames
for i = 1 to 10 do roProps.add roMD2Exporter.lvAnimations.items.item[i] text:roMD2Exporter.lvAnimations.items.item[i].text


show roMD2Exporter.lvAnimations.items.item[0]

getproperty roMD2Exporter.lvAnimations.items.item[0] "bounds"


roProps.tv.nodes.item[1].nodes.item[1].tag

roProps.add roMD2Exporter.lvAnimations


roProps.add $.transform.controller


$Box01.pos.controller.numSubs
s = getSubAnim $Box01.pos.controller 1
s.numSubs

roProps.add $.transform.controller

roProps.add (dotnetclass "System.Runtime.Remoting.ObjRef")