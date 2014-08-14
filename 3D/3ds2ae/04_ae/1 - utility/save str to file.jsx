// Need to check prototype function for the argument as it currently fails if supplied
// think its to do with file not existing
/*
function saveToFile(str,textFile){
	if(textFile==undefined){
		var textFile = filePutDialog("Select a file to output your results", "", "TEXT txt");
		}
	if (textFile == null){
		alert("No output file selected. Aborting. " ) ;
		}
	else {
		textFile.open("w","TEXT","????");
		textFile.writeln(str)
		}
	textFile.close()
	}
*/
String.prototype.saveToFile=function(path){
	if(this!=undefined){
		textFile=new File(path)
		if(!File(textFile).exists)textFile = filePutDialog("The path defined in the script does not exist. Select a file to output your results", "", "TEXT txt");
		}
	
	else {
		textFile = filePutDialog("Select a file to output your results", "", "TEXT txt");
		}

	if (textFile == null || textFile ==undefined)alert("No output file selected. Aborting." ) ;
	else {
		textFile.open("w","TEXT","????");
		textFile.writeln(this)
		textFile.close()
		}
	}

/*
str="hello"
var path='/E/02_Current_Jobs/2005-04_BBC4_Beethoven/2_testing/test.txt'
str.saveToFile(path)

new File(path)

*/