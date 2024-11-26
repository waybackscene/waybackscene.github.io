/* Fade link script used on e-motionalis.net */
/* I don't know who made it, but well, thanks for it */

fadeColor = "#99ccff";
stepIn = 20;
stepOut = 35;
autoFade = true;  
sloppyClass = false; 

hexa = new makearray(16);
for(var i = 0; i < 10; i++)
    hexa[i] = i;
hexa[10]="a"; hexa[11]="b"; hexa[12]="c";
hexa[13]="d"; hexa[14]="e"; hexa[15]="f";
document.onmouseover = domouseover;
document.onmouseout = domouseout;
fadeColor = dehexize(fadeColor.toLowerCase());
var fadeId = new Array();
function dehexize(Color){
	var colorArr = new makearray(3);
	for (i=1; i<7; i++){
		for (j=0; j<16; j++){
			if (Color.charAt(i) == hexa[j]){
				if (i%2 !=0)
					colorArr[Math.floor((i-1)/2)]=eval(j)*16;
				else
					colorArr[Math.floor((i-1)/2)]+=eval(j);
			}
		}
	}
	return colorArr;
}
function domouseover() {
	if(document.all){
		var srcElement = event.srcElement;
		if ((srcElement.tagName == "A" && autoFade && srcElement.className != "nofade") || srcElement.className == "fade" || (sloppyClass && srcElement.className.indexOf("fade") != -1)) {
				if (!srcElement.startColor) {
					srcElement.startColor = (srcElement.style.color)? srcElement.style.color: srcElement.currentStyle.color;
					srcElement.startColor = dehexize(srcElement.startColor.toLowerCase());
				}
				fade(srcElement.startColor,fadeColor,srcElement.uniqueID,stepIn);				
		}
	}
}
function domouseout() {
	if (document.all){
		var srcElement = event.srcElement;
		if ((srcElement.tagName == "A" && autoFade && srcElement.className != "nofade") || srcElement.className == "fade" || (sloppyClass && srcElement.className.indexOf("fade") != -1)) {
				fade(fadeColor,srcElement.startColor,srcElement.uniqueID,stepIn);
		}
	}
}
function makearray(n) {
    this.length = n;
    for(var i = 1; i <= n; i++)
        this[i] = 0;
    return this;
}
function hex(i) {
    if (i < 0)
        return "00";
    else if (i > 255)
        return "ff";
    else
       return "" + hexa[Math.floor(i/16)] + hexa[i%16];
}
function setColor(r, g, b, element) {
      var hr = hex(r); var hg = hex(g); var hb = hex(b);
      element.style.color = "#"+hr+hg+hb;
}
function fade(s,e,element,step) {
	var sr = s[0]; var sg = s[1]; var sb = s[2];
	var er = e[0]; var eg = e[1]; var eb = e[2];
	if (fadeId[0] != null && fade[0] != element) {
		var orig = eval(fadeId[0]);
		setColor(orig.startColor[0],orig.startColor[1],orig.startColor[2],orig);
		var i = 1;
		while(i < fadeId.length) {
			clearTimeout(fadeId[i]);
			i++;
		}
	}	
	for(var i = 0; i <= step; i++) {
		fadeId[i+1] = setTimeout("setColor(Math.floor(" +sr+ " *(( " +step+ " - " +i+ " )/ " +step+ " ) + " +er+ " * (" +i+ "/" +
			step+ ")),Math.floor(" +sg+ " * (( " +step+ " - " +i+ " )/ " +step+ " ) + " +eg+ " * (" +i+ "/" +step+
			")),Math.floor(" +sb+ " * ((" +step+ "-" +i+ ")/" +step+ ") + " +eb+ " * (" +i+ "/" +step+ ")),"+element+");",i*step);
	}
	fadeId[0] = element;
}