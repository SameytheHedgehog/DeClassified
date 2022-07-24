/************************************
*   Filename: init-compact-disc.m   *
*   Version:  1.3                   *
*   Created:  2018-10-16            *
*   Updated   2020-02-18            *
*   Author:   PeterK.               *
*   E-Mail:   peter_ka@gmx.net      *
************************************/

#ifndef included
#error This script "init-compact-disc.m" can only be compiled as #include
#endif

#include "..\include\include-display-info.m"

#include "initialize-custom-pages.m"

Global ConfigAttribute attribute_compact_disc;

Function initializeAttributeCompactDisc();

initializeAttributeCompactDisc()
{
	initializeCustomPages();
	
	attribute_compact_disc=custom_page.newAttribute("Compact Disc","0");
}
attribute_compact_disc.onDataChanged()
{
	if (attribute_compact_disc.getData()=="1")
	{
		displayInfo("showinfo","OPEN COMPACT DISC");
		System.getContainer("compact.disc").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE COMPACT DISC");
		System.getContainer("compact.disc").hide();
	}
}