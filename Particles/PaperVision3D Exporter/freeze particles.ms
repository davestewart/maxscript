

  fn filter_one_pflow = (selection.count == 1 and classof selection[1] == PF_Source)
  (
    pick_pflow = selection[1]
    holder_mesh = Editable_Mesh()
    holder_mesh.name = uniquename (pick_pflow.name+"_Freeze")

    with undo off
    (
      i = 0
      finish = false
      while not finish do
      (
        i += 1
        pick_pflow.particleIndex = i
        current_mesh = pick_pflow.particleShape
        if current_mesh == undefined then
          finish = true
        else
        (
          new_mesh = Editable_Mesh()
          new_mesh.mesh = current_mesh
          new_mesh.transform = pick_pflow.particleTM
          attach holder_mesh new_mesh
        )
      )
    )

    update holder_mesh
    pushPrompt (i as string +" Particle(s) Frozen!")
  )
