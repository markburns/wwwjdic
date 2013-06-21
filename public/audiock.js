swfloc="http://www.csse.monash.edu.au/~jwb/";
/***
JavaScript for embedding audiock.swf into WWWJDIC
By Charles Kelly 2010-03-09/2010-04-29 - I took the function m from v19
***/
function m(jpstuff){
var w="14";
var h="14";
swf = swfloc+'audiock.swf?u='+jpstuff;
a='<object width="'+w+'" height="'+h+'"><param name="movie" value="'+swf+'" /><param name="allowFullScreen" value="true" /><embed wmode="transparent" src="'+swf+'"type="application/x-shockwave-flash" allowfullscreen="true" width="'+w+'" height="'+h+'"></embed><param name="wmode" value="transparent" /></object> ';
document.write(a);
}
