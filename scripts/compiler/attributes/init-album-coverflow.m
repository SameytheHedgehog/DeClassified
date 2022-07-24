/***************************************
*   Filename: init-album-coverflow.m   *
*   Version:  1.6                      *
*   Created:  2018-10-29               *
*   Updated   2020-02-18               *
*   Author:   PeterK.                  *
*   E-Mail:   peter_ka@gmx.net         *
***************************************/

#ifndef included
#error This script "init-album-coverflow.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_album_coverflow;

Function initializeAttributeAlbumCoverflow();

initializeAttributeAlbumCoverflow()
{
	initializeCustomPages();
	
	attribute_album_coverflow=custom_page.newAttribute("Album Coverflow","0");
}
attribute_album_coverflow.onDataChanged()
{
	if (attribute_album_coverflow.getData()=="1")
	{
		displayInfo("showinfo","OPEN ALBUM COVERFLOW");
		System.getContainer("album.coverflow").show();
		
		// Show "Album Coverflow Background" window additionally if previously saved as open (check mark=1)
		Int acfb_window_visible=System.getPrivateInt("Quinto_Black_CT","acfb_window_visible",1); // show at first run
		if (acfb_window_visible==-1) System.getContainer("album.coverflow.background").hide();
		else if (acfb_window_visible==1) System.getContainer("album.coverflow.background").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE ALBUM COVERFLOW");
		System.getContainer("album.coverflow").hide();
		System.getContainer("album.coverflow.background").hide();
	}
}