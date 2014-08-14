DOMElement.prototype.getAttribute = function DOMElement_getAttribute(name) {
  var ret = "";

  // if attribute exists, use it
  var attr = this.attributes.getNamedItem(name);

  if (attr) {
    ret = attr.value.toString();
  }

  return ret; // if Attribute exists, return its value, otherwise, return ""
};
