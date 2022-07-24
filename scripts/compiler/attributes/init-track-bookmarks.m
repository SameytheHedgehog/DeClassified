/***************************************
*   Filename: init-track-bookmarks.m   *
*   Version:  1.2                      *
*   Created:  2018-06-12               *
*   Updated   2020-02-18               *
*   Author:   PeterK.                  *
*   E-Mail:   peter_ka@gmx.net         *
***************************************/

#ifndef included
#error This script "init-track-bookmarks.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_track_bookmarks;

Function initializeAttributeTrackBookmarks();

initializeAttributeTrackBookmarks()
{
	initializeCustomPages();
	
	attribute_track_bookmarks=custom_page.newAttribute("Track Bookmarks","0");
}
attribute_track_bookmarks.onDataChanged()
{
	if (attribute_track_bookmarks.getData()=="1")
	{
		displayInfo("showinfo","OPEN TRACK BOOKMARKS");
		System.getContainer("track.bookmarks").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE TRACK BOOKMARKS");
		System.getContainer("track.bookmarks").hide();
	}
}