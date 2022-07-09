#include "compiler/lib/std.mi"

Function refreshSPKRSettings();
Function setSPKRModeRBD();
Function ProcessMenuResult (int a);

Global Group L_frameGroup;

Global PopUpMenu speakermenu;

Global timer SpkrVU;
Global layer speakerLeft, L_SpeakerTrigger, L_GrilleLayer;
Global AnimatedLayer L_Tweeter_VU, L_Midrange_VU, L_Woofer_VU;
Global Int L_TweetVUBand, L_MidRVUband, L_WoofVUband;
Global Int level1T, level1M, level1W;

Global Boolean speaker_grille;

System.onScriptLoaded() {
	L_frameGroup = getScriptGroup();

	L_GrilleLayer = L_frameGroup.findObject("L_Grille");

	L_Tweeter_VU = L_frameGroup.getObject("L_Tweeter");
	L_Midrange_VU = L_frameGroup.getObject("L_Midrange");
	L_Woofer_VU = L_frameGroup.getObject("L_Woofer");

	L_SpeakerTrigger = L_frameGroup.getObject("L_SpeakerBG");


	SpkrVU = new Timer;
	SpkrVU.setDelay(10);
	SpkrVU.start();

	refreshSPKRSettings();
}

//	========	Loads the settings when the script loads	========
refreshSPKRSettings()
{
	speaker_grille = getPrivateInt(getSkinName(), "Speaker Grille", 1);
	if (speaker_grille == 0) L_GrilleLayer.setXmlParam("visible","0");
	else L_GrilleLayer.setXmlParam("visible","1");
}

//	========	stops and deletes the timer when the script unloads	========
System.onscriptunloading() {
	SpkrVU.stop();
}

//	========	Changes the Speakers to the beat	========
SpkrVU.onTimer() {

	L_TweetVUBand = (getVisBand(0, 50)+getVisBand(0, 56)+getVisBand(0, 62)+getVisBand(0, 68)+getVisBand(0, 75)/5);
	L_MidRVUband = (getVisBand(0, 25)+getVisBand(0, 31)+getVisBand(0, 37)+getVisBand(0, 43)+getVisBand(0, 49)/5);
	L_WoofVUband = (getVisBand(0, 0)+getVisBand(0, 6)+getVisBand(0, 12)+getVisBand(0, 18)+getVisBand(0, 24)/5);

	level1T = (L_TweetVUBand*(L_Tweeter_VU.getLength())/256);
	level1M = (L_MidRVUband*(L_Midrange_VU.getLength())/256);
	level1W = (L_WoofVUband*(L_Woofer_VU.getLength())/256);

	L_Tweeter_VU.gotoFrame(level1T);
	L_Midrange_VU.gotoFrame(level1M);
	L_Woofer_VU.gotoFrame(level1W);
}


//	========	Right click menu	========	
setSPKRModeRBD(){
	speakermenu = new PopUpMenu;
	speakermenu.addCommand("Show Grille", 101, speaker_grille == 1, 0);
	speakermenu.addCommand("Mini Mode (WIP, just removes Grille atm)", 101, speaker_grille == 1, 0);
	speakermenu.addSeparator();
	speakermenu.addCommand("Close Speakers", 102, 0, 0);

	ProcessMenuResult (speakermenu.popAtMouse());

	delete speakermenu;
	complete;	
}

//	========	Process R-Click menu actions	========
ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
	}

	else if (a == 101)
	{
		speaker_grille = (speaker_grille - 1) * (-1);
		setPrivateInt(getSkinName(), "Speaker Grille", speaker_grille);

		if (speaker_grille == 0)
		{
			L_GrilleLayer.setXmlParam("visible","0");
		}
		else
		{
			L_GrilleLayer.setXmlParam("visible","1");
		}
	}
	else if (a == 102)
	{
		System.getContainer("left-speaker").hide();
	}
}

//	========	Right-click action on Left Speaker	========
L_SpeakerTrigger.onRightButtonUp (int x, int y)
{
	setSPKRModeRBD();
}



