//Handles switching most of the main windows,
//the Equalizer does this on it's own, though the
//mechanism is the same.

#include "compiler/lib/std.mi"
#include "IsWACUP.m"

Global Group frameGroup, frameGroupShade;

Global Layer wacupmain, wacuptitlebar, wacupshade;

System.onScriptLoaded(){

    initDetector();

    frameGroup = getContainer("Main").getLayout("Normal");
	frameGroupShade = getContainer("Main").getLayout("shade");

    wacupshade = frameGroupShade.findObject("washade");

    wacupmain = frameGroup.findObject("mainwnd");
	wacuptitlebar = frameGroup.findObject("wa.titlebar");

	if(IsWACUP != 0){
		wacupmain.setXmlParam("image", "wacup.main");
		wacuptitlebar.setXmlParam("image", "wacup.titlebar.on");
		wacuptitlebar.setXmlParam("inactiveimage", "wacup.titlebar.off");
		wacupshade.setXmlParam("image", "wacup.player.shade.enabled");
		wacupshade.setXmlParam("inactiveimage", "wacup.player.shade.disabled");
	}else{
		wacupmain.setXmlParam("image", "wa.main");
		wacuptitlebar.setXmlParam("image", "wa.titlebar.on");
		wacuptitlebar.setXmlParam("inactiveimage", "wa.titlebar.off");
		wacupshade.setXmlParam("image", "wa2.player.shade.enabled");
		wacupshade.setXmlParam("inactiveimage", "wa2.player.shade.disabled");
	}
}