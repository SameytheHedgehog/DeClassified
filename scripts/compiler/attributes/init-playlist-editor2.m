/****************************************
*   Filename: init-playlist-editor2.m   *
*   Version:  1.3                       *
*   Created:  2018-09-24                *
*   Updated   2020-02-18                *
*   Author:   PeterK.                   *
*   E-Mail:   peter_ka@gmx.net          *
****************************************/

#ifndef included
#error This script "init-playlist-editor2.m" can only be compiled as #include
#endif

#include "..\include\include-display-info.m"

#include "initialize-custom-pages.m"

Global ConfigAttribute attribute_playlist_editor2;

Function initializeAttributePlaylistEditor2();

initializeAttributePlaylistEditor2()
{
	initializeCustomPages();
	
	attribute_playlist_editor2=custom_page.newAttribute("Playlist Editor2","0");
}
attribute_playlist_editor2.onDataChanged()
{
	if (attribute_playlist_editor2.getData()=="1")
	{
		displayInfo("showinfo","OPEN PLAYLIST EDITOR2");
		System.getContainer("playlist.editor2").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE PLAYLIST EDITOR2");
		System.getContainer("playlist.editor2").hide();
	}
}