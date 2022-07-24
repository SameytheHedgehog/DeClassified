/******************************************************************************
*   Filename: initialize-custom-pages.m                                       *
*   Version:  1.7                                                             *
*   Created:  2017-04-07                                                      *
*   Updated   2020-04-05                                                      *
*   Author:   PeterK.                                                         *
*   E-Mail:   peter_ka@gmx.net                                                *
*   Note:     This script is based on gen_pageguids.m made by martin.deimos   *
******************************************************************************/

#ifndef included
#error This script "initialize-custom-pages.m" can only be compiled as #include
#endif

#ifndef __GEN_PAGEGUIDS_M
#define __GEN_PAGEGUIDS_M

#include "..\lib\config.mi"

#define CUSTOM_OPTIONSMENU_ITEMS "{1828d28f-78dd-4647-8532-eba504b8fc04}"
#define CUSTOM_PAGE              "{26e26319-aeca-4433-b8f1-f4a5bf2a9ed5}"
#define CUSTOM_PAGE_NONEXPOSED   "{0b804f46-fd44-49e6-ba2d-410844a4b190}"
#define CUSTOM_WINDOWSMENU_ITEMS "{6559ca61-7eb2-4415-a8a9-a2aeef762b7f}"

Global ConfigAttribute attributeSeparator;

Global ConfigItem custom_page_nonexposed;
Global ConfigItem custom_page_options;
Global ConfigItem custom_page_windows;
Global ConfigItem custom_page;

Global Int separator_count=0;

Function ConfigItem addConfigSubMenu(ConfigItem parent,String name,String guid);
Function addMenuSeparator(ConfigItem cfgMenuPage);
Function initializeCustomPages();
Function toggleAttribute(ConfigAttribute attribute);

initializeCustomPages()
{
	#ifndef __PAGES
	#define __PAGES
	custom_page_nonexposed=Config.newItem("Hidden",CUSTOM_PAGE_NONEXPOSED);
	custom_page_options=Config.getItem(CUSTOM_OPTIONSMENU_ITEMS);
	custom_page_windows=Config.getItem(CUSTOM_WINDOWSMENU_ITEMS);
	custom_page=addConfigSubMenu(custom_page_options,"Quinto Black CT",CUSTOM_PAGE);
	#endif
}
addMenuSeparator(ConfigItem cfgMenuPage)
{
	#ifdef CREATE_SEPARATOR
	separator_count=separator_count+1;
	attributeSeparator=cfgMenuPage.newAttribute("Quinto_Black_CT"+"_separator_"+System.integerToString(separator_count),"");
	attributeSeparator.setData("-");
	#endif
}
ConfigItem addConfigSubMenu(ConfigItem parent,String name,String guid)
{
	ConfigItem __ret=Config.newItem(name,guid);
	ConfigAttribute __dret=parent.newAttribute(name,"");
	__dret.setData(guid);
	return __ret;
}
toggleAttribute(ConfigAttribute attribute)
{
	if (attribute.getData()=="0") attribute.setData("1");
	else attribute.setData("0");
}
#endif