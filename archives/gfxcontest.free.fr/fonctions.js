
/* ----------------- met img sur newSrc --------------------------------- */
function rollover(img,newSrc) {
	document.images[img].src=newSrc;
}

/* ----------------- fonction pour l'effet de flou ---------------------- */
function oui(var1) {
   image=var1
   effet=setInterval("effet2(image)",50)
};

function non(var1) {
   clearInterval(effet)
   var1.filters.alpha.opacity=60
};

function effet2(var2) {
   if (var2.filters.alpha.opacity<100)
      var2.filters.alpha.opacity+=5
   else if (window.effet)
      clearInterval(effet)
};

/* ----------------- affiche l'image dans une popup --------------------- */

function PopupImage(img) {
   titre="mz design";
   w=open("",'image','width=400,height=400,toolbar=no,scrollbars=no,resizable=yes');	
   w.document.write("<html><head><title>"+titre+"</title></head>");
   w.document.write("<script language=javascript>function checksize() { if (document.images[0].complete) {  window.resizeTo(document.images[0].width+12,document.images[0].height+30); window.focus();} else { setTimeout('check()',250) } }</"+"script>");
   w.document.write("<body onload='checksize()' leftMargin=0 topMargin=0 marginwidth=0 marginheight=0><img src='"+img+"' border=0>");
   w.document.write("");
   w.document.write("</body></html>");
   w.document.close();
}


function popup(page,largeur,hauteur) { 
   var top=(screen.height-hauteur)/2; 
   var left=(screen.width-largeur)/2; 
   window.open(page,"","top="+top+",left="+left+",width="+largeur+",height="+hauteur+",scrollbars=1");
}
