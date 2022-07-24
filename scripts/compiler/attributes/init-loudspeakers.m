/************************************
*   Filename: init-loudspeakers.m   *
*   Version:  1.2                   *
*   Created:  2019-02-16            *
*   Updated   2020-02-18            *
*   Author:   PeterK.               *
*   E-Mail:   peter_ka@gmx.net      *
************************************/

#ifndef included
#error This script "init-loudspeakers.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_loudspeakers;

Function initializeAttributeLoudspeakers();

initializeAttributeLoudspeakers()
{
	initializeCustomPages();
	
	attribute_loudspeakers=custom_page.newAttribute("Loudspeakers","0");
}
attribute_loudspeakers.onDataChanged()
{
	if (attribute_loudspeakers.getData()=="1")
	{
		displayInfo("showinfo","OPEN LOUDSPEAKERS");
		System.getContainer("loudspeaker.left").show();
		System.getContainer("loudspeaker.right").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE LOUDSPEAKERS");
		System.getContainer("loudspeaker.left").hide();
		System.getContainer("loudspeaker.right").hide();
	}
}