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

var stretchers = $$('div.accordion');
var togglers = $$('h3.toggler');
stretchers.setStyles({'height': '0', 'overflow': 'hidden'});

/* smoothbox */
// prevent javascript error before the content has loaded
TB_WIDTH = 0;
TB_HEIGHT = 0;
var TB_doneOnce = 0 ;

// add smoothbox to href elements that have a class of .smoothbox
function TB_init(){
	$$("a.smoothbox").each(function(el){el.onclick=TB_bind});
}

function TB_bind(event) {
	var event = new Event(event);
	// stop default behaviour
	event.preventDefault();
	// remove click border
	this.blur();
	// get caption: either title or name attribute
	var caption = this.title || this.name || "";
	// get rel attribute for image groups
	var group = this.rel || false;
	// display the box for the elements href
	TB_show(caption, this.href, group);
	this.onclick=TB_bind;
	return false;
}


// called when the user clicks on a smoothbox link
function TB_show(caption, url, rel) {

	// create iframe, overlay and box if non-existent

	if ( !$("TB_overlay") )
	{
		new Element('iframe').setProperty('id', 'TB_HideSelect').injectInside(document.body);
		$('TB_HideSelect').setOpacity(0);
		new Element('div').setProperty('id', 'TB_overlay').injectInside(document.body);
		$('TB_overlay').setOpacity(0);
		TB_overlaySize();
		new Element('div').setProperty('id', 'TB_load').injectInside(document.body);
		$('TB_load').innerHTML = "<img src='img/loading.gif' />";
		TB_load_position();
		new Fx.Style('TB_overlay', 'opacity',{duration: 400, transition: Fx.Transitions.sineInOut}).start(0,0.6);
	}
	
	if ( !$("TB_load") )
	{		
		new Element('div').setProperty('id', 'TB_load').injectInside(document.body);
		$('TB_load').innerHTML = "<img src='img/loading.gif' />";
		TB_load_position();
	}
	
	if ( !$("TB_window") )
	{
		new Element('div').setProperty('id', 'TB_window').injectInside(document.body);
		$('TB_window').setOpacity(0);
	}
	
	$("TB_overlay").onclick=TB_remove;
	window.onscroll=TB_positionEffect;

	// check if a query string is involved
	var baseURL = url.match(/(.+)?/)[1] || url;

	// regex to check if a href refers to an image
	var imageURL = /\.(jpe?g|png|gif|bmp)/gi;

	// check for images
	if ( baseURL.match(imageURL) ) {
		var dummy = { caption: "", url: "", html: "" };
		
		var prev = dummy,
			next = dummy,
			imageCount = "";
			
		// if an image group is given
		if ( rel ) {
			function getInfo(image, id, label) {
				return {
					caption: image.title,
					url: image.href,
					html: "<span id='TB_" + id + "'>&nbsp;&nbsp;<a href='#'>" + label + "</a></span>"
				}
			}
		
			// find the anchors that point to the group
			var imageGroup = [] ;
			$$("a.smoothbox").each(function(el){
				if (el.rel==rel) {imageGroup[imageGroup.length] = el ;}
			})

			var foundSelf = false;
			
			// loop through the anchors, looking for ourself, saving information about previous and next image
			for (var i = 0; i < imageGroup.length; i++) {
				var image = imageGroup[i];
				var urlTypeTemp = image.href.match(imageURL);
				
				// look for ourself
				if ( image.href == url ) {
					foundSelf = true;
					imageCount = "Image " + (i + 1) + " of "+ (imageGroup.length);
				} else {
					// when we found ourself, the current is the next image
					if ( foundSelf ) {
						next = getInfo(image, "next", "Next &gt;");
						// stop searching
						break;
					} else {
						// didn't find ourself yet, so this may be the one before ourself
						prev = getInfo(image, "prev", "&lt; Prev");
					}
				}
			}
		}
		
		imgPreloader = new Image();
		imgPreloader.onload = function() {
			imgPreloader.onload = null;

			// Resizing large images
			var x = window.getWidth() - 150;
			var y = window.getHeight() - 150;
			var imageWidth = imgPreloader.width;
			var imageHeight = imgPreloader.height;
			if (imageWidth > x) {
				imageHeight = imageHeight * (x / imageWidth); 
				imageWidth = x; 
				if (imageHeight > y) { 
					imageWidth = imageWidth * (y / imageHeight); 
					imageHeight = y; 
				}
			} else if (imageHeight > y) { 
				imageWidth = imageWidth * (y / imageHeight); 
				imageHeight = y; 
				if (imageWidth > x) { 
					imageHeight = imageHeight * (x / imageWidth); 
					imageWidth = x;
				}
			}
			// End Resizing
			
			// TODO don't use globals
			TB_WIDTH = imageWidth + 30;
			TB_HEIGHT = imageHeight + 60;
			
			// TODO empty window content instead
			$("TB_window").innerHTML += "<a href='' id='TB_ImageOff' title='Close'><img id='TB_Image' src='"+url+"' width='"+imageWidth+"' height='"+imageHeight+"' alt='"+caption+"'/></a>" + "<div id='TB_caption'>"+caption+"<div id='TB_secondLine'>" + imageCount + prev.html + next.html + "</div></div><div id='TB_closeWindow'><a href='#' id='TB_closeWindowButton' title='Close'>[x]</a></div>";
			
			$("TB_closeWindowButton").onclick = TB_remove;
			
			function buildClickHandler(image) {
				return function() {
					$("TB_window").remove();
					new Element('div').setProperty('id', 'TB_window').injectInside(document.body);
					
					TB_show(image.caption, image.url, rel);
					return false;
				};
			}
			var goPrev = buildClickHandler(prev);
			var goNext = buildClickHandler(next);
			if ( $('TB_prev') ) {
				$("TB_prev").onclick = goPrev;
			}
			
			if ( $('TB_next') ) {		
				$("TB_next").onclick = goNext;
			}
			
			document.onkeydown = function(event) {
				var event = new Event(event);
				switch(event.code) {
				case 27:
					TB_remove();
					break;
				case 190:
					if( $('TB_next') ) {
						document.onkeydown = null;
						goNext();
					}
					break;
				case 188:
					if( $('TB_prev') ) {
						document.onkeydown = null;
						goPrev();
					}
					break;
				}
			}
			
			// TODO don't remove loader etc., just hide and show later
			$("TB_ImageOff").onclick = TB_remove;
			TB_position();
			TB_showWindow();
		}
		imgPreloader.src = url;
		
	} else { //code to show html pages
		
		var queryString = url.match(/\?(.+)/)[1];
		var params = TB_parseQuery( queryString );
		
		TB_WIDTH = (params['width']*1) + 30;
		TB_HEIGHT = (params['height']*1) + 40;

		var ajaxContentW = TB_WIDTH - 30,
			ajaxContentH = TB_HEIGHT - 45;
		
		if(url.indexOf('TB_iframe') != -1){				
			urlNoQuery = url.split('TB_');		
			$("TB_window").innerHTML += "<div id='TB_title'><div id='TB_ajaxWindowTitle'>"+caption+"</div><div id='TB_closeAjaxWindow'><a href='#' id='TB_closeWindowButton' title='Close'>[x]</a></div></div><iframe frameborder='0' hspace='0' src='"+urlNoQuery[0]+"' id='TB_iframeContent' name='TB_iframeContent' style='width:"+(ajaxContentW + 29)+"px;height:"+(ajaxContentH + 17)+"px;' onload='TB_showWindow()'> </iframe>";
		} else {
			$("TB_window").innerHTML += "<div id='TB_title'><div id='TB_ajaxWindowTitle'>"+caption+"</div><div id='TB_closeAjaxWindow'><a href='#' id='TB_closeWindowButton'>[x]</a></div></div><div id='TB_ajaxContent' style='width:"+ajaxContentW+"px;height:"+ajaxContentH+"px;'></div>";
		}
				
		$("TB_closeWindowButton").onclick = TB_remove;
		
			if(url.indexOf('TB_inline') != -1){	
				$("TB_ajaxContent").innerHTML = ($(params['inlineId']).innerHTML);
				TB_position();
				TB_showWindow();
			}else if(url.indexOf('TB_iframe') != -1){
				TB_position();
				if(frames['TB_iframeContent'] == undefined){//be nice to safari
					$(document).keyup( function(e){ var key = e.keyCode; if(key == 27){TB_remove()} });
					TB_showWindow();
				}
			}else{
				var handlerFunc = function(){
					TB_position();
					TB_showWindow();
				};
				var myRequest = new Ajax(url, {method: 'get',update: $("TB_ajaxContent"),onComplete: handlerFunc}).request();
			}
	}

	window.onresize=function(){ TB_position(); TB_load_position(); TB_overlaySize();}  
	
	document.onkeyup = function(event){ 	
		var event = new Event(event);
		if(event.code == 27){ // close
			TB_remove();
		}	
	}
		
}

//helper functions below

function TB_showWindow(){
	//$("TB_load").remove();
	//$("TB_window").setStyles({display:"block",opacity:'0'});
	
	if (TB_doneOnce==0) {
		TB_doneOnce = 1;
		var myFX = new Fx.Style('TB_window', 'opacity',{duration: 250, transition: Fx.Transitions.sineInOut, onComplete:function(){if ($('TB_load')) { $('TB_load').remove();}} }).start(0,1);
	} else {
		$('TB_window').setStyle('opacity',1);
		if ($('TB_load')) { $('TB_load').remove();}
	}
}

function TB_remove() {
 	$("TB_overlay").onclick=null;
	document.onkeyup=null;
	document.onkeydown=null;
	
	if ($('TB_imageOff')) $("TB_imageOff").onclick=null;
	if ($('TB_closeWindowButton')) $("TB_closeWindowButton").onclick=null;
	if ( $('TB_prev') ) { $("TB_prev").onclick = null; }
	if ( $('TB_next') ) { $("TB_next").onclick = null; }

	new Fx.Style('TB_window', 'opacity',{duration: 250, transition: Fx.Transitions.sineInOut, onComplete:function(){$('TB_window').remove();} }).start(1,0);
	new Fx.Style('TB_overlay', 'opacity',{duration: 400, transition: Fx.Transitions.sineInOut, onComplete:function(){$('TB_overlay').remove();} }).start(0.6,0);

	window.onscroll=null;
	window.onresize=null;	
	
	$('TB_HideSelect').remove();
	TB_init();
	TB_doneOnce = 0;
	return false;
}

function TB_position() {
	$("TB_window").setStyles({width: TB_WIDTH+'px', 
				 left: (window.getScrollLeft() + (window.getWidth() - TB_WIDTH)/2)+'px',
				 top: (window.getScrollTop() + (window.getHeight() - TB_HEIGHT)/2)+'px'});
}

function TB_positionEffect() {
	new Fx.Styles('TB_window', {duration: 75, transition: Fx.Transitions.sineInOut}).start({
		'left':(window.getScrollLeft() + (window.getWidth() - TB_WIDTH)/2)+'px',
		'top':(window.getScrollTop() + (window.getHeight() - TB_HEIGHT)/2)+'px'});
}

function TB_overlaySize(){
	// we have to set this to 0px before so we can reduce the size / width of the overflow onresize 
	$("TB_overlay").setStyles({"height": '0px', "width": '0px'});
	$("TB_HideSelect").setStyles({"height": '0px', "width": '0px'});
	$("TB_overlay").setStyles({"height": window.getScrollHeight()+'px', "width": window.getScrollWidth()+'px'});
	$("TB_HideSelect").setStyles({"height": window.getScrollHeight()+'px',"width": window.getScrollWidth()+'px'});
}

function TB_load_position() {
	if ($("TB_load")) { $("TB_load").setStyles({left: (window.getScrollLeft() + (window.getWidth() - 56)/2)+'px', top: (window.getScrollTop() + ((window.getHeight()-20)/2))+'px',display:"block"}); }
}

function TB_parseQuery ( query ) {
	// return empty object
	if( !query )
		return {};
	var params = {};
	
	// parse query
	var pairs = query.split(/[;&]/);
	for ( var i = 0; i < pairs.length; i++ ) {
		var pair = pairs[i].split('=');
		if ( !pair || pair.length != 2 )
			continue;
		// unescape both key and value, replace "+" with spaces in value
		params[unescape(pair[0])] = unescape(pair[1]).replace(/\+/g, ' ');
   }
   return params;
}

window.addEvent('load', function(){

  TB_init();
	togglers.each(function(toggler, i){
		toggler.color = toggler.getStyle('background-color');
		toggler.$tmp.first = toggler.getFirst();
		toggler.$tmp.fx = new Fx.Style(toggler, 'background-color', {'wait': false, 'transition': Fx.Transitions.Quart.easeOut});
	});
	
	myAccordion = new Accordion(togglers, stretchers, {
		'opacity': false,
		'start': false,
		'transition': Fx.Transitions.Quad.easeOut,
		onActive: function(toggler){
			toggler.$tmp.fx.start('#e0542f');
			toggler.$tmp.first.setStyle('color', '#fff');
		},
		onBackground: function(toggler){
			toggler.$tmp.fx.stop();
			toggler.setStyle('background-color', toggler.color).$tmp.first.setStyle('color', '#222');
		}
	});
	
  var found = 0;
  var hash = window.location.hash;
  var letter = '';
  if ((hash.contains('archive'))&(hash.charAt(8) != '')){
    letter = hash.charAt(8);
    hash = '#archive';
    if (letter != ''){
      $('archiverlz').setHTML('<p>Loading..</p>');
      var myXhr = new XHR({method: 'post'});
      myXhr.onSuccess = function(){
        $('archiverlz').setHTML('<p>'+myXhr.transport.responseText+'</p>');
        myAccordion.showThisHideOpen(stretchers[1]); 
      }
      myXhr.send('rlz_frontend.php', 'mode=archive&'+'letter='+letter);      
    }
  } else {
	  $$('h3.toggler a').each(function(link, i){
  		if (hash.test(link.hash)) found = i;
  	});
  }
	myAccordion.display(found);
	
	var slun = $('header').getElement('h1');
	var slunfx = new Fx.Styles(slun, {duration: 1000, 'transition': Fx.Transitions.Elastic.easeOut});
	new Drag.Base(slun, {
		onComplete: function(){
			slunfx.start({'top': 17, 'left': 32});
		}
	});
	
});

function DlRlz(id){
  var myXhr = new XHR({async: false, method: 'post'});
  myXhr.send('rlz_frontend.php', 'mode=download&dlid='+id);
}

function ShowArchive(letter){

  $('archiverlz').setHTML('<p>Loading..</p>');
  var myXhr = new XHR({method: 'post'});
  $('arc').setHTML('<img src="img/loading.gif" border=0>');
  myAccordion.display(-1);
  myXhr.onSuccess = function(){
    $('archiverlz').setHTML('<p>'+myXhr.transport.responseText+'</p>');
    $('arc').setHTML('<a href="#archive">archive</a>');
    myAccordion.showThisHideOpen(stretchers[1]); 
  }
  myXhr.send('rlz_frontend.php', 'mode=archive&letter='+letter);
}

function ShowPage(index){
  myAccordion.display(index);
}

function SearchRlz(){
  $('manage').setHTML('<img src="img/loading.gif" border=0>');
  myAccordion.display(-1);
  var log = $('slog_res').empty().addClass('ajax-loading');
  $('searchform').send({
  	update: log,
  	onComplete: function() {
  	  log.removeClass('ajax-loading');
  	  $('manage').setHTML('<a href="#manage">manage releases</a>');
  	  TB_init();
  	  myAccordion.showThisHideOpen(stretchers[0]); 
  	}
	});
} 

function AddRlz(){
  $('add').setHTML('<img src="img/loading.gif" border=0>');
  myAccordion.display(-1);
  var log = $('addlog_res').empty().addClass('ajax-loading');
  $('addform').send({
  	update: log,
  	onComplete: function() {
  	  log.removeClass('ajax-loading');
  	  $('add').setHTML('<a href="#add">add release</a>');
  	  myAccordion.showThisHideOpen(stretchers[1]); 
  	}
	});
} 

function EditRlz(){
  var log = $('editres').addClass('ajax-loading');
  $('editform').send({
  	update: log,
  	onComplete: function() {
  	  log.removeClass('ajax-loading');
  	}
 	});
 	log.empty();
}

function confirm_del(id){
	if (confirm('Do you really want to delete this reliz?')){
    var myXhr = new XHR({method: 'post'});
    myXhr.onSuccess = function(){
      alert('Release was deleted..');
  	}
  }
  myXhr.send('rlz_frontend.php', 'mode=delete&'+'id='+id);		
}

}