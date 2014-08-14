-------------------------------------------------------------------------------
-- DisplayMatID.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 04/18/01
-- Modified On: 04/18/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- What this script does: 
-- Displays all material IDs used by the faces in a particular object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals 

global get_mat_ids_in_editable_mesh
global get_mat_ids_in_editable_poly

global dmi_do

-- Functions

fn get_mat_ids_in_editable_mesh obj1 = 
(
	the_array = #()
	for i = 1 to (getNumFaces obj1) do 
	(
		answer = getFaceMatID obj1 i
		if finditem the_array (answer as integer) == 0 then append the_array (answer as integer)
	)
	sort the_array
	to_print = "Face IDs: "
	for i = 1 to the_array.count do
	(
		to_print += the_array[i] as string
		if i != the_array.count then to_print += ", "
	)
	MessageBox to_print title:"DisplayMatID"
	print to_print
)
	
fn get_mat_ids_in_editable_poly obj1 = 
(
	the_array = #()
	for i = 1 to (getNumFaces obj1) do 
	(
		answer = polyop.getFaceMatID obj1 i
		if finditem the_array (answer as integer) == 0 then append the_array (answer as integer)
	)
	sort the_array
	to_print = "Face IDs: "
	for i = 1 to the_array.count do
	(
		to_print += the_array[i] as string
		if i != the_array.count then to_print += ", "
	)
	MessageBox to_print title:"DisplayMatID"
	print to_print
)
	
fn dmi_do obj = 
(
	if classof obj == Editable_mesh then get_mat_ids_in_editable_mesh obj
	else if classof obj == Editable_Poly then get_mat_ids_in_editable_poly obj
	else MessageBox "Please choose an Editable Mesh Or Editable Poly object." title:"DisplayMatID"
)

-- The Script

if selection.count != 1 then (MessageBox "Please select only one object." title:"DisplayMatID")
else dmi_do $
)
-------------------------------------------------------------------------------