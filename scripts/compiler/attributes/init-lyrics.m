/*********************************
*   Filename: init-lyrics.m      *
*   Version:  1.1                *
*   Created:  2017-08-17         *
*   Updated   2020-02-18         *
*   Author:   PeterK.            *
*   E-Mail:   peter_ka@gmx.net   *
*********************************/

#ifndef included
#error This script "init-lyrics.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_lyrics;

Function initializeAttributeLyrics();

initializeAttributeLyrics()
{
	initializeCustomPages();
	
	attribute_lyrics=custom_page.newAttribute("Lyrics (offline)","0");
}
attribute_lyrics.onDataChanged()
{
	if (attribute_lyrics.getData()=="1")
	{
		displayInfo("showinfo","OPEN LYRICS (OFFLINE)");
		System.getContainer("lyrics.offline").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE LYRICS (OFFLINE)");
		System.getContainer("lyrics.offline").hide();
	}
}