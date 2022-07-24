/************************************
*   Filename: include-frame.m       *
*   Version:  3.1                   *
*   Created:  2016-09-20            *
*   Updated   2020-02-18            *
*   Author:   PeterK.               *
*   E-Mail:   peter_ka@gmx.net      *
************************************/

#ifndef included
#error This script "include-frame.m" can only be compiled as #include
#endif

Global Group groupContent;
Global Group groupFileinfoLayer;
Global Group groupNoFrame;
Global Group groupPlaybackFrame;
Global Group groupStandardFrame;

Global Layout layoutContainer;

Global ToggleButton nstatesButtonFrame; // <nstatesbutton/> is a special <togglebutton/>
Global ToggleButton toggleButtonFileinfo; // only ON/OFF

Function hideFileinfoLayer();
Function setContentSize(String x,String y,String w,String h);
Function setMinimumLayoutSize(String min_w,String min_h);
Function setMlPlaybackFrame();
Function setNoFrame();
Function setNoFrame2();
Function setNstatesButtonFrameAlpha(String alpha,String ghost);
Function setPePlaybackFrame();
Function setStandardFrame();
Function setStandardFrame2();
Function setVidVisPlaybackFrame();
Function showFileinfoLayer();

hideFileinfoLayer()
{
	groupFileinfoLayer.setXmlParam("visible","0");
	setContentSize("31","31","-62","-177");
}
setContentSize(String x,String y,String w,String h)
{
	groupContent.setXmlParam("x",x);
	groupContent.setXmlParam("y",y);
	groupContent.setXmlParam("w",w);
	groupContent.setXmlParam("h",h);
}
setMinimumLayoutSize(String min_w,String min_h)
{
	layoutContainer.setXmlParam("minimum_w",min_w);
	layoutContainer.setXmlParam("minimum_h",min_h);
}
setMlPlaybackFrame()
{
	groupStandardFrame.setXmlParam("visible","0");
	groupPlaybackFrame.setXmlParam("visible","1");
	groupNoFrame.setXmlParam("visible","0");
	setContentSize("31","31","-62","-177");
	setMinimumLayoutSize("800","177"); // pseudo shade mode
}
setNoFrame()
{
	groupStandardFrame.setXmlParam("visible","0");
	groupPlaybackFrame.setXmlParam("visible","0");
	groupNoFrame.setXmlParam("visible","1");
	setContentSize("1","27","-2","-28");
	setMinimumLayoutSize("608","258"); //1:2.35
}
setNoFrame2() // Lyrics window
{
	groupStandardFrame.setXmlParam("visible","0");
	groupNoFrame.setXmlParam("visible","1");
	setContentSize("1","27","-2","-28");
}
setNstatesButtonFrameAlpha(String alpha,String ghost)
{
	nstatesButtonFrame.setXmlParam("alpha",alpha);
	nstatesButtonFrame.setXmlParam("ghost",ghost);
}
setPePlaybackFrame()
{
	groupStandardFrame.setXmlParam("visible","0");
	groupPlaybackFrame.setXmlParam("visible","1");
	groupNoFrame.setXmlParam("visible","0");
	setMinimumLayoutSize("800","340"); //1:2.35
	
	if (System.getPrivateInt("Quinto_Black_CT","pe_fileinfo_visible",FALSE)==0) hideFileinfoLayer();
	else if (System.getPrivateInt("Quinto_Black_CT","pe_fileinfo_visible",TRUE)==1) showFileinfoLayer();
}
setStandardFrame()
{
	groupStandardFrame.setXmlParam("visible","1");
	groupPlaybackFrame.setXmlParam("visible","0");
	groupNoFrame.setXmlParam("visible","0");
	setContentSize("31","31","-62","-62");
	setMinimumLayoutSize("608","258"); //1:2.35
}
setStandardFrame2() // Lyrics window
{
	groupStandardFrame.setXmlParam("visible","1");
	groupNoFrame.setXmlParam("visible","0");
	setContentSize("31","31","-62","-62");
}
setVidVisPlaybackFrame()
{
	groupStandardFrame.setXmlParam("visible","0");
	groupPlaybackFrame.setXmlParam("visible","1");
	groupNoFrame.setXmlParam("visible","0");
	setContentSize("31","31","-62","-177");
	setMinimumLayoutSize("800","340"); //1:2.35
}
showFileinfoLayer()
{
	groupFileinfoLayer.setXmlParam("visible","1");
	setContentSize("31","31","-62","-273");
}