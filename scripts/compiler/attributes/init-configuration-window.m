/********************************************
*   Filename: init-configuration-window.m   *
*   Version:  1.0                           *
*   Created:  2020-02-18                    *
*   Updated   2020-02-18                    *
*   Author:   PeterK.                       *
*   E-Mail:   peter_ka@gmx.net              *
********************************************/

#ifndef included
#error This script "init-configuration-window.m" can only be compiled as #include
#endif

#include "initialize-custom-pages.m"

#include "..\include\include-display-info.m"

Global ConfigAttribute attribute_configuration_window;

Function initializeAttributeConfigurationWindow();

initializeAttributeConfigurationWindow()
{
	initializeCustomPages();
	
	attribute_configuration_window=custom_page.newAttribute("Configuration","0");
	addMenuSeparator(custom_page);
}
attribute_configuration_window.onDataChanged()
{
	if (attribute_configuration_window.getData()=="1")
	{
		displayInfo("showinfo","OPEN CONFIGURATION WINDOW");
		System.getContainer("configuration.window").show();
	}
	else
	{
		displayInfo("showinfo","CLOSE CONFIGURATION WINDOW");
		System.getContainer("configuration.window").hide();
	}
}