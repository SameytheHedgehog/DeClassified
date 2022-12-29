/*---------------------------------------------------
-----------------------------------------------------
Filename:	wa2visualizer.m
Version:	2.1

Type:		maki
Date:		07. Okt. 2007 - 19:56 , May 24th 2021 - 2:13am UTC+1
Author:		Martin Poehlmann aka Deimos, Eris Lund (0x5066), mirzi
E-Mail:		martin@skinconsortium.com
Internet:	www.skinconsortium.com
			www.martin.deimos.de.vu

Note:		Ripped from Winamp Modern, this also includes the option 
			to set the Spectrum Analyzer coloring, and more.
			Now resides in skin.xml to hook into the Main Window and
			Playlist Editor.
-----------------------------------------------------
---------------------------------------------------*/

#include "compiler/lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function setVis2 (int mode2);
Function ProcessMenuResult (int a);
Function setVisModeLBD();
Function setVisModeRBD();
Function setFont(int font);
Function ShowHideVis();

Global GuiObject PlayIndicator, Songticker, Infoticker;

Global Group MainWindow, MainClassicVis, Clutterbar;
Global Group PLWindow, MainShadeWindow, PLVis, MainVUVIS, PLVUVis;

Global Vis MainVisualizer, MainShadeVisualizer, PLVisualizer;
Global AnimatedLayer MainShadeVULeft, MainShadeVURight, MainVULeft, MainVURight, MainVUPeakLeft, MainVUPeakRight;
Global AnimatedLayer PlaylistVULeft, PlaylistVURight, PlaylistVUPeakLeft, PlaylistVUPeakRight;
Global timer VU;
Global float level1, level2, peak1, peak2, pgrav1, pgrav2, level1_new, level2_new, vu_falloffspeed_bar, vu_falloffspeed_peak, vp_falloffspeed, falloffrate, falloffrate_peak;

Global Button CLBV1, CLBV2, CLBV3;

Global PopUpMenu visMenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu anasettings;
Global PopUpMenu oscsettings;
Global PopUpMenu stylemenu;
Global PopUpMenu fpsmenu;
Global PopUpMenu vumenu;
Global PopUpMenu vumenu2;
Global PopUpMenu vusettings;
Global PopUpMenu firemenu;

Global Int currentMode, currentMode2, a_falloffspeed, p_falloffspeed, osc_render, ana_render, a_coloring, v_fps, smoothvu, PlaylistRBD, vu_coloring;
Global Boolean show_peaks, show_vupeaks, vu_gravity, isShade, playLED, WA265SPEED, SKINNEDFONT;
Global layer MainTrigger, MainShadeTrigger, PLTrigger;

#include "classicplaystatus.m"

Global Layout WinampMainWindow;

System.onScriptLoaded()
{
	initDetector();
	WinampMainWindow = getContainer("Main").getLayout("Normal");

	MainWindow = getContainer("Main").getLayout("Normal");
	PlayIndicator = MainWindow.findObject("playbackstatus");
	Songticker = MainWindow.findObject("Songticker");
	Infoticker = MainWindow.findObject("Infoticker");
	Clutterbar = MainWindow.findObject("mainwindow");
	CLBV1 = Clutterbar.getObject("CLB.V1");
	CLBV2 = Clutterbar.getObject("CLB.V2");
	CLBV3 = Clutterbar.getObject("CLB.V3");
	MainClassicVis = MainWindow.findObject("waclassicvis");
	MainVisualizer = MainClassicVis.getObject("wa.vis");
	MainTrigger = MainClassicVis.getObject("main.vis.trigger");

	MainShadeWindow = getContainer("Main").getLayout("shade");
	MainShadeVisualizer = MainShadeWindow.findObject("wa.vis");
	MainShadeVULeft = MainShadeWindow.findObject("wa.shade.vu.left");
	MainShadeVURight = MainShadeWindow.findObject("wa.shade.vu.right");
	MainShadeTrigger = MainShadeWindow.findObject("main.vis.trigger");
		MainVUVIS = MainClassicVis.findObject("WACUPVU");
		MainVULeft = MainVUVIS.findObject("wacup.vu.l");
		MainVURight = MainVUVIS.findObject("wacup.vu.r");
		MainVUPeakLeft = MainVUVIS.findObject("wacup.vu.l.peak");
		MainVUPeakRight = MainVUVIS.findObject("wacup.vu.r.peak");

	PLWindow = getContainer("PL").getLayout("normal");
	PLVis = PLWindow.findObject("waclassicplvis");
	PLVisualizer = PLVis.getObject("wa.vis");
	PLTrigger = PLVis.getObject("main.vis.trigger");
		PLVUVis = PLVis.findObject("WACUPVU");
		PlaylistVULeft = PLVUVis.findObject("wacup.vu.l");
		PlaylistVURight = PLVUVis.findObject("wacup.vu.r");
		PlaylistVUPeakLeft = PLVUVis.findObject("wacup.vu.l.peak");
		PlaylistVUPeakRight = PLVUVis.findObject("wacup.vu.r.peak");

	pgrav1 = 0;
	pgrav2 = 0;

	VU = new Timer;
	VU.setdelay(0);
    VU.start();
    VU.onTimer();

	vu_falloffspeed_bar = (2/100)+0.02; //magic number
	falloffrate = 128; //winamp 2.65 vu falloff
	falloffrate_peak = 256; //wacup vu peak falloff

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

System.onScriptUnloading(){
	DeleteStuff();
}

setFont(int font){
	if(font){
		Songticker.setXmlParam("font", "wasabi.font.default");
		Songticker.setXmlParam("y", "27");
		Songticker.setXmlParam("h", "9");

		Infoticker.setXmlParam("font", "wasabi.font.default");
		Infoticker.setXmlParam("y", "27");
		Infoticker.setXmlParam("offsety", "-1");
		Infoticker.setXmlParam("h", "9");
	}else{
		Songticker.setXmlParam("font", "arial");
		Songticker.setXmlParam("y", "22");
		Songticker.setXmlParam("h", "14");

		Infoticker.setXmlParam("font", "arial");
		Infoticker.setXmlParam("y", "24");
		Infoticker.setXmlParam("offsety", "-2");
		Infoticker.setXmlParam("h", "14");
	}
}

VU.onTimer(){
    level1 = getLeftVuMeter();
    level2 = getRightVuMeter();

//doesnt work anyway
//the idea was to remove the decimal points
//the peaks still clip inside
	int newlevel1;
	int newlevel2;
	if(WA265SPEED){
		newlevel1 = Level1_new;
		newlevel2 = Level2_new;
	}else{
		newlevel1 = Level1;
		newlevel2 = Level2;
	}

//Winamp 2.65 type beat (is WA265SPEED)
	if (level1 >= level1_new){
		level1_new = level1;
	}
	else{
		level1_new -= vu_falloffspeed_bar*falloffrate;
	}

	if (level2 >= level2_new){
		level2_new = level2;
	}
	else{
		level2_new -= vu_falloffspeed_bar*falloffrate;
	}

//because i provide modes of compatibility and also because i like
//how wa 2.65's vu meter works... in falloff, i'm providing an extra
//option just for that

//the if(IsWACUP) checks only exist because i only want it to be there for wacup
//idk if this kills winamp...
//update a few seconds later: only guru errors
	if(WA265SPEED){
		MainShadeVULeft.gotoFrame(level1_new*MainShadeVULeft.getLength()/256);
		MainShadeVURight.gotoFrame(level2_new*MainShadeVURight.getLength()/256);
		MainVULeft.gotoFrame(level1_new*MainVULeft.getLength()/256);
		MainVURight.gotoFrame(level2_new*MainVURight.getLength()/256);
		PlaylistVULeft.gotoFrame(level1_new*PlaylistVULeft.getLength()/256);
		PlaylistVURight.gotoFrame(level2_new*PlaylistVURight.getLength()/256);
	}else{
		MainShadeVULeft.gotoFrame(level1*MainShadeVULeft.getLength()/256);
		MainShadeVURight.gotoFrame(level2*MainShadeVURight.getLength()/256);
		MainVULeft.gotoFrame(Level1*MainVULeft.getLength()/256);
		MainVURight.gotoFrame(level2*MainVURight.getLength()/256);
		PlaylistVULeft.gotoFrame(level1*PlaylistVULeft.getLength()/256);
		PlaylistVURight.gotoFrame(level2*PlaylistVURight.getLength()/256);
	}

//somehow, with gravity disabled and peak falloff to fast,
//the peaks will clip inside the bars themselves, 
//in Winamp Modern i havent seen it happen but here it happens
//what's going on?

//10/08/22
//seems unfixable, peaks just want to clip
//inside the bars for some fucking reason
	if(vu_gravity == 0){
		if (newlevel1 >= peak1){
			peak1 = newlevel1;
			//pgrav1 = 0;
		}
		else{
			//peak1 += pgrav1;
			peak1 -= vu_falloffspeed_peak*falloffrate_peak;
		}
		if (newlevel2 >= peak2){
			peak2 = newlevel2;
			//pgrav2 = 0;
		}
		else{
			//peak2 += pgrav2;
			peak2 -= vu_falloffspeed_peak*falloffrate_peak;
		}
	}else{
		if (newlevel1 >= peak1){
			peak1 = newlevel1;
			pgrav1 = 0;
		}
		else{
			peak1 += pgrav1;
			pgrav1 -= vu_falloffspeed_peak*1.5;
		}
		if (newlevel2 >= peak2){
			peak2 = newlevel2;
			pgrav2 = 0;
		}
		else{
			peak2 += pgrav2;
			pgrav2 -= vu_falloffspeed_peak*1.5;
		}
	}

		MainVUPeakLeft.gotoFrame(peak1*MainVULeft.getLength()/256);
		MainVUPeakRight.gotoFrame(peak2*MainVURight.getLength()/256);
		PlaylistVUPeakLeft.gotoFrame(peak1*PlaylistVULeft.getLength()/256);
		PlaylistVUPeakRight.gotoFrame(peak2*PlaylistVURight.getLength()/256);

}

System.onStop(){
	VU.start();
	if(IsWACUP == 0){
		peak1 = 0;
		peak2 = 0;
	}
	StopStuff();
	ShowHideVis();
}

System.onPause(){
	VU.stop();
	PauseStuff();
	ShowHideVis();
}

System.onResume(){
	VU.start();
	ResumeStuff();
	ShowHideVis();
}

System.onPlay(){
	VU.start();
	PlayStuff();
	ShowHideVis();
}

System.onTitleChange(String newtitle){
	ChangeTitle();
}

setVisModeLBD(){
	if (PlaylistRBD == 0)
	{
		currentMode++;

		if(currentMode == 4)
		{
			currentMode = 0;
		}

		setVis (currentMode);
		complete;
	}else
	{
		currentMode2++;

		if (currentMode2 == 4)
		{
			currentMode2 = 0;
		}

		setVis2 (currentMode2);
		complete;
	}
}

setVisModeRBD(){
	visMenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;
	anasettings = new PopUpMenu;
	oscsettings = new PopUpMenu;
	fpsmenu = new PopUpMenu;
	vumenu = new PopUpMenu;
		vumenu2 = new PopUpMenu;
		vusettings = new PopUpMenu;
	firemenu = new PopUpmenu;

	visMenu.addCommand("Visualisation mode:", 999, 0, 1);
	visMenu.addSeparator();

	if(PlaylistRBD == 0)
	{
		visMenu.addCommand("Off", 100, currentMode == 0, 0);
		visMenu.addCommand("Spectrum analyzer", 1, currentMode == 1, 0);
		visMenu.addCommand("Oscilliscope", 2, currentMode == 2, 0);
		visMenu.addCommand("VU meter", 3, currentMode == 3, 0);
	}else
	{
		visMenu.addCommand("Off", 102, currentMode2 == 0, 0);
		visMenu.addCommand("Spectrum analyzer", 4, currentMode2 == 1, 0);
		visMenu.addCommand("Oscilliscope", 5, currentMode2 == 2, 0);
		visMenu.addCommand("VU meter", 6, currentMode2 == 3, 0);
	}

	visMenu.addSeparator();
	visMenu.addCommand("DeClassified Settings", 998, 0, 1);
	visMenu.addSeparator();
	visMenu.addCommand("Use bitmap font for main title display (no int. support)", 106, SKINNEDFONT == 1, 0);
	visMenu.addCommand("Playback Indicator", 103, playLED == 1, 0);

	visMenu.addSeparator();

	visMenu.addSubmenu(fpsmenu, "Refresh rate");
	fpsmenu.addCommand("9fps", 800, v_fps == 0, 0);
	fpsmenu.addCommand("18fps", 802, v_fps == 2, 0);
	fpsmenu.addCommand("35fps", 803, v_fps == 3, 0);
	fpsmenu.addCommand("70fps", 804, v_fps == 4, 0);

	visMenu.addSubmenu(anasettings, "Spectrum analyzer options");

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

	visMenu.addSubmenu(oscsettings, "Oscilliscope Options");
	oscsettings.addCommand("Dot scope", 601, osc_render == 1, 0);
	oscsettings.addCommand("Line scope", 602, osc_render == 2, 0);
	oscsettings.addCommand("Solid scope", 603, osc_render == 3, 0);

	visMenu.addSubmenu(vumenu, "Winshade VU options");
	vumenu.addCommand("Normal VU", 901, smoothvu == 1, 0);
	vumenu.addCommand("Smooth VU", 902, smoothvu == 2, 0);

		visMenu.addSubmenu(vusettings, "VU Meter Options");
		vusettings.addCommand("Show VU Peaks", 107, show_vupeaks == 1, 0);
		vusettings.addCommand("Smooth VU Peak falloff", 109, vu_gravity == 1, 0);
		vusettings.addCommand("Winamp 2.65 Speed", 108, WA265SPEED == 1, 0);
		vusettings.addSeparator();
	vusettings.addCommand("VU Bar Color Styles", 996, 0, 1);
		vusettings.addSeparator();
			vusettings.addCommand("Normal style", 410, vu_coloring == 0, 0);
			vusettings.addCommand("Fire style", 412, vu_coloring == 2, 0);
			vusettings.addCommand("Line style", 413, vu_coloring == 3, 0);
		vusettings.addSeparator();
		vusettings.addSubmenu(vumenu2, "Peak falloff Speed");
		vumenu2.addCommand("Slower", 500, vp_falloffspeed == 0, 0);
		vumenu2.addCommand("Slow", 501, vp_falloffspeed == 1, 0);
		vumenu2.addCommand("Moderate", 502, vp_falloffspeed == 2, 0);
		vumenu2.addCommand("Fast", 503, vp_falloffspeed == 3, 0);
		vumenu2.addCommand("Faster", 504, vp_falloffspeed == 4, 0);

	visMenu.addSeparator();
	visMenu.addCommand("Visualiser Plugin Options", 997, 0, 1);
	visMenu.addSeparator();
	visMenu.addcommand(translate("Start/Stop plug-in")+"\tCtrl+Shift+K", 404, 0,0);
	visMenu.addcommand(translate("Configure plug-in...")+"\tAlt+K", 405, 0,0);
	visMenu.addcommand(translate("Select plug-in...")+"\tCtrl+K", 406, 0,0);

	ProcessMenuResult (visMenu.popAtMouse());

	PlayIndicator.setXmlParam("visible", integerToString(playLED));

	delete visMenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;
	delete anasettings;
	delete oscsettings;
	delete fpsmenu;
	delete vumenu;
	delete firemenu;

	complete;
}

refreshVisSettings()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode", 1);
	currentMode2 = getPrivateInt(getSkinName(), "PLVisualizer Mode", 1);
	show_vupeaks = getPrivateInt(getSkinName(), "DeClassified show VU Peaks", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks", 1);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff", 3);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer Peaks falloff", 1);
	osc_render = getPrivateInt(getSkinName(), "Oscilloscope Settings", 2);
	ana_render = getPrivateInt(getSkinName(), "Spectrum Analyzer Settings", 2);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring", 0);
	vu_coloring = getPrivateInt(getSkinName(), "Visualizer Bar coloring", 0);
	v_fps = getPrivateInt(getSkinName(), "Visualizer Refresh rate", 3);
	playLED = getPrivateInt(getSkinName(), "DeClassified Play LED", 1);
	WA265SPEED = getPrivateInt(getSkinName(), "DeClassified Winamp 2.65 VU Speed", 0);
	smoothvu = getPrivateInt(getSkinName(), "DeClassified Winamp 2.65 VU Options", 1);
	SKINNEDFONT = getPrivateInt(getSkinName(), "DeClassified Skinned Font", 1);
	vp_falloffspeed = getPrivateInt(getSkinName(), "DeClassified VU peaks falloff", 2);
	vu_gravity = getPrivateInt(getSkinName(), "DeClassified VU Peak Gravity", 1);

		vu_falloffspeed_peak = (vp_falloffspeed/100)+0.02; //magic number

	PlayIndicator.setXmlParam("visible", integerToString(playLED));

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

		MainVUPeakLeft.setXmlParam("visible", integerToString(show_vupeaks));
		MainVUPeakRight.setXmlParam("visible", integerToString(show_vupeaks));
		PlaylistVUPeakLeft.setXmlParam("visible", integerToString(show_vupeaks));
		PlaylistVUPeakRight.setXmlParam("visible", integerToString(show_vupeaks));

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

	if (vu_coloring == 0)
	{															// NORMAL
		MainVULeft.setXmlParam("image", "wacup.vu");
		MainVURight.setXmlParam("image", "wacup.vu");
		PlaylistVULeft.setXmlParam("image", "wacup.vu.pl");
		PlaylistVURight.setXmlParam("image", "wacup.vu.pl");
	}
	else if (vu_coloring == 1)
	{															// NORMAL
		MainVULeft.setXmlParam("image", "wacup.vu");
		MainVURight.setXmlParam("image", "wacup.vu");
		PlaylistVULeft.setXmlParam("image", "wacup.vu.pl");
		PlaylistVURight.setXmlParam("image", "wacup.vu.pl");
	}
	else if (vu_coloring == 2)
	{															// FIRE
		MainVULeft.setXmlParam("image", "wacup.vu_fire");
		MainVURight.setXmlParam("image", "wacup.vu_fire");
		PlaylistVULeft.setXmlParam("image", "wacup.vu.pl_fire");
		PlaylistVURight.setXmlParam("image", "wacup.vu.pl_fire");
	}
	else if (vu_coloring == 3)
	{															// LINE
		MainVULeft.setXmlParam("image", "wacup.vu_line");
		MainVURight.setXmlParam("image", "wacup.vu_line");
		PlaylistVULeft.setXmlParam("image", "wacup.vu.pl_line");
		PlaylistVURight.setXmlParam("image", "wacup.vu.pl_line");
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
	setPrivateInt(getSkinName(), "Visualizer Refresh rate", v_fps);

	if (smoothvu == 0)
	{
		if (vu_coloring == 0) //normal
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
		else if (vu_coloring == 1) //normal
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
		else if (vu_coloring == 2) //fire
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
		else if (vu_coloring == 3) //line
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_line");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_line");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
	}
	else if (smoothvu == 1)
	{
		if (vu_coloring == 0) //normal
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
		else if (vu_coloring == 1) //normal
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
		else if (vu_coloring == 2) //fire
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
		else if (vu_coloring == 3) //line
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_line");
			MainShadeVULeft.setXmlParam("frameheight", "2");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_line");
			MainShadeVURight.setXmlParam("frameheight", "2");
		}
	}
	else if (smoothvu == 2)
	{
		if (vu_coloring == 0) //normal
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu");
			MainShadeVULeft.setXmlParam("frameheight", "1");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu");
			MainShadeVURight.setXmlParam("frameheight", "1");
		}
		else if (vu_coloring == 1) //normal
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu");
			MainShadeVULeft.setXmlParam("frameheight", "1");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu");
			MainShadeVURight.setXmlParam("frameheight", "1");
		}
		else if (vu_coloring == 2) //fire
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu_fire");
			MainShadeVULeft.setXmlParam("frameheight", "1");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu_fire");
			MainShadeVURight.setXmlParam("frameheight", "1");
		}
		else if (vu_coloring == 3) //line
		{
			MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu_line");
			MainShadeVULeft.setXmlParam("frameheight", "1");
			MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu_line");
			MainShadeVURight.setXmlParam("frameheight", "1");
		}
	}
	setPrivateInt(getSkinName(), "DeClassified Winamp 2.65 VU Options", smoothvu);

	setVis (currentMode);
	setVis2 (currentMode2);
	setFont(SKINNEDFONT);
	initPlayLED();
	ShowHideVis();
}

MainTrigger.onLeftButtonDown (int x, int y)
{
	PlaylistRBD = 0;
	setVisModeLBD();
}

MainShadeTrigger.onLeftButtonDown (int x, int y)
{
	PlaylistRBD = 0;
	setVisModeLBD();
}

PLTrigger.onLeftButtonDown (int x, int y)
{
	PlaylistRBD = 1;
	setVisModeLBD();
}

MainTrigger.onRightButtonUp (int x, int y)
{
	PlaylistRBD = 0;
	setVisModeRBD();
}

MainShadeTrigger.onRightButtonUp (int x, int y)
{
	PlaylistRBD = 0;
	setVisModeRBD();
}

PLTrigger.onRightButtonUp (int x, int y)
{
	PlaylistRBD = 1;
	setVisModeRBD();
}

ProcessMenuResult (int a)
{
	
	PlaylistRBD = 0;
	if (a < 1) return;

	if (a > 0 && a < 4 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	if (a > 3 && a < 7 || a == 102)
	{
		if (a == 102) a = 3;
		setVis2(a - 3);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		MainVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		MainShadeVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		PLVisualizer.setXmlParam("Peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks", show_peaks);
	}

	else if (a == 103)
		{
			playLED = (playLED - 1) * (-1);
			PlayIndicator.setXmlParam("visible", integerToString(playLED));
			setPrivateInt(getSkinName(), "DeClassified Play LED", playLED);
		}

	else if (a == 104)
		{
		}

	else if (a == 106)
		{
			SKINNEDFONT = (SKINNEDFONT - 1) * (-1);
			setFont(SKINNEDFONT);
			setPrivateInt(getSkinName(), "DeClassified Skinned Font", SKINNEDFONT);
		}

	else if (a == 107)
	{
		show_vupeaks = (show_vupeaks - 1) * (-1);
		MainVUPeakLeft.setXmlParam("visible", integerToString(show_vupeaks));
		MainVUPeakRight.setXmlParam("visible", integerToString(show_vupeaks));
		PlaylistVUPeakLeft.setXmlParam("visible", integerToString(show_vupeaks));
		PlaylistVUPeakRight.setXmlParam("visible", integerToString(show_vupeaks));
		setPrivateInt(getSkinName(), "DeClassified show VU Peaks", show_vupeaks);
	}
	else if (a == 108)
	{
		WA265SPEED = (WA265SPEED - 1) * (-1);
		setPrivateInt(getSkinName(), "DeClassified Winamp 2.65 VU Speed", WA265SPEED);
	}

	else if (a == 109)
	{
		vu_gravity = (vu_gravity - 1) * (-1);
		setPrivateInt(getSkinName(), "DeClassified VU Peak Gravity", vu_gravity);
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

else if (a >= 410 && a <= 413)
	{
		vu_coloring = a - 410;
		if (vu_coloring == 0)
		{															// NORMAL
			if (smoothvu == 2)
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu");
			}
			else
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
			}
			MainVULeft.setXmlParam("image", "wacup.vu");
			MainVURight.setXmlParam("image", "wacup.vu");
			PlaylistVULeft.setXmlParam("image", "wacup.vu.pl");
			PlaylistVURight.setXmlParam("image", "wacup.vu.pl");
		}
		else if (vu_coloring == 1)
		{															// NORMAL
			if (smoothvu == 2)
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu");
			}
			else
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
			}
			MainVULeft.setXmlParam("image", "wacup.vu");
			MainVURight.setXmlParam("image", "wacup.vu");
			PlaylistVULeft.setXmlParam("image", "wacup.vu.pl");
			PlaylistVURight.setXmlParam("image", "wacup.vu.pl");
		}
		else if (vu_coloring == 2)
		{															// FIRE
			if (smoothvu == 2)
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu_fire");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu_fire");
			}
			else
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
			}
			MainVULeft.setXmlParam("image", "wacup.vu_fire");
			MainVURight.setXmlParam("image", "wacup.vu_fire");
			PlaylistVULeft.setXmlParam("image", "wacup.vu.pl_fire");
			PlaylistVURight.setXmlParam("image", "wacup.vu.pl_fire");
		}
		else if (vu_coloring == 3)
		{															// LINE
			if (smoothvu == 2)
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu_line");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu_line");
			}
			else
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_line");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_line");
			}
			MainVULeft.setXmlParam("image", "wacup.vu_line");
			MainVURight.setXmlParam("image", "wacup.vu_line");
			PlaylistVULeft.setXmlParam("image", "wacup.vu.pl_line");
			PlaylistVURight.setXmlParam("image", "wacup.vu.pl_line");
		}
		setPrivateInt(getSkinName(), "Visualizer Bar coloring", vu_coloring);
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

	else if (a >= 500 && a <= 504)
	{
		vp_falloffspeed = a - 500;
		vu_falloffspeed_peak = (vp_falloffspeed/100)+0.02;
		setPrivateInt(getSkinName(), "DeClassified VU peaks falloff", vp_falloffspeed);
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

	else if (a >= 900 && a <= 902)
	{
		smoothvu = a - 900;
		if (smoothvu == 0)
		{
			if (vu_coloring == 0) //normal
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
			else if (vu_coloring == 1) //normal
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
			else if (vu_coloring == 2) //fire
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
			else if (vu_coloring == 3) //line
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_line");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_line");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
		}
		else if (smoothvu == 1)
		{
			if (vu_coloring == 0) //normal
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
			else if (vu_coloring == 1) //normal
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
			else if (vu_coloring == 2) //fire
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_fire");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
			else if (vu_coloring == 3) //line
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.normal.vu_line");
				MainShadeVULeft.setXmlParam("frameheight", "2");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.normal.vu_line");
				MainShadeVURight.setXmlParam("frameheight", "2");
			}
		}
		else if (smoothvu == 2)
		{
			if (vu_coloring == 0) //normal
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu");
				MainShadeVULeft.setXmlParam("frameheight", "1");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu");
				MainShadeVURight.setXmlParam("frameheight", "1");
			}
			else if (vu_coloring == 1) //normal
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu");
				MainShadeVULeft.setXmlParam("frameheight", "1");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu");
				MainShadeVURight.setXmlParam("frameheight", "1");
			}
			else if (vu_coloring == 2) //fire
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu_fire");
				MainShadeVULeft.setXmlParam("frameheight", "1");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu_fire");
				MainShadeVURight.setXmlParam("frameheight", "1");
			}
			else if (vu_coloring == 3) //line
			{
				MainShadeVULeft.setXmlParam("image", "wa2.player.shade.smooth.vu_line");
				MainShadeVULeft.setXmlParam("frameheight", "1");
				MainShadeVURight.setXmlParam("image", "wa2.player.shade.smooth.vu_line");
				MainShadeVURight.setXmlParam("frameheight", "1");
			}
		}
		setPrivateInt(getSkinName(), "DeClassified Winamp 2.65 VU Options", smoothvu);
	}
}

setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode", mode);
	if (mode == 0)
	{
		MainVisualizer.setMode(0);
		MainShadeVisualizer.setMode(0);

		MainVULeft.setXmlParam("visible", "0");
		MainVURight.setXmlParam("visible", "0");
		MainVUPeakLeft.setXmlParam("image", "wacup.vu.peak.blank");
		MainVUPeakRight.setXmlParam("image", "wacup.vu.peak.blank");

		MainShadeVisualizer.setXmlParam("alpha", "255");
		MainShadeVULeft.setXmlParam("alpha", "0");
		MainShadeVURight.setXmlParam("alpha", "0");
	}
	else if (mode == 1)
	{
		MainVisualizer.setMode(1);
		MainShadeVisualizer.setMode(1);

		MainVULeft.setXmlParam("visible", "0");
		MainVURight.setXmlParam("visible", "0");
		MainVUPeakLeft.setXmlParam("image", "wacup.vu.peak.blank");
		MainVUPeakRight.setXmlParam("image", "wacup.vu.peak.blank");

		MainShadeVisualizer.setXmlParam("alpha", "255");
		MainShadeVULeft.setXmlParam("alpha", "0");
		MainShadeVURight.setXmlParam("alpha", "0");
	}
	else if (mode == 2)
	{
		MainVisualizer.setMode(2);
		MainShadeVisualizer.setMode(2);

		MainVULeft.setXmlParam("visible", "0");
		MainVURight.setXmlParam("visible", "0");
		MainVUPeakLeft.setXmlParam("image", "wacup.vu.peak.blank");
		MainVUPeakRight.setXmlParam("image", "wacup.vu.peak.blank");

		MainShadeVisualizer.setXmlParam("alpha", "255");
		MainShadeVULeft.setXmlParam("alpha", "0");
		MainShadeVURight.setXmlParam("alpha", "0");
	}
	else if(mode == 3){
		MainVisualizer.setMode(0);
		MainShadeVisualizer.setMode(0);

		MainVULeft.setXmlParam("visible", "1");
		MainVURight.setXmlParam("visible", "1");
		MainVUPeakLeft.setXmlParam("image", "wacup.vu.peak");
		MainVUPeakRight.setXmlParam("image", "wacup.vu.peak");

		MainShadeVisualizer.setXmlParam("alpha", "0");
		MainShadeVULeft.setXmlParam("alpha", "255");
		MainShadeVURight.setXmlParam("alpha", "255");
	}
	currentMode = mode;
}

//	===	 Sets Playlist Vis	===
setVis2 (int mode2)
{
	setPrivateInt(getSkinName(), "PLVisualizer Mode", mode2);
	if (mode2 == 0)
	{
		PLVisualizer.setMode(0);
		PlaylistVULeft.setXmlParam("visible", "0");
		PlaylistVURight.setXmlParam("visible", "0");
		PlaylistVUPeakLeft.setXmlParam("image", "wacup.vu.peak.pl.blank");
		PlaylistVUPeakRight.setXmlParam("image", "wacup.vu.peak.pl.blank");
	}
	else if (mode2 == 1)
	{
		PLVisualizer.setMode(1);
		PlaylistVULeft.setXmlParam("visible", "0");
		PlaylistVURight.setXmlParam("visible", "0");
		PlaylistVUPeakLeft.setXmlParam("image", "wacup.vu.peak.pl.blank");
		PlaylistVUPeakRight.setXmlParam("image", "wacup.vu.peak.pl.blank");
	}
	else if (mode2 == 2)
	{
		PLVisualizer.setMode(2);
		PlaylistVULeft.setXmlParam("visible", "0");
		PlaylistVURight.setXmlParam("visible", "0");
		PlaylistVUPeakLeft.setXmlParam("image", "wacup.vu.peak.pl.blank");
		PlaylistVUPeakRight.setXmlParam("image", "wacup.vu.peak.pl.blank");
	}
	else if (mode2 == 3)
	{
		PLVisualizer.setMode(0);
		PlaylistVULeft.setXmlParam("visible", "1");
		PlaylistVURight.setXmlParam("visible", "1");
		PlaylistVUPeakLeft.setXmlParam("image", "wacup.vu.peak.pl");
		PlaylistVUPeakRight.setXmlParam("image", "wacup.vu.peak.pl");
	}
	currentMode2 = mode2;
}

ShowHideVis(){
	WinampMainWindow.onSetVisible(WinampMainWindow.isVisible());
	MainShadeWindow.onSetVisible(MainShadeWindow.isVisible());
	if(getStatus() == -1){											// PAUSED
		MainVisualizer.setXmlParam("visible", "1");
		MainShadeVisualizer.setXmlParam("visible", "1");
		PLVisualizer.setXmlParam("visible", "1");
		PLVUVis.show();
		MainVUVIS.show();
		VU.stop();
	}else if(getStatus() == 0){										// STOPPED
		MainVisualizer.setXmlParam("visible", "0");
		MainShadeVisualizer.setXmlParam("visible", "0");
		PLVisualizer.setXmlParam("visible", "0");
		PLVUVis.hide();
		MainVUVIS.hide();
		VU.start();
	}else if(getStatus() == 1){										// PLAYING
		MainVisualizer.setXmlParam("visible", "1");
		MainShadeVisualizer.setXmlParam("visible", "1");
		PLVisualizer.setXmlParam("visible", "1");
		PLVUVis.show();
		MainVUVIS.show();
		VU.start();
	}
}