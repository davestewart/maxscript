matGiz = $.modifiers[1].Gizmo.transform * $.objectTransform

p1=point()
p1.transform = matGiz

p2=point()
p2.position = $.modifiers[1].Center * matGiz
