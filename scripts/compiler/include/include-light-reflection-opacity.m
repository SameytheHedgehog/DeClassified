/***************************************************
*   Filename: include-light-reflection-opacity.m   *
*   Version:  1.0                                  *
*   Created:  2020-03-28                           *
*   Updated   2020-03-28                           *
*   Author:   PeterK.                              *
*   E-Mail:   peter_ka@gmx.net                     *
***************************************************/

#ifndef included
#error This script "include-light-reflection-opacity.m" can only be compiled as #include
#endif

Function setLightReflectionOpacity(String component,String opacity); // for component scripts
Function setLightReflectionOpacityALL(String name_short,String opacity); // for "configuration-window.m" script

setLightReflectionOpacity(String component,String opacity)
{
	if (component=="vu.ma.scale.light.reflection.")
	{
		for (Int i=0;i<2;i++)
		{
			System.getScriptGroup().findObject(component+System.getToken("left/right","/",i)+".id").setXmlParam("alpha",opacity);
		}
	}
	else
	{
		System.getScriptGroup().findObject(component).setXmlParam("alpha",opacity);
	}
}
setLightReflectionOpacityALL(String name_short,String opacity)
{
	if (name_short=="cd")
	{
		System.getContainer("compact.disc").getLayout("normal").findObject("cd.case.light.reflection.id").setXmlParam("alpha",opacity);
	}
	else if (name_short=="frg")
	{
		System.getContainer("frequency.response.graph").getLayout("normal").findObject("frg.display.light.reflection.id").setXmlParam("alpha",opacity);
	}
	else if (name_short=="mp")
	{
		System.getContainer("main").getLayout("normal").findObject("mp.display.light.reflection.id").setXmlParam("alpha",opacity);
	}
	else if (name_short=="sa")
	{
		System.getContainer("spectrum.analyzer").getLayout("normal").findObject("sa.display.light.reflection.id").setXmlParam("alpha",opacity);
	}
	else if (name_short=="vu_ma")
	{
		for (Int i=0;i<2;i++)
		{
			System.getContainer("vu.meter.analog").getLayout("normal").findObject("vu.ma.scale.light.reflection."+
			System.getToken("left/right","/",i)+".id").setXmlParam("alpha",opacity);
		}
	}
	else if (name_short=="vu_mdh")
	{
		System.getContainer("vu.meter.digital.horizontal").getLayout("normal").findObject("vu.mdh.display.light.reflection.id").setXmlParam("alpha",opacity);
	}
}