/************************************
*   Filename: init-vinyl-record.m   *
*   Version:  1.1                   *
*   Created:  2018-12-26            *
*   Updated   2020-02-18            *
*   Author:   PeterK.               *
*   E-Mail:   peter_ka@gmx.net      *
************************************/

#ifndef included
#error This script "init-vinyl-record.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_vinyl_record;

Function initializeAttributeVinylRecord();

initializeAttributeVinylRecord()
{
	initializeCustomPages();
	
	attribute_vinyl_record=custom_page.newAttribute("Vinyl Record","0");
}
attribute_vinyl_record.onDataChanged()
{
	if (attribute_vinyl_record.getData()=="1")
	{
		displayInfo("showinfo","OPEN VINYL RECORD");
		System.getContainer("vinyl.record").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE VINYL RECORD");
		System.getContainer("vinyl.record").hide();
	}
}