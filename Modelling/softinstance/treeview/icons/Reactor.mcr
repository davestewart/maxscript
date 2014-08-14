-- Collections

macroScript RigidBodyCollection category:"Reactor Toolbar" tooltip:"Rigid Body Collection" Icon:#("Reactor",2)
 (
 StartObjectCreation HKRBCollection
 )

macroScript ClothCollection category:"Reactor Toolbar" tooltip:"Cloth Collection" Icon:#("Reactor",17)
 (
 StartObjectCreation HKCLCollection
 )

macroScript SoftBodyCollection category:"Reactor Toolbar" tooltip:"Soft Body Collection" Icon:#("Reactor",12)
 (
  StartObjectCreation HKSBCollection
  )

macroScript RopeCollection category:"Reactor Toolbar" tooltip:"Rope Collection" Icon:#("Reactor",1)
 (
 StartObjectCreation HKRPCollection
 -- MessageBox "This feature is coming soon..." title:"Coming soon..."
 )

macroScript DefMeshCollection category:"Reactor Toolbar" tooltip:"Deforming Mesh Collection" Icon:#("Reactor",30)
 (
 StartObjectCreation HKDMCollection
 -- MessageBox "This feature is coming soon..." title:"Coming soon..."
 )
 
-- Helpers

macroScript SpringSystem category:"Reactor Toolbar" tooltip:"Spring System" Icon:#("Reactor",5)
 (
 StartObjectCreation HKSpring
 )

macroScript DashpotSystem category:"Reactor Toolbar" tooltip:"Dashpot System" Icon:#("Reactor",6)
 (
 StartObjectCreation HKDashpot
 )

macroScript ConstraintSolverSystem category:"Reactor Toolbar" tooltip:"Constraint Solver System" Icon:#("Reactor",11)
 (
 StartObjectCreation HKConstraintSolver
 )

macroScript PointPointConstraint category:"Reactor Toolbar" tooltip:"Point-Point Constraint" Icon:#("Reactor",8)
 (
 StartObjectCreation HKPointToPoint
 )

macroScript PointNailConstraint category:"Reactor Toolbar" tooltip:"Point-Nail Constraint" Icon:#("Reactor",9)
 (
 StartObjectCreation HKPointToNail
 )

macroScript PointPathConstraint category:"Reactor Toolbar" tooltip:"Point-Path Constraint" Icon:#("Reactor",10)
 (
 StartObjectCreation HKPointToPath
 )

macroScript PlanePrimitive category:"Reactor Toolbar" tooltip:"Plane Primitive" Icon:#("Reactor",4)
 (
 StartObjectCreation HKPlane
 )

macroScript ToyCarSystem category:"Reactor Toolbar" tooltip:"Toy Car System" Icon:#("Reactor",13)
 (
 StartObjectCreation HKToyCar
 --MessageBox "This feature is coming soon" title:"Coming soon..."
 )

macroScript WindSystem category:"Reactor Toolbar" tooltip:"Wind System" Icon:#("Reactor",15)
 (
 StartObjectCreation HKWind
 )

macroScript MotorSystem category:"Reactor Toolbar" tooltip:"Motor System" Icon:#("Reactor",16)
 (
 StartObjectCreation HKMotor
 )

macroScript FractureSystem category:"Reactor Toolbar" tooltip:"Fracture System" Icon:#("Reactor",27)
 (
 StartObjectCreation HKFracture
 )

-- WSM Modifiers

macroScript WaterSystem category:"Reactor Toolbar" tooltip:"Water WSM System" Icon:#("Reactor",14)
 (
 StartObjectCreation HKWaterWSMObject
 )


-- Commands

macroScript HKShowInWindow category:"Reactor Toolbar" tooltip:"Show in Window" Icon:#("Reactor",23)
(
  HavokShowInWindow()
)

macroScript HKPerformSimulation category:"Reactor Toolbar" tooltip:"Perform Simulation" Icon:#("Reactor",24)
(
  HavokPerformSimulation()
)

macroScript HKAnalyzeWorld category:"Reactor Toolbar" tooltip:"Analyze World" Icon:#("Reactor",25)
(
  HavokAnalyzeWorld()
)

macroScript HKExportWorld category:"Reactor Toolbar" tooltip:"Export World" Icon:#("Reactor",26)
(
  HavokExportWorld()
  -- MessageBox "This feature is available only for Havok Game Development Kit registered users" title:"Havok GDK"
)

-- Modifiers

macroScript HKClothModifier category:"Reactor Toolbar" tooltip:"Cloth Modifier" Icon:#("Reactor",20)
(
  AddMod HKClothModifier
)

macroScript HKSoftBodyModifier category:"Reactor Toolbar" tooltip:"Soft Body Modifier" Icon:#("Reactor",19)
(
   AddMod HKSoftBodyModifier
)

macroScript HKRopeModifier category:"Reactor Toolbar" tooltip:"Rope Modifier" Icon:#("Reactor",18)
(
  AddMod HKRopeModifier
   -- MessageBox "This feature is coming soon" title:"Coming soon..."
)

macroScript HKAttachToRBModifier category:"Reactor Toolbar" tooltip:"Attach To RigidBody Modifier" Icon:#("Reactor",21)
(
  AddMod HKAttachToRBModifier
)

