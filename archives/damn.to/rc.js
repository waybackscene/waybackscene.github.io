/*
	This script (c) 2000-2001 Ivanopulo / DAMN -- http://www.damn.to
	You're free to use it, but please leave this message intact if you do it.
	
	Thanks alot to Marek for making this script NN6 compatible
	
	NN6 notice: It's *VERY* slow when it comes to timers, and I'm making an understatement here!

	Thanks to www.karaul.com webmaster for Opera detection hint ;)	
*/

//
// Yeah, there're alot of those pesky bastards we ought to support :/
var bNetscape4     = false;
var bNetscape6     = false;
var bExplorer4plus = false;
var bOpera5        = false;

if ( navigator.userAgent.indexOf("Opera 5") > -1 )
{
	bOpera5 = true;
}
else if ( navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.substring(0,1) >= "4" )
{
	bExplorer4plus = true;
}
else if ( navigator.appName == "Netscape" && navigator.appVersion.substring(0,1) == "4" )
{
	bNetscape4 = true;
}
else if ( navigator.appName == "Netscape" && navigator.appVersion.substring(0,1) >= "5" )
{
	bNetscape6 = true;
}

var nn6DivMenu, nn6DivButton; // specially for NN6 to speed up things at least a little

function CheckUIElements()
{
	var yMenuFrom, yMenuTo, yButtonFrom, yButtonTo, yOffset, timeoutNextCheck;
	
	if ( bNetscape4 ) {
		yButtonFrom = document["divLinkButton"].top;
		yButtonTo   = top.pageYOffset + top.innerHeight - 55;
		yMenuFrom   = document["divMenu"].top;
		yMenuTo     = top.pageYOffset + 50;
	}
	else if ( bExplorer4plus ) {
		yButtonFrom = parseInt (divLinkButton.style.top, 10);
		yButtonTo   = document.body.scrollTop + document.body.clientHeight - 55;
		yMenuFrom   = parseInt (divMenu.style.top, 10);
		yMenuTo     = document.body.scrollTop + 50;
	}
	else if ( bNetscape6 ) {
		yButtonFrom = nn6DivButton.style.top.replace(/px/,"");
		yButtonTo   = top.pageYOffset + top.innerHeight - 55;
		yMenuFrom   = nn6DivMenu.style.top.replace(/px/,"");
		yMenuTo     = top.pageYOffset + 50;
	}
	else if ( bOpera5 ) {
//		nn6DivMenu = document.getElementById('divMenu');
		yButtonFrom = nn6DivButton.style.top;
		yButtonTo   = top.pageYOffset + top.innerHeight - 55;
		yMenuFrom   = nn6DivMenu.style.top;
		yMenuTo     = top.pageYOffset + 50;
	}
	
	timeoutNextCheck = 500;
	
	if ( Math.abs(yButtonFrom - (yMenuTo + 152)) < 6 && yButtonTo < yButtonFrom ) {
		setTimeout ("CheckUIElements()", timeoutNextCheck);
		return;
	}

	if ( yButtonFrom != yButtonTo ) {

		if ( bNetscape6 )
			yOffset = Math.ceil( Math.abs( yButtonTo - yButtonFrom ) / 10 );
		else
			yOffset = Math.ceil( Math.abs( yButtonTo - yButtonFrom ) / 20 );
			
		if ( yButtonTo < yButtonFrom )
			yOffset = -yOffset;
		
		timeoutNextCheck = 10;

		if ( bNetscape4 )
			document["divLinkButton"].top += yOffset;
		else if ( bExplorer4plus )
			divLinkButton.style.top = parseInt (divLinkButton.style.top, 10) + yOffset;
		else if ( bOpera5 )
			nn6DivButton.style.top += yOffset;
		else if ( bNetscape6 ) {
			nn6DivButton.style.top = eval(nn6DivButton.style.top.replace(/px/,"")) + yOffset;
//			document.getElementById('divLinkButton').style.top = eval(document.getElementById('divLinkButton').style.top.replace(/px/,"")) + yOffset;
			timeoutNextCheck = 50;
		}
		

	}
	if ( yMenuFrom != yMenuTo ) {
	
		if ( bNetscape6 )
			yOffset = Math.ceil( Math.abs( yMenuTo - yMenuFrom ) / 10 );
		else
			yOffset = Math.ceil( Math.abs( yMenuTo - yMenuFrom ) / 30 );
			
		if ( yMenuTo < yMenuFrom )
			yOffset = -yOffset;
		
		timeoutNextCheck = 10;

		if ( bNetscape4 )
			document["divMenu"].top += yOffset;
		else if ( bExplorer4plus )
			divMenu.style.top = parseInt (divMenu.style.top, 10) + yOffset;
		else if ( bOpera5 )
			nn6DivMenu.style.top += yOffset;
		else if ( bNetscape6 ) {
			nn6DivMenu.style.top = eval(nn6DivMenu.style.top.replace(/px/,"")) + yOffset;
//			document.getElementById('divMenu').style.top = eval(document.getElementById('divMenu').style.top.replace(/px/,"")) + yOffset;
			timeoutNextCheck = 50;
		}

		timeoutNextCheck = 10;
	}

	setTimeout ("CheckUIElements()", timeoutNextCheck);
}

function OnLoad()
{
	var y;
	
	// we're not gonna be loaded in frames, no sir!
	if ( top.frames.length )
		top.location.href = self.location.href;
		
	// setting initial UI elements positions
	if ( bNetscape4 ) {
		document["divMenu"].top = top.pageYOffset + 50;
		document["divMenu"].visibility = "visible";
		document["divLinkButton"].top = top.pageYOffset + top.innerHeight - 55;
		document["divLinkButton"].visibility = "visible";
	}
	else if ( bExplorer4plus ) {
		divMenu.style.top = document.body.scrollTop + 50;
		divMenu.style.visibility = "visible";
		divLinkButton.style.top = document.body.scrollTop + document.body.clientHeight - 55;
		divLinkButton.style.visibility = "visible";
		// and fixing incorect css property handling in msie
		bodyText.style.right = -150;
	}
	else if ( bNetscape6 || bOpera5 ) {
		nn6DivMenu = document.getElementById('divMenu');
		nn6DivMenu.style.top = top.pageYOffset + 50;
		nn6DivMenu.style.visibility = "visible";
		nn6DivButton = document.getElementById('divLinkButton');
		nn6DivButton.style.top = top.pageYOffset + top.innerHeight - 55;
		nn6DivButton.style.visibility = "visible";

//		document.getElementById('divMenu').style.top = top.pageYOffset + 50;
//		document.getElementById('divMenu').style.visibility = "visible";
//		document.getElementById('divLinkButton').style.top = top.pageYOffset + top.innerHeight - 55;
//		document.getElementById('divLinkButton').style.visibility = "visible";
	}
	
	// initializing UI update timer
	CheckUIElements();
	return true;
}

function funcSwapImage(imageName, bHilite) {
// DUMB Netscape (prior to v6) doesn't see img names if they're inside a <div> that has an id
// if they're just in <div></div> - it's okay, but that's not the case :\
// Workaround (using layers) was provided by Kostya. Tnx man :)
	if ( bExplorer4plus || bNetscape6 || bOpera5 ) {
		document.images[imageName].src = "/images/" + imageName + (bHilite == 1 ? "_hi.gif" : "_lo.gif");
	}
	else if ( bNetscape4 ) {
		document.layers["divMenu"].document.images[imageName].src = "/images/" + imageName + (bHilite == 1 ? "_hi.gif" : "_lo.gif");
	}
	return false;
}

function PreloadMenuRollovers() {
	// preloading misc images
	img_temp10=new Image;
	img_temp10.src="/images/null.gif";
	img_temp11=new Image;
	img_temp11.src="/images/h_ruler.jpg";
	img_temp12=new Image;
	img_temp12.src="/images/background.jpg";
	
	// preloading rollovers
	img_temp1=new Image;
	img_temp1.src="/images/menu_main_hi.gif";
	img_temp2=new Image;
	img_temp2.src="/images/menu_news_hi.gif";
	img_temp3=new Image;
	img_temp3.src="/images/menu_rels_hi.gif";
	img_temp4=new Image;
	img_temp4.src="/images/menu_soft_hi.gif";
	img_temp5=new Image;
	img_temp5.src="/images/menu_crypto_hi.gif";
	img_temp6=new Image;
	img_temp6.src="/images/menu_src_hi.gif";
	img_temp7=new Image;
	img_temp7.src="/images/menu_forums_hi.gif";
	img_temp8=new Image;
	img_temp8.src="/images/menu_links_hi.gif";
	img_temp9=new Image;
	img_temp9.src="/images/menu_fga_hi.gif";
	
}

/* Coupla MSIE only routines to make page header flash after the document is loaded */
function StartTitleFlash()
{

	if ( bExplorer4plus )
		setTimeout ( "FlashTitleStepIt(255)", 10 );

	return true;
}

function FlashTitleStepIt( fptItersLeft )
{
	var str;
	str = fptItersLeft.toString(16);
	str = eval ( "\"#" + str + str + str + "\"" );
	
	pageTitle.style.color = str;

	fptItersLeft--;
	if ( str !=  "#606060" )
		setTimeout ( eval ( "\"FlashTitleStepIt(" + fptItersLeft + ")\"" ), 10 );
}