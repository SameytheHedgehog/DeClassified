/****************************************
*   Filename: include-display-light.m   *
*   Version:  1.0                       *
*   Created:  2020-03-28                *
*   Updated   2020-03-28                *
*   Author:   PeterK.                   *
*   E-Mail:   peter_ka@gmx.net          *
****************************************/

#ifndef included
#error This script "include-display-light.m" can only be compiled as #include
#endif

#include "include-fade.m"

Function showDisplayLight(String name_short);

showDisplayLight(String name_short)
{
	if (name_short=="frg")
	{
		Layer displayLight=System.getContainer("frequency.response.graph").getLayout("normal").findObject("frg.display.light.id");

		if (System.getEq()==TRUE)
		{
			String frg_display_light=System.getPrivateString("Quinto_Black_CT","frg_display_light","off");
			if (frg_display_light=="off") fade(displayLight,0,1);
			else if (frg_display_light=="on") displayLight.setXmlParam("alpha","255");
		}
	}
	else if (name_short=="ml")
	{
		if (System.getContainer("media.library")!=NULL)
		{
			Layer displayLight=System.getContainer("media.library").getLayout("normal").findObject("ml.display.light.id");

			if (System.getStatus()!=STATUS_STOPPED)
			{
				String ml_display_light=System.getPrivateString("Quinto_Black_CT","ml_display_light","off");
				if (ml_display_light=="off") fade(displayLight,0,1);
				else if (ml_display_light=="on") displayLight.setXmlParam("alpha","255");
			}
		}
	}
	else if (name_short=="mp")
	{
		Layer displayLight=System.getContainer("main").getLayout("normal").findObject("mp.display.light.id");

		if (System.getStatus()!=STATUS_STOPPED)
		{
			String mp_display_light=System.getPrivateString("Quinto_Black_CT","mp_display_light","off");
			if (mp_display_light=="off") fade(displayLight,0,1);
			else if (mp_display_light=="on") displayLight.setXmlParam("alpha","255");
		}
	}
	else if (name_short=="sa")
	{
		Layer displayLight=System.getContainer("spectrum.analyzer").getLayout("normal").findObject("sa.display.light.id");

		if (System.getStatus()!=STATUS_STOPPED)
		{
			String sa_display_light=System.getPrivateString("Quinto_Black_CT","sa_display_light","off");
			if (sa_display_light=="off") fade(displayLight,0,1);
			else if (sa_display_light=="on") displayLight.setXmlParam("alpha","255");
		}
	}
	else if (name_short=="vid")
	{
		if (System.getContainer("video")!=NULL)
		{
			Layer displayLight=System.getContainer("video").getLayout("normal").findObject("vid.display.light.id");

			if (System.getStatus()!=STATUS_STOPPED)
			{
				String vid_display_light=System.getPrivateString("Quinto_Black_CT","vid_display_light","off");
				if (vid_display_light=="off") fade(displayLight,0,1);
				else if (vid_display_light=="on") displayLight.setXmlParam("alpha","255");
			}
		}
	}
	else if (name_short=="vu_ma")
	{
		Layer scaleLightLeft=System.getContainer("vu.meter.analog").getLayout("normal").findObject("vu.ma.scale.light.left.id");
		Layer scaleLightRight=System.getContainer("vu.meter.analog").getLayout("normal").findObject("vu.ma.scale.light.right.id");

		if (System.getStatus()!=STATUS_STOPPED)
		{
			String vu_ma_display_light=System.getPrivateString("Quinto_Black_CT","vu_ma_display_light","off");
			if (vu_ma_display_light=="off")
			{
				fade(scaleLightLeft,0,1);
				fade(scaleLightRight,0,1);
			}
			else if (vu_ma_display_light=="on")
			{
				scaleLightLeft.setXmlParam("alpha","255");
				scaleLightRight.setXmlParam("alpha","255");
			}
		}
	}
	else if (name_short=="vu_mdh")
	{
		Layer displayLight=System.getContainer("vu.meter.digital.horizontal").getLayout("normal").findObject("vu.mdh.display.light.id");

		if (System.getStatus()!=STATUS_STOPPED)
		{
			String vu_mdh_display_light=System.getPrivateString("Quinto_Black_CT","vu_mdh_display_light","off");
			if (vu_mdh_display_light=="off") fade(displayLight,0,1);
			else if (vu_mdh_display_light=="on") displayLight.setXmlParam("alpha","255");
		}
	}
}