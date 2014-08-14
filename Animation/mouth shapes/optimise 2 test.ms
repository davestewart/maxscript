plugin modifier optimize2
name:"Optimize2"
extends:optimize
replaceui:true
classID:#(0x52ef94f8, 0xadb373cb)
(
parameters pblock rollout:params
   (
   power type:#integer default:1 ui:str
   on power set val do 
      (
      case val of
         (
         1:   delegate.facethreshold1 = 0
         2:   delegate.facethreshold1 = 2.5
         3:   delegate.facethreshold1 = 5
         4:   delegate.facethreshold1 = 10
         )
      )
  )

rollout params "Parameters"
   (
   group "Optimize"
      (
      radiobuttons str "Strength:" labels:#("None","Low","Medium","High")
      )

   )
    on create do this.facethreshold1.controller = bezier_float()

)