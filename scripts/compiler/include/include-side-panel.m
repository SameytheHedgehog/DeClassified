/*************************************
*   Filename: include-side-panel.m   *
*   Version:  1.1                    *
*   Created:  2020-03-28             *
*   Updated   2020-05-29             *
*   Author:   PeterK.                *
*   E-Mail:   peter_ka@gmx.net       *
*************************************/

#ifndef included
#error This script "include-side-panel.m" can only be compiled as #include
#endif

Function toggleSidePanel(String name_short);

toggleSidePanel(String name_short)
{
	String component_background=System.getPrivateString("Quinto_Black_CT","component_background","standard");
	String side_panel_color=System.getPrivateString("Quinto_Black_CT","side_panel_color","darkbrown");
	String side_panel_light_reflection=System.getPrivateString("Quinto_Black_CT","side_panel_light_reflection","show");
	String side_panel_width=System.getPrivateString("Quinto_Black_CT","side_panel_width","standard");
	String visible_1;

	// COLOR
	for (Int i=0;i<2;i++)
	{
		System.getScriptGroup().findObject(name_short+".side.panel."+side_panel_width+"."+
		System.getToken("left/right","/",i)+".id").setXmlParam("image",name_short+".side.panel."+side_panel_width+"."+side_panel_color+"."+
		System.getToken("left/right","/",i));
	}
	// LIGHT REFLECTION
	if (component_background=="classic") visible_1="0";
	else
	{
		if (side_panel_light_reflection=="hide") visible_1="0";
		else visible_1="1";
	}
	for (Int i=0;i<2;i++)
	{
		System.getScriptGroup().findObject(name_short+".side.panel."+side_panel_width+".reflection."+
		System.getToken("left/right","/",i)+".id").setXmlParam("visible",visible_1);
	}
	// WIDTH
	if (component_background=="classic") visible_1="0";
	else visible_1="1";
	for (Int i=0;i<2;i++)
	{
		System.getScriptGroup().findObject(name_short+".side.panel."+side_panel_width+"."+
		System.getToken("left/right","/",i)+".id").setXmlParam("visible",visible_1);
	}
}