if (version > 3)
document.write('<div id="trailSprite1"><img src="trailgif5.gif" height="10" width="10" border="0" name="trailSprite1img"></div><div id="trailSprite2"><img src="trailgif5.gif" height="10" width="10" border="0" name="trailSprite2img"></div><div id="trailSprite3"><img src="trailgif5.gif" height="10" width="10" border="0" name="trailSprite3img"></div><div id="trailSprite4"><img src="trailgif5.gif" height="10" width="10" border="0" name="trailSprite4img"></div><div id="trailSprite5"><img src="trailgif5.gif" height="10" width="10" border="0" name="trailSprite5img"></div><div id="trailSprite6"><img src="trailgif5.gif" height="10" width="10" border="0" name="trailSprite6img"></div>')

NS4 = (("Netscape"==navigator.appName) && ("4"<=parseInt(navigator.appVersion)))
window.name = "main"
var isNS = (navigator.appName == "Netscape");
layerRef = (isNS) ? "document" : "document.all";
styleRef = (isNS) ? "" : ".style";

var queue = new Array();
var NUM_OF_TRAIL_PARTS = 6

for (x=1; x < 7; x++) {	 ///////////////Image Preload
eval("trailSpriteFrame" + x + " = new Image(10,10);");
eval("trailSpriteFrame" + x + ".src = 'trailgif" + x + ".gif';");
}

function trailSpriteObj(anID) {
this.trailSpriteID = "trailSprite" + anID;
this.imgRef = "trailSprite" + anID + "img";
this.currentFrame = 1;
this.animateTrailSprite = animateTrailSprite;
}

function animateTrailSprite() {
if (this.currentFrame <7) {
if (isNS) {
eval("document['"+ this.imgRef + "'].src  =  trailSpriteFrame" + this.currentFrame + ".src");
} else {
eval("document['" + this.imgRef + "'].src  =  trailSpriteFrame" + this.currentFrame + ".src");
}
this.currentFrame ++;
} else {
eval(layerRef + '.' + this.trailSpriteID +  styleRef + '.visibility = "hidden"');
}	
}

function processAnim() {
for(x=0; x < NUM_OF_TRAIL_PARTS; x++)
queue[x].animateTrailSprite();
}

function processMouse(e) {
currentObj = shuffleQueue();
if (isNS) {
eval("document." + currentObj + ".left = e.pageX - 0 ;");
eval("document." + currentObj + ".top = e.pageY + 5;");
} else {
eval("document.all." + currentObj + ".style.pixelLeft = event.clientX + document.body.scrollLeft - 0 ;");
eval("document.all." + currentObj + ".style.pixelTop = event.clientY + document.body.scrollTop + 5;");
}
}

function shuffleQueue() {
lastItemPos = queue.length - 1;
lastItem = queue[lastItemPos];
for (i = lastItemPos; i>0; i--) 
queue[i] = queue[i-1];
queue[0] = lastItem;

queue[0].currentFrame = 1;
eval(layerRef + '.' + queue[0].trailSpriteID +  styleRef + '.visibility = "visible"');

return 	queue[0].trailSpriteID;
}

function init() {
for(x=0; x<NUM_OF_TRAIL_PARTS; x++)
queue[x] = new trailSpriteObj(x+1) ;

if (isNS) { document.captureEvents(Event.MOUSEMOVE); }
document.onmousemove = processMouse;

setInterval("processAnim();",25);
}

if (version > 3)
window.onload = init;