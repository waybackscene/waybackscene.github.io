var _____WB$wombat$assign$function_____ = function(name) {return (self._wb_wombat && self._wb_wombat.local_init && self._wb_wombat.local_init(name)) || self[name]; };
if (!self.__WB_pmw) { self.__WB_pmw = function(obj) { this.__WB_source = obj; return this; } }
{
  let window = _____WB$wombat$assign$function_____("window");
  let self = _____WB$wombat$assign$function_____("self");
  let document = _____WB$wombat$assign$function_____("document");
  let location = _____WB$wombat$assign$function_____("location");
  let top = _____WB$wombat$assign$function_____("top");
  let parent = _____WB$wombat$assign$function_____("parent");
  let frames = _____WB$wombat$assign$function_____("frames");
  let opener = _____WB$wombat$assign$function_____("opener");

var browser = "unknown";
var version = 0;

if (navigator.userAgent.indexOf("Opera") >= 0)
 browser = "opera";
else if (navigator.userAgent.indexOf("obot") >= 0)
 browser = "robot";
else if (navigator.appName.indexOf("etscape") >= 0)
 browser = "netscape";
else if (navigator.appName.indexOf("icrosoft") >= 0)
 browser = "msie";

version = parseFloat(navigator.appVersion);
if (isNaN(version)) version = 0;
if ((browser == "msie")&&(version == 2)) version = 3;

// lookup table
var tohex = new Array(256);
var hex = "0123456789ABCDEF";
var count = 0;
for (x=0; x<16; x++) {
 for (y=0; y<16; y++) {
 tohex[count] = hex.charAt(x) + hex.charAt(y);
 count++;
 }
}

function ColorCode(hexcode) {
  if (hexcode.length == 7) {
    this.r = parseInt(hexcode.substring(1,3),16);
    this.g = parseInt(hexcode.substring(3,5),16);
    this.b = parseInt(hexcode.substring(5,7),16);
  }
  else if (hexcode.length == 6) {
    this.r = parseInt(hexcode.substring(0,2),16);
    this.g = parseInt(hexcode.substring(2,4),16);
    this.b = parseInt(hexcode.substring(4,6),16);
  }
  else {
    this.r = this.g = this.b = 0;
    alert("Error: ColorCode constructor failed");
  }
  if (isNaN(this.r)||isNaN(this.g)||isNaN(this.b))
    alert("Error: ColorCode constructor failed");
}

function ColorList(hexcodes) {
  var i = 0;
  var c = 0;
  this.codes = new Array(Math.round(hexcodes.length/7));
  while (i < hexcodes.length) {
    if (isNaN(parseInt(hexcodes.substring(i,i+6),16))) ++i;
    else {
      this.codes[c] = new ColorCode(hexcodes.substring(i,i+6));
      i += 7;
      ++c;
    }
  }
  this.len = c;
}

function interpolate (x1, y1, x3, y3, x2) {
  if (x3 == x1) return y1
  else return (x2-x1)*(y3-y1)/(x3-x1) + y1
}

// x=index of letter, y=number of letters, z=number of colors
function lowcolorindex (x, y, z) {
  if (y == 1) return 0
  else return Math.floor( (x*(z-1))/(y-1) )
}

function hicolorindex (x, y, z, low) { 
  if ( low*(y-1) == x*(z-1) ) return low
  else if (y == 1) return 0
  else return Math.floor( (x*(z-1))/(y-1) + 1 )
}

function gradient (thetext,thecolors) {
  if (((browser == "netscape")||(browser == "msie")||(browser == "opera"))&&(version>=3.0)) {
    var colors = new ColorList(thecolors);
    var numcolors = colors.len;
    var numchars = thetext.length;
    var rr = 0;
    var gg = 0;
    var bb = 0;
    var lci = 0;
    var hci = 0;
      for (i=0; i<numchars; ++i) {
      lci = lowcolorindex(i, numchars, numcolors);
      hci = hicolorindex(i, numchars, numcolors, lci);
      rr = Math.round(interpolate( lci/(numcolors-1), colors.codes[lci].r, hci/(numcolors-1), colors.codes[hci].r, i/(numchars-1)));
      gg = Math.round(interpolate( lci/(numcolors-1), colors.codes[lci].g, hci/(numcolors-1), colors.codes[hci].g, i/(numchars-1)));
      bb = Math.round(interpolate( lci/(numcolors-1), colors.codes[lci].b, hci/(numcolors-1), colors.codes[hci].b, i/(numchars-1)));
      if (browser == "opera") {
        rr = 255 - rr;
        gg = 255 - gg;
        bb = 255 - bb;
      }
    document.write(thetext.charAt(i).fontcolor(tohex[rr]+tohex[gg]+tohex[bb]));
    }
  }
  else document.write(thetext);
}


}