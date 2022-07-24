/*****************************************
*   Filename: include-file-extension.m   *
*   Version:  1.4                        *
*   Created:  2019-02-17                 *
*   Updated   2020-02-18                 *
*   Author:   PeterK.                    *
*   E-Mail:   peter_ka@gmx.net           *
*****************************************/

#ifndef included
#error This script "include-file-extension.m" can only be compiled as #include
#endif

Function Boolean onlineRadioOrVideo();

Boolean onlineRadioOrVideo()
{
	String char_item=System.getPlayItemString();
	String char_ext=System.getExtension(char_item);
	
	if (char_ext=="avi" ||
			char_ext=="mp4" ||
			char_ext=="webm" ||
			char_ext=="flv" ||
			char_ext=="mkv" ||
			char_ext=="ogg" ||
			char_ext=="wmv" || System.strsearch(System.getPlayItemString(),"http")==0) return TRUE;
	else return FALSE;
}