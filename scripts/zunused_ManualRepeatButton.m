/*	Changes the Repeat button graphic based on if Manual Advance is on or not
	Written by Samey the Hedgie												*/

#include "compiler/lib/std.mi"
#include "compiler/lib/config.mi"

Function refreshRepeatsetting();
Function setRepeatModeLMB();
Function setRepeatModeRMB();
Function ProcessRepResult (int a);
Function setRepeat(int mode);

Global Group frameGroup;
Global Togglebutton repeatButton;

Global PopUpMenu RepMenu;

Global ConfigAttribute attrib_repeat, attrib_manadvance;
Global int currentRepMode, currentPLAMode;

System.onScriptLoaded(){

    frameGroup = getContainer("Main").getLayout("Normal");				// looks for the main window
	repeatButton = frameGroup.findObject("RepeatButton");				// Looks for the repeat button

	ConfigItem configSection = config.getItem("Options");
	if (configSection != NULL) {
		attrib_repeat = configSection.getAttribute("Repeat");							// returns 0 for Repeat off, 1 for Repeat playlist
		attrib_manadvance = configSection.getAttribute("pladv");						// returns 0 for Manual Advance, 1 for Off?
	}

	refreshRepeatsetting();												// I don't exactly know just yet
}

/*	========================	Figures out what to do if the Repeat button is clicked normallyy	========================	*/
setRepeatModeLMB(){
	currentRepMode++;															// add 1 to the currentRepMode

	if (currentRepMode == 2)													// if above 1, go back to 0
	{
		currentRepMode = 0;
	}

	setRepeat (currentRepMode);													// set the Repeat mode based on currentRepMode
	complete;
}

/*	========================	Right click Menu	========================	*/
setRepeatModeRMB(){
	RepMenu = new PopUpMenu;

	RepMenu.addcommand(translate("Repeat")+"\tR", 1, currentRepMode = 1, 0);
	RepMenu.addcommand(translate("Manual Playlist Advance")+"\tShift+R", 2, currentPLAMode = 1, 0);

	ProcessRepResult (RepMenu.popAtMouse());

	delete RepMenu;
	complete;
}

/*	========================	Refreshes the repeat button 	========================	*/
refreshRepeatsetting ()
{
	currentRepMode = getPrivateInt(getSkinName(), "Repeat Mode", 0);
	currentPLAMode = getPrivateInt(getSkinName(), "Manual Advance Mode", 0);
	setRepeat (currentRepMode);
}

/*	========================	Right click Menu	========================	*/
ProcessRepResult (int a) {
	if (a < 1) return;
	if (a == 1)
		attrib_repeat.setData("1");					// turn repeat on
	if (a == 2)
		attrib_manadvance.setData("0");					// turn Manual Advance on
}

/*	========================	Left Mouse buttin input 	========================	*/
repeatButton.onLeftButtonUp (int x, int y)
{
	setRepeatModeLMB();
}

/*	========================	Right Mouse buttin input 	========================	*/
repeatButton.onRightButtonUp (int x, int y)
{
	setRepeatModeRMB();
}

/*	========================	Checks for if the pladv (manual advance) config changed 	========================	*/
attrib_manadvance.onDataChanged ()
{
	if (stringToInteger(attrib_manadvance.getData()) == 0)						// is Manual Advance on?
	{
		currentPLAMode = 1;										// Set 'currentPLAMode' to 1
	}
	else
	{
		currentPLAMode = 0;										// if not, set it to 0
	}
}

/*	========================	Checks for if the repeat config changed 	========================	*/
attrib_repeat.onDataChanged ()
{
	if (stringToInteger(attrib_repeat.getData()) == 1 && currentPLAMode == 0)			// Repeat is On - PLADV is Off
	{
		repeatButton.setXMLParam("image", "rep");						// Repeat On - MA off - Off graphic
		repeatButton.setXMLParam("downImage", "repp");					// Repeat On - MA off - Pushed graphic
		repeatButton.setXMLParam("activeImage", "repa");				// Repeat On - MA off - active graphic
	}
	else if (stringToInteger(attrib_repeat.getData()) == 1 && currentPLAMode == 1)		// Repeat is On - PLADV is On
	{
		repeatButton.setXMLParam("image", "repa");						// Repeat On - MA On - off Graphic
		repeatButton.setXMLParam("downImage", "repp");					// Repeat On - MA On - Pushed Graphic
		repeatButton.setXMLParam("activeImage", "repa");				// Repeat On - MA On - Active Graphic
	}
	else if (stringToInteger(attrib_repeat.getData()) == 0 && currentPLAMode == 0)		// Repeat is On - PLADV is On
	{
		repeatButton.setXMLParam("image", "rep");						// Repeat Off - MA Off - Off graphic
		repeatButton.setXMLParam("downImage", "repp");					// Repeat Off - MA Off - Pushed graphic
		repeatButton.setXMLParam("activeImage", "repa");				// Repeat Off - MA Off - Active Grapic
	}
	else																// if not, use Manual Advance On Graphics
	{
		repeatButton.setXMLParam("image", "repa");						// Repeat Off - MA On - Off Graphic
		repeatButton.setXMLParam("downImage", "repp");					// Repeat Off - MA On - Pushed Graphic
		repeatButton.setXMLParam("activeImage", "repa");				// Repeat Off - MA On - Active Graphic
	}
}

/*	========================	Sets the Repeat mode based on currentRepMode	========================	*/
setRepeat (int mode)
{
	if (mode == 0)
	{
		attrib_repeat.setData("0");
	}
	else if (mode == 1)
	{
		attrib_repeat.setData("1");
	messagebox("It works to this point", "", 1, "");
	}
	currentRepMode = mode;
}