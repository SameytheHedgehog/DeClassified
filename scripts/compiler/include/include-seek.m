/****************************************************************
*   Filename: include-seek.m                                    *
*   Version:  1.5                                               *
*   Created:  2016-09-04                                        *
*   Updated   2020-02-18                                        *
*   Author:   PeterK.                                           *
*   E-Mail:   peter_ka@gmx.net                                  *
*   Note:     This script is based on seek.m from Modern Skin   *
****************************************************************/

#ifndef included
#error This script "include-seek.m" can only be compiled as #include
#endif

#include "include-display-info.m"

Global Boolean is_seeking;

Global Slider sliderSeek;

sliderSeek.onSetPosition(Int newpos)
{
	if (is_seeking==TRUE)
	{
		Float f=newpos;
		Float length=System.getPlayItemLength();
		f=f/2.55;
		if (length!=0)
		{
			Int i=length*f/100;
			String info="SEEK: "+System.integerToTime(i)+"/"+
										System.integerToTime(length)+" ("+
										System.integerToString(f)+" %)";
			displayInfo("showinfo",info);
		}
	}
}
sliderSeek.onLeftButtonDown(Int x,Int y) // slide is a <GuiObject/> in here, not a button.onLeftClick()
{
	is_seeking=TRUE;
}
sliderSeek.onLeftButtonUp(Int x,Int y) // slider is a <GuiObject/> in here, not a button.onLeftClick()
{
	is_seeking=FALSE;
	displayInfo("cancelinfo","");
}
sliderSeek.onSetFinalPosition(Int pos)
{
	displayInfo("cancelinfo","");
}