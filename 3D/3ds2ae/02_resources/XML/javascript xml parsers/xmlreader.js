/*
  JS XML Document Reader.  Author Joe McCormack.  Copyright 2003.  All Rights Reserved.
  www.geocities.com/code_stratos/
*/
function getRecords(locale,docid,place) {
var plate = new String();
var lemme = new String(docid);
var dest = new String(place);
var recordSet = window.document.getElementById(lemme).recordset;
	while(!recordSet.EOF) {
	plate += "<table border=\"0\" width=\"100%\" cellpadding=\"5\" cellspacing=\"0\"><tr>";
		if (recordSet("D").value.length > 0) {
		plate += "<td valign=\"top\"><center>";
		if (locale == "links") {
		if (recordSet("C").value.length > 0) { plate += "<a href=\"http://"+recordSet("C")+"\">"; }
		plate += "<img src=\""+recordSet("D")+"\" border=0 alt=\""+recordSet("A")+"\" />";
		if (recordSet("C").value.length > 0) { plate += "</a>"; }
		}
		if (locale == "email") {
		if (recordSet("C").value.length > 0) { plate += "<a href=\"mailto:"+recordSet("C")+"\">"; }
		plate += "<img src=\""+recordSet("D")+"\" border=0 alt=\""+recordSet("A")+"\" />";
		if (recordSet("C").value.length > 0) { plate += "</a>"; }
		}
		plate += "</center></td>";
		}
	plate += "<td valign=\"top\">";
		if (recordSet("C").value.length > 0) {
		if (locale == "links") { plate += "<a href=\"http://"+recordSet("C")+"\">"; }
		if (locale == "email") { plate += "<a href=\"mailto:"+recordSet("C")+"\">"; }
		}
	plate += recordSet("A"); if (recordSet("C").value.length > 0) { plate += "</a>"; }
	plate += "&nbsp;&nbsp;"+recordSet("B")+"</td></tr></table>";
	recordSet.moveNext();
}
window.document.getElementById(dest).innerHTML = plate;
}

