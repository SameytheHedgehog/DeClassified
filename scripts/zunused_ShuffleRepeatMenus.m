/*  just creates right-click menus for the Shuffle and Repeat buttons.
	Written by Samey the Hedgie											*/

#include "compiler/lib/std.mi"
#include "compiler/lib/winampconfig.mi"

#define ShuffRepConfig "{45F3F7C1-A6F3-4EE6-A15E-125E92FC3F8D}"

Function setRepeatModeRMB();
Function setShuffleModeRMB();
Function ProcessRepResult (int a);
Function ProcessShuffResult (int a);

Global Group frameGroup;
Global Togglebutton repeatButton, ShuffleButton;

Global WinampConfigGroup shuffrep;
Global int currentRepMode, currentPLAMode, currentShuffMode;
Global PopUpMenu RepMenu, ShufMenu;

System.onScriptLoaded(){

    frameGroup = getContainer("Main").getLayout("Normal");				// looks for the main window
	repeatButton = frameGroup.findObject("Repeat");						// Looks for the repeat button
	ShuffleButton = frameGroup.findObject("Shuffle");					// Looks for the shuffle button
	
	shuffrep = WinampConfig.getGroup(ShuffRepConfig);
	int currentRepMode = shuffrep.getInt("repeat");
	int currentPLAMode = shuffrep.getInt("pladv");
	int currentShuffMode = shuffrep.getInt("shuffle");
}

/*	========================	Repeat Right click Menu		========================	*/
setRepeatModeRMB(){
	RepMenu = new PopUpMenu;

	RepMenu.addcommand(translate("Repeat")+"\tR", 1, currentRepMode = 1, 0);
	RepMenu.addcommand(translate("Manual Playlist Advance")+"\tShift+R", 2, currentPLAMode = 0, 0);

	ProcessRepResult (RepMenu.popAtMouse());

	delete RepMenu;
	complete;
}

/*	========================	Shuffle Right click Menu	========================	*/
setShuffleModeRMB(){
	ShufMenu = new PopUpMenu;

	ShufMenu.addcommand(translate("Shuffle")+"\tS", 1, currentShuffMode = 1, 0);

	ProcessShuffResult (ShufMenu.popAtMouse());

	delete ShufMenu;
	complete;
}

/*	========================	process Repeat menus	========================	*/
ProcessRepResult (int a) {
	if (a < 1) return;
	if (a == 1)
	{
		currentRepMode = 1;					// turn repeat on
	}
	if (a == 2)
	{
		currentPLAMode = 0;					// turn Manual Advance on
	}
}

/*	========================	process Shuffle menus	 ========================	*/
ProcessShuffResult (int a) {
	if (a < 1) return;
	if (a == 1)
		currentShuffMode = 1;					// turn Shuffle on
}

/*	========================	Right Mouse buttin input 	========================	*/
repeatButton.onRightButtonUp (int x, int y)
{
	setRepeatModeRMB();
}

/*	========================	Right Mouse buttin input 	========================	*/
ShuffleButton.onRightButtonUp (int x, int y)
{
	setShuffleModeRMB();
}