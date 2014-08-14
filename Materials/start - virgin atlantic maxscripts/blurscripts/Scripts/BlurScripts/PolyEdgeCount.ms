-------------------------------------------------------------------------------
-- PolyEdgeCount.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 02/28/01
-- Modified On: 02/28/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Prints to the listener the number of edges a selected polygon has.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if selection.count == 1 then
	(
	if classof $ == Editable_Poly then
		(
		temp_array = #()
		for i in (getfaceselection $) do 
			(
			append temp_array i
			)
		for i in temp_array do
			(
			num_edges = (polyop.getFaceEdges $ i).count
			to_print = "Polygon " + (i as string) + ": " + (num_edges as string) + " Edges"
			print to_print
			)
		)
	)
)
-------------------------------------------------------------------------------