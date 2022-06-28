#include "compiler/lib/std.mi"
#include "compiler/lib/config.mi"

Function UpdateLeft(Int Var);
Function refreshSPKRSettings();
Function setSPKRModeRBD();
Function ProcessMenuResult (int a);

Global Group frameGroup;

Global PopUpMenu speakermenu;

Global Timer refreshEQ;
Global layer speakerLeft, L_SpeakerTrigger, R_SpeakerTrigger, L_GrilleLayer, R_GrilleLayer;
Global AnimatedLayer L_Tweeter_Vis, L_Midrange_Vis, L_Woofer_Vis;
Global Int L_TweetVisBand, L_MidRVisband, L_WoofVisband;
Global Int level1T, level1M, level1W, level2, LastFrame1;

Global Boolean speaker_grille;

System.onScriptLoaded() {
	frameGroup = getScriptGroup();

	L_GrilleLayer = frameGroup.findObject("L_Grille");
//	R_GrilleLayer = frameGroup.findObject("R_Grille");

	L_Tweeter_Vis = frameGroup.getObject("L_Tweeter");
	L_Midrange_Vis = frameGroup.getObject("L_Midrange");
	L_Woofer_Vis = frameGroup.getObject("L_Woofer");
//	R_Speaker_Vis = frameGroup.findObject("R_Speaker");

	L_SpeakerTrigger = frameGroup.getObject("L_SpeakerBG");
//	R_SpeakerTrigger = frameGroup.getObject("R_SpeakerBG");

	refreshEQ = new Timer;
	refreshEQ.setDelay(10);

	refreshSPKRSettings();
}

//	========	Loads the settings when the script loads	========
refreshSPKRSettings()
{
	speaker_grille = getPrivateInt(getSkinName(), "Speaker Grille", 1);
	if (speaker_grille == 0) L_GrilleLayer.setXmlParam("visible","0");
	else L_GrilleLayer.setXmlParam("visible","1");
	refreshEQ.start();
}

//	========	stops and deletes the timer when the script unloads	========
System.onscriptunloading() {
	refreshEQ.stop();
	delete refreshEQ;
}

//	========	Changes the Speakers to the beat	========
refreshEQ.onTimer() {

	L_TweetVisBand = (getVisBand(0, 50)+getVisBand(0, 58)+getVisBand(0, 67)+getVisBand(0, 75)/4);
	L_MidRVisband = (getVisBand(0, 25)+getVisBand(0, 33)+getVisBand(0, 42)+getVisBand(0, 49)/4);
	L_WoofVisband = (getVisBand(0, 0)+getVisBand(0, 8)+getVisBand(0, 17)+getVisBand(0, 24)/4);

    level1T = (L_TweetVisBand*L_Tweeter_Vis.getLength()/256);
    level1M = (L_MidRVisband*L_Midrange_Vis.getLength()/256);
    level1W = (L_WoofVisband*L_Woofer_Vis.getLength()/256);
//    level2 = (getRightVuMeter()*speakerRight.getLength()/256);

    L_Tweeter_Vis.gotoFrame(level1T);
    L_Midrange_Vis.gotoFrame(level1M);
    L_Woofer_Vis.gotoFrame(level1W);
//    speakerRight.gotoFrame(level2);
}


//	========	Right click menu	========	
setSPKRModeRBD(){
	speakermenu = new PopUpMenu;
	speakermenu.addCommand("Show Grille", 101, speaker_grille == 1, 0);
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
/*		System.getContainer("loudspeaker.right").hide();*/
	}
}

//	========	Right-click action on Left Speaker	========
L_SpeakerTrigger.onRightButtonUp (int x, int y)
{
	setSPKRModeRBD();
}



