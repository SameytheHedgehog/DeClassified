//Handles switching most of the main windows,
//the Equalizer does this on it's own, though the
//mechanism is the same.

#include "compiler/lib/std.mi"
#include "IsWACUP.m"

Global GuiObject WAPLC;
Global Group frameGroup, frameGroupShade, frameGroupPL;

Global Layer wacupmain, wacuptitlebar, wacupshade;

System.onScriptLoaded(){

    initDetector();

    frameGroup = getContainer("Main").getLayout("Normal");
	frameGroupShade = getContainer("Main").getLayout("shade");
    frameGroupPL = getContainer("PL").getLayout("normal");

    wacupshade = frameGroupShade.findObject("washade");

    wacupmain = frameGroup.findObject("mainwnd");
	wacuptitlebar = frameGroup.findObject("wa.titlebar");

	WAPLC = frameGroupPL.findObject("wasabi.list");

	if(IsWACUP != 0){
		wacupmain.setXmlParam("image", "wacup.main");
		wacuptitlebar.setXmlParam("image", "wacup.titlebar.on");
		wacuptitlebar.setXmlParam("inactiveimage", "wacup.titlebar.off");
		wacupshade.setXmlParam("image", "wacup.player.shade.enabled");
		wacupshade.setXmlParam("inactiveimage", "wacup.player.shade.disabled");
		WAPLC.setXmlParam("x", "12");
		WAPLC.setXmlParam("w", "-31");
	}else{
		wacupmain.setXmlParam("image", "wa.main");
		wacuptitlebar.setXmlParam("image", "wa.titlebar.on");
		wacuptitlebar.setXmlParam("inactiveimage", "wa.titlebar.off");
		wacupshade.setXmlParam("image", "wa2.player.shade.enabled");
		wacupshade.setXmlParam("inactiveimage", "wa2.player.shade.disabled");
		WAPLC.setXmlParam("x", "10");
		WAPLC.setXmlParam("w", "-15");
	}
}