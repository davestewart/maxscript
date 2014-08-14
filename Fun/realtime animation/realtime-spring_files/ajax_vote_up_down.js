if (isJsEnabled()) {
  addLoadEvent(voteUpDownAutoAttach);
}

function voteUpDownAutoAttach() {
  var vdb = [];
  var spans = document.getElementsByTagName('span');
  for (var i = 0; span = spans[i]; i++) {
    if (span && (hasClass(span, 'vote-up-inact') || hasClass(span, 'vote-down-inact') || hasClass(span, 'vote-up-act') || hasClass(span, 'vote-down-act'))) {
      // Read in the path to the PHP handler
      uri = span.getAttribute('title');
      // Read in the id
      id  = span.getAttribute('id');
      // Remove the title, so no tooltip will display
      span.removeAttribute('title');
      // remove href link
      var elem = document.getElementById(id);
      elem.innerHTML = '';
      // Create an object with this uri. Because
      // we feed in the span as an argument, we'll be able
      // to attach events to this element.
      if (!vdb[uri]) {
        vdb[uri] = new VDB(span, uri, id);
      }
    }
  }
}

/**
 * A Vote DataBase object
 */
function VDB(elt, uri, id) {
  var db = this;
  // By making the span element a property of this object,
  // we get the ability to attach behaviours to that element.
  this.elt = elt;
  this.uri = uri;
  this.id  = id;
  this.elt.onclick = function() {
    HTTPGet(db.uri, db.receive, db);
  }
}

/**
 * HTTP callback function.
 */
VDB.prototype.receive = function(string, xmlhttp, vdb) {
  if (xmlhttp.status != 200) {
    return alert('An HTTP error '+ xmlhttp.status +' occured.\n'+ vdb.uri);
  }

  // extract the cid so we can change other elements for the same cid
  var cid = vdb.id.match(/[0-9]+$/);
  var pid = 'vote_points_' + cid;
  //update the voting arrows
  var elem = document.getElementById(vdb.id);
  if (hasClass(elem, 'vote-up-inact')) {
    removeClass(elem, 'vote-up-inact');
    addClass(elem, 'vote-up-act');
    var did = 'vote_down_' + cid;
    if (document.getElementById(did)) {
      var elem2 = document.getElementById(did);
      removeClass(elem2, 'vote-down-act');
      addClass(elem2, 'vote-down-inact');
    }
  }
  else if (hasClass(elem, 'vote-down-inact')) {
    removeClass(elem, 'vote-down-inact');
    addClass(elem, 'vote-down-act');
    var uid = 'vote_up_' + cid;
    if (document.getElementById(uid)) {
      var elem2 = document.getElementById(uid);
      removeClass(elem2, 'vote-up-act');
      addClass(elem2, 'vote-up-inact');
    }
  }
  // update the points
  document.getElementById(pid).innerHTML = string;
}
