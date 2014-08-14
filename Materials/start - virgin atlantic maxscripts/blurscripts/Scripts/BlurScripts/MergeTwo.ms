-------------------------------------------------------------------------------
-- MergeTwo.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 08/01/01
-- Modified On: 08/31/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Same as a normal merge, except creates a selectionset automatically
-- from whatever you merged in.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
mfile = getMAXOpenFileName()
if mfile != undefined then
(
	mergeMAXFile (mfile) #prompt #select #noRedraw
	m = getFilenameFile mfile
	selectionSets[m] = selection
)
)
-------------------------------------------------------------------------------