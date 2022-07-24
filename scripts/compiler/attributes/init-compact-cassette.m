/****************************************
*   Filename: init-compact-cassette.m   *
*   Version:  1.2                       *
*   Created:  2019-01-14                *
*   Updated   2020-02-18                *
*   Author:   PeterK.                   *
*   E-Mail:   peter_ka@gmx.net          *
****************************************/

#ifndef included
#error This script "init-compact-cassette.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_compact_cassette;

Function initializeAttributeCompactCassette();

initializeAttributeCompactCassette()
{
	initializeCustomPages();
	
	attribute_compact_cassette=custom_page.newAttribute("Compact Cassette","0");
}
attribute_compact_cassette.onDataChanged()
{
	if (attribute_compact_cassette.getData()=="1")
	{
		displayInfo("showinfo","OPEN COMPACT CASSETTE");
		System.getContainer("compact.cassette").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE COMPACT CASSETTE");
		System.getContainer("compact.cassette").hide();
	}
}