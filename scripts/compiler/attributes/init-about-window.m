/************************************
*   Filename: init-about-window.m   *
*   Version:  1.4                   *
*   Created:  2018-09-24            *
*   Updated   2020-02-18            *
*   Author:   PeterK.               *
*   E-Mail:   peter_ka@gmx.net      *
************************************/

#ifndef included
#error This script "init-about-window.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_about_window;

Function initializeAttributeAboutWindow();

initializeAttributeAboutWindow()
{
	initializeCustomPages();
	
	attribute_about_window=custom_page.newAttribute("About \"Quinto Black CT\"","0");
	addMenuSeparator(custom_page);
}
attribute_about_window.onDataChanged()
{
	if (attribute_about_window.getData()=="1")
	{
		displayInfo("showinfo","OPEN \"ABOUT\" WINDOW");
		System.getContainer("about.window").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE \"ABOUT\" WINDOW");
		System.getContainer("about.window").hide();
	}
}