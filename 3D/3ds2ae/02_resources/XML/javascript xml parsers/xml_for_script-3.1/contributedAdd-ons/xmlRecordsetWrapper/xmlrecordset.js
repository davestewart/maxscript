// ///////////////////////////////////////////////////////////////
//                                                              //
//   JavaScript XML Database Library v0.5                       //
//   Copyright (C) 2002 James S. Elkins. All rights reserved.   //
//   e-mail: jselkins@yahoo.com                                 //
//                                                              //
//   This package requires the script xmldom.js, part of the    //
//   XML for <SCRIPT> cross-browser XML parser package by       //
//   David Joham and Michael Houghton, available at             //
//   xmljs.sourceforge.net    
//
//  Version 3.1                                //
//                                                              //
// ///////////////////////////////////////////////////////////////

// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net


// CLASS Recordset EXPOSES THE FOLLOWING INTERFACE:

// listColumns()                          returns table (2-dimensional array) of column names, types, and maxlengths
// countColumns()                         returns number of columns in recordset
// countRecords()                         returns number of active records (children of <ACTIVE>) in recordset
// getIndex()                             returns record pointer set by moveX methods
// moveFirst()                            set pointer to first record
// movePrevious()                         set pointer to previous record
// moveNext()                             set pointer to next record
// moveLast()                             set pointer to last record
// moveTo(index)                          set record pointer to given index
// insertRecord(field1[,field2,...])      inserts a new record at end of recordset with field values set to supplied values
// updateRecord(field1[,field2,...])      changes all fields in the current record to supplied values
// deleteRecord()                         deletes the current record (unlinks it from <ACTIVE> and appends it to <DELETED>)
// getField(fieldName)                    gets the value of named field in current record
// setField(fieldName)                    changes value of named field in current record
// querySetField(fieldName,oldVal,newVal) sets named field to newVal in all active records where named field contains oldVal
// queryDelete(fieldName,value)           deletes all active records where named field contains supplied value
// serialize()                            returns recordset as XML text

// EXAMPLE XML RECORDSET DOCUMENT

// <?xml version="1.0" encoding="UTF-8"?>
// <RECORDSET>
//  <COLUMN name="name" type="text" maxlength="32"/>
//  <COLUMN name="soc_sec_num" type="text" maxlength="32"/>
//  <COLUMN name="date_hired" type="text" maxlength="32"/>
//  <COLUMN name="wage" type="number" maxlength="32"/>
//  <ACTIVE>
//   <RECORD id="0" status="unchanged">
//    <FIELD>John Doe</FIELD>
//    <FIELD>123-45-6789</FIELD>
//    <FIELD>01/01/2002</FIELD>
//    <FIELD>15.25</FIELD>
//   </RECORD>
//   <RECORD id="1" status="unchanged">
//    <FIELD>Jane Plain</FIELD>
//    <FIELD>987-65-4321</FIELD>
//    <FIELD>12/12/2001</FIELD>
//    <FIELD>16.50</FIELD>
//   </RECORD>
//  </ACTIVE>
//  <DELETED/>
// </RECORDSET>

function Recordset(xmlStr) {
 this.listColumns = rs_lst_col;
 this.countColumns = rs_cnt_col;
 this.countRecords = rs_cnt_rec;
 this.getIndex = rs_get_curr_rec;
 this.moveFirst = rs_mv_first;
 this.movePrevious = rs_mv_prev;
 this.moveNext = rs_mv_next;
 this.moveLast = rs_mv_last;
 this.moveTo = rs_mv_to;
 this.insertRecord = rs_ins_rec;
 this.updateRecord = rs_upd_rec;
 this.deleteRecord = rs_del_rec;
 this.getField = rs_get_field;
 this.setField = rs_set_field;
 this.querySetField = rs_qry_set_field;
 this.queryDelete = rs_qry_del;
 this.serialize = rs_serialize;
 this.doc = new XMLDoc(xmlStr);
 this.dom = this.doc.docNode;
 this.columns = this.dom.getElements("COLUMN");
 this.records = this.dom.getElements("ACTIVE")[0].getElements("RECORD");
 this.currentRecord = 0;
}

function rs_lst_col() {
 var lst = new Array();
 for (m=0;m<this.countColumns();m++) {
  var attrs = new Array();
  attrs['name'] = this.dom.getElements("COLUMN")[m].getAttribute('name');
  attrs['type'] = this.dom.getElements("COLUMN")[m].getAttribute('type');
  attrs['maxlength'] = this.dom.getElements("COLUMN")[m].getAttribute('maxlength');
  lst.push(attrs);
 }
 return lst;
}

function rs_cnt_col() {
 return this.columns.length;
}

function rs_cnt_rec() {
 return this.records.length;
}

function rs_get_curr_rec() {
 return this.currentRecord;
}

function rs_mv_first() {
 this.currentRecord = 0;
}

function rs_mv_prev() {
 this.currentRecord = (this.currentRecord == 0) ? this.countRecords() - 1 : this.currentRecord - 1;
}

function rs_mv_next() {
 this.currentRecord = (this.currentRecord == this.countRecords() - 1) ? 0 : this.currentRecord + 1;
}

function rs_mv_last() {
 this.currentRecord = this.countRecords() - 1;
}

function rs_mv_to(idx) {
 this.currentRecord = idx;
}

function rs_ins_rec() {
 var fields = rs_ins_rec.arguments;
 var id = this.countRecords();
 while (this.dom.getElements("ACTIVE")[0].getElementById(id)) {
  id++;
 }
 var xmlStr = '<RECORD id="' + id + '" status="new">';
 for (i=0;i<fields.length;i++) {
  xmlStr += '<FIELD>' + fields[i] + '</FIELD>';
 }
 xmlStr += '</RECORD>';
 var newRec = this.doc.createXMLNode(xmlStr);
 var lastRec = this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.dom.getElements("ACTIVE")[0].getElements("RECORD").length-1];
 if (this.countRecords() > 0) {
  this.doc = this.doc.insertNodeAfter(lastRec,newRec);
 }
 else {
  this.doc = this.doc.insertNodeInto(this.dom.getElements("ACTIVE")[0],newRec);
 }
 this.dom = this.doc.docNode;
 this.columns = this.dom.getElements("COLUMN");
 this.records = this.dom.getElements("ACTIVE")[0].getElements("RECORD");
}

function rs_upd_rec() {
 var fields = rs_upd_rec.arguments;
 var xmlStr = '';
 for (i=0;i<fields.length;i++) {
  xmlStr += '<FIELD>' + fields[i] + '</FIELD>';
 }
 this.doc = this.doc.replaceNodeContents(this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord],xmlStr);
 this.dom = this.doc.docNode;
 this.columns = this.dom.getElements("COLUMN");
 this.records = this.dom.getElements("ACTIVE")[0].getElements("RECORD");
 this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord].addAttribute("status","edited");
}

function rs_del_rec() {
 if (this.countRecords() > 0) {
  var xmlStr = this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord].getUnderlyingXMLText();
  var delNode = this.doc.createXMLNode(xmlStr);
  delNode.addAttribute("status","deleted");
  var trash = this.dom.getElements("DELETED")[0];
  this.doc = this.doc.removeNodeFromTree(this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord]);
  this.doc = this.doc.insertNodeInto(trash,delNode);
  this.dom = this.doc.docNode;
  this.columns = this.dom.getElements("COLUMN");
  this.records = this.dom.getElements("ACTIVE")[0].getElements("RECORD");
 }
}

function rs_get_field(name) {
 var cols = this.listColumns();
 var idx = 0;
 for (i=0;i<cols.length;i++) {
  if (cols[i]['name'] == name) {
   idx = i;
   break;
  }
 }
 return this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord].getElements("FIELD")[idx].getText();
}

function rs_set_field(name,newVal) {
 var cols = this.listColumns();
 var idx = 0;
 for (i=0;i<cols.length;i++) {
  if (cols[i]['name'] == name) {
   idx = i;
   break;
  }
 }
 this.doc = this.doc.replaceNodeContents(this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord].getElements("FIELD")[idx],newVal);
 this.dom = this.doc.docNode;
 this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord].addAttribute("status","edited");
 this.columns = this.dom.getElements("COLUMN");
 this.records = this.dom.getElements("ACTIVE")[0].getElements("RECORD");
}

function rs_qry_set_field(name,oldVal,newVal) {
 for (j=0;j<this.countRecords();j++) {
  this.moveTo(j);
  if (this.getField(name) == oldVal) {
   this.setField(name,newVal);
   this.dom.getElements("ACTIVE")[0].getElements("RECORD")[this.currentRecord].addAttribute("status","edited");
  }
 }
}

function rs_qry_del(name,val) {
 for (j=0;j<this.countRecords();j++) {
  this.moveTo(j);
  if (this.getField(name) == val) {
   this.deleteRecord();
   this.queryDelete(name,val);
  }
  else {
   this.moveNext();
  }
 }
}

function rs_serialize() {
 return this.doc.getUnderlyingXMLText();
}
