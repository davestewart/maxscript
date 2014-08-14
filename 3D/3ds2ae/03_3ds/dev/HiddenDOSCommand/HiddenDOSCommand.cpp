//*********************************************************
// HiddenDOSCommand maxscript extension
// --biddle 8/3/05
//*********************************************************

#include "MAX.h"
#include "MAXScrpt.h"
#include "Numbers.h"
#include "Strings.h"
#include "Name.h"

//********************************************************
#include "definsfn.h"
#include "lclimpfn.h"

def_visible_primitive( HiddenDOSCommand, "HiddenDOSCommand");

Value* HiddenDOSCommand_cf(Value** arg_list, int count)
{
	check_arg_count_with_keys(HiddenDOSCommand, 1, count);
	TCHAR* params = arg_list[0]->to_string();

	Value* key;

	// Look for a starting path to launch the command from
	Value* def_name(startpath);
	key = key_arg(startpath);
	TCHAR* startpath = (key == &unsupplied) ? 0 : key->to_string();

	// Look for a wait-for-completion override 
	const bool DEFAULT_WAIT_FOR_COMPLETION = false;
	Value* def_name(donotwait);
	key = key_arg(donotwait);
	BOOL donotwait = (key == &unsupplied) ? DEFAULT_WAIT_FOR_COMPLETION : key->to_bool();

	// Look for a prompt string
	Value* def_name(prompt);
	key = key_arg(prompt);
	TCHAR* prompt = (key == &unsupplied) ? 0 : key->to_string();

	PROCESS_INFORMATION pi;
	STARTUPINFO si;

	ZeroMemory( &pi, sizeof(pi) );
	ZeroMemory( &si, sizeof(si) );
	si.cb = sizeof(si);

	GetCOREInterface()->PushPrompt( prompt ? prompt : params ) ;

	// You may want to adjust the arguments passed to cmd here,
	// type 'cmd /?' from the console for additional documentation
	TSTR args("cmd /e:on /d /c ");

	// Make sure we have a quoted command string
	if ( (params[0] != '\"') || (params[_tcslen(params)-1] != '\"') )
	{
		args.append("\"");
		args.append(params);
		args.append("\"");
	}
	else
	{
		args.append(params);
	}

	BOOL ret = CreateProcess(
		NULL,					
		args.data(),		 
		NULL,					 
		NULL,					
		false,					
		CREATE_NO_WINDOW,		
		NULL,					
		startpath,
		&si,					
		&pi);					

	DWORD ExitCode = 0;

	if (ret && !donotwait)
	{
		ret = (WAIT_OBJECT_0 == WaitForSingleObject( pi.hProcess, INFINITE ));
		GetExitCodeProcess(pi.hProcess,&ExitCode);
	}

	GetCOREInterface()->PopPrompt();

	// Close process and thread handles. 
	CloseHandle( pi.hProcess );
	CloseHandle( pi.hThread );

	if (ret) 
	{
		return &true_value;
	}
	else 
	{
		mprintf("-- Error! CreateProcess(%s) failed!\n", args.data());
		return &false_value;
	}
}
