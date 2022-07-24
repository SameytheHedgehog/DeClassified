/*******************************************
*   Filename: include-button-led-color.m   *
*   Version:  1.0                          *
*   Created:  2020-03-28                   *
*   Updated   2020-03-28                   *
*   Author:   PeterK.                      *
*   E-Mail:   peter_ka@gmx.net             *
*******************************************/

#ifndef included
#error This script "include-button-led.m" can only be compiled as #include
#endif

Function setButtonLEDcolor(String button_name,String led_color); // for scripts

// ALL
Function setButtonLEDonEqualizer(String button_name,String led_color);
Function setButtonMuteLEDcolor(String led_color);
Function setButtonRepeatLEDcolor(String led_color);
Function setButtonShuffleLEDcolor(String led_color);
Function setButtonLEDonTrackBookmarks(String button_name,String led_color);
Function setButtonFileinfoLEDcolor(String led_color);
Function setButtonRandomLEDcolor(String led_color);

setButtonLEDcolor(String button_name,String led_color)
{
	System.getScriptGroup().findObject(button_name).setXmlParam("activeimage","led."+led_color);
}
setButtonLEDonEqualizer(String button_name,String led_color)
{
	System.getContainer("equalizer").getLayout("normal").findObject(button_name+".led.id").setXmlParam("activeimage","led."+led_color);
}
setButtonMuteLEDcolor(String led_color)
{
	// Main Player is not a dynamic container hence no need for if-query
	System.getContainer("main").getLayout("normal").findObject("mp.button.mute.led.id").setXmlParam("activeimage","led."+led_color);
	
	if (System.getContainer("media.library")!=NULL) System.getContainer("media.library").getLayout("normal").findObject("button.mute.led.id").setXmlParam("activeimage","led."    +led_color);
	if (System.getContainer("playlist.editor")!=NULL) System.getContainer("playlist.editor").getLayout("normal").findObject("button.mute.led.id").setXmlParam("activeimage","led."+led_color);
	if (System.getContainer("video")!=NULL) System.getContainer("video").getLayout("normal").findObject("button.mute.led.id").setXmlParam("activeimage","led."                    +led_color);
	if (System.getContainer("visualization")!=NULL) System.getContainer("visualization").getLayout("normal").findObject("button.mute.led.id").setXmlParam("activeimage","led."    +led_color);
}
setButtonRepeatLEDcolor(String led_color)
{
	System.getContainer("main").getLayout("normal").findObject("mp.button.repeat.led.id").setXmlParam("activeimage","led."+led_color);
	
	if (System.getContainer("media.library")!=NULL) System.getContainer("media.library").getLayout("normal").findObject("button.repeat.led.id").setXmlParam("activeimage","led."    +led_color);
	if (System.getContainer("playlist.editor")!=NULL) System.getContainer("playlist.editor").getLayout("normal").findObject("button.repeat.led.id").setXmlParam("activeimage","led."+led_color);
	if (System.getContainer("video")!=NULL) System.getContainer("video").getLayout("normal").findObject("button.repeat.led.id").setXmlParam("activeimage","led."                    +led_color);
	if (System.getContainer("visualization")!=NULL) System.getContainer("visualization").getLayout("normal").findObject("button.repeat.led.id").setXmlParam("activeimage","led."    +led_color);
}
setButtonShuffleLEDcolor(String led_color)
{
	System.getContainer("main").getLayout("normal").findObject("mp.button.shuffle.led.id").setXmlParam("activeimage","led."+led_color);
	
	if (System.getContainer("media.library")!=NULL) System.getContainer("media.library").getLayout("normal").findObject("button.shuffle.led.id").setXmlParam("activeimage","led."    +led_color);
	if (System.getContainer("playlist.editor")!=NULL) System.getContainer("playlist.editor").getLayout("normal").findObject("button.shuffle.led.id").setXmlParam("activeimage","led."+led_color);
	if (System.getContainer("video")!=NULL) System.getContainer("video").getLayout("normal").findObject("button.shuffle.led.id").setXmlParam("activeimage","led."                    +led_color);
	if (System.getContainer("visualization")!=NULL) System.getContainer("visualization").getLayout("normal").findObject("button.shuffle.led.id").setXmlParam("activeimage","led."    +led_color);
}
setButtonLEDonTrackBookmarks(String button_name,String led_color)
{
	System.getContainer("track.bookmarks").getLayout("normal").findObject(button_name+".led.id").setXmlParam("activeimage","led."+led_color);
}
setButtonFileinfoLEDcolor(String led_color)
{
	// Dynamic container
	if (System.getContainer("playlist.editor")!=NULL) System.getContainer("playlist.editor").getLayout("normal").findObject("pe.button.fileinfo.led.id").setXmlParam("activeimage","led."+led_color);
}
setButtonRandomLEDcolor(String led_color)
{
	// Dynamic container
	if (System.getContainer("visualization")!=NULL) System.getContainer("visualization").getLayout("normal").findObject("vis.button.random.led.id").setXmlParam("activeimage","led."+led_color);
}