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

var paradox = 8;
var now = new Date()
var sec = now.getSeconds()
var ad = sec % paradox;
ad +=1;

if (ad==1) {
oben="Developer Resources";
paralink="../dev/index.html";
alt="dev.paradogs.com";
banner="thb_devp.jpg";
}

if (ad==2) {
oben="Modules";
paralink="../sfx/index.html";
alt="sfx.paradogs.com";
banner="thb_sfxp.jpg";
}

if (ad==3) {
oben="Art Department";
paralink="../art/index.html";
alt="art.paradogs.com";
banner="thb_artp.jpg";
}

if (ad==4) {
oben="Download";
paralink="../download/index.html";
alt="download.paradogs.com";
banner="thb_dwnp.jpg";
}

if (ad==5) {
oben="Cracktros";
paralink="http://www.cracktro.de";
alt="www.cracktro.de";
banner="lnk_crck.jpg";
}

if (ad==6) {
oben="Demoscene info";
paralink="http://www.ojuice.net";
alt="www.ojuice.net";
banner="lnk_ojui.jpg";
}

if (ad==7) {
oben="the scene gateway";
paralink="http://www.scenet.de";
alt="www.scenet.de";
banner="lnk_scnt.jpg";
}

if (ad==8) {
oben="Advanced SubPort";
paralink="http://advanced.subport.org";
alt="advanced.subport.org";
banner="lnk_asub.jpg";
}

if (ad==9) {
oben="PAIN Magazine";
paralink="http://pain.planet-d.net";
alt="pain.planet-d.net";
banner="lnk_pain.jpg";
}

document.write('<SPAN CLASS="ADHEAD"><B>' + oben + '</B></SPAN><BR>');
document.write('<A HREF="' + paralink + '" TARGET="_blank">');
document.write('<IMG SRC="../screenshots/' + banner + '" WIDTH=160" HEIGHT="100"')
document.write('ALT="' + alt + '" BORDER="0"></A><BR>');
document.write('<SPAN CLASS="ADHEAD">' + alt + '</SPAN>');

}