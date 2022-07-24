/*******************************************
*   Filename: include-visualizer-color.m   *
*   Version:  1.1                          *
*   Created:  2019-11-12                   *
*   Updated   2020-02-18                   *
*   Author:   PeterK.                      *
*   E-Mail:   peter_ka@gmx.net             *
*******************************************/

#ifndef included
#error This script "include-visualizer-color.m" can only be compiled as #include
#endif

Global Vis visualizer;

Function setColorScheme(String color_osc,
	String color_bandpeak,
	String color_band16,
	String color_band15,
	String color_band14,
	String color_band13,
	String color_band12,
	String color_band11,
	String color_band10,
	String color_band9,
	String color_band8,
	String color_band7,
	String color_band6,
	String color_band5,
	String color_band4,
	String color_band3,
	String color_band2,
	String color_band1);
	
Function setVisualizerColor(String container_name,String color_scheme);

setVisualizerColor(String container_name,String color_scheme)
{
	if (container_name=="main")
	{
		visualizer=System.getContainer("main").getLayout("normal").findObject("mp.vis.id");
	}
	else
	{
		visualizer=System.getContainer("spectrum.analyzer").getLayout("normal").findObject("sa.vis.id");
		Layout visualizerLayout=System.getContainer("spectrum.analyzer").getLayout("normal");
		
		visualizerLayout.findObject("sa.display.plane.id").setXmlParam("image","sa.display.plane."+color_scheme);
		visualizerLayout.findObject("sa.display.bars1.id").setXmlParam("image","sa.display.bars1."+color_scheme);
		visualizerLayout.findObject("sa.display.bars2.id").setXmlParam("image","sa.display.bars2."+color_scheme);
		visualizerLayout.findObject("sa.display.grid1.id").setXmlParam("image","sa.display.grid1."+color_scheme);
		visualizerLayout.findObject("sa.display.grid2.id").setXmlParam("image","sa.display.grid2."+color_scheme);
	}
	if (color_scheme=="classic")
	{
		setColorScheme("#ffffff",
			"#959595",
			"#e44300",
			"#e44300",
			"#e04f00",
			"#dc7500",
			"#d0ab00",
			"#c4c700",
			"#c0d800",
			"#b6e400",
			"#a6ec00",
			"#90e000",
			"#7bd400",
			"#61c800",
			"#4ebc00",
			"#39b000",
			"#21a400",
			"#099700");
	}
	else if (color_scheme=="darkred")
	{
		setColorScheme("#ff0808",
			"#ffc0c0",
			"#ffe4e4",
			"#ffd1d1",
			"#ffc0c0",
			"#ffa7a7",
			"#ff9a9a",
			"#ff9090",
			"#ff8383",
			"#ff7575",
			"#ff6969",
			"#ff5858",
			"#ff4f4f",
			"#ff3f3f",
			"#ff2e2e",
			"#ff2424",
			"#ff1515",
			"#ff0808");
	}
	else if (color_scheme=="goldenrod")
	{
		setColorScheme("#ffd409",
			"#fff7e0",
			"#fff1c7",
			"#fff1c7",
			"#ffeeb6",
			"#ffedac",
			"#ffeb9f",
			"#ffe991",
			"#ffe681",
			"#ffe575",
			"#ffe263",
			"#ffe057",
			"#ffde4b",
			"#ffdc3b",
			"#ffda2f",
			"#ffd824",
			"#ffd615",
			"#ffd409");
	}
	else if (color_scheme=="turquoise")
	{
		setColorScheme("#00fefe",
			"#ebffff",
			"#ebffff",
			"#ebffff",
			"#ebffff",
			"#c3ffff",
			"#c3ffff",
			"#9bffff",
			"#9bffff",
			"#73ffff",
			"#73ffff",
			"#4bffff",
			"#4bffff",
			"#23ffff",
			"#23ffff",
			"#00fefe",
			"#00fefe",
			"#00fefe");
	}
}
setColorScheme(String color_osc,
	String color_bandpeak,
	String color_band16,
	String color_band15,
	String color_band14,
	String color_band13,
	String color_band12,
	String color_band11,
	String color_band10,
	String color_band9,
	String color_band8,
	String color_band7,
	String color_band6,
	String color_band5,
	String color_band4,
	String color_band3,
	String color_band2,
	String color_band1)
{
	// Oscilloscope on Main Player
	for (Int i=1;i<6;i++)
	{
		visualizer.setXmlParam("colorosc"+System.integerToString(i),color_osc);
	}
	
	// Spectroscope on Main Player and Spectrum Analyzer
	visualizer.setXmlParam("colorbandpeak",color_bandpeak);
	visualizer.setXmlParam("colorband16"  ,color_band16);
	visualizer.setXmlParam("colorband15"  ,color_band15);
	visualizer.setXmlParam("colorband14"  ,color_band14);
	visualizer.setXmlParam("colorband13"  ,color_band13);
	visualizer.setXmlParam("colorband12"  ,color_band12);
	visualizer.setXmlParam("colorband11"  ,color_band11);
	visualizer.setXmlParam("colorband10"  ,color_band10);
	visualizer.setXmlParam("colorband9"   ,color_band9);
	visualizer.setXmlParam("colorband8"   ,color_band8);
	visualizer.setXmlParam("colorband7"   ,color_band7);
	visualizer.setXmlParam("colorband6"   ,color_band6);
	visualizer.setXmlParam("colorband5"   ,color_band5);
	visualizer.setXmlParam("colorband4"   ,color_band4);
	visualizer.setXmlParam("colorband3"   ,color_band3);
	visualizer.setXmlParam("colorband2"   ,color_band2);
	visualizer.setXmlParam("colorband1"   ,color_band1);
}