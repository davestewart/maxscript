-- Legal mumbo-jumbo
--
--   Copyright:  Copyright (C) 1999 by Digital Wizards
--   Author:     M² (msquared)
--   Email:      msquared@digitalwizards.com.au
--   URL:        http://www.digitalwizards.com.au/
--   License:    Free for personal and not-for-profit use by the
--               3D Studio MAX user community.  Please contact
--               us before you use this software commercially.
--
-- Name
--
--   calculateLookatMatrix - Calculate a lookat transformation
--
-- Description
--
--   This function takes a source point in 3D, a target in 3D, and
--   an orientation matrix.  An optional up vector can be provided too,
--   the default is the Z axis.  The result is a transformation matrix
--   that causes the X axis in the orientation matrix to point toward
--   the target, with the Z axis in the orientation matrix pointing
--   upward.  The orientation matrix permits the object to which the
--   final matrix is applied to be oriented so that whatever axis
--   as desired may be pointed toward the target.  If you want the
--   object's X axis pointing toward the target, with Z upwards, then
--   just pass an identity matrix as the orientation matrix.  The
--   translation applied to the orientation matrix (row 4) allows
--   you to change the effective centre of rotation of the object for
--   the lookat rotation.  The lookat final translation is the
--   origin, so that the resulting matrix can be applied directly to
--   the object as its transformation matrix, which will move it to
--   the origin and point it to the target.
--

function calculateLookatMatrix orientation origin target up:[0,0,1] =
(
	local lookatmatrix = matrix3 1
	lookatmatrix.row1 = normalize(target-origin)
	lookatmatrix.row2 = normalize (cross up lookatmatrix.row1)
	lookatmatrix.row3 = normalize (cross lookatmatrix.row1 lookatmatrix.row2)
	lookatmatrix.row4 = origin
	orientation * lookatmatrix
)
