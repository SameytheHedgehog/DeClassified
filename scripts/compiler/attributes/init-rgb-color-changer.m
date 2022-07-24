/*****************************************
*   Filename: init-rgb-color-changer.m   *
*   Version:  1.2                        *
*   Created:  2019-04-26                 *
*   Updated   2020-02-18                 *
*   Author:   PeterK.                    *
*   E-Mail:   peter_ka@gmx.net           *
*****************************************/

#ifndef included
#error This script "init-rgb-color-changer.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_rgb_color_changer;

Function initializeAttributeRGBColorChanger();

initializeAttributeRGBColorChanger()
{
	initializeCustomPages();
	
	attribute_rgb_color_changer=custom_page.newAttribute("RGB Color Changer","0");
}
attribute_rgb_color_changer.onDataChanged()
{
	if (attribute_rgb_color_changer.getData()=="1")
	{
		displayInfo("showinfo","OPEN RGB COLOR CHANGER");
		System.getContainer("rgb.color.changer").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE RGB COLOR CHANGER");
		System.getContainer("rgb.color.changer").hide();
	}
}