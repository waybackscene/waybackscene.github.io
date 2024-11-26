function popupChat() {
        win=window.open("popup.html", "ShmeitCorp Chat",
                             "height=220,width=520");
}     


function send()
{
   if (document.UserInfo.NICKNAME.value == null ||
                                        document.UserInfo.NICKNAME.value == "")
   {
        window.alert("You must enter your nick name.")
        return false
   }

 var USERNICK = document.UserInfo.NICKNAME.value

 win=window.open("","IRC","resizable=no,height=320,width=600")
 win.document.write('<html><head><title>ShmeitCorp Chat</title><noscript> </head></noscript>')
 win.document.write('<body bgcolor="#000000">')
 win.document.write('<applet archive="jirc_nss.zip" codebase="." code=Chat.class width=580 height=300 >')         
 win.document.write('<param name="CABBASE" value="Jirc_mss.cab">');
 win.document.write('<param name="LicenseKey" value="0007054000000502801402100000nzzv@55}}}4otlotoz 3oxi4uxm&Xoingxj&Qxgzz&Otlotoz &OXI&Tkz}uxq&">')
 win.document.write('<param name="ServerPort" value="6667">')
 win.document.write('<param name="ServerName1" value="shmeitirc.mefound.com">')

 win.document.write('<param name="Channel1" value="[S.Corp]">')

 win.document.write('<param name="AllowURL" value="true">')
 win.document.write('<param name="AllowIdentd" value="true">')
 win.document.write('<param name="WelcomeMessage" value="Bienvenue sur le channel Shmeitcorp !">')
 win.document.write('<param name="RealName" value="ShmeitCorp Website Visitor">')
 win.document.write('<param name="NickName" value="'+USERNICK+'">')
 win.document.write('<param name="UserName" value="shmeit">')
 win.document.write('<param name="DirectStart" value="true"> ')

 win.document.write('<param name="IgnoreLevel" value="0">') 
 win.document.write('<param name="NoConfig" value="true">')
 win.document.write('<param name="DisplayAbout" value="false">')

 win.document.write('<param name="LogoBgColor" value="black">')
 win.document.write('<param name="FGColor" value="White">')
 win.document.write('<param name="BackgroundColor" value="black">')

 win.document.write('<param name="TextColor" value="white">')
 win.document.write('<param name="TextScreenColor" value="black">')    

 win.document.write('<param name="ListTextColor" value="90,180,250">')
 win.document.write('<param name="ListScreenColor" value="black">')

 win.document.write('<param name="InputTextColor" value="black">')
 win.document.write('<param name="InputScreenColor" value="white">')

 win.document.write('<param name="MessageCol" value="80">')
 win.document.write('<param name="TextFontName" value="Arial">')
 win.document.write('<param name="TextFontSize" value="11">')

 win.document.write('<param name="BorderVsp" value="2">')
 win.document.write('<param name="BorderHsp" value="2">')

 win.document.write('</applet>')
 win.document.write('</body>')
 win.document.write('</html>')
 win.document.close()


 //document.location=document.referrer
 //document.location="intro.html"

 return true
}            
