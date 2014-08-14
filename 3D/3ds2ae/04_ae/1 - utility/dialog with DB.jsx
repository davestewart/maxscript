//Client Upload Script v1.0
//===Byron Nash===   
//September 2004
//Certain parts of this script were taken from the After Effects documentation, 
// aenhancers.com, and motionscript.com.
//
/*Instructions: Select a comp you want to upload to the client site.
-Choose a folder for the rendered files and upload information file to go.
-Choose the DB file.(this will be automated from the server in the future)
-Pick a client and project
-Enter data and hit build to write the data to a file.*/
{//opening
var clientName = "Speedy";
var projectName = "NASCAR";
var userText = "No Comments";
var titleText = "No TITLE";
var emailBo = true;
var commentsBo = true;
var embedBo = true;
var renderBo = false;
var aInfo = new Array();
var compName = "NoCompNameYet";
var renderLoc = "C:/temp/";
var setupOutput = new Array();

//============================================================================
function collectFromDB(){
var yLocation = 15;
var oClients = new Array();  //original client array pulled from the text file
var sClient = "Nothing" ;  
var masterList = new Array();
var panel = "";
var projects = new Array();
var singleProjList = new Array();
var curProjBtnList = new Array()  //array containing the list of project buttons
var selClientName = "King Tubby"
var selProject = "The Best of Studio One"

//============================================================================
function addRadioButton(panel,buttonSize,buttonName){ //obsolete, delete?
var newRButton = panel.add('radiobutton',buttonSize,buttonName);
newRButton.onClick = setProject;
return newRButton;
}
//============================================================================
function setProject(){
selProject = this.text;
}
//============================================================================
function onClientChange(){ //When a client is chosen, it re-populates the project list
getProjectList(this.text);  //call function to retrieve the list of projects
button_top = button_height;  //reset the button placement for adding project buttons
button_bottom = button_top + button_height; 

if (curProjBtnList.length > 0){  //If project buttons exist, jump into a loop to hide them
	for(var k=0; k < curProjBtnList.length; k++){ //Loop through and turn off existing buttons
		curProjBtnList[k].visible = false;
	}
}
for(var l=1; l < singleProjList.length; l++){  //loop through the project list and make a button for each
	var sProj = singleProjList[l]; //grab a single project
	rbutton = addRadioButton(dlg.Proj,[button_left,button_top,button_right,button_bottom],sProj);
	button_top = button_bottom + between_button_width;  //increment button placement
	button_bottom = button_top + button_height;
	curProjBtnList[(l-1)] = rbutton; //make an array of all the project buttons
		if (l>10) break;  //jump out if we get stuck

}
}
//============================================================================
function addClientButton(panel,buttonSize,buttonName){  //function to create the client buttons
var newButton = panel.add('radiobutton',buttonSize,buttonName);  //Make the button
newButton.onClick = onClientChange;  //call the onClientChange function when a new client is selected
return newButton  //returns a button to be added to an array
}
//============================================================================
function getProjectList(clientName){  //Gets the list of projects by comparing the client name with the button name
var oCounter = 0;
selClientName = clientName; //set a global variable that defines the selected client
while (clientName != oClients[oCounter]){
	
	oCounter++;
	if (oCounter>10) break;//break out if it gets out of control
}
singleProjList = masterList[oCounter].split(","); //set the variable to the chosen client project list
}
//============================================================================
 var myFile = fileGetDialog("Select a text file to open.", "");
    if (myFile != null){

    // open file
    var fileOK = myFile.open("r","TEXT","????");
    if (fileOK){


      var oCount = 0;
      while (!myFile.eof){
	var textline = myFile.readln();
	masterList[oCount] = textline;
	var marker = textline.indexOf(",");
	oClients[oCount] = textline.slice(0,marker);
	//singleProjList = masterList[oCount].split(",");
	oCount = oCount + 1;
	
}

//Setup Button bounds and placement
// Horizontal Spacing variables
var left_margin_width    = 5;
var right_margin_width   = 5;
var between_button_width = 5;

// Width of buttons 
var button_width = 200;
var button_height = 20;

//Variables to describe the button size and placement
var button_left  = left_margin_width;
var button_right = button_left + button_width;
var button_top  = button_height;
var button_bottom = button_top + button_height;
var palette_width  = button_right + right_margin_width;

//Create an empty dialog window near the upper left of the screen
var dlg = new Window('dialog', 'Client File Uploader V1.0 by Byron Nash', [200,200,720,580]);

//Add panel to choose a client
dlg.ClientPnl = dlg.add('panel', [10,10,255,170], 'Client List');

//Add panel to choose a Project
dlg.Proj = dlg.add('panel', [260,10,510,170], 'Project List');
dlg.Proj.enabled = false; //?disable the panel makes the user able to select the project buttons. Why?

dlg.msgPnl = dlg.add('panel', [10,180,375,340], 'Information');

dlg.msgPnl.titleSt = dlg.msgPnl.add('statictext', [15,15,85,35], 'Name');
dlg.msgPnl.titleEt = dlg.msgPnl.add('edittext', [85,15,355,35], 'Enter Name Here ' ) ;

dlg.msgPnl.msgSt = dlg.msgPnl.add('statictext', [15,45,85,65], 'Comments');
dlg.msgPnl.msgEt = dlg.msgPnl.add('edittext', [85,45,355,145], '<your message here>', {multiline:true});

var cbLeft = 395; //Check boxes Left position
var cbSpace = 15; //spacing of Check boxes
var cbYpos = 260; //starting y position of check boxes

//Add a checkbox to control the Comments and Email Notify
dlg.commentsCb = dlg.add('checkbox', [cbLeft,cbYpos,530,(cbSpace+cbYpos)], 'Allow Comments?');
cbYpos = cbYpos + cbSpace + 5;
dlg.emailCb = dlg.add('checkbox', [cbLeft,cbYpos,530,(cbSpace+cbYpos)], 'Email Notify?');
cbYpos = cbYpos + cbSpace + 5;
dlg.embedCb = dlg.add('checkbox', [cbLeft,cbYpos,530,(cbSpace+cbYpos)], 'Embed Movie?');
cbYpos = cbYpos + cbSpace + 5;
dlg.renderCb = dlg.add('checkbox', [cbLeft,cbYpos,530,(cbSpace+cbYpos)], 'Start Render Now?');

//Add a panel with buttons for OK and Cancel
dlg.btnPnl = dlg.add('panel', [180,345,340,375], '');
dlg.btnPnl.buildBtn = dlg.btnPnl.add('button', [5,5,75,25], 'Ok', {name:'ok'});
dlg.btnPnl.cancelBtn = dlg.btnPnl.add('button', [85,5,155,25], 'Cancel ' , {name:'cancel'});

var clientButtonList = new Array() //new array for the list of buttons for clients

for(var j=0; j < oClients.length; j++){  //Loop through the list of clients array and make a new button for each client
		sClient = oClients.slice(j,j+1);  //separate out one client from the array
		sClient = sClient.toString() 
		rbutton = addClientButton(dlg.ClientPnl,[button_left,button_top,button_right,button_bottom],sClient);
		clientButtonList[j] = rbutton //add current button to array
		button_top = button_bottom + between_button_width; //Increment for next button placement
		button_bottom = button_top + button_height;
		if (j>10) break; //Break the loop in case I've screwed something up
		
}

if(dlg.show() !=1){ //Send an alert if the user hits cancel
alert("User Cancelled");
}
}	        
}
sClient = ""; //clear out variables
oClients = "";
clientName = selClientName;
projectName = selProject;
userText = dlg.msgPnl.msgEt.text;
titleText = dlg.msgPnl.titleEt.text;
emailBo = dlg.emailCb.value;
commentsBo = dlg.commentsCb.value;
embedBo = dlg.embedCb.value;
renderBo = dlg.renderCb.value;
tempInfo = [titleText,userText,commentsBo,emailBo,embedBo,renderBo]
return tempInfo
}//closing db function

//====================================================================================================

function setupRender(){
// Preview Maker
//
// Select a comp to make a small quicktime and associated thumbnail image.
// Requires a Render Setting template named "Preview_Web" and "Thumbnail_Web"
// Requires an Output Module template names "Preview_Web" and "jpeg"
//

//Set up template variables
var movRS = "Preview_Web";  //Render Setting Template for Movie File
var thumbRS = "Thumbnail_Web";  //Render Setting Template for Thumbnail File
var movOM = "Preview_Web";  //Output Module Template for Movie File
var thumbOM = "jpeg";  //Output Module Template for Thumbnail File

var myComp = app.project.activeItem;
  if(myComp instanceof CompItem) {
    renderLoc = folderGetDialog("Select a render destination...");
    var stillTime = myComp.time;
    var compName = myComp.name;
    
    //Add a quicktime to the queue
    app.project.renderQueue.items.add(myComp); //add item to the Render Queue
    var renderIndex = app.project.renderQueue.numItems;  //count the items 
    var qItem = app.project.renderQueue.item(renderIndex);
    qItem.outputModules[1].applyTemplate(movOM); //apply template for quicktime
    qItem.applyTemplate(movRS); //apply render setting
    var curOM = qItem.outputModules[1];
        curOM.file = new File(renderLoc.toString() + "/" + myComp.name + "_Preview.mov"); //rename file 
    
    //Clear the values
    renderIndex = "";
    qItem = "";
    curOM = "";
    
    //Add a thumbnail image to the Queue    
    app.project.renderQueue.items.add(myComp); //add item to the Render Queue
    renderIndex = app.project.renderQueue.numItems;  //count the items 
    qItem = app.project.renderQueue.item(renderIndex);
    qItem.outputModules[1].applyTemplate(thumbOM); //apply template for quicktime
    qItem.applyTemplate(thumbRS);
    qItem.timeSpanDuration = 0.0333333;
    qItem.timeSpanStart = stillTime;
    curOM = qItem.outputModules[1];
    curOM.file = new File(renderLoc.toString() + "/" + myComp.name + "_Thumbnail_.\[#\].jpg ");
       
    
    app.project.renderQueue.showWindow(true); //bring the RQ window to the front
    
    //app.project.renderQueue.render()  //start the render
    //app.project.renderQueue.item(1).outputModules[i].name
}
else{
alert("Select a comp you moron!");
}

//Clear everything out
renderIndex = "";
qItem = "";
curOM = "";
fileOutput = [renderLoc,compName]
return fileOutput;
}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

function writeInfo(compName,aInfo,folderLoc){
var default_text_filename = compName;

default_text_filename += "_upload_info.txt";
// Create a file object for the file we'll write out.
//var text_file = filePutDialog("Select a file to output your results", default_text_filename, "TEXT txt");
//alert(folderLoc.toString() + default_text_filename);
var text_file = new File(folderLoc.toString() + "/" + default_text_filename);

if (text_file == null){
alert("No output file selected. Aborting. " ) ;
} else {
// opens file for writing. First argument is mode ("w" for writing),
text_file.open("w","TEXT","????");
// Write the heading of the file:
text_file.writeln("Upload information for " + default_text_filename);
text_file.writeln("Client: " + clientName);
text_file.writeln("Project: " + projectName);
text_file.writeln("Name: " + aInfo[0]);
text_file.writeln("Comments: " + aInfo[1]);
text_file.writeln("Email Notify: " + aInfo[2]);
text_file.writeln("Allow Comments: " + aInfo[3]);
text_file.writeln("File type: Quicktime");
text_file.writeln("Movie Size: 320 x 240");
text_file.writeln("Embed Movie: " + aInfo[4]);
text_file.writeln("File Location: " + folderLoc.toString() + "/" + compName + "_Preview.mov");
text_file.writeln("Thumbnail Location: " + folderLoc.toString() + "/" + compName + "_Thumbnail_.\[#\].jpg");
text_file.close();
}

}//close function

//---------------------------------------------------------------------------------
//MAIN SCRIPT
//---------------------------------------------------------------------------------
if (confirm("Do you want to upload files and info to server after render?")){
setupOutput = setupRender();
aInfo = collectFromDB();
writeInfo(setupOutput[1],aInfo,setupOutput[0]); //Write out the info gleaned from the user to a text file.
if(aInfo[5] == true){ //Check to see if "Render Now" is checked and start the render.
	alert("The Script would now start to render")
}
}else {
setupRender();
}
}//closing