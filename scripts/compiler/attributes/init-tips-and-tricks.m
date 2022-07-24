/***************************************
*   Filename: init-tips-and-tricks.m   *
*   Version:  1.2                      *
*   Created:  2018-10-29               *
*   Updated   2020-02-18               *
*   Author:   PeterK.                  *
*   E-Mail:   peter_ka@gmx.net         *
***************************************/

#ifndef included
#error This script "init-tips-and-tricks.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_tips_and_tricks;

Function initializeAttributeTipsAndTricks();

initializeAttributeTipsAndTricks()
{
	initializeCustomPages();
	
	attribute_tips_and_tricks=custom_page.newAttribute("Tips And Tricks","0");
}
attribute_tips_and_tricks.onDataChanged()
{
	if (attribute_tips_and_tricks.getData()=="1")
	{
		displayInfo("showinfo","OPEN TIPS AND TRICKS");
		System.getContainer("tips.and.tricks").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE TIPS AND TRICKS");
		System.getContainer("tips.and.tricks").hide();
	}
}