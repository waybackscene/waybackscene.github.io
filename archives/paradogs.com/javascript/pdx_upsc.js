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

var marqueewidth=218;
var marqueeheight=380;
var speed=1;

var pica='<CENTER><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">HQ<\/SPAN><BR><IMG BORDER=\"0\" SRC=\"screenshots\/thb_wwwp.jpg\" ALT=\"www.paradogs.com\" WIDTH=\"160\" HEIGHT=\"100\"><\/A><BR><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">www.paradogs.com<\/SPAN><\/CENTER>';
var picb='<CENTER><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">Developer Resources<\/SPAN><BR><IMG BORDER=\"0\" SRC="screenshots\/thb_devp.jpg\" ALT=\"dev.paradogs.com\" WIDTH=\"160\" HEIGHT=\"100\"><BR><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">dev.paradogs.com<\/SPAN><\/CENTER>';
var picc='<CENTER><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">Art Department<\/SPAN><BR><IMG BORDER=\"0\" SRC=\"screenshots/thb_artp.jpg\" ALT=\"art.paradogs.com\" WIDTH=\"160\" HEIGHT=\"100\"><BR><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">art.paradogs.com<\/SPAN><\/CENTER>';
var picd='<CENTER><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">Modules<\/SPAN><BR><IMG BORDER=\"0\" SRC=\"screenshots/thb_sfxp.jpg\" ALT=\"sfx.paradogs.com\" WIDTH=\"160\" HEIGHT=\"100\"><BR><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">sfx.paradogs.com<\/SPAN><\/CENTER>';
var pice='<CENTER><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">Download<\/SPAN><BR><IMG BORDER=\"0\" SRC=\"screenshots/thb_dwnp.jpg\" ALT=\"download.paradogs.com\" WIDTH=\"160\" HEIGHT=\"100\"><BR><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">download.paradogs.com<\/SPAN><\/CENTER>';
var picf='<CENTER><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">Sceneboard<\/SPAN><BR><IMG BORDER=\"0\" SRC=\"screenshots/thb_sfxp.jpg\" ALT=\"sceneboard.paradogs.com\" WIDTH=\"160\" HEIGHT=\"100\"><BR><SPAN STYLE=\"background: #333333; font-family: Verdana; font-size: 11pt; font-weight: bold;\">sceneboard.paradogs.com<\/SPAN><\/CENTER>';

var txta='<P>The official Paradox Console <B>headquarter<\/B> and home of the Paradox portal, storing information and links regarding the past, present and future activities of Paradox.<P>';
var txtb='<P>Developer Resources is more known under the name of <B>The Graveland<\/B> and administrated by AVH, named after his old Amiga BBS. This site is storing all kind of useful development tools. A must see for coders.<P>';
var txtc='<P>The Art Department is storing some of the work of our excellent graphic artists Alien and Germ. You can not afford to miss <B>Paratroopers<\/B>, the first Paradox webtro in Flash4 format.<P>';
var txtd='<P>Modules is currently hosting certain modules made by our very own <B>Estrayk<\/B> and is supposed to become the source for all Paradox related composers and from Paradox used modules soon. Be patient. Still under heavy construction.<P>';
var txte='<P>Download is supposed to become the download resource for the Paradox PlayStation intro collection since there are hardly any download resources for downloads of this 80 MB collection available.<P>';
var txtf='<P>Sceneboard will be a BBS alike forum. Actually after the internal beta test we decided to run a public beta test, too.<P>';

var marqueecontents=pica+txta+picb+txtb+picc+txtc+picd+txtd+pice+txte+picf+txtf;

if (document.all)
document.write('<marquee direction="up" scrollAmount='+speed+' style="width:'+marqueewidth+';height:'+marqueeheight+'">'+marqueecontents+'</marquee>')
function regenerate(){
window.location.reload()
}

function regenerate2(){
if (document.layers){
setTimeout("window.onresize=regenerate",450)
intializemarquee()
}
}

function intializemarquee(){
document.cmarquee01.document.cmarquee02.document.write(marqueecontents)
document.cmarquee01.document.cmarquee02.document.close()
thelength=document.cmarquee01.document.cmarquee02.document.height
scrollit()
}

function scrollit(){
if (document.cmarquee01.document.cmarquee02.top>=thelength*(-1)){
document.cmarquee01.document.cmarquee02.top-=speed
setTimeout("scrollit()",100)
}

else{
document.cmarquee01.document.cmarquee02.top=marqueeheight
scrollit()
}
}

window.onload=regenerate2;


}