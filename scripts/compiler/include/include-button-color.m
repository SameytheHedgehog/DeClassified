/***************************************
*   Filename: include-button-color.m   *
*   Version:  1.0                      *
*   Created:  2020-03-28               *
*   Updated   2020-03-28               *
*   Author:   PeterK.                  *
*   E-Mail:   peter_ka@gmx.net         *
***************************************/

#ifndef included
#error This script "include-button-color.m" can only be compiled as #include
#endif

#define BUTTON_ACD      "reset/apply.new.dimension/close2"
#define BUTTON_ACFB     "select.file/apply.new.background/close2"
#define BUTTON_AW       "forum"
#define BUTTON_PE       "add/remove/select/misc/manage.playlist/fileinfo"
#define BUTTON_PE2      "show.current/reset/move.up/move.down/move.to.position/play.track/remove/swap/close2"
#define BUTTON_PLAYBACK "prev/play/pause/stop/next/eject/mute"
#define BUTTON_RGB_CC   "select.item/reset/apply.new.color/close2"
#define BUTTON_TB       "set1/set2/set3/play1/play2/play3/clear.playlist/a/b/stop/close2"
#define BUTTON_VID      "fullsize/1x/2x/options"
#define BUTTON_VIS      "fullsize/prev/next/random/options"

// Functions for container scripts
Function setButtonColorPlayback(String button_type,String button_color);
Function setButtonColorStandard(String name_short,String button_type,String button_color);

Function setButtonColorALL(String new_color);
Function setButtonColorStandardALL(String container_name,String name_short,String button_type,String button_color);
Function setButtonColorPlaybackALL(String container_name,String button_type,String button_color);

setButtonColorPlayback(String button_type,String button_color)
{
	System.getScriptGroup().findObject("button."+button_type+".id").setXmlParam("image"     ,"button."+button_type+"."      +button_color);
	System.getScriptGroup().findObject("button."+button_type+".id").setXmlParam("hoverimage","button."+button_type+".hover."+button_color);
	System.getScriptGroup().findObject("button."+button_type+".id").setXmlParam("downimage" ,"button."+button_type+".down." +button_color);
}
setButtonColorStandard(String name_short,String button_type,String button_color)
{
	System.getScriptGroup().findObject(name_short+".button."+button_type+".id").setXmlParam("image"      ,name_short+".button."+button_type+"."      +button_color);
	System.getScriptGroup().findObject(name_short+".button."+button_type+".id").setXmlParam("hoverimage" ,name_short+".button."+button_type+".hover."+button_color);
	System.getScriptGroup().findObject(name_short+".button."+button_type+".id").setXmlParam("downimage"  ,name_short+".button."+button_type+".down." +button_color);
	System.getScriptGroup().findObject(name_short+".button."+button_type+".id").setXmlParam("activeimage",name_short+".button."+button_type+".down." +button_color);
	
	// Winamp activates RANDOM <button/> after every new start and it looks like pressed. => make it look normal, there is a LED, which is activ.
	if (name_short=="vis" && button_type=="random") System.getScriptGroup().findObject("vis.button.random.id").setXmlParam("activeimage","vis.button.random."+button_color);
}
setButtonColorALL(String new_color)
{
	for (Int i=0;i<1;i++)  {setButtonColorStandardALL("about.window","aw"                ,System.getToken(BUTTON_AW,    "/",i),new_color);}
	for (Int i=0;i<3;i++)  {setButtonColorStandardALL("album.cover.dimension","acd"      ,System.getToken(BUTTON_ACD,   "/",i),new_color);}
	for (Int i=0;i<3;i++)  {setButtonColorStandardALL("album.coverflow.background","acfb",System.getToken(BUTTON_ACFB,  "/",i),new_color);}
	for (Int i=0;i<9;i++)  {setButtonColorStandardALL("playlist.editor2","pe2"           ,System.getToken(BUTTON_PE2,   "/",i),new_color);}
	for (Int i=0;i<4;i++)  {setButtonColorStandardALL("rgb.color.changer","rgb.cc"       ,System.getToken(BUTTON_RGB_CC,"/",i),new_color);}
	for (Int i=0;i<11;i++) {setButtonColorStandardALL("track.bookmarks","tb"             ,System.getToken(BUTTON_TB,    "/",i),new_color);}
	
	// These are dynamic containers hence if-query is needed
	if (System.getContainer("media.library")!=NULL)
	{
		for (Int i=0;i<7;i++)
		{
			setButtonColorPlaybackALL("media.library",System.getToken(BUTTON_PLAYBACK,"/",i),new_color);
		}
	}
	if (System.getContainer("playlist.editor")!=NULL)
	{
		for (Int i=0;i<7;i++)
		{
			setButtonColorPlaybackALL("playlist.editor",System.getToken(BUTTON_PLAYBACK,"/",i),new_color);
		}
		for (Int i=0;i<6;i++)
		{
			setButtonColorStandardALL("playlist.editor","pe",System.getToken(BUTTON_PE,"/",i),new_color);
		}
	}
	if (System.getContainer("video")!=NULL)
	{
		for (Int i=0;i<7;i++)
		{
			setButtonColorPlaybackALL("video",System.getToken(BUTTON_PLAYBACK,"/",i),new_color);
		}
		for (Int i=0;i<4;i++)
		{
			setButtonColorStandardALL("video","vid",System.getToken(BUTTON_VID,"/",i),new_color);
		}
	}
	if (System.getContainer("visualization")!=NULL)
	{
		for (Int i=0;i<7;i++)
		{
			setButtonColorPlaybackALL("visualization",System.getToken(BUTTON_PLAYBACK,"/",i),new_color);
		}
		for (Int i=0;i<5;i++)
		{
			setButtonColorStandardALL("visualization","vis",System.getToken(BUTTON_VIS,"/",i),new_color);
		}
	}
}
setButtonColorPlaybackALL(String container_name,String button_type,String button_color)
{
	Layout layoutComponent=System.getContainer(container_name).getLayout("normal");

	layoutComponent.findObject("button."+button_type+".id").setXmlParam("image"     ,"button."+button_type+"."      +button_color);
	layoutComponent.findObject("button."+button_type+".id").setXmlParam("hoverimage","button."+button_type+".hover."+button_color);
	layoutComponent.findObject("button."+button_type+".id").setXmlParam("downimage" ,"button."+button_type+".down." +button_color);
}
setButtonColorStandardALL(String container_name,String name_short,String button_type,String button_color)
{
	Layout layoutComponent=System.getContainer(container_name).getLayout("normal");
	
	layoutComponent.findObject(name_short+".button."+button_type+".id").setXmlParam("image"      ,name_short+".button."+button_type+"."      +button_color);
	layoutComponent.findObject(name_short+".button."+button_type+".id").setXmlParam("hoverimage" ,name_short+".button."+button_type+".hover."+button_color);
	layoutComponent.findObject(name_short+".button."+button_type+".id").setXmlParam("downimage"  ,name_short+".button."+button_type+".down." +button_color);
	layoutComponent.findObject(name_short+".button."+button_type+".id").setXmlParam("activeimage",name_short+".button."+button_type+".down." +button_color);
	
	// Winamp activates RANDOM <button/> after every new start and it looks like pressed. => make it look normal, there is a LED, which is activ.
	if (name_short=="vis" && button_type=="random") layoutComponent.findObject("vis.button.random.id").setXmlParam("activeimage","vis.button.random."+button_color);
}