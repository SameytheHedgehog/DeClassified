/*---------------------------------------------------
-----------------------------------------------------
Filename:	wa2visualizer.m
Version:	2.2

Type:		maki
Date:		07. Okt. 2007 - 19:56 , May 24th 2021 - 2:13am UTC+1
Author:		Martin Poehlmann aka Deimos, Eris Lund (0x5066), mirzi
E-Mail:		martin@skinconsortium.com
Internet:	www.skinconsortium.com
			www.martin.deimos.de.vu

Note:		Ripped from Winamp Modern, removed the VU Meter section
			this also includes the option to set the Spectrum 
			Analyzer coloring.
			Now resides in skin.xml to hook into the Main Window and
			Playlist Editor.
-----------------------------------------------------
---------------------------------------------------*/

#include "compiler/lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);
Function LegacyOptions(int legacy);
Function setVisModeLBD();
Function setVisModeRBD();
/*------Playlist Vis Stuff------*/
Function setVis2 (int mode2);
Function ProcessMenuResult2 (int a);
Function setVisModeLBD2();
Function setVisModeRBD2();

Global Group MainWindow, MainClassicVis, Clutterbar;
Global Group MainShadeWindow, PLVis;
Global Group PLWindow;

Global Vis MainVisualizer, MainShadeVisualizer, PLVisualizer;

Global Button CLBV1, CLBV2, CLBV3;

Global PopUpMenu visMenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu anasettings;
Global PopUpMenu oscsettings;
Global PopUpMenu stylemenu;
Global PopUpMenu fpsmenu;
/*------Playlist Menu------*/
Global PopUpMenu visMenu2;

Global Int currentMode, currentMode2, a_falloffspeed, p_falloffspeed, osc_render, ana_render, a_coloring, v_fps;
Global Boolean show_peaks, isShade, compatibility;
Global layer MainTrigger, MainShadeTrigger, PLTrigger;

Global Layout WinampMainWindow;

System.onScriptLoaded()
{
	WinampMainWindow = getContainer("Main").getLayout("Normal");

	MainWindow = getContainer("Main").getLayout("Normal");
	Clutterbar = MainWindow.findObject("mainwindow");
	CLBV1 = Clutterbar.getObject("CLB.V1");
	CLBV2 = Clutterbar.getObject("CLB.V2");
	CLBV3 = Clutterbar.getObject("CLB.V3");
	MainClassicVis = MainWindow.findObject("waclassicvis");
	MainVisualizer = MainClassicVis.getObject("wa.vis");
	MainTrigger = MainClassicVis.getObject("main.vis.trigger");

	MainShadeWindow = getContainer("Main").getLayout("shade");
	MainShadeVisualizer = MainShadeWindow.findObject("wa.vis");
	MainShadeTrigger = MainShadeWindow.findObject("main.vis.trigger");

	PLWindow = getContainer("pl").getLayout("normal");
	PLVis = PLWindow.findObject("waclassicplvis");
	PLVisualizer = PLVis.getObject("wa.vis");
	PLTrigger = PLVis.getObject("main.vis.trigger");

	MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainShadeVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainShadeVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	PLVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	PLVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	PLVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	PLVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	PLVisualizer.setXmlParam("bandwidth", integerToString(ana_render));
	refreshVisSettings();
}

setVisModeLBD(){
	currentMode++;

	if (currentMode == 3)
	{
		currentMode = 0;
	}

	setVis (currentMode);
	complete;
}
/*------Change Playlist Vis on left-click------*/
setVisModeLBD2(){
	currentMode2++;

	if (currentMode2 == 3)
	{
		currentMode2 = 0;
	}

	setVis2 (currentMode2);
	complete;
}

setVisModeRBD(){
	visMenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;
	anasettings = new PopUpMenu;
	oscsettings = new PopUpMenu;
	fpsmenu = new PopUpMenu;

	visMenu.addCommand("Visualization mode:", 999, 0, 1);
	visMenu.addSeparator();
	visMenu.addCommand("Off", 100, currentMode == 0, 0);
	visMenu.addCommand("Spectrum analyzer", 1, currentMode == 1, 0);
	visMenu.addCommand("Oscilliscope", 2, currentMode == 2, 0);
	
	visMenu.addSeparator();
	visMenu.addCommand("Modern Visualizer Settings", 998, 0, 1);
	visMenu.addCommand("Classic Skin Compatibility", 102, compatibility == 1, 0);
	visMenu.addSeparator();
	visMenu.addSubmenu(fpsmenu, "Refresh rate");
	fpsmenu.addCommand("9fps", 800, v_fps == 0, 0);
	fpsmenu.addCommand("18fps", 802, v_fps == 2, 0);
	fpsmenu.addCommand("35fps", 803, v_fps == 3, 0);
	fpsmenu.addCommand("70fps", 804, v_fps == 4, 0);
	visMenu.addSubmenu(anasettings, "Spectrum analyzer options");
	//anasettings.addCommand("Band line width:", 997, 0, 1);
	//anasettings.addSeparator();

	anasettings.addCommand("Normal style", 400, a_coloring == 0, 0);
	anasettings.addCommand("Fire style", 402, a_coloring == 2, 0);
	anasettings.addCommand("Line style", 403, a_coloring == 3, 0);
	anasettings.addSeparator();
	anasettings.addCommand("Peaks", 101, show_peaks == 1, 0);
	anasettings.addSeparator();
	anasettings.addCommand("Thin bands", 701, ana_render == 1, 0);
	if(getDateDay(getDate()) == 1 && getDateMonth(getDate()) == 3){
		anasettings.addCommand("乇乂丅尺卂 丅卄工匚匚", 702, ana_render == 2, 0);
	}else{
		anasettings.addCommand("Thick bands", 702, ana_render == 2, 0);
	}
	anasettings.addSeparator();

	anasettings.addSubMenu(anamenu, "Analyzer falloff");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	anasettings.addSubMenu(pksmenu, "Peaks falloff");
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);

	//anasettings.addSubMenu(stylemenu, "Analyzer Coloring");

	visMenu.addSubmenu(oscsettings, "Oscilliscope Options");
	//oscsettings.addCommand("Oscilloscope drawing style:", 996, 0, 1);
	//oscsettings.addSeparator();
	oscsettings.addCommand("Dot scope", 601, osc_render == 1, 0);
	oscsettings.addCommand("Line scope", 602, osc_render == 2, 0);
	oscsettings.addCommand("Solid scope", 603, osc_render == 3, 0);

	visMenu.addSeparator();
	visMenu.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 404, 0,0);
	visMenu.addcommand(translate("Configure plug-in...")+"\tAlt+K", 405, 0,0);
	visMenu.addcommand(translate("Select plug-in...")+"\tCtrl+K", 406, 0,0);

	ProcessMenuResult (visMenu.popAtMouse());

	delete visMenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;
	delete anasettings;
	delete oscsettings;
	delete fpsmenu;

	complete;	
}
/*------Playlist Vis Menu------*/
setVisModeRBD2(){
	visMenu2 = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;
	anasettings = new PopUpMenu;
	oscsettings = new PopUpMenu;
	fpsmenu = new PopUpMenu;

	visMenu2.addCommand("Playlist Visualization mode:", 999, 0, 1);
	visMenu2.addSeparator();
	visMenu2.addCommand("Off", 100, currentMode2 == 0, 0);
	visMenu2.addCommand("Spectrum analyzer", 1, currentMode2 == 1, 0);
	visMenu2.addCommand("Oscilliscope", 2, currentMode2 == 2, 0);
	
	visMenu2.addSeparator();
	visMenu2.addCommand("Modern Visualizer Settings", 998, 0, 1);
	visMenu2.addCommand("Classic Skin Compatibility", 102, compatibility == 1, 0);
	visMenu2.addSeparator();
	visMenu2.addSubmenu(fpsmenu, "Refresh rate");
	fpsmenu.addCommand("9fps", 800, v_fps == 0, 0);
	fpsmenu.addCommand("18fps", 802, v_fps == 2, 0);
	fpsmenu.addCommand("35fps", 803, v_fps == 3, 0);
	fpsmenu.addCommand("70fps", 804, v_fps == 4, 0);
	visMenu2.addSubmenu(anasettings, "Spectrum analyzer options");
	//anasettings.addCommand("Band line width:", 997, 0, 1);
	//anasettings.addSeparator();

	anasettings.addCommand("Normal style", 400, a_coloring == 0, 0);
	anasettings.addCommand("Fire style", 402, a_coloring == 2, 0);
	anasettings.addCommand("Line style", 403, a_coloring == 3, 0);
	anasettings.addSeparator();
	anasettings.addCommand("Peaks", 101, show_peaks == 1, 0);
	anasettings.addSeparator();
	anasettings.addCommand("Thin bands", 701, ana_render == 1, 0);
	if(getDateDay(getDate()) == 1 && getDateMonth(getDate()) == 3){
		anasettings.addCommand("乇乂丅尺卂 丅卄工匚匚", 702, ana_render == 2, 0);
	}else{
		anasettings.addCommand("Thick bands", 702, ana_render == 2, 0);
	}
	anasettings.addSeparator();

	anasettings.addSubMenu(anamenu, "Analyzer falloff");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	anasettings.addSubMenu(pksmenu, "Peaks falloff");
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);

	//anasettings.addSubMenu(stylemenu, "Analyzer Coloring");

	visMenu2.addSubmenu(oscsettings, "Oscilliscope Options");
	//oscsettings.addCommand("Oscilloscope drawing style:", 996, 0, 1);
	//oscsettings.addSeparator();
	oscsettings.addCommand("Dot scope", 601, osc_render == 1, 0);
	oscsettings.addCommand("Line scope", 602, osc_render == 2, 0);
	oscsettings.addCommand("Solid scope", 603, osc_render == 3, 0);

	visMenu2.addSeparator();
	visMenu2.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 404, 0,0);
	visMenu2.addcommand(translate("Configure plug-in...")+"\tAlt+K", 405, 0,0);
	visMenu2.addcommand(translate("Select plug-in...")+"\tCtrl+K", 406, 0,0);

	ProcessMenuResult2 (visMenu2.popAtMouse());

	delete visMenu2;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;
	delete anasettings;
	delete oscsettings;
	delete fpsmenu;

	complete;	
}

refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
/*------Playlist Vis Mode------*/
	currentMode2 = getPrivateInt(getSkinName(), "PLVisualizer Mode", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	compatibility = getPrivateInt(getSkinName(), "DeClassified Classic Visualizer behavior", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer Peaks falloff", 2);
	osc_render = getPrivateInt(getSkinName(), "Oscilloscope Settings", 2);
	ana_render = getPrivateInt(getSkinName(), "Spectrum Analyzer Settings", 2);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring", 0);
	v_fps = getPrivateInt(getSkinName(), "Visualizer Refresh rate", 3);

	MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	MainShadeVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	MainShadeVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	PLVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
	PLVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	PLVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	PLVisualizer.setXmlParam("oscstyle", integerToString(osc_render));
	PLVisualizer.setXmlParam("bandwidth", integerToString(ana_render));

	if (a_coloring == 0)
	{
		MainVisualizer.setXmlParam("coloring", "Normal");
		MainShadeVisualizer.setXmlParam("coloring", "Normal");
		PLVisualizer.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 1)
	{
		MainVisualizer.setXmlParam("coloring", "Normal");
		MainShadeVisualizer.setXmlParam("coloring", "Normal");
		PLVisualizer.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 2)
	{
		MainVisualizer.setXmlParam("coloring", "Fire");
		MainShadeVisualizer.setXmlParam("coloring", "Fire");
		PLVisualizer.setXmlParam("coloring", "Fire");
	}
	else if (a_coloring == 3)
	{
		MainVisualizer.setXmlParam("coloring", "Line");
		MainShadeVisualizer.setXmlParam("coloring", "Line");
		PLVisualizer.setXmlParam("coloring", "Line");
	}

	if (osc_render == 0)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			PLVisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 1)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			PLVisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 2)
		{
			MainVisualizer.setXmlParam("oscstyle", "Solid");
			MainShadeVisualizer.setXmlParam("oscstyle", "Solid");
			PLVisualizer.setXmlParam("oscstyle", "Solid");
		}
		else if (osc_render == 3)
		{
			MainVisualizer.setXmlParam("oscstyle", "Lines");
			MainShadeVisualizer.setXmlParam("oscstyle", "Lines");
			PLVisualizer.setXmlParam("oscstyle", "Lines");
		}
	setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
    
	if (ana_render == 0)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			PLVisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 1)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			PLVisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 2)
		{
			MainVisualizer.setXmlParam("bandwidth", "wide");
			MainShadeVisualizer.setXmlParam("bandwidth", "wide");
			PLVisualizer.setXmlParam("bandwidth", "wide");
		}
	setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);
	if (v_fps == 0)
		{
			MainVisualizer.setXmlParam("fps", "9");
			MainShadeVisualizer.setXmlParam("fps", "9");
			PLVisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 1)
		{
			MainVisualizer.setXmlParam("fps", "9");
			MainShadeVisualizer.setXmlParam("fps", "9");
			PLVisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 2)
		{
			MainVisualizer.setXmlParam("fps", "18");
			MainShadeVisualizer.setXmlParam("fps", "18");
			PLVisualizer.setXmlParam("fps", "18");
		}
		else if (v_fps == 3)
		{
			MainVisualizer.setXmlParam("fps", "35");
			MainShadeVisualizer.setXmlParam("fps", "35");
			PLVisualizer.setXmlParam("fps", "35");
		}
		else if (v_fps == 4)
		{
			MainVisualizer.setXmlParam("fps", "70");
			MainShadeVisualizer.setXmlParam("fps", "70");
			PLVisualizer.setXmlParam("fps", "70");
		}

	setVis (currentMode);
	setVis2 (currentMode2);
	LegacyOptions(compatibility);
}

System.onStop(){
	LegacyOptions(compatibility);
}

System.onPlay(){
	LegacyOptions(compatibility);
}

System.onResume(){
	LegacyOptions(compatibility);
}

MainTrigger.onLeftButtonDown (int x, int y)
{
	setVisModeLBD();
}

MainShadeTrigger.onLeftButtonDown (int x, int y)
{
	setVisModeLBD();
}

PLTrigger.onLeftButtonDown (int x, int y)
{
	setVisModeLBD2();
}

MainTrigger.onRightButtonUp (int x, int y)
{
	setVisModeRBD();
}

MainShadeTrigger.onRightButtonUp (int x, int y)
{
	setVisModeRBD();
}

PLTrigger.onRightButtonUp (int x, int y)
{
	setVisModeRBD2();
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		PLVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a == 102)
	{
		compatibility = (compatibility - 1) * (-1);
		LegacyOptions(compatibility);
		setPrivateInt(getSkinName(), "DeClassified Classic Visualizer behavior", compatibility);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		PLVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer Peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		PLVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			MainVisualizer.setXmlParam("coloring", "Normal");
			MainShadeVisualizer.setXmlParam("coloring", "Normal");
			PLVisualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 1)
		{
			MainVisualizer.setXmlParam("coloring", "Normal");
			MainShadeVisualizer.setXmlParam("coloring", "Normal");
			PLVisualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 2)
		{
			MainVisualizer.setXmlParam("coloring", "Fire");
			MainShadeVisualizer.setXmlParam("coloring", "Fire");
			PLVisualizer.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			MainVisualizer.setXmlParam("coloring", "Line");
			MainShadeVisualizer.setXmlParam("coloring", "Line");
			PLVisualizer.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring", a_coloring);
	}

	else if (a == 404)
	{
		CLBV1.Leftclick();
	}
	else if (a == 405)
	{
		CLBV2.Leftclick();
	}
	else if (a == 406)
	{
		CLBV3.Leftclick();
	}

	else if (a >= 600 && a <= 603)
	{
		osc_render = a - 600;
		if (osc_render == 0)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			PLVisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 1)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			PLVisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 2)
		{
			MainVisualizer.setXmlParam("oscstyle", "Solid");
			MainShadeVisualizer.setXmlParam("oscstyle", "Solid");
			PLVisualizer.setXmlParam("oscstyle", "Solid");
		}
		else if (osc_render == 3)
		{
			MainVisualizer.setXmlParam("oscstyle", "Lines");
			MainShadeVisualizer.setXmlParam("oscstyle", "Lines");
			PLVisualizer.setXmlParam("oscstyle", "Lines");
		}
	setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
	}

    else if (a >= 700 && a <= 702)
	{
		ana_render = a - 700;
		if (ana_render == 0)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			PLVisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 1)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			PLVisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 2)
		{
			MainVisualizer.setXmlParam("bandwidth", "wide");
			MainShadeVisualizer.setXmlParam("bandwidth", "wide");
			PLVisualizer.setXmlParam("bandwidth", "wide");
		}
	setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);
	}

	else if (a >= 800 && a <= 804)
	{
		v_fps = a - 800;
		if (v_fps == 0)
		{
			MainVisualizer.setXmlParam("fps", "9");
			MainShadeVisualizer.setXmlParam("fps", "9");
			PLVisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 1)
		{
			MainVisualizer.setXmlParam("fps", "9");
			MainShadeVisualizer.setXmlParam("fps", "9");
			PLVisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 2)
		{
			MainVisualizer.setXmlParam("fps", "18");
			MainShadeVisualizer.setXmlParam("fps", "18");
			PLVisualizer.setXmlParam("fps", "18");
		}
		else if (v_fps == 3)
		{
			MainVisualizer.setXmlParam("fps", "35");
			MainShadeVisualizer.setXmlParam("fps", "35");
			PLVisualizer.setXmlParam("fps", "35");
		}
		else if (v_fps == 4)
		{
			MainVisualizer.setXmlParam("fps", "70");
			MainShadeVisualizer.setXmlParam("fps", "70");
			PLVisualizer.setXmlParam("fps", "70");
		}
		setPrivateInt(getSkinName(), "Visualizer Refresh rate", v_fps);
	}
}
/*------Same as above but changes the Playlist vis instead------*/
ProcessMenuResult2 (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis2(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		PLVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a == 102)
	{
		compatibility = (compatibility - 1) * (-1);
		LegacyOptions(compatibility);
		setPrivateInt(getSkinName(), "DeClassified Classic Visualizer behavior", compatibility);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		MainVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		MainShadeVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		PLVisualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer Peaks falloff", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		MainVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		MainShadeVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		PLVisualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff", a_falloffspeed);
	}

else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			MainVisualizer.setXmlParam("coloring", "Normal");
			MainShadeVisualizer.setXmlParam("coloring", "Normal");
			PLVisualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 1)
		{
			MainVisualizer.setXmlParam("coloring", "Normal");
			MainShadeVisualizer.setXmlParam("coloring", "Normal");
			PLVisualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 2)
		{
			MainVisualizer.setXmlParam("coloring", "Fire");
			MainShadeVisualizer.setXmlParam("coloring", "Fire");
			PLVisualizer.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			MainVisualizer.setXmlParam("coloring", "Line");
			MainShadeVisualizer.setXmlParam("coloring", "Line");
			PLVisualizer.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring", a_coloring);
	}

	else if (a == 404)
	{
		CLBV1.Leftclick();
	}
	else if (a == 405)
	{
		CLBV2.Leftclick();
	}
	else if (a == 406)
	{
		CLBV3.Leftclick();
	}

	else if (a >= 600 && a <= 603)
	{
		osc_render = a - 600;
		if (osc_render == 0)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			PLVisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 1)
		{
			MainVisualizer.setXmlParam("oscstyle", "Dots");
			MainShadeVisualizer.setXmlParam("oscstyle", "Dots");
			PLVisualizer.setXmlParam("oscstyle", "Dots");
		}
		else if (osc_render == 2)
		{
			MainVisualizer.setXmlParam("oscstyle", "Solid");
			MainShadeVisualizer.setXmlParam("oscstyle", "Solid");
			PLVisualizer.setXmlParam("oscstyle", "Solid");
		}
		else if (osc_render == 3)
		{
			MainVisualizer.setXmlParam("oscstyle", "Lines");
			MainShadeVisualizer.setXmlParam("oscstyle", "Lines");
			PLVisualizer.setXmlParam("oscstyle", "Lines");
		}
	setPrivateInt(getSkinName(), "Oscilloscope Settings", osc_render);
	}

    else if (a >= 700 && a <= 702)
	{
		ana_render = a - 700;
		if (ana_render == 0)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			PLVisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 1)
		{
			MainVisualizer.setXmlParam("bandwidth", "Thin");
			MainShadeVisualizer.setXmlParam("bandwidth", "Thin");
			PLVisualizer.setXmlParam("bandwidth", "Thin");
		}
		else if (ana_render == 2)
		{
			MainVisualizer.setXmlParam("bandwidth", "wide");
			MainShadeVisualizer.setXmlParam("bandwidth", "wide");
			PLVisualizer.setXmlParam("bandwidth", "wide");
		}
	setPrivateInt(getSkinName(), "Spectrum Analyzer Settings", ana_render);
	}

	else if (a >= 800 && a <= 804)
	{
		v_fps = a - 800;
		if (v_fps == 0)
		{
			MainVisualizer.setXmlParam("fps", "9");
			MainShadeVisualizer.setXmlParam("fps", "9");
			PLVisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 1)
		{
			MainVisualizer.setXmlParam("fps", "9");
			MainShadeVisualizer.setXmlParam("fps", "9");
			PLVisualizer.setXmlParam("fps", "9");
		}
		else if (v_fps == 2)
		{
			MainVisualizer.setXmlParam("fps", "18");
			MainShadeVisualizer.setXmlParam("fps", "18");
			PLVisualizer.setXmlParam("fps", "18");
		}
		else if (v_fps == 3)
		{
			MainVisualizer.setXmlParam("fps", "35");
			MainShadeVisualizer.setXmlParam("fps", "35");
			PLVisualizer.setXmlParam("fps", "35");
		}
		else if (v_fps == 4)
		{
			MainVisualizer.setXmlParam("fps", "70");
			MainShadeVisualizer.setXmlParam("fps", "70");
			PLVisualizer.setXmlParam("fps", "70");
		}
		setPrivateInt(getSkinName(), "Visualizer Refresh rate", v_fps);
	}
}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		MainVisualizer.setMode(0);
		MainShadeVisualizer.setMode(0);
	}
	else if (mode == 1)
	{
		MainVisualizer.setMode(1);
		MainShadeVisualizer.setMode(1);
	}
	else if (mode == 2)
	{
		MainVisualizer.setMode(2);
		MainShadeVisualizer.setMode(2);
	}
	currentMode = mode;
}
/*------Sets the Playlist Vis------*/
setVis2 (int mode2)
{
	setPrivateInt(getSkinName(), "PLVisualizer Mode", mode2);
	if (mode2 == 0)
	{
		PLVisualizer.setMode(0);
	}
	else if (mode2 == 1)
	{
		PLVisualizer.setMode(1);
	}
	else if (mode2 == 2)
	{
		PLVisualizer.setMode(2);
	}
	currentMode2 = mode2;
}

LegacyOptions(int legacy){
	//messageBox(integertoString(legacy), "", 1, "");
	if(legacy == 1){
		WinampMainWindow.onSetVisible(WinampMainWindow.isVisible());
		if(getStatus() == -1){
			MainVisualizer.setXmlParam("visible", "1");
			MainShadeVisualizer.setXmlParam("visible", "1");
			PLVisualizer.setXmlParam("visible", "1");
		}else if(getStatus() == 0){
			MainVisualizer.setXmlParam("visible", "0");
			MainShadeVisualizer.setXmlParam("visible", "0");
			PLVisualizer.setXmlParam("visible", "0");
		}else if(getStatus() == 1){
			MainVisualizer.setXmlParam("visible", "1");
			MainShadeVisualizer.setXmlParam("visible", "1");
			PLVisualizer.setXmlParam("visible", "1");
		}
		if(WinampMainWindow.getScale() != 2){
		MainVisualizer.setXmlParam("y", "2");
		PLVisualizer.setXmlParam("y", "2");
		}else{
		MainVisualizer.setXmlParam("y", "0");
		PLVisualizer.setXmlParam("y", "0");
		}
	}else{
		MainVisualizer.setXmlParam("visible", "1");
		MainShadeVisualizer.setXmlParam("visible", "1");
		PLVisualizer.setXmlParam("visible", "1");
		MainVisualizer.setXmlParam("y", "0");
		PLVisualizer.setXmlParam("y", "0");
		WinampMainWindow.onSetVisible(0);
	}
}

WinampMainWindow.onScale(Double newscalevalue){
	LegacyOptions(compatibility);
	if(legacy == 1){
		if(newscalevalue != 2){
			MainVisualizer.setXmlParam("y", "2");
			PLVisualizer.setXmlParam("y", "2");
		}else{
			MainVisualizer.setXmlParam("y", "0");
			PLVisualizer.setXmlParam("y", "0");
		}
	}else{
		MainVisualizer.setXmlParam("y", "0");
		PLVisualizer.setXmlParam("y", "0");
	}
}