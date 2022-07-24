/***********************************************
*   Filename: include-component-background.m   *
*   Version:  1.1                              *
*   Created:  2020-03-28                       *
*   Updated   2020-05-29                       *
*   Author:   PeterK.                          *
*   E-Mail:   peter_ka@gmx.net                 *
***********************************************/

#ifndef included
#error This script "include-display-info.m" can only be compiled as #include
#endif

Function changeComponentLayout(
	String container_name,
	String name_short,
	String bitmap_file,
	String snappoint_left,
	String snappoint_top,
	String snappoint_right,
	String snappoint_bottom);
Function toggleComponentBackground(String name_short);

changeComponentLayout(
	String container_name,
	String name_short,
	String bitmap_file,
	String snappoint_left,
	String snappoint_top,
	String snappoint_right,
	String snappoint_bottom)
{
	Layout layoutComponent=System.getContainer(container_name).getLayout("normal");
	
	layoutComponent.setXmlParam("alphabackground",name_short+".background."+bitmap_file);
	layoutComponent.setXmlParam("snapadjustleft",snappoint_left);
	layoutComponent.setXmlParam("snapadjusttop",snappoint_top);
	layoutComponent.setXmlParam("snapadjustright",snappoint_right);
	layoutComponent.setXmlParam("snapadjustbottom",snappoint_bottom);
}
toggleComponentBackground(String name_short)
{
	String component_background=System.getPrivateString("Quinto_Black_CT","component_background","standard");
	String side_panel_width=System.getPrivateString("Quinto_Black_CT","side_panel_width","standard");

	if (name_short=="eq")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("eq.background.id").setXmlParam("visible","0");
			changeComponentLayout("equalizer","eq","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("equalizer","eq","feet"     ,"34","14","44","10");
				else if (side_panel_width=="wide") changeComponentLayout("equalizer","eq","feet.wide","10","14","20","10");
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("equalizer","eq","shadow"     ,"34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("equalizer","eq","shadow.wide","10","10","20","20");
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("equalizer","eq","standard","34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("equalizer","eq","standard","10","10","20","20");
			}
		}
	}
	else if (name_short=="frg")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("frg.background.id").setXmlParam("visible","0");
			changeComponentLayout("frequency.response.graph","frg","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("frequency.response.graph","frg","feet"     ,"34","14","44","10");
				else if (side_panel_width=="wide") changeComponentLayout("frequency.response.graph","frg","feet.wide","10","14","20","10");
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("frequency.response.graph","frg","shadow"     ,"34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("frequency.response.graph","frg","shadow.wide","10","10","20","20");
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("frequency.response.graph","frg","standard","34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("frequency.response.graph","frg","standard","10","10","20","20");
			}
		}
	}
	else if (name_short=="mp")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("mp.background.id").setXmlParam("visible","0");
			changeComponentLayout("main","mp","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("main","mp","feet","10","14","20","10");
				else if (side_panel_width=="wide") changeComponentLayout("main","mp","feet","10","14","20","10"); // no wide for Main Player
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("main","mp","shadow","10","10","20","20");
				else if (side_panel_width=="wide") changeComponentLayout("main","mp","shadow","10","10","20","20"); // no wide for Main Player
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("main","mp","standard","10","10","20","20");
				else if (side_panel_width=="wide") changeComponentLayout("main","mp","standard","10","10","20","20");
			}
		}
	}
	else if (name_short=="sa")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("sa.background.id").setXmlParam("visible","0");
			changeComponentLayout("spectrum.analyzer","sa","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("spectrum.analyzer","sa","feet"     ,"34","14","44","10");
				else if (side_panel_width=="wide") changeComponentLayout("spectrum.analyzer","sa","feet.wide","10","14","20","10");
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("spectrum.analyzer","sa","shadow"     ,"34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("spectrum.analyzer","sa","shadow.wide","10","10","20","20");
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("spectrum.analyzer","sa","standard","34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("spectrum.analyzer","sa","standard","10","10","20","20");
			}
		}
	}
	else if (name_short=="vu.ma")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("vu.ma.background.id").setXmlParam("visible","0");
			changeComponentLayout("vu.meter.analog","vu.ma","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.analog","vu.ma","feet"     ,"34","14","44","10");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.analog","vu.ma","feet.wide","10","14","20","10");
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.analog","vu.ma","shadow"     ,"34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.analog","vu.ma","shadow.wide","10","10","20","20");
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.analog","vu.ma","standard","34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.analog","vu.ma","standard","10","10","20","20");
			}
		}
	}
	else if (name_short=="vu.mdh")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("vu.mdh.background.id").setXmlParam("visible","0");
			changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","feet"     ,"34","14","44","10");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","feet.wide","10","14","20","10");
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","shadow"     ,"34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","shadow.wide","10","10","20","20");
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","standard","34","10","44","20");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.digital.horizontal","vu.mdh","standard","10","10","20","20");
			}
		}
	}
	else if (name_short=="vu.mdv")
	{
		if (component_background=="classic")
		{
			System.getScriptGroup().findObject("vu.mdv.background.id").setXmlParam("visible","0");
			changeComponentLayout("vu.meter.digital.vertical","vu.mdv","classic","49","14","59","24");
		}
		else
		{
			if (component_background=="show_with_feet")
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.digital.vertical","vu.mdv","feet","42","14","52","10");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.digital.vertical","vu.mdv","feet","42","14","52","10"); // no wide for VU Meter Vertical
			}
			else if (component_background=="show_with_shadow")
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.digital.vertical","vu.mdv","shadow","42","10","52","20");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.digital.vertical","vu.mdv","shadow","42","10","52","20"); // no wide for VU Meter Vertical
			}
			else if (component_background=="standard") // same background but different snappoints
			{
				if (side_panel_width=="standard")  changeComponentLayout("vu.meter.digital.vertical","vu.mdv","standard","42","10","52","20");
				else if (side_panel_width=="wide") changeComponentLayout("vu.meter.digital.vertical","vu.mdv","standard","42","10","52","20");
			}
		}
	}
}