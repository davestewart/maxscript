macroScript splineToMXS
	category:"Comet Cartoons"
	toolTip:"splineToMXS: Returns/Prints the currently selected shape objects to MAXScript code."
	Icon:#("Maxscript",3)
(
--
-- splineToMXS - Michael B. Comet - comet@comet-cartoons.com - http://www.comet-cartoons.com/
--		Copyright ©2002 Michael B. Comet  All Rights Reserved
--
--	For info/help read function comments below
--

-- -----------------------------------------------------------------------------------------------
-- Helper procs
-- -----------------------------------------------------------------------------------------------

fn executeString s = (if classof s == stringstream then seek s 0; execute s)
fn appendString s add = (format "%" add to:s)

/* 
 * replaceChar() - Given a string replaces all occurences of character f (from) with 
 *					character t (to)
 */
fn replaceChar str f t =
(
    if (str == "" or str == undefined) then
		return "";
		
	len = str.count;

	for i in 1 to len do
		(
		if (str[i] == f) then	-- replace it needed
			str[i] = t;		
		)

    return str;
)

-- -----------------------------------------------------------------------------------------------
--	Main Proc
-- -----------------------------------------------------------------------------------------------

/*
 * splineTpMXS() - This will take any selected "Editable Spline Object" and will convert
 *					it to a MAXScript Function that you can run to recreate it.  Useful
 *					for building control objects for rigging.  Just draw whatever you want, 
 *				    then select it, and run this function.  The object must be a "line"
 *					or be converted to "Editable Spline" before trying to export.
 *
 *					Note that the objects transform (ie: pos, rotation etc...) doesn't matter.
 *						The exported function will recreate the spline shape at 0,0,0 relative
 *						to the original object itself.  This means you MAY need to do a 
 *						"Reset XForm" on the shape before exporting.
 *
 *					You can then take that code and add it as a toolbar button or into 
 *					 your own scripts to easily recreate that shape.
 *
 *					This proc even retain the Object's name and the Wireframe color, so
 *						that the created object will be identical.  (The name may be 01, 02, etc...)
 *
 *					The name of the function that it creates will be called "create<OBJNAME>Shape()".
 *
 *					This returns the MAXScript code as a stringstream value.  And should appear
 *						also in the listener window.
 */
fn splineToMXS =
(
	str = stringstream "";

    objs = getCurrentSelection();
	
	for o in 1 to objs.count do
	    (
		if (classOf objs[o] == SplineShape or classOf objs[o] == line) then
		    (
			format "-- Exporting %\n" objs[o].name;

				-- Make sure function name has no spaces.
			fnName = replaceChar objs[o].name " " "_";

			appendString str ("-- Start of Shape Creation Proc\n");
			appendString str ("-- \n");
			appendString str ("fn create"+fnName +"Shape = \n");
			appendString str ("(\n\n");

			appendString str ("\tln = line();\n");

			ns = numSplines objs[o]
			for si in 1 to ns do
			    (
				appendString str ("\tsplIdx = addNewSpline ln;\n");

				nk = numKnots objs[o] si;	-- how many knots in this spline?
				for k in 1 to nk do
				    (
					type = getKnotType objs[o] si k;

					coordsys objs[o];
					    (

						pos = getKnotPoint objs[o] si k;
						
						appendString str ("\t\taddKnot ln splIdx #"+(type as string)+" #curve "+(pos as string));
	
						if (type == #bezier or type == #bezierCorner) then
						    (
							invec = getInVec objs[o] si k;
							outvec = getOutVec objs[o] si k;
							appendString str (" "+(invec as string)+" "+(outvec as string));
							)
	
						appendString str (";\n");
					
						)  -- end off coordsys

					)  -- end of knot loop

				closed = isClosed objs[o] si;
				
				if (closed == true) then
				    appendString str ("\tclose ln splIdx;\n");
				else
				    appendString str ("\topen ln splIdx;\n");
					
				)	-- end of splineIndex loop

			appendString str ("\tupdateShape ln;\n");
			appendString str ("\tconvertToSplineShape ln;\n");
			
			origColor = objs[o].wireColor;
			appendString str ("\tln.wireColor = "+(origColor as string)+";\n");
			appendString str ("\tln.name = uniqueName \""+(objs[o].name)+"\";\n");
			appendString str ("\tselect ln;\n");
			appendString str ("\treturn ln;\n");

			appendString str ("\n)\n");
			appendString str ("-- \n");
			appendString str ("-- End of Shape Creation Proc\n");
			)
		
		)

	format "-- splineToMXS OUTPUT:\n\n"
    format "%\n" (str as string); 
	format "\n\n";
	
	appendString str ("");

	return str;
)

-- now just do it for the macro!
splineToMXS();

)

