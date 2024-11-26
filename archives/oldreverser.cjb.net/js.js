var version = 0;
if (navigator.userAgent.indexOf("MSIE 4") != -1)  version = 5;
else if
(navigator.userAgent.indexOf("MSIE 3") != -1)  version = 1;
else if
(navigator.userAgent.indexOf("Mozilla/4") != -1)  version = 4;
else if
(navigator.userAgent.indexOf("Mozilla/4.5") != -1)  version = 7;
else if
(navigator.userAgent.indexOf("Mozilla/3") != -1)  version = 3;
else if
(navigator.userAgent.indexOf("Mozilla/2") != -1)  version = 2;
else if
(navigator.userAgent.indexOf("MSIE 4.5") != -1)  version = 6;
else version = 8;