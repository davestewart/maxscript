/*
 * adsense_click.js - fires counter to log adsense clicks
 */
var lastStatus = '';
function aslog(e) {
  window.focus();
  if (window.status && (window.status!=lastStatus)) {
    lastStatus = window.status;
    var bug = new Image();
    bug.src = window.location.protocol + '//' + window.location.host + '/adsense/counter' + '?u=' + escape(document.location);
  }
}

var iframeObj;
var elements;
elements = document.getElementsByTagName("iframe");
for (var i = 0; i < elements.length; i++) {
  if(elements[i].src.indexOf('googlesyndication.com') > -1) {
    if (document.layers) {
      elements[i].captureEvents(Events.ONFOCUS);
    }
    elements[i].onfocus = aslog;
    iframeObj = elements[i];
  }
}
