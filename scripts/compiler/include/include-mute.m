/****************************************************************
*   Filename: include-mute.m                                    *
*   Version:  2.0                                               *
*   Created:  2016-09-04                                        *
*   Updated   2020-02-18                                        *
*   Author:   PeterK.                                           *
*   E-Mail:   peter_ka@gmx.net                                  *
*   Note:     This script is based on mute.m from Modern Skin   *
****************************************************************/

#ifndef included
#error This script "include-mute.m" can only be compiled as #include
#endif

#include "include-display-info.m"

Global Button buttonMute; // Mute <button/> on ML, PE, VID and VIS

Global Float old_volume;

Function setLEDactive(String container_name,Boolean is_activated);

buttonMute.onLeftClick()
{
	if (System.getPrivateInt("Quinto_Black_CT","muted",FALSE)==0)
	{
		displayInfo("showinfo","MUTE: ON");
		System.setPrivateInt("Quinto_Black_CT","muted",TRUE);
		System.setPrivateInt("Quinto_Black_CT","old_volume",System.getVolume());
		System.setVolume(0);
		
		// Main Player is not a dynamic container hence no need for if-query
		setLEDactive("main",TRUE);
		if (System.getContainer("media.library")!=NULL)   setLEDactive("media.library"  ,TRUE);
		if (System.getContainer("playlist.editor")!=NULL) setLEDactive("playlist.editor",TRUE);
		if (System.getContainer("video")!=NULL)           setLEDactive("video"          ,TRUE);
		if (System.getContainer("visualization")!=NULL)   setLEDactive("visualization"  ,TRUE);
	}
	else
	{
		displayInfo("showinfo","MUTE: OFF");
		System.setPrivateInt("Quinto_Black_CT","muted",FALSE);
		System.setVolume(System.getPrivateInt("Quinto_Black_CT","old_volume",old_volume));
		
		setLEDactive("main",FALSE);
		if (System.getContainer("media.library")!=NULL)   setLEDactive("media.library"  ,FALSE);
		if (System.getContainer("playlist.editor")!=NULL) setLEDactive("playlist.editor",FALSE);
		if (System.getContainer("video")!=NULL)           setLEDactive("video"          ,FALSE);
		if (System.getContainer("visualization")!=NULL)   setLEDactive("visualization"  ,FALSE);
	}
	System.setPrivateInt("Quinto_Black_CT","mute_button_pressed",TRUE);
}
setLEDactive(String container_name,Boolean is_activated)
{
	if (container_name=="main")
	{
		ToggleButton toggleButtonMute=System.getContainer("main").getLayout("normal").findObject("mp.button.mute.id");
		toggleButtonMute.setActivated(is_activated);
		ToggleButton toggleButtonMuteLED=System.getContainer("main").getLayout("normal").findObject("mp.button.mute.led.id");
		toggleButtonMuteLED.setActivated(is_activated);
	}
	else
	{
		ToggleButton toggleButtonMuteLED=System.getContainer(container_name).getLayout("normal").findObject("button.mute.led.id");
		toggleButtonMuteLED.setActivated(is_activated);
	}
}