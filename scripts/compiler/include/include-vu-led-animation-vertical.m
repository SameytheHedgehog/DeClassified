/*****************************************************************************
*   Filename: include-vu-led-animation-vertical.m                            *
*   Version:  1.8                                                            *
*   Created:  2017-11-24                                                     *
*   Updated   2020-02-18                                                     *
*   Author:   PeterK.                                                        *
*   E-Mail:   peter_ka@gmx.net                                               *
*   Note:     This script is based on beatvisualization.m from Modern Skin   *
*****************************************************************************/

#ifndef included
#error This script "include-vu-led-animation-vertical.m" can only be compiled as #include
#endif

Global AnimatedLayer animationVuLEDleft;
Global AnimatedLayer animationVuLEDright;

Global Int last_LED_left;
Global Int last_LED_right;
Global Int value_left;
Global Int value_right;

Function startAnimationVuLED();

startAnimationVuLED()
{
	value_left=System.getLeftVuMeter()/26; // System.getLeftVuMeter(0...255)/26 => Int 0...9 and there are 10 animated <layers/> (0...9)
	value_right=System.getRightVuMeter()/26;
	
	if (value_left<last_LED_left)
	{
		value_left=last_LED_left-1;
		if (value_left<0) value_left=0;
	}
	if (value_right<last_LED_right)
	{
		value_right=last_LED_right-1;
		if (value_right<0) value_right=0;
	}
	last_LED_left=value_left;
	last_LED_right=value_right;
	animationVuLEDleft.gotoFrame(value_left);
	animationVuLEDright.gotoFrame(value_right);
}