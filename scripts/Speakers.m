/*---------------------------------------------------
-----------------------------------------------------
Filename:	speakers.m
Version:	1.0

Type:		maki
Date:		12-15-2022
Author:		Samey the Hedgehog

Note:		Simple speaker script that has a tweeter,
			midrange, and woofer speaker all animated
			seperately. Feel free to use however you
			like. :)
-----------------------------------------------------
---------------------------------------------------*/

#include "compiler/lib/std.mi"

Function refreshSPKRSettings();
Function Left_setSPKRModeRBD();
Function Right_setSPKRModeRBD();
Function ProcessMenuResult (int a);

Global Container L_SpeakerContainer, R_SpeakerContainer;
Global Group L_frameGroup, L_frameGroupMini, L_NormalGroup, L_MiniGroup;
Global Group R_frameGroup, R_frameGroupMini, R_NormalGroup, R_MiniGroup;

Global PopUpMenu speakermenu;

Global timer SpkrVU;
Global layer L_SpeakerTrigger, L_GrilleLayer, L_MinSpeakerTrigger, L_MinGrilleLayer;
Global layer R_SpeakerTrigger, R_GrilleLayer, R_MinSpeakerTrigger, R_MinGrilleLayer;
Global AnimatedLayer L_Tweeter_VU, L_Midrange_VU, L_Woofer_VU, L_MinTweeter_VU, L_MinMidrange_VU, L_MinWoofer_VU;
Global AnimatedLayer R_Tweeter_VU, R_Midrange_VU, R_Woofer_VU, R_MinTweeter_VU, R_MinMidrange_VU, R_MinWoofer_VU;
Global Int TweetVUBand, MidRVUband, WoofVUband;
Global Int level1T, level1M, level1W;

Global Boolean speaker_grille, speaker_mini, speaker_closed, onoff;

System.onScriptLoaded() {
	L_SpeakerContainer = getContainer("left-speaker");
    L_frameGroup = L_SpeakerContainer.getLayout("normal");
	L_frameGroupMini = L_SpeakerContainer.getLayout("minimised");
	R_SpeakerContainer = getContainer("right-speaker");
    R_frameGroup = R_SpeakerContainer.getLayout("normal");
	R_frameGroupMini = R_SpeakerContainer.getLayout("minimised");

// === Normal Mode [Left] ===
	L_NormalGroup = L_frameGroup.findObject("Speaker-Left");
	L_GrilleLayer = L_NormalGroup.findObject("L_Grille");

	L_Tweeter_VU = L_NormalGroup.getObject("L_Tweeter");
	L_Midrange_VU = L_NormalGroup.getObject("L_Midrange");
	L_Woofer_VU = L_NormalGroup.getObject("L_Woofer");

	L_SpeakerTrigger = L_NormalGroup.getObject("L_SpeakerBG");

// === Normal Mode [Right] ===
	R_NormalGroup = R_frameGroup.findObject("Speaker-Right");
	R_GrilleLayer = R_NormalGroup.findObject("R_Grille");

	R_Tweeter_VU = R_NormalGroup.getObject("R_Tweeter");
	R_Midrange_VU = R_NormalGroup.getObject("R_Midrange");
	R_Woofer_VU = R_NormalGroup.getObject("R_Woofer");

	R_SpeakerTrigger = R_NormalGroup.getObject("R_SpeakerBG");

// === Mini Mode [Left] ===
	L_MiniGroup = L_frameGroupMini.findObject("MiniSpeaker-Left");
	L_MinGrilleLayer = L_MiniGroup.findObject("L_MiniGrille");

	L_MinTweeter_VU = L_MiniGroup.getObject("L_MiniTweeter");
	L_MinMidrange_VU = L_MiniGroup.getObject("L_MiniMidrange");
	L_MinWoofer_VU = L_MiniGroup.getObject("L_MiniWoofer");

	L_MinSpeakerTrigger = L_MiniGroup.getObject("L_MiniSpeakerBG");

// === Mini Mode [Right] ===
	R_MiniGroup = R_frameGroupMini.findObject("MiniSpeaker-Right");
	R_MinGrilleLayer = R_MiniGroup.findObject("R_MiniGrille");

	R_MinTweeter_VU = R_MiniGroup.getObject("R_MiniTweeter");
	R_MinMidrange_VU = R_MiniGroup.getObject("R_MiniMidrange");
	R_MinWoofer_VU = R_MiniGroup.getObject("R_MiniWoofer");

	R_MinSpeakerTrigger = R_MiniGroup.getObject("R_MiniSpeakerBG");


	SpkrVU = new Timer;
	SpkrVU.setDelay(10);
	SpkrVU.start();

	refreshSPKRSettings();
}

//	========	Loads the settings when the script loads	========
refreshSPKRSettings()
{
	speaker_grille = getPrivateInt(getSkinName(), "Speaker Grille", 1);
	if (speaker_grille == 0)
	{
		L_GrilleLayer.setXmlParam("visible","0");
		R_GrilleLayer.setXmlParam("visible","0");
		L_MinGrilleLayer.setXmlParam("visible","0");
		R_MinGrilleLayer.setXmlParam("visible","0");
	}
	else
	{
		L_GrilleLayer.setXmlParam("visible","1");
		R_GrilleLayer.setXmlParam("visible","1");
		L_GrilleLayer.setXmlParam("visible","1");
		R_GrilleLayer.setXmlParam("visible","1");
	}

	speaker_mini = getPrivateInt(getSkinName(), "Speaker Mini", 0);
	if (speaker_mini == 0)
	{
	L_SpeakerContainer.switchToLayout("normal");
	R_SpeakerContainer.switchToLayout("normal");
	}
	else
	{
	L_SpeakerContainer.switchToLayout("minimised");
	R_SpeakerContainer.switchToLayout("minimised");
	}

	speaker_closed = getPrivateInt(getSkinName(), "Speaker Closed", 0);
	if (speaker_closed == 1)
	{
	System.getContainer("left-speaker").hide();
	System.getContainer("right-speaker").hide();
	SpkrVU.stop();
	}
}

//	========	stops and deletes the timer when the script unloads	========
System.onscriptunloading() {
	SpkrVU.stop();
}

//	========	Changes the Speakers to the beat	========
SpkrVU.onTimer() {
	TweetVUBand = (getVisBand(0, 50)+getVisBand(0, 56)+getVisBand(0, 62)+getVisBand(0, 68)+getVisBand(0, 75)/5);
	MidRVUband = (getVisBand(0, 25)+getVisBand(0, 31)+getVisBand(0, 37)+getVisBand(0, 43)+getVisBand(0, 49)/5);
	WoofVUband = (getVisBand(0, 0)+getVisBand(0, 6)+getVisBand(0, 12)+getVisBand(0, 18)+getVisBand(0, 24)/5);

	level1T = (TweetVUBand*(L_Tweeter_VU.getLength())/256);
	level1M = (MidRVUband*(L_Midrange_VU.getLength())/256);
	level1W = (WoofVUband*(L_Woofer_VU.getLength())/256);

	if (speaker_mini == 0)
	{
	//	==== Left ====
		L_Tweeter_VU.gotoFrame(level1T);
		L_Midrange_VU.gotoFrame(level1M);
		L_Woofer_VU.gotoFrame(level1W);

	//	==== Right ====
		R_Tweeter_VU.gotoFrame(level1T);
		R_Midrange_VU.gotoFrame(level1M);
		R_Woofer_VU.gotoFrame(level1W);
	}
	else
	{
		L_MinTweeter_VU.gotoFrame(level1T);
		L_MinMidrange_VU.gotoFrame(level1M);
		L_MinWoofer_VU.gotoFrame(level1W);

		R_MinTweeter_VU.gotoFrame(level1T);
		R_MinMidrange_VU.gotoFrame(level1M);
		R_MinWoofer_VU.gotoFrame(level1W);
	}
}


//	========	Right click menu	[Left]	========	
Left_setSPKRModeRBD(){
	speakermenu = new PopUpMenu;
	speakermenu.addCommand("Left Speaker", 100, 0, 1);
	speakermenu.addSeparator();
	speakermenu.addCommand("Show Grille", 101, speaker_grille == 1, 0);
	speakermenu.addCommand("Mini Mode", 102, speaker_mini == 1, 0);
	speakermenu.addSeparator();
	speakermenu.addCommand("Close Speakers", 103, 0, 0);

	ProcessMenuResult (speakermenu.popAtMouse());

	delete speakermenu;
	complete;	
}

//	========	Right click menu	[Right]	========	
Right_setSPKRModeRBD(){
	speakermenu = new PopUpMenu;
	speakermenu.addCommand("Right Speaker", 100, 0, 1);
	speakermenu.addSeparator();
	speakermenu.addCommand("Show Grille", 101, speaker_grille == 1, 0);
	speakermenu.addCommand("Mini Mode", 102, speaker_mini == 1, 0);
	speakermenu.addSeparator();
	speakermenu.addCommand("Close Speakers", 103, 0, 0);

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
			L_MinGrilleLayer.setXmlParam("visible","0");
			R_GrilleLayer.setXmlParam("visible","0");
			R_MinGrilleLayer.setXmlParam("visible","0");
		}
		else
		{
			L_GrilleLayer.setXmlParam("visible","1");
			L_MinGrilleLayer.setXmlParam("visible","1");
			R_GrilleLayer.setXmlParam("visible","1");
			R_MinGrilleLayer.setXmlParam("visible","1");
		}
	}
	else if (a == 102)
	{
		speaker_mini = (speaker_mini - 1) * (-1);
		setPrivateInt(getSkinName(), "Speaker Mini", speaker_mini);

		if (speaker_mini == 0)
		{
			L_SpeakerContainer.switchToLayout("normal");
			R_SpeakerContainer.switchToLayout("normal");
		}
		else
		{
			L_SpeakerContainer.switchToLayout("minimised");
			R_SpeakerContainer.switchToLayout("minimised");
		}
		SpkrVU.start();
	}
	else if (a == 103)
	{
		speaker_closed = (speaker_closed - 1) * (-1);
		setPrivateInt(getSkinName(), "Speaker Closed", speaker_closed);

		if (speaker_closed == 1)
		{
			System.getContainer("left-speaker").hide();
			System.getContainer("right-speaker").hide();
			SpkrVU.stop();
		}
	}
}

//	========	Right-click action on Left Speaker	========
L_SpeakerTrigger.onRightButtonUp (int x, int y)
{
	speaker_closed = 0;
	Left_setSPKRModeRBD();
}
L_MinSpeakerTrigger.onRightButtonUp (int x, int y)
{
	speaker_closed = 0;
	Left_setSPKRModeRBD();
}

R_SpeakerTrigger.onRightButtonUp (int x, int y)
{
	speaker_closed = 0;
	Right_setSPKRModeRBD();
}
R_MinSpeakerTrigger.onRightButtonUp (int x, int y)
{
	speaker_closed = 0;
	Right_setSPKRModeRBD();
}

//	========	Make sure the Right Speaker opens too	========
L_frameGroup.onSetVisible(boolean onoff)
{
	if (onoff == 1)
	{
	SpkrVU.start();
	System.getContainer("right-speaker").show();
	speaker_closed = 0;
	}
	else
	{
	System.getContainer("right-speaker").hide();
	speaker_closed = 1;
	SpkrVU.stop();

	}
}
L_frameGroupMini.onSetVisible(boolean onoff)
{
	if (onoff == 1)
	{
	SpkrVU.start();
	System.getContainer("right-speaker").show();
	speaker_closed = 0;
	}
	else
	{
	System.getContainer("right-speaker").hide();
	speaker_closed = 1;
	SpkrVU.stop();

	}
}