function alertBoxBuilder(){
	var dlg = new Window(
		'dialog', 
		'Alert Box Builder',
		[100,100,480,245]
		);
	
	dlg.msgPnl = dlg.add(
		'panel', 
		[25,15,355,130], 
		'Messages'
		);
	
	dlg.msgPnl.titleSt = dlg.msgPnl.add(
		'statictext',
		[15,15,105,35],
		'Alert box title:'
		);
	
	dlg.msgPnl.titleEt = dlg.msgPnl.add('edittext', [115,15,315,35], 'Sample Alert ' ) ;
	dlg.msgPnl.msgSt = dlg.msgPnl.add('statictext', [15,65,105,85], 'Aler t message:');
	dlg.msgPnl.msgEt = dlg.msgPnl.add(
		'edittext',
		[115,45,315,105],
		'<your message here>',
		{multiline:true} 
		);
	dlg.show();
	}

//alertBoxBuilder()

function createBuilderDialog()
	{
	//Create an empty dialog window near the upper left of the screen
		var dlg = new Window('dialog', 'Aler t Box Builder', [100,100,480,490]);
	
	//Add a panel to hold title and 'message text' strings
	dlg.msgPnl = dlg.add('panel', [25,15,355,130], 'Messages');
	dlg.msgPnl.titleSt = dlg.msgPnl.add('statictext', [15,15,105,35], 'Aler t box title:');
	dlg.msgPnl.titleEt = dlg.msgPnl.add('edittext', [115,15,315,35], 'Sample Alert ' ) ;
	dlg.msgPnl.msgSt = dlg.msgPnl.add('statictext', [15,65,105,85], 'Aler t message:');
	dlg.msgPnl.msgEt = dlg.msgPnl.add('edittext', [115,45,315,105], '<your message here>',
	{multiline:true});
	
	//Add a checkbox to control the presence of buttons to dismiss the alert box
	dlg.hasBtnsCb = dlg.add('checkbox', [125,145,255,165], 'Has aler t buttons?');
	
	//Add panel to determine alignment of buttons on the alert box
	dlg.alertBtnsPnl = dlg.add('panel', [45,180,335,225], 'Button alignment');
	dlg.alertBtnsPnl.alignLeftRb = dlg.alertBtnsPnl.add('radiobutton', [15,15,95,35], 'Left');
	dlg.alertBtnsPnl.alignCenterRb = dlg.alertBtnsPnl.add('radiobutton', [105,15,185,35], 'Center ' ) ;
	dlg.alertBtnsPnl.alignRightRb = dlg.alertBtnsPnl.add('radiobutton', [195,15,275,35], 'Right');
	
	//Add a panel with controls for the dimensions of the aler t box
	dlg.sizePnl = dlg.add('panel', [60,240,320,315], 'Dimensions');
	dlg.sizePnl.widthSt = dlg.sizePnl.add('statictext', [15,15,65,35], 'Width:');
	dlg.sizePnl.widthScrl = dlg.sizePnl.add('scrollbar', [75,15,195,35], 300, 300, 800);
	dlg.sizePnl.widthEt = dlg.sizePnl.add('edittext', [205,15,245,35]);
	dlg.sizePnl.heightSt = dlg.sizePnl.add('statictext', [15,45,65,65], 'Height:');
	dlg.sizePnl.heightScrl = dlg.sizePnl.add('scrollbar', [75,45,195,65], 200, 200, 600);
	dlg.sizePnl.heightEt = dlg.sizePnl.add('edittext', [205,45,245,65]);
	
	//Add a panel with buttons to test parameters and create the aler t box specification
	dlg.btnPnl = dlg.add('panel', [15,330,365,375], 'Build it');
	dlg.btnPnl.testBtn = dlg.btnPnl.add('button', [15,15,115,35], 'Test');
	dlg.btnPnl.buildBtn = dlg.btnPnl.add('button', [125,15,225,35], 'Build', {name:'ok'});
	dlg.btnPnl.cancelBtn = dlg.btnPnl.add('button', [235,15,335,35], 'Cance l ' , {name:'cancel'});
	
	return dlg;
	//createBuilderDialog
	}


function initializeBuilder(builder)
{
//Set up initial control states
with (builder) {
hasBtnsCb.value = true;
alertBtnsPnl.alignCenterRb.value = true;
with (sizePnl) {
widthEt . text = widthScrl.value;
heightEt . text = heightScrl.value;
}

}
//Attach event callback functions to controls
/*'has buttons' checkbox enables or disables the panel that
determines the justification of the 'aler t' button group */
builder.hasBtnsCb.onClick =
function () { this.parent.alertBtnsPnl.enabled = this.value; } ;
/*The edittext fields and scrollbars in sizePnl are connected */
with (builder.sizePnl) {
widthEt.onChange =
function () { this.parent.widthScrl.value = this.text; } ;
widthScrl.onChange =
function () { this.parent.widthEt . text = this.value; } ;
heightEt.onChange =
function () { this.parent.heightScrl.value = this.text; } ;
heightScrl.onChange =
function () { this.parent.heightEt . text = this.value; } ;
}
with (builder.btnPnl) {
//The Test button creates a tri a l Alert box from the current specifications
testBtn.onClick =
function () {
Window.alert('Type Enter or Esc to dismiss the test Alert box');
createTestDialog(createResource(this.parent.parent));
};
//The Build and Cancel buttons close this dialog
buildBtn.onClick =
function () { this.parent.parent.close(1); } ;
cancelBtn.onClick =
function () { this.parent.parent.close(2); } ;
};
} // initializeBuilder
function runBuilder(builder)
{
//Run the builder dialog, return i t s result
return builder.show();
}
/*This function creates and returns a string containing a dialog
resource specification that will create an Alert dialog using
the parameters the user entered. */
function createResource(builder)
{
//Define the initial part of the resource spec with dialog parameters
var dlgWidth = Number(builder.sizePnl.widthEt . text);
var dlgHeight = Number(builder.sizePnl.heightEt . text);
var res = "dialog { " +
stringProperty("text", builder.msgPnl.titleEt . text) +
arrayProperty("bounds", 0, 0, dlgWidth, dlgHeight) +
"\n";
//Define the alert message statictext element, sizing it to the aler t box
var margin = 15; var l, t ;
var msgWidth, msgHeight;
var hasButtons = builder.hasBtnsCb.value;
var btnsHeightUsed = hasButtons ? 20 + margin : 0;
msgHeight = 60;
msgWidth = dlgWidth - (margin * 2);
l = margin;
t = (dlgHeight - msgHeight - btnsHeightUsed) / 2;
res += " msg: StaticText { " +
stringProperty("text", builder.msgPnl.msgEt . text) +
arrayProperty("bounds", l , t , l + msgWidth, t + msgHeight) +
"justify : ' center ' , properties:{multiline:true} }";
//Define buttons if desired
 if(hasButtons) {
var btnWidth = 90;
//Align buttons as specified
with (builder.alertBtnsPnl) {
 (alignLeftRb.value)
l = margin;
else if (alignCenterRb.value)
l = (dlgWidth - (btnWidth * 2 + 10)) / 2;
else
l = dlgWidth - ((btnWidth * 2 + 10) + margin);
}
t = dlgHeight - btnsHeightUsed;
res += ",\n" +
" okBtn: Button { " +
stringProperty("text", "OK") +
arrayProperty("bounds", l , t , l + btnWidth, t + 20) +
"},\n";
l += btnWidth + 10;
res += " cancelBtn: Button { " +
stringProperty("text", "Cancel") +
arrayProperty("bounds", l , t , l + btnWidth, t + 20) +
"}";
}
//All done!
res += "\n}";
return res;
}
function stringProperty(pname, pval)
{
return pname + ":'" + pval + "', " ;
}
function arrayProperty(pname, l , t , r, b)
{
return pname + ":[" + l + "," + t + "," + r + "," + b + "], " ;
}
function createTestDialog(resource)
{
var target = new Window (resource);
return target.show();
}
//------------- Main script -------------//
var builder = createBuilderDialog();
initializeBuilder(builder);
 (runBuilder(builder) == 1) {
//Create the Alert dialog resource specification string
var resSpec = createResource(builder);
//Write the resource specification string to a file, using the standard file open dialog
var fname = File.openDialog('Save resource specification');
var f = File(fname);
 (f.open('w')) {
var ok = f.write(resSpec);
 (ok)
ok = f.close();
 (! ok)
Window.alert("Error creating " + fname + ": " + f.error);
}
}