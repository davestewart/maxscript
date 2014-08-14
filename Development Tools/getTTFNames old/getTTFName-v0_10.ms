--*****************************************************
-- getTTFName-v0_10.ms
--
-- 08.11.01, swami*, a.k.a. "codeWarrior()", swami@cfl.rr.com
-- Written for MAX R4.20
-- (Does NOT run in R3.x)
--
--*****************************************************
--
--  ***************************************************
--  ***       FOR NON-COMMERCIAL USE ONLY!          ***
--  *** Contact the author for licensing agreement  ***
--  ***            or custom scripting              ***
--  ***       copyright 2001 SWAMANIMATIONS!        ***
--  ***************************************************
--
--*****************************************************
-- INSTALLATION:
--
-- Required Extensions  :
-- Required Scripts     :
-- Required Files       :ttfname.exe
-- Optional Files       :ttfname-v1_0.zip (source & exe)
--                      :TableDirectory&NameIDsExplained-010809-02.zip
--
--    - Put script anywhere.
--    - Put 'ttfname.exe' in max ..\scripts.
--*****************************************************
-- PURPOSE:
--    - To get common names of system ttf fonts.
--*****************************************************
-- USAGE:
--    - See end of script for examples...
--*****************************************************
-- COMMENTS:
--    - This is a WIP.
--    - There has been minimal testing. More is required...
--    - There is minimal error checking/handling.
--    - The script is NOT optimized.
--
--    - Dave Stewart <3dsmax@davestewart.co.uk> wrote:
--    - "
--    - Is it possible to get a list of installed fonts as an array to place in a dropdownlist box?
--    - "
--
--    - This script is a LIMITED solution.  Future versions will improve upon it...
--
--    - Overview of operation:
--        - ttf font names are gotten via a call to 'ttfname.exe' using 'DOSCommand'
--          (this leads to limitations which will be discussed, later...).
--          This executable runs in console mode in a DOSPrompt window.  The source code is in C++.
--        - The ttf font filenames are put into an array (via MXS).
--        - ttfname is called in a loop: once for each file.
--        - ttfname ATTEMPTS to read the Name Table data in the ttf.
--        - The results are output to the console by ttfname.
--        - This is piped to a temp file (c:\ttfnameTMP.txt) by MXS.
--        - According to the ttf spec., line 5 is the font common name.  This is the name which appears
--          in a max text object's dropdown list and the one required by the '.font' property in MXS.
--        - This line is put into a data structure which also contains the associated filename.
--        - The result is an array of data structures from which the names can be pulled (and sorted).
--          This has been automated via a call to 'getTTFNameStrs()'.
--        - Several usage examples are provided at the end of the script.
--
--    - Limitations:
--        - Each call to ttfname pops up a DOSPrompt window! That's a lot o windows considering the number
--          of fonts in the Windows fonts directory (150 on my system). It works, but it ain't pretty!
--        - ttfname does NOT always find a name table, or errors out in some way, resulting in 'undefined'
--          being assigned to the font name :( My test yielded 110 out of the 150 installed.
--
--    - Future Plans/Fixes...
--       1) The best fix is to realize the ttfname functionality in MXS. Binary read is possible in MXS,
--          and I have been able to identify some matching methods, so hopefully a conversion is possible.
--       2) Another fix is to modify the ttfname code to process an array of files (not just one at a time
--          as it currently does), and to output the results to a data file (instead of to the console).
--          This could then be read by MXS.
--       3) Get the font names from the Registry (don't know if I want to go there!)
--
--        - Solutions 1 and 2 require that I FULLY understand the ttfname code.
--          Time to dig in and learn some C++!...
--
--        - But in the meantime, here's a chunk of code that gets the font names into an array
--          (well, most of 'em)...
--*****************************************************
-- HISTORY:
-- (Legend: M => Major change; m => minor change; B => Bug fix; (i) => info.)
--    - v0.10 (08.11.01):
--        (i) 1st Beta version.
--*****************************************************
--
--             <<< S C R I P T   S T A R T S   H E R E >>> 
--
--
--------------------------
--<< F U N C T I O N S >>
--------------------------
--------------------------
-- FUNCTION (sortCaseInsensitive)
-- 
-- This function sorts an array of strings in ascending or descending alphabetical order while ignoring case.
-- Returns "undefined" if an error occurs.
-- By default, sort is asceneding.  For descending sort, pass asc:false.
-- Sort string value is case sensitive (e.g. "Z" is BEFORE "a"!).
-- Sort #name value is NOT case sensitive (go figure!).

fn sortCaseInsensitive theArray asc:true =
(
	try
	(
		theArray=for arg in theArray collect (arg as name)
		sort theArray
		
		if NOT asc then
		(
			local theArrayTMP=copy theArray #noMap
			local revIdx=theArray.count
			for i = 1 to theArray.count do
			(
				theArray[revIdx]=theArrayTMP[i] as string
				revIdx-=1
			)
			theArray
		)
		else
		(		
			theArray=for arg in theArray collect (arg as string)
		)
	)
	catch(theArray=undefined)
)
--------------------------
-- FUNCTION (getFontsFilenameArr)
--
-- This function gets all the font filenames from a directory.
-- This defaults to the Windows fonts directory.

fn getFontsFilenameArr fDir:(sysInfo.windowsDir+"\\Fonts\\") =
(
	setWaitCursor()
	
	sysFontsArr =getFiles (fDir+"*.ttf")
	sysFontsArr =sortCaseInsensitive sysFontsArr
	
	setArrowCursor()
	
	sysFontsArr
)
--------------------------
-- FUNCTION (getTTFName)
--
-- This function get the font common name for a SINGLE ttf file.
-- It returns a data structure containing the name and the associated filename.

fn getTTFName
		fDir:		(sysInfo.windowsDir+"\\Fonts\\")
		ttf:		"allegron"
		fFilename:	undefined
		dbug:		false
=
(
	setWaitCursor()
	
	-- Build filename.
	ff	=if fFilename!=undefined then fFilename else (fDir+ttf+".ttf")
	
	-- Call 'ttfname' and pipe results to a temp file.
	ttfnameTMP	="c:\\ttfnameTMP.txt"
	cmdStr		=(getDir #scripts)+"\\ttfname "+ff+" >"+ttfnameTMP
	DOSCommand cmdStr
	
	-- Open the temp file.
	df=openFile ttfnameTMP
	
	-- Get the font common name from the temp file.
	local fontName
	for i=1 to 5 where (NOT eof df) do
	(
		try
		(
			fontName=readLine df
		)
		catch exit
	)
	
	flush df
	close df

	setArrowCursor()
	
	-- Define and return the data structure.
	struct fontStruct (fName,cName)		-- fName=>filename; cName=>proper name.
	fontStruct fName:ff cName:fontName	-- Return a structure containing the filename AND the common name.
)
--------------------------
-- FUNCTION (getTTFNameStrs)
--
-- This function gets the font common names as an array of sorted strings for a given directory.

fn getTTFNameStrs
		fDir:		(sysInfo.windowsDir+"\\Fonts\\")
		fFilename:	undefined
		cntMax:		1000
		dbug:		false
=
(
	-- Get ALL the font filenames and common names.
	global gffAllArr, fontAllArr, fontArr
	
	gffAllArr	=getFontsFilenameArr()
	cnt			=0
	fontStruct	=for f in gffAllArr where (cnt+=1; cnt<=cntMax) collect getTTFName fFilename:f
	ttfNameStrs	=for f in fontStruct where (f.cName!=undefined) collect f.cName
	ttfNameStrs	=sortCaseInsensitive ttfNameStrs
)
--------------------------
--------------------------

-- USAGE:

-- Note: In general the results have been declared as global for inspection, but in practice they
--       should be declared as local whereever possible.

example=0	-- Set =0 to not run any example.
case example of
(
	1:-- Get ALL the font filenames into an array, and write results to Listener.
	(
		global gffAllArr, fontAllArr, fontArr
		
		gffAllArr	=getFontsFilenameArr()
		cnt			=0
		cntMax		=1000
		fontAllArr	=for f in gffAllArr where (cnt+=1; cnt<=cntMax) collect f
		
		-- Write ALL the font filenames and common names to the Listener.
		format "\nfontAllArr (cnt=%)\n" fontAllArr.count
		for f in fontAllArr do format "%\n" f
	)

	2:-- Get the first 5 font common names into an array, and write results to Listener.
	(
		global fontStrsArr=getTTFNameStrs cntMax:5
		
		format "\nFont Strings (%)\n" fontStrsArr.count
		for f in fontStrsArr do format "%\n" f
	)

	3:-- Get ALL the font common names into an array, and write results to Listener.
	(
		global fontStrsArr=getTTFNameStrs()
		
		format "\nFont Strings (%)\n" fontStrsArr.count
		for f in fontStrsArr do format "%\n" f
	)

	4:-- Get ALL the font filenames and common names, and write results to Listener.
	  -- This example can be used to troubleshoot which fonts files are not processed properly.
	(
		global gffAllArr
		
		gffAllArr	=getFontsFilenameArr()
		cnt			=0
		cntMax		=1000
		fontStruct	=for f in gffAllArr where (cnt+=1; cnt<=cntMax) collect getTTFName fFilename:f
		
		for f in fontStruct do format "%\n" f
	)
)