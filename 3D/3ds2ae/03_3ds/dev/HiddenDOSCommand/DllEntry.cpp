/**********************************************************************
 *<
	FILE: DllEntry.cpp

	DESCRIPTION: Contains the Dll Entry stuff

	CREATED BY: 

	HISTORY: 

 *>	Copyright (c) 2000, All Rights Reserved.
 **********************************************************************/

#include "MAX.h"

HINSTANCE hInstanceDLL;
int controlsInit = FALSE;

// This function is called by Windows when the DLL is loaded.  This 
// function may also be called many times during time critical operations
// like rendering.  Therefore developers need to be careful what they
// do inside this function.  In the code below, note how after the DLL is
// loaded the first time only a few statements are executed.

BOOL WINAPI DllMain(HINSTANCE hinstDLL,ULONG fdwReason,LPVOID lpvReserved)
{
	switch (fdwReason) 
	{ 
		case DLL_PROCESS_ATTACH: 

			hInstanceDLL = hinstDLL;				// Hang on to this DLL's instance handle.

			if (!controlsInit) {
				controlsInit = TRUE;
				InitCustomControls(hInstanceDLL);	// Initialize MAX's custom controls
				InitCommonControls();				// Initialize Win95 controls
			}

		break;
	}
			
	return (TRUE);
}

// This function returns a string that describes the DLL and where the user
// could purchase the DLL if they don't have it.
__declspec( dllexport ) const TCHAR* LibDescription()
{
	return "HiddenDOSCommand Maxscript Extension";
}

// This function returns a pre-defined constant indicating the version of 
// the system under which it was compiled.  It is used to allow the system
// to catch obsolete DLLs.
__declspec( dllexport ) ULONG LibVersion()
{
	return VERSION_3DSMAX;
}

__declspec( dllexport ) void LibInit()
{
}



