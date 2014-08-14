/*
$.width = $.material.diffusemap.bitmap.width / 10
$.length = $.material.diffusemap.bitmap.height / 10
*/

map = $.material.diffusemap.bitmap

mw = map.width
pw = $.width

div = pw / mw

$.width = $.material.diffusemap.bitmap.width * div
$.length = $.material.diffusemap.bitmap.height * div
